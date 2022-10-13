#!/bin/env python3
import os
import subprocess
import argparse
import time

# options
# --install-base <path> : install dir name (optional, default: install)
# --packages-select <...> : select packages
# --parallel-workers <number> : maximum number of parallel action (optional)
# --packages-skip-build-finished : skip packages after last unfinished build
# --executor (parallel or sequential) : executor to run (default: parallel)
# --clear-cache : clear cache before building (optional)
# --distro <distro> : specify distro to use

def run_command(args):
    workspace = os.path.realpath(args.workspace)
    ros2_base_dir = os.path.realpath(args.ros2_base_dir)
    install_base = os.path.realpath(args.install_base)

    packages_select = args.packages_select
    packages_skip_up_to = args.packages_skip_up_to
    parallel_workers = args.parallel_workers
    packages_skip_build_finished = args.packages_skip_build_finished
    executor = args.executor
    clear_cache = args.clear_cache
    distro = args.distro

    cmake_args = args.cmake_args
    ament_cmake_args = args.ament_cmake_args

    # if workspace is not exists, make it
    if not os.path.exists(workspace):
        os.makedirs(workspace)
        print("{} is not exists, make it".format(workspace))
    
    build_command = "colcon build"
    build_command += " --executor {}".format(executor)
    build_command += " --parallel-workers {}".format(parallel_workers)
    build_command += " --install-base /{}".format(os.path.basename(install_base))

    if packages_skip_build_finished:
        build_command += " --packages-skip-build-finished"

    if len(packages_select):
        build_command += " --packages-select"
        for pkg in packages_select:
            build_command += " {}".format(pkg)
    if len(packages_skip_up_to):
        build_command += " --packages-skip-up-to"
        for pkg in packages_skip_up_to:
            build_command += " {}".format(pkg)

    if cmake_args is not None:
        build_command += " --cmake-args {}".format(cmake_args)
    if ament_cmake_args is not None:
        build_command += " --ament-cmake-args {}".format(ament_cmake_args)


    print("[Building workspace: {}]".format(workspace))
    print("============================")
    print("[ros2_base_dir:] {}".format(ros2_base_dir))
    print("[install_base:] {}".format(install_base))
    print("build_command:", build_command)
    print("================================================================================")

    source_optros = "source /opt/ros/{}/setup.bash".format(distro)

    # mkdir -p
    os.makedirs(os.path.join(ros2_base_dir, distro), exist_ok=True)
    os.chdir(os.path.join(ros2_base_dir, distro))
    subprocess.run(["wget", "https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/features/cross_compile/install.bash"])
    subprocess.run(["/bin/bash", "./install.bash", distro, os.uname().machine, "0.2.0", ros2_base_dir, "DL_ONLY"])
    subprocess.run(["docker", "build", "-t", "xcolcon_docker", os.path.join(ros2_base_dir, distro, "rpi-bullseye-ros2/build/.")])

    docker_command = "docker run --rm -it"
    docker_command += " -v {}:/workspace".format(workspace)
    docker_command += " -v {}:/opt/ros".format(ros2_base_dir, distro)
    docker_command += " -v {}:/{}".format(install_base, os.path.basename(install_base))
    docker_command += " xcolcon_docker:latest"
    docker_command += " /bin/bash -c {}".format('"' + source_optros + " && cd /workspace && " + build_command + '"')
    print("=============================")
    print("[docker_command]: {}".format(docker_command))# execute docker
    print("==================================================================================")
    start = time.time()
    subprocess.run(docker_command, shell=True)
    print("[Build done]")
    print("elapsed: {}sec".format(round(time.time() - start, 4)))
    
    # compress
    subprocess.run(["zip", "-r", os.path.basename(install_base) + ".zip", os.path.basename(install_base)], stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=os.path.dirname(install_base))
    print("[ZIP]: ", os.path.dirname(install_base) + "/" + install_base + ".zip")
    print("[compress done]🍓🐢")


if __name__ == "__main__":
    base = os.getcwd()
    
    #parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--workspace', type=str, help='Source path (from current path)', required=True)
    parser.add_argument('--distro', type=str,  help='specify distro', default='humble')

    parser.add_argument('--ros2-base-dir', type=str, help='ROS2 path (from current path)', default='ros2')
    parser.add_argument('--install-base', type=str,  help='install base directory', default='output_'+os.uname().machine+'_'+str(int(time.time())))
    parser.add_argument('--packages-select', nargs='+', help='select packages', default=[])
    parser.add_argument('--packages-skip-up-to', nargs='+', help='skip up to packages', default=[])
    parser.add_argument('--parallel-workers', type=int,  help='max number of parallel execution', default=4)
    parser.add_argument('--packages-skip-build-finished',  help='skip build finished', action="store_true")
    parser.add_argument('--executor', type=str,  help='executor type', default='parallel')
    parser.add_argument('--clear-cache',  help='clear cache after build', action="store_true")
    parser.add_argument('--cmake-args', type=str, help='pass arguments to cmake in command line', default=None)
    parser.add_argument('--ament-cmake-args', type=str, help='pass arguments to ament_cmake in command line', default=None)

    args = parser.parse_args()
    run_command(args=args)
