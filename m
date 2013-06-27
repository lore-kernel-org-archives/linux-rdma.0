From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/14] IB/srp: Avoid that srp_reset_host() is skipped
 after a TL error
Date: Thu, 27 Jun 2013 17:03:18 -0400
Message-ID: <1372366998.32164.33.camel@frustration.ornl.gov>
References: <51B87501.4070005@acm.org> <51B87638.50102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87638.50102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-06-12 at 15:23 +0200, Bart Van Assche wrote:
> The SCSI error handler assumes that the transport layer is
> operational if an eh_abort_handler() returns SUCCESS. Hence let
> srp_abort() only return SUCCESS if sending the ABORT TASK task
> management function succeeded. This patch avoids that the SCSI
> error handler skips the srp_reset_host() call after a transport
> layer error.

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
