From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Tue, 25 Feb 2014 22:32:57 -0800
Message-ID: <1393396377.12328.5.camel@haswell.thedillows.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>
			 <1392954937.26557.3.camel@haswell.thedillows.org>
			 <53071B2E.2050302@acm.org>
		 <1393047697.12377.11.camel@haswell.thedillows.org>
		 <530BA476.7040005@acm.org>
	 <1393302995.9096.1.camel@haswell.thedillows.org> <530C7175.5060907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530C7175.5060907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-02-25 at 11:33 +0100, Bart Van Assche wrote:
> Do you really think it is essential to introduce a
> new flag in the block layer for the purpose of suppressing transport
> layer error messages and to add support for that flag in the block
> core and in the SCSI mid-layer ? To me it seems a lot simpler to use
> the existing REQ_QUIET flag.

Yes, I think you want different semantics -- one is the requestor saying
"don't complain about this if it fails", the other is the LLD saying
"this failed due to transport failure, you may or may not want to report
it, under user control". But it doesn't necessarily have to be a new
block flag -- it may be as simple as adding a stanza in
scsi_io_completion() that looks like

if (cmd->device->sdev_state != SDEV_TRANSPORT_OFFLINE &&
    user_want_to_silence_transport_errors)
	req->cmd_flags |= REQ_QUIET;

if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
	;
else if (!(req->cmd_flags & REQ_QUIET))
	scsi_print_sense("", cmd);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
