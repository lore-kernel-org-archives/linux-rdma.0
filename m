From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 05/14] ib_srp: Avoid that late SRP replies cause trouble
Date: Thu, 15 Dec 2011 15:03:24 -0500
Message-ID: <1323979404.16703.68.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012000.04427.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012000.04427.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 20:00 +0100, Bart Van Assche wrote:
> If a user misconfigures the block layer timeout such that it is below
> the InfiniBand RC timeout it can happen that an SRP reply arrives after
> the SCSI error handler has already killed the associated SCSI command.
> Avoid that late replies cause a kernel crash.

I'm not sure that the case you describe can happen. The request do not
get killed until srp_remove_req() is called on them. In the event of
timeouts, this will be through srp_abort() initially, and then
srp_reset_device() and srp_reset_host(). If srp_abort() is successful,
we will never see a reply for that request unless the target is broken.
If it fails, a successful srp_reset_device() gives us the same
assurance. And if that fails, we kill the connection in
srp_reset_host(), so there is no possibility of a late reply.

However, the code as it currently is leaves us open to malformed
requests from the target. We cannot do anything about it if the target
is swapping tags around on the requests, but we should detect invalid
tags and take appropriate action. Checking for a null req->scmnd and
returning isn't the right action, as that leaks the request, and does
nothing to protect against bad tags.

I'm happy to code up a patch that sanity-checks the response for
in-range and outstanding (req->scmnd != NULL) responses, and kills the
connection, or you are welcome to do so as well. I think it would be
better suited later in the patch series, building on top of your work to
disconnect a target without removing the module.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
