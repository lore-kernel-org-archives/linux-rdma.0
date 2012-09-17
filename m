From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Fix use-after-free in srp_reset_req()
Date: Mon, 17 Sep 2012 15:31:50 -0400
Message-ID: <1347910310.12412.5.camel@frustration.ornl.gov>
References: <5037572A.4040006@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5037572A.4040006-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-08-24 at 10:27 +0000, Bart Van Assche wrote:
> srp_free_req() uses the scsi_cmnd structure contents to unmap
> buffers, so we must invoke srp_free_req() before we release
> ownership of that structure.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Roland, are you planning to apply this one and the one Bart has that
fixes the error handling (srp_aport)? I didn't see them in your pull
request.

Thanks,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
