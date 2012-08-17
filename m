From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Two more ib_srp patches
Date: Fri, 17 Aug 2012 11:07:36 -0400
Message-ID: <1345216056.17811.7.camel@frustration.ornl.gov>
References: <502E13DA.2030603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502E13DA.2030603-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-08-17 at 05:50 -0400, Bart Van Assche wrote:
> Hello Dave,
> 
> I think I have found two additional (longstanding) ib_srp issues. Do the
> patches below make sense to you ? If so, do you prefer that I post these
> as individual patches or that I merge these in the patch called "[PATCH
> 01/20] ib_srp: Fix a race condition" ?

Separate patches are fine.

> [PATCH 1/2] ib_srp: Fix use-after-free in srp_reset_req()

This needs to have a commit message along the lines of
"srp_free_req() uses the scsi_cmnd structure to unmap buffers, so we
must do that before we call release ownership by calling scsi_done()."

But otherwise

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

> [PATCH 2/2] ib_srp: Avoid that aborted requests cause I/O to hang

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>


-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
