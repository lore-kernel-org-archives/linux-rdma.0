From: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Announcing the Release of MVAPICH2 1.5.1
Date: Wed, 15 Sep 2010 00:47:23 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1009150046000.25352-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MVAPICH team is pleased to announce the release of MVAPICH2 1.5.1
with the following NEW features/enhancements and bug fixes:

* NEW Features and Enhancements (since MVAPICH2-1.5)

  - Significantly reduce memory footprint on some systems by changing the
    stack size setting for multi-rail configurations
  - Optimization to the number of RDMA Fast Path connections
  - Performance improvements in Scatterv and Gatherv collectives for CH3
    interface (Thanks to Dan Kokran and Max Suarez of NASA for identifying
    the issue)
  - Tuning of Broadcast Collective
  - Support for tuning of eager thresholds based on both adapter and
    platform type
  - Environment variables for message sizes can now be expressed in short
    form K=Kilobytes and M=Megabytes (e.g.  MV2_IBA_EAGER_THRESHOLD=12K)
  - Ability to selectively use some or all HCAs using colon separated
    lists. e.g. MV2_IBA_HCA=mlx4_0:mlx4_1
  - Improved Bunch/Scatter mapping for process binding with HWLOC and SMT
    support (Thanks to Dr. Bernd Kallies of ZIB for ideas and suggestions)
  - Update to Hydra code from MPICH2-1.3b1
  - Auto-detection of various iWARP adapters
  - Specifying MV2_USE_IWARP=1 is no longer needed when using iWARP
  - Changing automatic eager threshold selection and tuning for iWARP
    adapters based on number of nodes in the system instead of the number
    of processes
  - PSM progress loop optimization for QLogic Adapters (Thanks to Dr.
    Avneesh Pant of QLogic for the patch)

* Bug fixes (since MVAPICH2-1.5)

  - Fix memory leak in registration cache with --enable-g=all
  - Fix memory leak in operations using datatype modules
  - Fix for rdma_cross_connect issue for RDMA CM. The server is prevented
    from initiating a connection
  - Don't fail during build if RDMA CM is unavailable
  - Various mpirun_rsh bug fixes for CH3, Nemesis and uDAPL interfaces
  - ROMIO panfs build fix
  - Update panfs for not-so-new ADIO file function pointers
  - Shared libraries can be generated with unknown compilers
  - Explicitly link against DL library to prevent build error due to DSO
    link change in Fedora 13 (introduced with gcc-4.4.3-5.fc13)
  - Fix regression that prevents the proper use of our internal HWLOC
    component
  - Remove spurious debug flags when certain options are selected at
    build time
  - Error code added for situation when received eager SMP message is
    larger than receive buffer
  - Fix for Gather and GatherV back-to-back hang problem with LiMIC2
  - Fix for packetized send in Nemesis
  - Fix related to eager threshold in nemesis ib-netmod
  - Fix initialization parameter for Nemesis based on adapter type
  - Fix for uDAPL one sided operations (Thanks to Jakub Fedoruk from
    Intel for reporting this)
  - Fix an issue with out-of-order message handling for iWARP
  - Fixes for memory leak and Shared context Handling in PSM for QLogic
    Adapters (Thanks to Dr. Avneesh Pant of QLogic for the patch)

For downloading MVAPICH2 1.5.1, associated user guide and accessing the
SVN, please visit the following URL:

http://mvapich.cse.ohio-state.edu

MVAPICH2 1.5.1 is also being made available with OFED 1.5.2.

All questions, feedbacks, bug reports, hints for performance tuning,
patches and enhancements are welcome. Please post it to the
mvapich-discuss mailing list (mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org).

We are also happy to inform that the number of organizations using
MVAPICH/MVAPICH2 and registered at the MVAPICH site has crossed 1,250
world-wide (in 59 countries). The list of organizations can be
obtained from http://mvapich.cse.ohio-state.edu/current_users/. The
MVAPICH team extends thanks to all these organizations.

Thanks,

The MVAPICH Team



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
