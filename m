From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/srp: Avoid endless SCSI error handling loop
Date: Fri, 14 Dec 2012 10:55:52 -0500
Message-ID: <1355500552.18309.11.camel@frustration.ornl.gov>
References: <50CB46A4.4050300@acm.org> <50CB47E7.2060308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB47E7.2060308-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-12-14 at 16:38 +0100, Bart Van Assche wrote:
> If a SCSI command times out it is passed to the SCSI error
> handler. The SCSI error handler will try to abort the command
> that timed out. If aborting failed a device reset will be
> attempted. If the device reset fails too a host reset will
> be attempted. If the host reset also fails the whole procedure
> will be repeated.
> 
> Since srp_abort() and srp_reset_device() fail for a QP in the
> error state and since srp_reset_host() fails after host removal
> has started an endless loop will be triggered.
> 
> Hence modify the SCSI error handling functions in ib_srp as
> follows:
> - Abort SCSI commands properly even if the QP is in the error
>   state.
> - Make srp_reset_host() reset SCSI requests even if host
>   removal has already started or if reconnecting fails.

This is much more than your original patch that Alex claimed fixed his
issues; are you not merging two separate issues?

Also, there's no reason to invoke srp_send_tsk_mgmt() if we're not
connected or the QP is in error -- for those cases, it makes sense to
just abort the command directly. Similarly, we should probably be
checking the status of srp_send_tsk_mgmt() and failing -- or checking
qp_in_error/connected again and directly aborting if we have problems.

No?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
