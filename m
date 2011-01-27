From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OFED 1.5.3 rc2 is available
Date: Thu, 27 Jan 2011 15:43:48 +0200
Message-ID: <4D417694.5060700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060103040309070005040302"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060103040309070005040302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.3-rc2 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.3/OFED-1.5.3-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.3

Vladimir & Tziporet

========================================================================
Supported Platforms and Operating Systems
---------------------------------------------
     o   CPU architectures:
           - x86_64
           - x86
           - ppc64
           - ia64

     o   Linux Operating Systems:
           - RedHat EL5 up4        2.6.18-164.el5
           - RedHat EL5 up5        2.6.18-194.el5
           - RedHat EL5 up6        2.6.18-238.el5
           - RedHat EL6            2.6.32-71.el6
           - SLES10 SP3            2.6.16.60-0.54-smp
           - SLES11                2.6.27.19-5-default
           - SLES11 SP1            2.6.32.12-0.7-default
           - Fedora Core12         2.6.31.5-127.fc12    *
           - OpenSuSE 11.2         2.6.31.5-0.1-default *
           - kernel.org            2.6.29 - 2.6.36    *

         * Minimal QA for these versions

Main changes from 1.5.3-rc1:
===========================
1. Updated packages:
    infinipath-psm-1.14
    libsdp-1.1.108-0.14.g63e0cf1
    perftest-1.3.0-0.40.g11c4950
    sdpnetstat-1.60-0.3.gb6e7425

    - MPI
    mvapich2-1.6-0.2.20110125svn4431

2. Added RHEL5.6 support

--------------060103040309070005040302
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.3-rc2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.3-rc2.txt"

commit e163bcb66b04bed7ab946a6f2cecc390d3940fb5
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Jan 20 15:03:05 2011 -0500

    IB/qib: Hold link for Tx SERDES settings
    
    Hold the IB link at DISABLED until we get the correct TX
    settings on mezz boards.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit dc76474c013e8d4d1e222e8c2cee3a2908424668
Author: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Thu Jan 20 10:48:07 2011 +0200

    IB/uverbs: Handle large number of entries in poll CQ
    
    In ib_uverbs_poll_cq() code there is a potential integer overflow if
    userspace passes in a large cmd.ne.  The calls to kmalloc() would
    allocate smaller buffers than intended, leading to memory corruption.
    There iss also an information leak if resp wasn't all used.
    Unprivileged userspace may call this function, although only if an
    RDMA device that uses this function is present.
    
    Fix this by copying CQ entries one at a time, which avoids the
    allocation entirely, and also by moving this copying into a function
    that makes sure to initialize all memory copied to userspace.
    
    Special thanks to Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
    for his help and advice.
    
    Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    
    [ Monkey around with things a bit to avoid bad code generation by gcc
      when designated initializers are used.  - Roland ]
    
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit e9dda1545111aaee070827baefae53a59105c106
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Jan 19 12:56:26 2011 +0100

    RDMA/core: backports for 2.6.35 and 2.6.36 kernels
    
    Added missing backports
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit e4b79f1ce8a28b300aa6df4def4a247752fbcdb2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 19 12:32:48 2011 +0200

    mlx4,mthca: Change version to 1.5.3
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 54bd87d97c9f878029231fb647897ac6b883ae1f
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 19 10:07:33 2011 +0200

    openibd: unload cxgb3i on restart
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ba6fb97979aed79a54556de9a73f0d2527389f1a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 18 13:03:36 2011 +0200

    Fix support for kernels > 2.6.30
    
    Replace dma_sync_single() use with proper functions
    
    dma_sync_single() is deprecated now, and the use in mthca is wrong:
    there should be a dma_sync_single_for_cpu() before touching the memory
    from the CPU, and a dma_sync_single_for_device() afterwards.  Fix
    this, prompted by a kick in the pants from a patch from FUJITA
    Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>.
    
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e75f1be772a7c48b0467a3cb98bb9731814be650
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 18 19:03:32 2011 +0200

    sdp: do not reenter sdp_abort_rx_srcavail
    
    SrcAvailCancel could be handled from within sdp_abort_rx_srcavail. This
    shouldn't happen. To prevent it, ssk->rx_sa is set to NULL at the begining.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 925cbfc97f8395abc8ac04f463e676561dca8d16
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 16 18:32:38 2011 +0200

    sdp: Abort rx SrcAvail when out of credits
    
    SrcAvail sink side could run out of credits when having bcopy sends to the
    other direction. Because of that no RdmaRdCompl could be sent nor SendSM.  This
    could hang the sender side forever (No SendSM on SrcAvailCancel).
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ea27c49e4fb320ab84645d57f375a05a8224109b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 16 15:41:37 2011 +0200

    cxgb3: Fix backport for RHEL5.6
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c330eedc7149e70f94ca4a30e0be0657c97a2944
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Jan 16 15:02:51 2011 +0200

    mlx4: enable raw eth QPs to work with inline and blueflame.
    
    When using blueflame, an assigned qp number cannot contain "1" bits
    in positions 6 and 7 (which become the CS and SV bits in the second
    dword of the CTL segment when using blueflame).
    
    To solve this, we add a "skip_mask" dword to resource range allocation.
    The acquired resource is skipped if its number "and'ed" with the
    skip_mask is non_zero.
    
    For RAW_ETH qp's, we use a skip_mask of 0xC0, corresponding to bits
    6 and 7 of the QP number.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit f29ad409551c11d77656d00279dc1b49571b4add
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 13 16:24:36 2011 +0200

    Add RHEL5.6 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 906bfc2bd29adce4fefa8600a505c9f8b2b04a8f
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 12 11:48:48 2011 +0200

    tuning/sysctl: Rename ib_ipoib_sysctl -> sysctl_perf_tuning
    
    Tuning parameters are valid for all ULPs/network drivers.
    So, remove IPoIB dependency.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5a8f89849629b994934821a9f36c88e3bf6b29f1
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 11 17:12:42 2011 +0200

    openibd: add option to disable kernel parameters tuning
    
    Add RUN_SYSCTL parameter to the openib.conf.
    If RUN_SYSCTL=no the /sbin/ib_ipoib_sysctl will not be executed.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 97f08a7e422516791900b060aa47493fce7d454c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 11 17:00:58 2011 +0200

    openibd: replace ifconfig by ip
    
    ifconfig should not be used to get/set network device properties.
    It was replaced by ip.
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2209
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0ac3c8b53ed10101a1d7cef914a31dda100fe464
Merge: 449b58e 02e0103
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 11 16:54:08 2011 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 02e010336e34b3485a393bce5f462b029986cbe5
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 11 15:16:51 2011 +0200

    sdp: Fixed BUG2207 - EINVAL when connect after IPv6 bind
    
    Connect to IPv4 over IPv6 address need rdma id to be created with IPv4 address.
    If bound before with IPv6 adderss, need to destroy and recreate the id.
    Also, when connecting after bind, keep the same source port number.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 449b58e2ef0be13b317ecaca7adc402c8ce213c5
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 11 10:35:57 2011 +0200

    Fix show_abi_version on 2.6.34
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 38ffe0066bc8327256b8f73242906491fb7b2db3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 9 14:48:34 2011 +0200

    sdp: Fix 2.6.36 backport patch
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f77da9f97403312c69373df8b4eabc1657751fad
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 9 14:28:54 2011 +0200

    Add support for 2.6.18.8-xen kernel
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ce9d42bebe9729655a874a985bc6cb7b850232d9
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 6 15:49:55 2011 +0200

    sdp: check address family before connecting
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9805faa6d787f379ad0c67528cfb636937f3829e
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 6 14:38:34 2011 +0200

    sdp: Do not ignore scope_id in IPv6
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e640d343c50c14b9eb3aab39dd407cb1d5292c26
Merge: 0148f04 b9cc54d
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 9 09:25:44 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit b9cc54dc33cb21b3b32037131aa53ccdd37e6dfa
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Jan 6 16:33:25 2011 -0500

    IB/qib: fix refcount leak in lkey/rkey validation
    
    The mr optimization introduced a reference count leak on an exception test.
    The lock/refcount manipulation is moved down and the problematic exception
    test now calls bail to insure that the lock is released.
    
    Additional fixes as suggested by Ralph Campbell <ralph.campbell-l8fZCXd1Rtodnm+yROfE0A@public.gmane.org>:
    - reduce lock scope of dma regions
    - use explicit values on returns vs. automatic ret value
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0148f048919082023c1dd94f00149462a6e04ed6
Merge: d74a5ae 708221f
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 5 15:54:13 2011 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 708221f03c7f110350691746c6d4f4ae28611fb2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 5 13:26:32 2011 +0200

    sdp: make backport sk_inet()->xxx simpler
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d74a5ae3cd0471770b5d5293b16cd92d6b058dda
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 5 14:17:07 2011 +0200

    ppc64/backport: Add workaround for compilation on PPC64 with 2.6.32
    
    Add an empty asm/iomap.h under kernel_addons for 2.6.32* kernels
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2203
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 890e7721d4c2c19a4c7a9b6d23a6502182ec476b
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 5 11:33:21 2011 +0200

    sdp: Fix get getsockname/getpeername in IPv6
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8effad4bafd8a98e49e44d64859951bbc536e031
Merge: a61000b 9fdd445
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 5 10:58:39 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 9fdd445e04aac7cbe3fa3780e385bce4fa9d5db1
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Jan 4 15:19:07 2011 -0500

    ofa_kernel.spec: Account for QLogic cards for counting ipoib aliases
    
    The routine count_ib_ports() now lspci's for QLogic SDR, DDR, and QDR HCAs
    to correctly configure ib_ipoib.conf aliases.
    
    The aliases are also corrected for upgrade installs as well as initial
    installs.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit a61000bf2180da935306819d981fdc00aa9386b3
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Mon Jan 3 14:10:14 2011 +0100

    ehca: fixes
    
    The changes are tested with ./ofed_scripts/ofed_makedist.sh
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit 6855440dd8cfab0a0d82ab33c1d3979b4b5ce443
Merge: 03dc015 9887f6b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 4 17:46:29 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 9887f6b42a367e7a19534aa8f24bbe12c6191a9f
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 3 15:40:43 2011 -0500

    truescale.cmds: balance IRQs for kernel contexts across CPUs
    
    Balance the IRQs of the kernel receive contexts across the
    available CPUs by assigning IRQ affinities in a round-robin
    fashion.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit eeb4091b076e3bfd224a2ba70b376150fa9b64c8
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 3 15:38:49 2011 -0500

    truescale.cmds: Fix setting SERDES Tx values on HP Mezz
    
    If the mezz card is in the second mezz slot, both ports
    are enabled. Therefore, we need to set the correct Tx
    settings for the second port.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 7971d9be1cdd03b2c8f0928cbc11e24fd8e3e699
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 3 15:34:30 2011 -0500

    truescale.cmds: Fix invalid 'if' statement syntax
    
    Delete leading -a.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 16d386a4ed37befb3ccfcdd3d176a08017aeedf6
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 3 15:30:18 2011 -0500

    truescale.cmds: make the mount of /ipathfs more robust and quiet
    
    The 'start' section of truescale.cmds isn't terribly robust against
    being called multiple times or having a slightly wonky environment.
    Device testers in particular were getting messages from the failing
    mkdir.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 03dc0154a1aa21b335d5df251010bace7bfc62a3
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 2 13:31:12 2011 +0200

    sdp: Allow bind to address with family AF_INETx_SDP
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 46e20629818ba040ce1ea83df701496844aa9c23
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 30 14:38:48 2010 +0200

    sdp: Use %pI4 + %pI6 in new kernels
    
    A patch in this subject was in the wrong backport. Moving it to a dedicated patch.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 954d37f69074eb23f70e848f11fd2af089f800ba
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 29 17:23:07 2010 +0200

    sdp: fix connect to IPv4 over IPv6
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit de706b6e1c3d9503e650411878b25cf13d51b519
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 29 12:40:52 2010 +0200

    sdp: Fix some issues in ipv6 support
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0ff5467c40c0ec3e5e25e46946900ea98a04d279
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 27 11:58:26 2010 +0200

    sdp: ipv6 support
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2e0ab2acaef2528a9ca94692af08e550fedac691
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 27 15:04:30 2010 -0500

    IB/qib: Code style issues found during kernel.org submission testing
    
    These are fixes to style issues detected by checkpatch.pl.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit cf8b6ca317a31ccee24e0058415db36a59242eb6
Merge: 3435de1 b17abc2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 26 09:39:46 2010 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit b17abc2b2164948531f8fc591a9ff6e3d971cdd1
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:59:51 2010 -0500

    IB/qib: Add return value testing for work queue creation
    
    The code ignored potentially NULL rvals.  This patch adds testing for NULL
    and the appropriate failure branches at the end of qib_init().
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 53027eea12923aaa3ba11961a486af80d9c0ce73
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:56:40 2010 -0500

    IB/qib: Allow driver to load if PCIe advanced error reporting fails
    
    Some PCIe root complex chip sets don't support advanced error reporting.
    Allow the driver to load OK if pci_enable_pcie_error_reporting() fails.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit cbb1b059540f802f0c65573629bf41fdf3a2eb2e
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:53:25 2010 -0500

    IB/qib: clean up properly if pci_set_consistent_dma_mask() fails
    
    Clean up properly when pci_set_consistent_dma_mask() fails.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 56fde9902048fec37e81dc8be3fb7f774d0dbc8f
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:48:01 2010 -0500

    IB/qib: Fix QIB early error reporting prints
    
    Replace incorrect use of dev_info with dev_err.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 6a1024778af0b7c4b7f1e0075548fe1a75867f26
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:43:41 2010 -0500

    IB/qib: Improve SERDES tunning on QMH boards
    
    Improve the QMH SERDES tunning on initial driver load by
    removing the delay after SERDES init and having the driver
    go through a link state change.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 4714a7ae7734059bd6b63186bb7bccd1a6cde441
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:39:31 2010 -0500

    IB/qib: Add a delay to allow SERDES to initialize
    
    Adding a small delay would allow the SERDES to adapt better,
    which would improve the link negotiation.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 825356532db07e34632a9aa9a64451b75201eeb1
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:32:45 2010 -0500

    IB/qib: Un-necessary delayed completions on RC connection
    
    Currently on receipt of a response message (ACKs, RDMA Response, Atomic
    Responses etc.) if the SDMA completion counter is not advanced the
    driver delays the completion of the WQE. In most cases this is overly
    pessimistic as the response (ACK) to a previously transmitted send
    implies that the send is complete. Ensure that SDMA queue is progressed
    appropriately before determining if a send has delayed completions.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit deac6a9658f1e4121fa0e26899702323c715e8f2
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:25:33 2010 -0500

    IB/qib: Issue pre-emptive NAKs on eager buffer overflow
    
    Under congestion resulting in eager buffer overflow attempt to send
    pre-emptive NAKs if header queue entries with TID errors are generated and
    a valid header is present. This prevents long timeouts and flow restarts if
    a trailing set of packets are dropped due to eager overflows. Pre-emptive
    NAKs are currently only supported for RDMA Writes.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit e2f3b28bbe27e34a1abfa7bccb8377c42535c910
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:16:48 2010 -0500

    IB/qib: RDMA lkey/rkey validation is inefficient for large MRs
    
    The current code loops during rkey/lkey validiation to isolate the mr
    for the RDMA, which is expensive when the current operation is
    inside a very large memory region.
    
    This fix optimizes rkey/lkey validation routines for user memory regions and
    fast memory regions.  The mr entry can be isolated by shifts/mods instead of
    looping.  The existing loop is preserved for phys memory regions for now.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 9ad35a43699e7d77c1a1081e184afb79c0df0dd5
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 12:07:50 2010 -0500

    IB/qib: change qpn increment
    
    Changing from +1 to +2 allows for better QP
    distribution across receive contexts.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 55333e094dd97f75e4e007f03183f71527bdf962
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 11:33:43 2010 -0500

    IB/qib: backport changes for last two commits
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 07933e2d064eb0f0eadee8f4fa7b634334207518
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 11:29:43 2010 -0500

    IB/qib: adding fix missing from earlier patch
    
    0669da697c7779955806ef3dae3db4ecf68618cc was missing part
    of a fix that makes merges impossible.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0e0ccb83fb114887d2abfafffbb5bb5a576ec2f0
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 22 11:28:56 2010 -0500

    IB/qib: change rcv queue/qpn selection
    
    The basic idea is that on SusieQ, the difficult part of mapping QPN to context
    is handled by the mapping registers so the generic QPN allocation doesn't need
    to worry about chip specifics. For Monty and Linda, there is no mapping table
    so the qpt->mask (same as dd->qpn_mask), is used to see if the QPN to context
    falls within [zero..dd->n_krcv_queues).
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 8f448d7d90a50ab0cc32a06e0811c702c5007c78
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 13:01:59 2010 -0500

    IB/qib: interrupt mitigation fix
    
    For SusieQ we need to write to the interrupt timer register before updating the
    header queue head with interrupt count. This is to ensure that the timer is
    enabled properly and a receive available interrupt is delivered else this
    interrupt can be lost if the receiver header/eager queues are full before the
    timer is enabled.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 684272b5a7a72508a4c70023b2099793fb7948c5
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:40:12 2010 -0500

    IB/qib: Avoid duplicate writes to the rcv head register
    
    Avoid duplicate writes to the head register as this can lead to lost interrupts
    if the context goes full before the second write is done.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit bd512a70873e18d098ab940472f81693af71b578
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:35:31 2010 -0500

    IB/qib: fix RDMA write with immediate
    
    The immediate word for RDMA_WRITE_ONLY_WITH_IMMEDIATE was being extracted
    from the wrong location in the header.  Thanks to
    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> for finding this.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 7bc68c54f2fa74632b15225a1cd946b463b90e77
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:29:48 2010 -0500

    IB/qib: Add a few new SERDES tunings
    
    Add new SERDES tuning to aid manufacturing.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 1b4acc545ee7065acaf9e5f56e290a24bcf54467
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:22:32 2010 -0500

    IB/qib: Reset packet list after freeing
    
    Reset the list pointers after freeing the SDMA packet
    list. This is done to any potential double-free cases.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 3252ff781558691d6e09f567456db55912099404
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:15:00 2010 -0500

    IB/qib: New SERDES init routine and improvements to SI quality
    
    Implement new SERDES initialization routine and improvements
    to SI - disable LE1 adaptation, disable LOS after link-up, set
    better SERDES parameters.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 37644c3c66a9c7cf6559aa0735d92b673731efa0
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 12:03:46 2010 -0500

    IB/qib: remove IB latency turnoff
    
    This is required for hardware testing.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 55d63e9ee381cf842f56d57c950d3aa76cb6880b
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:37:43 2010 -0500

    IB/qib: clear WAIT_SEND flags when setting QP to error state
    
    If these flags are set when the QP is transitioned to the error
    state, it will wait until the flags are cleared, which may never
    happen if the error transition is due to a link going down.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit f834687c62a99e884ff915725222fe7e2d69edc9
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:36:04 2010 -0500

    IB/qib: fix context allocation with multiple HCAs
    
    The driver was incorrectly choosing HCAs on which to allocate
    new user contexts based on overall count of usable ports
    regardless whether the usable port was on the currently selected
    HCA.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit c881784aa894d97a5e41ab18cdaa0a2a47fee178
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:34:57 2010 -0500

    IB/qib: Multi Florida HCA Hosts panic on reboot
    
    Add check when setting configured contexts that the value
    does not exceed the number of contexts allocated for the
    card. If the value exceeds the already allocated count,
    set it to what is already allocated.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit addaddd141739e6d4a69ff54c0ae12aa8ba4e110
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:33:50 2010 -0500

    IB/qib: Handle transitions from ACTIVE_DEFERRED to ACTIVE better
    
    When the link transitions from ACTIVE_DEFERRED to ACTIVE, the driver
    only sees the ACTIVE state. With this change, it will check whether
    the state was already ACTIVE and if so, it will not generated IB
    events and will not clear symbol error counts.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit fc430b5cc66fa0a23f3ba879a0c94c21938536fa
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:32:12 2010 -0500

    IB/qib: UD send with immediate Rx completion has wrong size
    
    The code to generate receive completion entries for UD send with
    immediate contains the wrong payload length. This is because when
    the code to compute the payload size was moved, the value of hdrsize
    didn't get moved too.  The fix is to update tlen directly.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0a9f81750d0c9909c4b95a2de2d430daf754d020
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:30:40 2010 -0500

    IB/qib: set port physical state even if other fields are invalid
    
    The IBTA vol. 1 release 1.2.1 spec. says:
    C14-24.2.1: If PortInfo:Portstate=Down, then a SubnSet(PortInfo)
    shall make any changes it specifies to PortInfo:PortPhysicalState;
    any other result is vendor-dependent.
    
    The patch changes the error handling so that the reply says there
    are invalid fields but still attempts to set fields that are
    in range including PortInfo:PortPhysicalState.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 85dff982123cdb426b69b0a41e1101cf91227352
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:29:28 2010 -0500

    IB/qib: generate completion callback on errors
    
    According to IBTA vol. 1, C11-30.1.1, a notification callback is
    invoked if the CQ is armed for the next solicited completion event
    or an error completion. The error case wasn't being generated
    previously.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 466c85baa925b006c659b0c26e109bf1e4151d99
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:28:47 2010 -0500

    IB/qib: add thresholds to VendorPortCounters PMA operation
    
    This adds thresholds to be specified in the VendorPortCounters PMA
    operation.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 4b9e0ac717070c3e8628b9926b7e3a430c3f3541
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:27:02 2010 -0500

    IB/qib: add support for the new QME7362 card
    
    This patch adds support to recognize another board variation
    named QME7362.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit fc6238f5dfcc0e5e369a5a65ec46708cebafa895
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:24:59 2010 -0500

    IB/qib: add receive header queue size module parameters
    
    The receive header queue sizes need to modified to support
    performance tuning.  Three module parameters are added to
    support this.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 5be565611feaf040e50142339000379cf4790dc3
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 21 10:24:05 2010 -0500

    IB/qib: set cfgctxts to number of CPUs by default
    
    Up to now, we have set the number of available user contexts based on
    the number of hardware contexts which is set according to the number
    of available CPUs. This was fine since most CPUs had a power of two
    number of cores and the chip supported 4, 8, or 16 user contexts.
    Now that some systems have 12 cores, the default isn't optimal and
    should be set to 12 even though 16 hardware contexts need to be enabled.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

--------------060103040309070005040302
Content-Type: text/csv;
 name="bugs-2011-01-27.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2011-01-27.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9kZXNjIgoyMTI5LCJub3JtYWwi
LCJQNCIsIlNMRVMgMTEiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJjbG9zZV90ZXN0IGZhaWxzIG9uIGNhc2UgIzQgKFNIVVRET1dOX1JFQ1YpIgoyMTc1
LCJjcml0aWNhbCIsIlA1IiwiT3RoZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJ
RUQiLCJGSVhFRCIsIkNvbXBpbGF0aW9uIG9mIGRhaWx5IE9GRUQxLjUuMyAoMzAtMTEtMjAx
MCkgb24gUkg2IGZhaWxzIGR1ZSB0byBtaXNzaW5nIHN5c3lzZnN1dGlscy1kZXZlbHNmc3V0
aWxzLWRldmVsIgoyMTg4LCJjcml0aWNhbCIsIlA1IiwiQWxsIiwiYW1pcnZAbWVsbGFub3gu
Y28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsInRocmVzaG9sZHNfdGVzdCBvdmVyIFJvQ0UgY2F1
c2VzIHNlcnZlciB0byBoYW5nIgoyMTg5LCJlbmhhbmNlbWVudCIsIlA1IiwiT3RoZXIiLCJh
bWlydkBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJWEVEIiwiQWRkIElQdjYgc3VwcG9y
dCIKMjE5Miwibm9ybWFsIiwiUDUiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNM
T1NFRCIsIkZJWEVEIiwiTWFueSB3cm9uZyBlcnJub3MiCjIxOTMsIm1ham9yIiwiUDUiLCJP
dGhlciIsInZsYWRAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiW09GRUQt
MS41LjMtcmMxXSA6IGtlcm5lbCBBQkkgdmVyc2lvbiBtaXNtYXRjaGVzIHdpdGggbGliaWJ2
ZXJicyBvbiAyLjYuMzQoMzIgQml0KSBrZXJuZWwuIgoyMTk2LCJtYWpvciIsIlA1IiwiUmVk
SGF0IEZlZG9yYSBDb3JlIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJVbmFibGUgdG8gb3BlbiBTU0ggYmV0d2VlbiB0d28gbWFjaGluZXMgY29uZmln
dXJlZCBhbGwgdHJhZmZpYyB2aWEgU0RQIgoyMTk3LCJtaW5vciIsIlA1IiwiUmVkSGF0IEZl
ZG9yYSBDb3JlIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQi
LCJ0dGNwIGZhaWxzIG9wZW5pbmcgY29ubmVjdGlvbiB3aGlsZSB0cmFmZmljIGRpcmVjdGVk
IHZpYSBTRFAgb25seTsgZXJybm89OTciCjIxOTgsImVuaGFuY2VtZW50IiwiUDUiLCJSZWRI
YXQgRmVkb3JhIENvcmUgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJG
SVhFRCIsImVlZWUiCjIyMDAsImJsb2NrZXIiLCJQNSIsIkFsbCIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJpcHY2IG92ZXIgaXB2NCBkb2Vzbid0IHdvcmsi
CjIyMDEsImNyaXRpY2FsIiwiUDUiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNM
T1NFRCIsIkZJWEVEIiwiaXB2NiBzdHJ1Y3Qgc29ja2FkZHJfaW42LnNpbjZfc2NvcGVfaWQg
ZG9lc24ndCB3b3JrIgoyMjAzLCJtYWpvciIsIlAxIiwiT3RoZXIiLCJ2bGFkQG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIltPRkVELTEuNS4zLXJjMV0gb2ZhX2tlcm5l
bCBjb21waWxhdGlvbiBmYWlscyB3aXRoIFNMRVMxMVNQMSBhbmQgUkhFTDYuMCBvbiBQUEM2
NCIKMjIwNywibm9ybWFsIiwiUDUiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNM
T1NFRCIsIkZJWEVEIiwiY29ubmVjdCgpIGZhaWxzIGlmIGJpbmQoKSBpcyBkb25lIGluIGNs
aWVudCAtIElQdjYiCjIyMTQsImNyaXRpY2FsIiwiUDUiLCJSSEVMIDUiLCJ2bGFkQG1lbGxh
bm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkNvbXBpbGF0aW9uIG9mIGRhaWx5IGJ1
aWxkIE9GRUQgMS41LjMgaW4gUkhFTCA1LjUgZmFpbHMi
--------------060103040309070005040302--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
