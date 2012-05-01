From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Announcing the Release of MVAPICH2 1.8 GA version and OSU Micro-Benchmarks
 (OMB) 3.6
Date: Tue, 1 May 2012 12:58:59 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1205011253290.28248-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MVAPICH team is pleased to announce the release of MVAPICH2 1.8 GA
version and OSU Micro-Benchmarks (OMB) 3.6.

The complete set of features and enhancements for MVAPICH2 1.8 compared
to MVAPICH2 1.7 are as follows:

* Features & Enhancements:
    - Support for MPI communication from NVIDIA GPU device memory
        - High performance RDMA-based inter-node point-to-point
          communication (GPU-GPU, GPU-Host and Host-GPU)
        - High performance intra-node point-to-point communication for
          multi-GPU adapters/node (GPU-GPU, GPU-Host and Host-GPU)
        - Taking advantage of CUDA IPC (available in CUDA 4.1) in
          intra-node communication
          for multiple GPU adapters/node
        - Enhanced designs for Alltoall and Allgather collective
          communication from GPU device buffers
        - Optimized and tuned collectives for GPU device buffers
        - MPI datatype support for point-to-point and collective
          communication from GPU device buffers
    - Support for running UD only mode
    - Support suspend/resume functionality with mpirun_rsh
    - Enhanced support for CPU binding with socket and numanode level
      granularity
    - Support for showing current CPU bindings
    - Exporting local rank, local size, global rank and global
      size through environment variables (both mpirun_rsh and hydra)
    - Update to hwloc v1.4.1
    - Checkpoint-Restart support in OFA-IB-Nemesis interface
    - Enabling run-through stabilization support to handle
      process failures in OFA-IB-Nemesis interface
    - Enhancing OFA-IB-Nemesis interface to handle IB errors gracefully
    - Performance tuning on various architecture clusters
    - Support for Mellanox IB FDR adapter
    - Adjust shared-memory communication block size at runtime
    - Enable XRC by default at configure time
    - New shared memory design for enhanced intra-node small message
      performance
    - Tuned inter-node and intra-node performance on different cluster
      architectures
    - Support for fallback to R3 rendezvous protocol if RGET fails
    - SLURM integration with mpiexec.mpirun_rsh to use SLURM
      allocated hosts without specifying a hostfile
    - Support added to automatically use PBS_NODEFILE in Torque and PBS
      environments
    - Enable signal-triggered (SIGUSR2) migration
    - Reduced memory footprint of the library
    - Enhanced one-sided communication design with reduced
      memory requirement
    - Enhancements and tuned collectives (Bcast and Alltoallv)
    - Flexible HCA selection with Nemesis interface
        - Thanks to Grigori Inozemtsev, Queens University
    - Support iWARP interoperability between Intel NE020 and
      Chelsio T4 Adapters
    - RoCE enable environment variable name is changed from
      MV2_USE_RDMAOE to MV2_USE_RoCE

Features and Enhancements for OSU Micro-Benchmarks (OMB)  3.6 are listed
here.

* New Features & Enhancements (since OMB 3.5.1)
    - New collective benchmarks
        * osu_allgather
        * osu_allgatherv
        * osu_allreduce
        * osu_alltoall
        * osu_alltoallv
        * osu_barrier
        * osu_bcast
        * osu_gather
        * osu_gatherv
        * osu_reduce
        * osu_reduce_scatter
        * osu_scatter
        * osu_scatterv

MVAPICH2 1.8 continues to deliver excellent performance. Sample
performance numbers include:

  OpenFabrics/Gen2 on Sandy Bridge 8-core (2.6 GHz) with PCIe-Gen3
      and ConnectX-3 FDR (Two-sided Operations):
        - 1.05 microsec one-way latency (4 bytes)
        - 6344 MB/sec unidirectional bandwidth
        - 11994 MB/sec bidirectional bandwidth

  OpenFabrics/Gen2-RoCE (RDMA over Converged Ethernet) Support on
      Sandy Bridge 8-core (2.6 GHz) with ConnectX-3 EN (40GigE)
      (Two-sided operations):
        - 1.2 microsec one-way latency (4 bytes)
        - 4565 MB/sec unidirectional bandwidth
        - 9117 MB/sec bidirectional bandwidth

  Intra-node performance on Sandy Bridge 8-core (2.6 GHz)
      (Two-sided operations, intra-socket)
        - 0.19 microsec one-way latency (4 bytes)
        - 9643 MB/sec unidirectional bandwidth
        - 16941 MB/sec bidirectional bandwidth

Sample performance numbers for MPI communication from NVIDIA GPU memory
using MVAPICH2 1.8 and OMB 3.6 can be obtained from the following URL:

http://mvapich.cse.ohio-state.edu/performance/gpu.shtml

Performance numbers for several other platforms and system configurations
can be viewed by visiting `Performance' section of the project's web page.

For downloading MVAPICH2 1.8, OMB 3.6, associated user guide, quick start
guide, and accessing the SVN, please visit the following URL:

http://mvapich.cse.ohio-state.edu

All questions, feedbacks, bug reports, hints for performance tuning,
patches and enhancements are welcome. Please post it to the
mvapich-discuss mailing list (mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org).

We are also happy to inform that the number of organizations using
MVAPICH/MVAPICH2 (and registered at the MVAPICH site) has crossed 1,900
world-wide (in 67 countries). The MVAPICH team extends thanks to all these
organizations.

Thanks,

The MVAPICH Team

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
