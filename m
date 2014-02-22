From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Fri, 21 Feb 2014 21:41:37 -0800
Message-ID: <1393047697.12377.11.camel@haswell.thedillows.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>
	 <1392954937.26557.3.camel@haswell.thedillows.org>
	 <53071B2E.2050302@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53071B2E.2050302-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2014-02-21 at 10:23 +0100, Bart Van Assche wrote:
> On 02/21/14 04:55, David Dillow wrote:
> > While I can see the utility for slow consoles, this should probably be
> > done in the SCSI lib, with a separate flag for indicating it is a
> > failure due to transport issues. That would allow the functionality to
> > be used by multiple drivers and verbosity configured in one place,
> > rather than patched in driver-by-driver.
> 
> Hello Dave,
> 
> If it would be possible to move the code for setting the REQ_QUIET flag
> into the SCSI lib that would be great. However, as far as I know only
> the LLD knows which requests are in progress. A call to
> blk_start_request() makes blk_dequeue_request() remove a request from
> the queuelist in struct request_queue. I am not aware of any list in the
> block layer nor in the SCSI mid-layer that keeps track of requests that
> are in progress ?

I didn't suggest that -- I'm saying add a common functionality to turn
on/off the message printing for commands that failed due to a dead
transport. If it is useful for SRP initiators, it is probably useful for
SAS and iSCSI imitators as well.

At a quick look, it seems you need to add a new value to the
rq_flag_bits enum in include/linux/blk_types.h, __REQ_FAILED_TRANSPORT,
somewhere before __REQ_NR_BITS. And a #define in the style of those
following it. Use that flag instead of REQ_QUIET in the patch we are
discussing, and change the code in scsi_lib.c to check

  ((req->cmd_flags & REQ_FAILED_TRANSPORT) && $user_wants_this_knob) || !(req->cmd_flags & REQ_QUIET)

before calling scsi_print_sense(), with appropriate naming, of course.
This gives you a central place to control it, and allows for consistency
between initiators.

I agree it is much easier to just fix it in SRP, especially given the
glacial rate of change for the SCSI mid-layer, but I really think a
central control and driver-by-driver enablement would be the best
approach. YMMV.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
