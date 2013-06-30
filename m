From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 03/15] IB/srp: Avoid that srp_reset_host() is skipped
 after a TL error
Date: Sun, 30 Jun 2013 16:00:30 -0400
Message-ID: <1372622430.12468.10.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD8644.5080600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD8644.5080600-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 14:49 +0200, Bart Van Assche wrote:
> The SCSI error handler assumes that the transport layer is
> operational if an eh_abort_handler() returns SUCCESS. Hence let
> srp_abort() only return SUCCESS if sending the ABORT TASK task
> management function succeeded. This patch avoids that the SCSI
> error handler skips the srp_reset_host() call after a transport
> layer error.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
