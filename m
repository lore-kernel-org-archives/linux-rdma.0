From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH][RESEND] IB/cma: Resolve AF_IB UD support
Date: Tue, 19 May 2015 17:06:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDCFC6@ORSMSX109.amr.corp.intel.com>
References: <1432019508-95824-1-git-send-email-matt@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432019508-95824-1-git-send-email-matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hari Shankar <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Resent due to mailer issues

Next time, please put this comment under the '---', so that it doesn't end up in the patch description.

> Support for using UD and AF_IB is currently broken.  The
> IB_CM_SIDR_REQ_RECEIVED
> message is not handled properly in cma_save_net_info() and we end up
> falling
> into code that will try and process the request as ipv4/ipv6, which will
> end
> up failing.
> 
> The resolution is to add a check for the SIDR_REQ and call
> cma_save_ib_info()
> with a NULL path record.  Change cma_save_ib_info() to copy the src sib
> info
> from the listen_id when the path record is NULL.
> 
> Reported-by: Hari Shankar <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
