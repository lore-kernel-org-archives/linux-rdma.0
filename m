From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Possible event on cm_id after rdma_accept() fails?
Date: Fri, 6 Jan 2012 22:23:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325675055@ORSMSX101.amr.corp.intel.com>
References: <CAL1RGDVhFP+yESH4pnYPA7co1WkY2HSV7vGB-eM34cgv7Tvpgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVhFP+yESH4pnYPA7co1WkY2HSV7vGB-eM34cgv7Tvpgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I get a new cm_id from a RDMA_CM_EVENT_CONNECT_REQUEST
> event, and call rdma_accept(), and then rdma_accept() returns an error
> for whatever reason, is it safe to assume I won't get any other events
> for the cm_id I failed to accept?
> 
> ie there's no race where another thread might get a disconnect event
> on that cm_id too, right?  So it's safe to just start cleaning up after
> I get a failed status from rdma_accept().

I typed in the response below before it occurred to me to ask whether you're asking about calling rdma_accept from user space or the kernel.  I was assuming user space. 

It looks like there is a race.

In ucma.c : ucma_event_handler(), we have:

 .. if (!ctx->uid) {
	/* ... ignore events for new connections ... */
	...
	goto out;
 }

But ucma_accept() does:

	ctx->uid = cmd.uid;
	...
	ret = rdma_accept(ctx->cm_id ...)

I believe it's possible for the remote side to issue a reject.  ucma_accept() could set ctx->uid.  The rdma_cm could process the reject, change the state of the cm_id, and call ucma_event_handler, which would queue the event.  rdma_accept() would then fail.

I think restructuring ucma_accept() like this would fix this race:

	mutex_lock(&file->mut);
	ret = rdma_accept(...)
	if (!ret)
		ctx->uid = cmd.uid;
	mutex_unlock(&file->mut);

I'll give this problem more thought.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
