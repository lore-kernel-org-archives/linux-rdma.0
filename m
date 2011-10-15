From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Announcing the Release of MVAPICH2 1.7 and OSU Micro-Benchmarks
 (OMB) 3.4
Date: Sat, 15 Oct 2011 01:22:07 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1110150119410.11820-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MVAPICH team is pleased to announce the release of MVAPICH2-1.7
and OSU Micro-Benchmarks (OMB) 3.4.

The complete set of Features, Enhancements, and Bug Fixes for MVAPICH2
1.7 (since MVAPICH2-1.6 release) are listed here.

    - Based on MPICH2-1.4.1p1
    - Integrated Hybrid (UD-RC/XRC) design to get best performance
      on large-scale systems with reduced/constant memory footprint
    - CH3 shared memory channel for standalone hosts
      (including laptops) without any InfiniBand adapters
    - HugePage support
    - Improved intra-node shared memory communication performance
    - Shared memory backed windows for One-Sided Communication
    - Support for truly passive locking for intra-node RMA in shared
      memory and LIMIC based windows
    - Improved on-demand InfiniBand connection setup (CH3 and RoCE)
    - Tuned RDMA Fast Path Buffer size to get better performance
      with less memory footprint (CH3 and Nemesis)
    - Support for large data transfers (>2GB)
    - Integrated with enhanced LiMIC2 (v0.5.5) to support Intra-node
      large message (>2GB) transfers
    - Optimized Fence synchronization (with and without
      LIMIC2 support)
    - Automatic intra-node communication parameter tuning
      based on platform
    - Efficient connection set-up for multi-core systems
    - Enhanced designs and tuning for collectives
      (bcast, reduce, barrier, gather, allreduce, allgather,
      gatherv, allgatherv and alltoall)
    - Support for shared-memory collectives for modern clusters
      with up to 64 cores/node
    - MPI_THREAD_SINGLE provided by default and
      MPI_THREAD_MULTIPLE as an option
    - Fast process migration using RDMA
    - Enabling Checkpoint/Restart support in pure SMP mode
    - Compact and shorthand way to specify blocks of processes
      on the same host with mpirun_rsh
    - Support for latest stable version of HWLOC v1.2.2
    - Enhanced mpirun_rsh design to avoid race conditions,
      support for fault-tolerance functionality and
      improved debug messages
    - Enhanced debugging config options to generate
      core files and back-traces
    - Automatic inter-node communication parameter tuning
      based on platform and adapter detection (Nemesis)
    - Integrated with latest OSU Micro-benchmarks (3.4)
    - Improved performance for medium sized messages (QLogic PSM interface)
    - Multi-core-aware collective support (QLogic PSM interface)
    - Performance optimization for QDR cards
    - Support for Chelsio T4 Adapter
    - Support for Ekopath Compiler

Bug Fixes:

    - Fixes in Checkpoint/Restart and Migration support
    - Fix Restart when using automatic checkpoint
          - Thanks to Alexandr for reporting this
    - Handling very large one-sided transfers using RDMA
    - Fixes for memory leaks
    - Graceful handling of unknown HCAs
    - Better handling of shmem file creation errors
    - Fix for a hang in intra-node transfer
    - Fix for a build error with --disable-weak-symbols
          - Thanks to Peter Willis for reporting this issue
    - Fixes for one-sided communication with passive target
      synchronization
    - Better handling of memory allocation and registration failures
    - Fixes for compilation warnings
    - Fix a bug that disallows '=' from mpirun_rsh arguments
    - Handling of non-contiguous transfer in Nemesis interface
    - Bug fix in gather collective when ranks are in cyclic order
    - Fix for the ignore_locks bug in MPI-IO with Lustre
    - Compiler preference lists reordered to avoid mixing GCC and Intel
      compilers if both are found by configure
    - Fix a bug in transferring very large messages (>2GB)
       - Thanks to Tibor Pausz from Univ. of Frankfurt for reporting it
    - Fix a hang with One-Sided Put operation
    - Fix a bug in ptmalloc integration
    - Avoid double-free crash with mpispawn
    - Avoid crash and print an error message in mpirun_rsh when the
      hostfile is empty
    - Checking for error codes in PMI design
    - Verify programs can link with LiMIC2 at runtime
    - Fix for compilation issue when BLCR or FTB installed in
      non-system paths
    - Fix an issue with RDMA-Migration
    - Fix a hang with RDMA CM
    - Fix an issue in supporting RoCE with second port on available on HCA
        - Thanks to Jeffrey Konz from HP for reporting it
    - Fix for a hang with passive RMA tests (QLogic PSM interface)

New features, Enhancements and Bug Fixes of OSU Micro-Benchmarks (OMB)
3.4 (since OMB 3.3 release) are listed here.

New Features & Enhancements

    - Add passive one-sided communication benchmarks
    - Update one-sided communication benchmarks to provide shared
      memory hint in MPI_Alloc_mem calls
    - Update one-sided communication benchmarks to use MPI_Alloc_mem
      for buffer allocation
    - Give default values to configure definitions (can now build
      directly with mpicc)
    - Update latency benchmarks to begin from 0 byte message

* Bug Fixes

    - Remove memory leaks in one-sided communication benchmarks
    - Update benchmarks to touch buffers before using them for
      communication
    - Fix osu_get_bw test to use different buffers for concurrent
      communication operations
    - Fix compilation warnings

MVAPICH2 1.7 is being made available with OFED 1.5.4. It continues to
deliver excellent performance. Sample performance numbers include:

  OpenFabrics/Gen2 on Westmere quad-core (2.53 GHz) with PCIe-Gen2
      and ConnectX2-QDR (Two-sided Operations):
        - 1.64 microsec one-way latency (4 bytes)
        - 3394 MB/sec unidirectional bandwidth
        - 6537 MB/sec bidirectional bandwidth

  QLogic InfiniPath Support on Westmere quad-core (2.53 GHz) with
      PCIe-Gen2 and QLogic-QDR (Two-sided Operations):
        - 1.70 microsec one-way latency (4 bytes)
        - 3265 MB/sec unidirectional bandwidth
        - 4228 MB/sec bidirectional bandwidth

  OpenFabrics/Gen2-RoCE (RDMA over Converged Ethernet) Support on
      Westmere quad-core (2.53 GHz) with ConnectX-EN (10GigE)
      (Two-sided operations):
        - 1.96 microsec one-way latency (4 bytes)
        - 1143 MB/sec unidirectional bandwidth
        - 2284 MB/sec bidirectional bandwidth

  Intra-node performance on Westmere quad-core (2.53 GHz)
      (Two-sided operations, intra-socket)
        - 0.29 microsec one-way latency (4 bytes)
        - 9964 MB/sec unidirectional bandwidth with LiMIC2
        - 17998 MB/sec bidirectional bandwidth with LiMIC2

Performance numbers for several other platforms and system configurations
can be viewed by visiting `Performance' section of the project's web page.

Starting with this release, a short `Quick Start Guide' is made available
for new and novice MVAPICH2 users. The complete `User Guide' is also
available.

For downloading MVAPICH2-1.7, OSU Micro-Benchmarks (OMB) 3.4, associated
quick start guide/user guide and accessing the SVN, please visit the
following URL:

http://mvapich.cse.ohio-state.edu

All questions, feedbacks, bug reports, hints for performance tuning,
patches and enhancements are welcome. Please post it to the
mvapich-discuss mailing list (mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org).

Thanks,

The MVAPICH Team


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
