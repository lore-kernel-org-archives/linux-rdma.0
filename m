From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 16:29:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0453F5@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Study of objects:
>  'device','port' - Pre-existing and read-only, query_object returns
>                    information like we have today
>  'pd','mr','mw','cq','srq','qp','ah' - Basic objects, not all have a
> modify/query
>  'flow','xrc',etc - extra objects

IMO, we should examine what items are objects.  E.g. and XRC RQ is treated as a QP, whereas an SRQ is not.  It may make more sense to treat each QP type as separate objects.  It would definitely make the data structures more efficient and a lot more understandable.

> Additional entry points:
>  poll_cq/req_notify_cq - These are high speed, so simple ioctls, or
>                          driver specific
>  post recv/send - drivers implement these via call_driver_on_object
>  attach/detach mcast - Could be 'modify' a qp, or could be new ioctls
>  async_event - Should be an ioctl
>  get_fd - Convert the object to a fd (eg async_fd, comp_channel, etc)

We could define a generic event_channel/event_queue object to report asynchronous events.  The EQ could then be associated with a device, port, CQ, CM objects (e.g. QP), etc.  User space could achieve current semantics by limiting which objects are associated with each channel.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
