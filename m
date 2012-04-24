From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: possible recursive locking detected in the cma?
Date: Tue, 24 Apr 2012 19:37:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D8171@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Specifically, I see that your commit 186834b5de69 "RDMA/ucma: Fix
> AB-BA deadlock" deals only with the ucma and this trace doesn't
> have ucma  symbols, so is that a different race? or false alarm?

Maybe I'm overlooking something, but this looks like a false match.

> =============================================
> [ INFO: possible recursive locking detected ]
> 3.3.0-32035-g1b2649e-dirty #4 Not tainted
> ---------------------------------------------
> kworker/5:1/418 is trying to acquire lock:
>  (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0138a41>]
> rdma_destroy_id+0x33/0x1f0 [rdma_cm]

cma_req_handler() calls rdma_destroy_id() for the newly created rdma_cm_id.  rdma_destroy_id() acquires the handler_mutex for that id.

> but task is already holding lock:
>  (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>]
> cma_disable_callback+0x24/0x45 [rdma_cm]

cma_req_handler() calls cma_disable_callback)() for the listening rdma_cm_id.  The listening handler_mutex is held throughout the callback.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
