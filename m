From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 00/15] Various ib_srpt patches
Date: Tue, 5 Jan 2016 15:19:40 +0100
Message-ID: <568BD0FC.70207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following series of patches is what I came up with while testing the 
most recent version of my SCSI target patch series (see also 
http://thread.gmane.org/gmane.linux.scsi.target.devel/10905):

0001-IB-srpt-Add-parentheses-around-sizeof-argument.patch
0002-IB-srpt-Inline-srpt_sdev_name.patch
0003-IB-srpt-Inline-srpt_get_ch_state.patch
0004-IB-srpt-Introduce-target_reverse_dma_direction.patch
0005-IB-srpt-Use-scsilun_to_int.patch
0006-IB-srpt-Simplify-srpt_handle_tsk_mgmt.patch
0007-IB-srpt-Simplify-channel-state-management.patch
0008-IB-srpt-Simplify-srpt_shutdown_session.patch
0009-IB-srpt-Fix-srpt_close_session.patch
0010-IB-srpt-Fix-srpt_handle_cmd-error-paths.patch
0011-IB-srpt-Fix-how-aborted-commands-are-processed.patch
0012-IB-srpt-Eliminate-srpt_find_channel.patch
0013-IB-srpt-Detect-session-shutdown-reliably.patch
0014-IB-srpt-Fix-srpt_write_pending.patch
0015-IB-srpt-Fix-a-rare-crash-in-srpt_close_session.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
