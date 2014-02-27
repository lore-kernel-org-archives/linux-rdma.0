From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Thu, 27 Feb 2014 14:44:26 +0100
Message-ID: <530F413A.3020706@acm.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>				 <1392954937.26557.3.camel@haswell.thedillows.org>				 <53071B2E.2050302@acm.org>			 <1393047697.12377.11.camel@haswell.thedillows.org>			 <530BA476.7040005@acm.org>		 <1393302995.9096.1.camel@haswell.thedillows.org>	 <530C7175.5060907@acm.org>	 <1393396377.12328.5.camel@haswell.thedillows.org>	 <530DE93A.2040400@acm.org> <1393480118.16410.10.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393480118.16410.10.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/27/14 06:48, David Dillow wrote:
> I don't see where the block level is printing messages about the failed
> requests -- but maybe I'm missing it. I see scsi_done() ->
> blk_complete_request() -> blk_done_softirq() -> scsi_softirq_done() ->
> scsi_finish_command() -> scsi_io_completion()
> 
> I'm not seeing where the errored block requests would be printed before
> scsi_io_completion(), which is where we were talking about setting the
> REQ_QUIET flag above.
> 
> What messages are you talking about -- even better if you can point to
> where they come from -- but mainly which ones; I'm happy to track them
> down myself. It's been a while since I've done a deep dive on this code,
> so my apologies if it should be obvious to me...

Hello Dave,

I think the call chain is as follows: scsi_io_completion() ->
scsi_end_request() -> blk_end_request() -> blk_end_bidi_request() ->
blk_update_bidi_request() -> blk_update_request(). That last function
prints an error message for failed requests if REQ_QUIET has not been
set. So this means that it's possible to set the REQ_QUIET flag from the
SCSI mid-layer before the block layer checks that flag.

> I agree it is the most expedient approach to solve Sebastian's immediate
> problem, but I'd rather the solution be generic to the SCSI mid-layer so
> it will be useful for others beyond SRP.

It would be great if this would be solved in a more generic way. But
please keep in mind that this is not just Sebastian's problem - other
users have reported this before.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
