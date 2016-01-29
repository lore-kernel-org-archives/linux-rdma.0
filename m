From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 00/22] IB/srpt patches for Linux kernel v4.6
Date: Fri, 29 Jan 2016 15:10:38 -0800
Message-ID: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series of patches is what I came up with while testing the most
recent version of my SCSI target patch series (see also
http://thread.gmane.org/gmane.linux.scsi.target.devel/10905). This
includes fixes for ABORT handling and a lockup during driver shutdown.

The changes compared to v1 of this patch series are:
- Rebased this patch series on top of kernel v4.5-rc1.
- As proposed by Alex Estrin, modified patch "Simplify
   srpt_handle_tsk_mgmt()" such that task management function code
   validity is now checked by the target core.
- Added a comment in patch "Simplify channel state management".
- Changed "return true" into "return 1" in patch "Simplify
   srpt_shutdown_session()" as proposed by Christoph.
- Fixed patch "Fix srpt_handle_cmd() error paths" based on the feedback
   provided by Sagi.
- Split patch "Eliminate srpt_find_channel()" in three patches.
- Left out patch "Fix a rare crash in srpt_close_session()". It is no
   longer needed because srpt_disconnect_ch() is now called with the
   sdev mutex held.
- Added several new patches.

The patches in this series are:
0001-IB-srpt-Add-parentheses-around-sizeof-argument.patch
0002-IB-srpt-Remove-struct-srpt_node_acl.patch
0003-IB-srpt-Inline-srpt_sdev_name.patch
0004-IB-srpt-Inline-srpt_get_ch_state.patch
0005-IB-srpt-Introduce-target_reverse_dma_direction.patch
0006-IB-srpt-Use-scsilun_to_int.patch
0007-IB-srpt-Simplify-srpt_handle_tsk_mgmt.patch
0008-IB-srpt-Simplify-channel-state-management.patch
0009-IB-srpt-Simplify-srpt_shutdown_session.patch
0010-IB-srpt-Do-not-complain-about-initiator-names-withou.patch
0011-IB-srpt-Fix-srpt_close_session.patch
0012-IB-srpt-Fix-srpt_handle_cmd-error-paths.patch
0013-IB-srpt-Fix-how-aborted-commands-are-processed.patch
0014-IB-srpt-Inline-trivial-CM-callback-functions.patch
0015-IB-srpt-Eliminate-srpt_find_channel.patch
0016-IB-srpt-Log-private-data-associated-with-REJ.patch
0017-IB-srpt-Convert-rch_list-to-RCU.patch
0018-IB-srpt-Detect-session-shutdown-reliably.patch
0019-IB-srpt-Fix-srpt_write_pending.patch
0020-IB-srpt-Log-out-all-initiators-if-a-port-is-disabled.patch
0021-IB-srpt-Introduce-srpt_process_wait_list.patch
0022-IB-srpt-Fix-wait-list-processing.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
