From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4-rc2 is available
Date: Thu, 20 Oct 2011 02:18:48 +0200
Message-ID: <4E9F68E8.4090004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010109080201050505040201"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010109080201050505040201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4-rc2 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.4

Regards,
Vladimir

Main changes from RC1:
----------------------
IB/qib: Bug fixes
Add RHEL6.2 beta support

Updated packages:
mstflint-1.4-1.13.g67bb70f
libcxgb3-1.3.1

MPI:
mvapich2-1.7-1


Supported Platforms and Operating Systems
---------------------------------------------
   o   CPU architectures:
         - x86_64
         - x86
         - ppc64
         - ia64

   o   Linux Operating Systems:
         - RedHat EL5 up6        2.6.18-238.el5
         - RedHat EL5 up7        2.6.18-274.el5
         - RedHat EL6            2.6.32-71.el6
         - RedHat EL6.1          2.6.32-131.0.15.el6
         - Scientific Linux 6.1  2.6.32-131.0.15.el6
         - SLES10 SP4            2.6.16.60-0.85.1-smp
         - SLES11                2.6.27.19-5-default
         - SLES11 SP1            2.6.32.12-0.7-default
         - kernel.org            2.6.30 - 3.0



--------------010109080201050505040201
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.4-rc2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.4-rc2.txt"

commit ac7665db4b6465fc6cb20e77c4d1a36606fe4ac8
Merge: feca492 32212e5
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Oct 19 15:52:33 2011 -0400

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit feca492ddd7f050f931f43d5f268ef936988d5db
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Oct 19 15:38:04 2011 -0400

    IB/qib: fix style issues with qib
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 09ff70afd95fef486bd271e345bde0c889dd6dac
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Oct 19 15:36:30 2011 -0400

    IB/qib: Fix issue with link states and QSFP cables
    
    Fix an issue where the link would come up after replugging
    a cable even if it has been DISABLED manually.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 78c1175b4f464c36fe9ee4741f3aa87f54fd3b11
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Oct 19 15:35:13 2011 -0400

    IB/qib: Hold links until tuning data is available
    
    Hold the link state machine until the tuning data is read
    from the QSFP EEPROM so correct tuning settings are applied
    before the state machine attempts to bring the link up.
    Link is also held on cable unplug in case a different cable is
    used.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 32212e55be995787dc37ba4557a8d252077973fa
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 18 19:34:02 2011 +0200

    Add RHEL6.2 beta support
    
    Kernel: 2.6.32-202.el6
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 365c8c2918d4b577ce2695ad68a56e4407e1bf52
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Oct 17 13:59:40 2011 +0530

    iw_cxgb4: Bring upstream commit 01e7da6ba53ca4d6189a1eae45607c0331c871f2
    
    This upstream commit makes sure that flush CQ entries are collected on
    connection close.
    
    At the time when a peer closes the connection, iw_cxgb4 will not send
    a cq event if ibqp.uobject exists.  In that case, its possible for a
    user application to get blocked in ibv_get_cq_event().
    
    To resolve this, call the cq's comp_handler to unblock any read from
    ibv_get_cq_event().  This will trigger userspace to poll the cq and
    collect flush status completions for any pending work requests.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit a2114b731c327129b98f805e71fe671d5539b066
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Oct 10 19:27:21 2011 +0530

    iw_cxgb4: Use NIPQUAD in sles10sp4 backport
    
    %pI4 is not available on sles10sp4 so, use NIPQUAD instead.
    Also fix few build warnings.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit d1c355e64d527abde8cea983f213f9cef1867acd
Merge: b8b8ff6 432c380
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 9 17:26:54 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit b8b8ff65b116ba5430c26e55fd368f7bb996bc03
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sat Oct 8 03:59:53 2011 +0530

    kernel_addons:2.6.16_sles10_sp4: Fix netif_napi_del
    
    kfree_skb on 2.6.16_sles10_sp4 does not check for NULL
    argument. Ability to handle NULL arguments in kfree_skb was
    introduced only after vanilla 2.6.16 release.
    
    So, protect call to kfree_skb with a NULL-check in netif_napi_del
    to prevent kernel crash.
    
    This resolves openfabrics bugzilla bug# 2294.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 81e203f568fc44c0bca53b6acc1a4d68e58c4c5e
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Oct 7 06:31:54 2011 +0530

    cxgb4: Fix ifconfig packet counters in backport
    
    This resolves openfabrics bugzilla bug# 2297
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 432c38055ba23a9b5f4c317578b93950dba82d58
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Oct 4 09:22:18 2011 -0400

    IB/qib,IB/ipath: handle kernels that export __get_user_pages()
    
    In patch 0014bd990e69063b0fb78940b35439d7980ce3ee,
    Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> exported __get_user_pages()
    and introduced a name conflict and syntax error in the qib
    and ipath driver.   His patch resolves the issue, but
    older code bases won't compile on kernels that have adopted
    his patch.
    
    This patch renames the static __get_user_pages() in each
    of the drivers to avoid the conflict.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

--------------010109080201050505040201--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
