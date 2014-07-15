From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2 0/2] NFS/RDMA server patches for 3.17
Date: Tue, 15 Jul 2014 15:46:24 -0500
Message-ID: <53C59320.70904@opengridcomputing.com>
References: <20140715175144.3448.48674.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715175144.3448.48674.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Veeresh U. Kokatnur" <veereshuk-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2014 12:54 PM, Chuck Lever wrote:
> Hi Steve-
>
> Can you include these 3.17 candidate patches in your testing branch?
>
> v2:
>
> - Second patch replaced with a lower-level fix
>

Done.

The for-test branch of git://git.linux-nfs.org/projects/swise/linux.git 
is now based on 3.16-rc5 plus:

Chuck Lever (23):
       xprtrdma: Fix panic in rpcrdma_register_frmr_external()
       xprtrdma: Protect ia->ri_id when unmapping/invalidating MRs
       xprtrdma: Limit data payload size for ALLPHYSICAL
       xprtrdma: Update rkeys after transport reconnect
       xprtrdma: On disconnect, don't ignore pending CQEs
       xprtrdma: Don't invalidate FRMRs if registration fails
       xprtrdma: Unclutter struct rpcrdma_mr_seg
       xprtrdma: Back off rkey when FAST_REG_MR fails
       xprtrdma: Chain together all MWs in same buffer pool
       xprtrdma: Properly handle exhaustion of the rb_mws list
       xprtrdma: Reset FRMRs when FAST_REG_MR is flushed by a disconnect
       xprtrdma: Reset FRMRs after a flushed LOCAL_INV Work Request
       xprtrdma: Don't post a LOCAL_INV in rpcrdma_register_frmr_external()
       xprtrdma: Disable completions for FAST_REG_MR Work Requests
       xprtrdma: Disable completions for LOCAL_INV Work Requests
       xprtrdma: Rename frmr_wr
       xprtrdma: Allocate each struct rpcrdma_mw separately
       xprtrdma: Schedule reply tasklet once per upcall
       xprtrdma: Make rpcrdma_ep_disconnect() return void
       xprtrdma: Remove RPCRDMA_PERSISTENT_REGISTRATION macro
       xprtrdma: Handle additional connection events
       [v2,1/2] svcrdma: Increase credit limit to 32
       [v2,2/2] svcrdma: Add zero padding if the client doesn't send it

Hariprasad S (2):
       iw_cxgb4: Fix skb_leak in reject_cr
       iw_cxgb4: clean up connection on arp error

Steve Wise (3):
       iw_cxgb4: call iwpm_init() only once
       iw_cxgb4: initialize the device status page
       svcrdma: send_write() must not overflow the device's max sge

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
