From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v3 3/3] IB/srp: Avoid endless SCSI error handling loop
Date: Wed, 19 Dec 2012 13:07:15 -0500
Message-ID: <1355940435.23687.4.camel@frustration.ornl.gov>
References: <50D1CD49.5080607@acm.org> <50D1CE0B.2080902@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D1CE0B.2080902-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2012-12-19 at 15:24 +0100, Bart Van Assche wrote:
> If a SCSI command times out it is passed to the SCSI error
> handler. The SCSI error handler will try to abort the commands
> that timed out. If aborting failed a device reset will be
> attempted. If the device reset also fails a host reset will
> be attempted. If the host reset also fails the whole procedure
> will be repeated.
> 
> srp_abort() and srp_reset_device() fail for a QP in the error
> state. srp_reset_host() fails after host removal has started.
> Hence if the SCSI error handler gets invoked after host removal
> has started and with the QP in the error state an endless loop
> will be triggered.
> 
> Modify the SCSI error handling functions in ib_srp as follows:
> - Abort SCSI commands properly even if the QP is in the error
>   state.
> - Make srp_reset_host() reset SCSI requests even after host
>   removal has already started or if reconnecting fails.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

It's not the cleanest way to handle this, but it is the simplest and
we're short on time.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
