From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Announcing the Release of MVAPICH2 1.6
Date: Wed, 9 Mar 2011 23:52:31 -0500 (EST)
Message-ID: <Pine.GSO.4.40.1103092349550.447-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MVAPICH team is pleased to announce the release of MVAPICH2 1.6
with the following NEW features/enhancements and bug fixes:

* NEW Features and Enhancements (since MVAPICH2-1.5.1)

    - Optimization and enhanced performance for clusters with nVIDIA
      GPU adapters (with and without GPUDirect technology)
    - Support for InfiniBand Quality of Service (QoS) with multiple lanes
    - Support for 3D torus topology with appropriate SL settings
        - For both CH3 and Nemesis interfaces
        - Thanks to Jim Schutt, Marcus Epperson and John Nagle from
          Sandia for the initial patch
    - Enhanced R3 rendezvous protocol
        - For both CH3 and Nemesis interfaces
    - Robust RDMA Fast Path setup to avoid memory allocation
      failures
        - For both CH3 and Nemesis interfaces
    - Multiple design enhancements for better performance of
      small and medium sized messages
    - Using LiMIC2 for efficient intra-node RMA transfer to avoid extra
      memory copies
    - Upgraded to LiMIC2 version 0.5.4
    - Support of Shared-Memory-Nemesis interface on multi-core platforms
      requiring intra-node communication only (SMP-only systems,
      laptops, etc. )
    - Enhancements to mpirun_rsh job start-up scheme on large-scale systems
    - Optimization in MPI_Finalize
    - XRC support with Hydra Process Manager
    - Updated Hydra launcher with MPICH2-1.3.3 Hydra process manager
    - Hydra is the default mpiexec process manager
    - Enhancements and optimizations for one sided Put and Get operations
    - Removing the limitation on number of concurrent windows in RMA
      operations
    - Optimized thresholds for one-sided RMA operations
    - Support for process-to-rail binding policy (bunch, scatter and
      user-defined) in multi-rail configurations (OFA-IB-CH3, OFA-iWARP-CH3,
      and OFA-RoCE-CH3 interfaces)
    - Enhancements to Multi-rail Design and features including striping
      of one-sided messages
    - Dynamic detection of multiple InfiniBand adapters and using these
      by default in multi-rail configurations (OFA-IB-CH3, OFA-iWARP-CH3
      and OFA-RoCE-CH3 interfaces)
    - Optimized and tuned algorithms for Gather, Scatter, Reduce,
      AllReduce and AllGather collective  operations
    - Enhanced support for multi-threaded applications
    - Fast Checkpoint-Restart support with aggregation scheme
    - Job Pause-Migration-Restart Framework for Pro-active Fault-Tolerance
    - Support for new standardized Fault Tolerant Backplane (FTB) Events
      for Checkpoint-Restart and Job Pause-Migration-Restart Framework
    - Enhanced designs for automatic detection of various
      architectures and adapters
    - Configuration file support (similar to the one available in MVAPICH).
      Provides a convenient method for handling all runtime variables
      through a configuration file.
    - User-friendly configuration options to enable/disable various
      checkpoint/restart and migration features
    - Enabled ROMIO's auto detection scheme for filetypes
      on Lustre file system
    - Improved error checking for system and BLCR calls in
      checkpoint-restart and migration codepath
    - Enhanced OSU Micro-benchmarks suite (version 3.3)
    - Building and installation of OSU micro benchmarks during default
      MVAPICH2 installation
    - Improved configure help for MVAPICH2 features
    - Improved usability of process to CPU mapping with support of
      delimiters (',' , '-') in CPU listing
        - Thanks to Gilles Civario for the initial patch
    - Use of gfortran as the default F77 compiler

* Bug fixes (since MVAPICH2-1.5.1)

    - Fix for shmat() return code check
    - Fix for issues in one-sided RMA
    - Fix for issues with inter-communicator collectives in Nemesis
    - KNEM patch for osu_bibw issue with KNEM version 0.9.2
    - Fix for osu_bibw error with Shared-memory-Nemesis interface
    - Fix for a hang in collective when thread level is set to multiple
    - Fix for intel test errors with rsend, bsend and ssend
      operations in Nemesis
    - Fix for memory free issue when it allocated by scandir
    - Fix for a hang in Finalize
    - Fix for issue with MPIU_Find_local_and_external when it is called
      from MPIDI_CH3I_comm_create
    - Fix for handling CPPFLGS values with spaces
    - Dynamic Process Management to work with XRC support
    - Fix related to disabling CPU affinity when shared memory is
      turned off at run time
    - Resolving a hang in mpirun_rsh termination when CR is enabled
    - Fixing issue in MPI_Allreduce and Reduce when called with MPI_IN_PLACE
        - Thanks to the initial patch by Alexander Alekhin
    - Fix for threading related errors with comm_dup
    - Fix for alignment issues in RDMA Fast Path
    - Fix for extra memcpy in header caching
    - Only set FC and F77 if gfortran is executable
    - Fix in aggregate ADIO alignment
    - XRC connection management
    - Fixes in registration cache
    - Fixes for multiple memory leaks
    - Fix for issues in mpirun_rsh
    - Checks before enabling aggregation and migration
    - Fixing the build errors with --disable-cxx
        - Thanks to Bright Yang for reporting this issue

MVAPICH2 1.6 is being made available with OFED 1.5.3. It continues to
deliver excellent performance. Sample performance numbers include:

  OpenFabrics/Gen2 on Westmere quad-core (2.53 GHz) with PCIe-Gen2
      and ConnectX2-QDR (Two-sided Operations):
        - 1.63 microsec one-way latency (4 bytes)
        - 3394 MB/sec unidirectional bandwidth
        - 6540 MB/sec bidirectional bandwidth

  QLogic InfiniPath Support on Westmere quad-core (2.53 GHz) with
      PCIe-Gen2 and QLogic-QDR (Two-sided Operations):
        - 2.00 microsec one-way latency (4 bytes)
        - 3139 MB/sec unidirectional bandwidth
        - 4255 MB/sec bidirectional bandwidth

  OpenFabrics/Gen2-RoCE (RDMA over Converged Ethernet) Support on
      Xeon quad-core (2.4 GHz) with ConnectX-EN
      (Two-sided operations):
        - 2.92 microsec one-way latency (4 bytes)
        - 1143 MB/sec unidirectional bandwidth
        - 2253 MB/sec bidirectional bandwidth

  Intra-node performance on Westmere quad-core (2.53 GHz)
      (Two-sided operations, intra-socket)
        - 0.33 microsec one-way latency (4 bytes)
        - 10135 MB/sec unidirectional bandwidth with LiMIC2
        - 16651 MB/sec bidirectional bandwidth with LiMIC2

Performance numbers for several other platforms and system configurations
can be viewed by visiting `Performance' section of the project's web page.

For downloading MVAPICH2 1.6, associated user guide and accessing the
SVN, please visit the following URL:

http://mvapich.cse.ohio-state.edu

All questions, feedbacks, bug reports, hints for performance tuning,
patches and enhancements are welcome. Please post it to the
mvapich-discuss mailing list (mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org).

We are also happy to inform that the number of organizations using
MVAPICH/MVAPICH2 (and registered at the MVAPICH site) has crossed
1,400 world-wide (in 60 countries). The MVAPICH team extends thanks to
all these organizations.

Thanks,

The MVAPICH Team



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
