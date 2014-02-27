From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Wed, 26 Feb 2014 21:48:38 -0800
Message-ID: <1393480118.16410.10.camel@haswell.thedillows.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>
				 <1392954937.26557.3.camel@haswell.thedillows.org>
				 <53071B2E.2050302@acm.org>
			 <1393047697.12377.11.camel@haswell.thedillows.org>
			 <530BA476.7040005@acm.org>
		 <1393302995.9096.1.camel@haswell.thedillows.org>
	 <530C7175.5060907@acm.org>
	 <1393396377.12328.5.camel@haswell.thedillows.org>
	 <530DE93A.2040400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530DE93A.2040400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2014-02-26 at 14:16 +0100, Bart Van Assche wrote:
> On 02/26/14 07:32, David Dillow wrote:
> > On Tue, 2014-02-25 at 11:33 +0100, Bart Van Assche wrote:
> >> Do you really think it is essential to introduce a
> >> new flag in the block layer for the purpose of suppressing transport
> >> layer error messages and to add support for that flag in the block
> >> core and in the SCSI mid-layer ? To me it seems a lot simpler to use
> >> the existing REQ_QUIET flag.
> > 
> > Yes, I think you want different semantics -- one is the requestor saying
> > "don't complain about this if it fails", the other is the LLD saying
> > "this failed due to transport failure, you may or may not want to report
> > it, under user control". But it doesn't necessarily have to be a new
> > block flag -- it may be as simple as adding a stanza in
> > scsi_io_completion() that looks like
> > 
> > if (cmd->device->sdev_state != SDEV_TRANSPORT_OFFLINE &&
> >     user_want_to_silence_transport_errors)
> > 	req->cmd_flags |= REQ_QUIET;
> > 
> > if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
> > 	;
> > else if (!(req->cmd_flags & REQ_QUIET))
> > 	scsi_print_sense("", cmd);
> 
> But this approach doesn't suppress the error messages printed by the
> block layer due to a transport layer failure.

I don't see where the block level is printing messages about the failed
requests -- but maybe I'm missing it. I see scsi_done() ->
blk_complete_request() -> blk_done_softirq() -> scsi_softirq_done() ->
scsi_finish_command() -> scsi_io_completion()

I'm not seeing where the errored block requests would be printed before
scsi_io_completion(), which is where we were talking about setting the
REQ_QUIET flag above.

What messages are you talking about -- even better if you can point to
where they come from -- but mainly which ones; I'm happy to track them
down myself. It's been a while since I've done a deep dive on this code,
so my apologies if it should be obvious to me...

> Additionally, the block layer is neither aware of the SCSI transport
> layer state nor of the ASC and ASCQ codes in the sense data.

Of course it isn't, and no one is suggesting it should.

> Hence my preference to keep patch 3/6 as it has been posted at the
> start of this thread.

I agree it is the most expedient approach to solve Sebastian's immediate
problem, but I'd rather the solution be generic to the SCSI mid-layer so
it will be useful for others beyond SRP.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
