From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 1/2] IB/srp: Track connection state properly
Date: Fri, 14 Dec 2012 10:48:04 -0500
Message-ID: <1355500084.18309.5.camel@frustration.ornl.gov>
References: <50CB46A4.4050300@acm.org> <50CB4713.4080909@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB4713.4080909-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-12-14 at 16:34 +0100, Bart Van Assche wrote:
> The connection state must be initialized before srp_connect_target()
> is invoked. Drop the assignment in srp_add_target() since
> scsi_host_alloc() zero-initializes the Scsi_Host structure anyway.
> This patch makes ib_srp again report the first QP error.

This change log doesn't capture the actual reason for the change -- if
it were really about the assignment being redundant with the
zero-initialization, the patch would be a no-op.

"Don't trash the connection state after srp_connect_target() has
properly initialized it."

or something like that.

Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
