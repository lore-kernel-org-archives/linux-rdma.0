From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Announcing the Release of MVAPICH2 1.5
Date: Mon, 12 Jul 2010 08:26:28 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1007120822120.865-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MVAPICH team is pleased to announce the release of MVAPICH2 1.5 with
the following NEW features/enhancements and bug fixes:

* NEW Features and Enhancements (since MVAPICH2-1.4.1)

 - MPI 2.2 standard compliant
 - Based on MPICH2 1.2.1p1
 - OFA-IB-Nemesis interface design
    - OpenFabrics InfiniBand network module support for
      MPICH2 Nemesis modular design
    - Support for high-performance intra-node shared memory
      communication provided by the Nemesis design
    - Adaptive RDMA Fastpath with Polling Set for high-performance
      inter-node communication
    - Shared Receive Queue (SRQ) support with flow control,
      uses significantly less memory for MPI library
    - Header caching
    - Advanced AVL tree-based Resource-aware registration cache
    - Memory Hook Support provided by integration with ptmalloc2
      library. This provides safe release of memory to the
      Operating System and is expected to benefit the memory
      usage of applications that heavily use malloc and free operations.
    - Support for TotalView debugger
    - Shared Library Support for existing binary MPI application
      programs to run ROMIO Support for MPI-IO
    - Support for additional features (such as hwloc,
      hierarchical collectives, one-sided, multithreading, etc.),
      as included in the MPICH2 1.2.1p1 Nemesis channel
 - Flexible process manager support
    - mpirun_rsh to work with any of the eight interfaces
      (CH3 and Nemesis channel-based) including OFA-IB-Nemesis,
      TCP/IP-CH3 and TCP/IP-Nemesis
    - Hydra process manager to work with any of the eight interfaces
      (CH3 and Nemesis channel-based) including OFA-IB-CH3,
      OFA-iWARP-CH3, OFA-RoCE-CH3 and TCP/IP-CH3
 - MPIEXEC_TIMEOUT is honored by mpirun_rsh
 - Support for hwloc library (1.0.1) for defining CPU affinity
 - Deprecating older PLPA support for defining CPU affinity
   with HWLOC
 - Efficient CPU binding policies (bunch and scatter) to
   specify CPU binding per job for modern multi-core platforms
 - New flag in mpirun_rsh to execute tasks with different group IDs
 - Enhancement to the design of Win_complete for RMA operations
 - Flexibility to support variable number of RMA windows
 - Support for Intel iWARP NE020 adapter
    - Tuning for Intel iWARP NE020 adapter, thanks to Harry
      Cropper of Intel
 - SRQ turned on by default for Nemesis interface
 - Performance tuning - adjusted eager thresholds for
   variety of architectures, vbuf size based on adapter
   types and vbuf pool sizes
 - Introduction of a retry mechanism for RDMA_CM connection
   establishment

* Bug fixes (since MVAPICH2-1.4.1)

 - Fix compilation error when configured with
   `--enable-thread-funneled'
 - Fix MPE functionality, thanks to Anthony Chan <chan-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org> for
   reporting and providing the resolving patch
 - Cleanup after a failure in the init phase is handled better by
   mpirun_rsh
 - Path determination is correctly handled by mpirun_rsh when DPM is
   used
 - Shared libraries are correctly built (again)
 - Compilation issue with the ROMIO adio-lustre driver, thanks
   to Adam Moody of LLNL for reporting the issue
 - Allowing checkpoint-restart for large-scale systems
 - Correcting a bug in clear_kvc function. Thanks to T J (Chris) Ward,
   IBM Research, for reporting and providing the resolving patch
 - Shared lock operations with RMA with scatter process distribution.
   Thanks to Pavan Balaji of Argonne for reporting this issue
 - Fix a bug during window creation in uDAPL
 - Compilation issue with --enable-alloca, Thanks to E. Borisch,
   for reporting and providing the patch
 - Improved error message for ibv_poll_cq failures
 - Fix an issue that prevents mpirun_rsh to execute programs without
   specifying the path from directories in PATH
 - Fix an issue of mpirun_rsh with Dynamic Process Migration (DPM)
 - Fix for memory leaks (both CH3 and Nemesis interfaces)
 - Updatefiles correctly update LiMIC2
 - Several fixes to the registration cache
   (CH3, Nemesis and uDAPL interfaces)
 - Fix to multi-rail communication
 - Fix to Shared Memory communication Progress Engine
 - Fix to all-to-all collective for large number of processes
 - Fix in build process with hwloc (for some Distros)
 - Fix for memory leak (Nemesis interface)

MVAPICH2 1.5 is being made available with OFED 1.5.2. It continues
to deliver excellent performance. Sample performance numbers include:

  OpenFabrics/Gen2 on Nehalem quad-core (2.4 GHz) with PCIe-Gen2
      and ConnectX2-QDR (Two-sided Operations):
        - 1.62 microsec one-way latency (4 bytes)
        - 3021 MB/sec unidirectional bandwidth
        - 5858 MB/sec bidirectional bandwidth

  QLogic InfiniPath Support on Nehalem quad-core (2.4 GHz) with
      PCIe-Gen2 and QLogic-DDR (Two-sided Operations):
        - 2.35 microsec one-way latency (4 bytes)
        - 1910 MB/sec unidirectional bandwidth
        - 3184 MB/sec bidirectional bandwidth

  OpenFabrics/Gen2-RoCE (RDMA over Convereged Ethernet) Support on
      Nehalem quad-core (2.4 GHz) with ConnectX-EN
      (Two-sided operations):
        - 3.29 microsec one-way latency (4 bytes)
        - 1143 MB/sec unidirectional bandwidth
        - 2283 MB/sec bidirectional bandwidth

  Intra-node performance on Nehalem quad-core (2.4GHz)
      (Two-sided operations, intra-socket)
        - 0.35 microsec one-way latency (4 bytes)
        - 9154 MB/sec unidirectional bandwidth, with and without LiMIC2
        - 11787 MB/sec bidirectional bandwidth with LiMIC2

Performance numbers for several other platforms, system configurations
and operations (such as collectives) can be viewed by visiting
`Performance' section of the project's web page.

For downloading MVAPICH2 1.5, associated user guide and accessing the
SVN, please visit the following URL:

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
