From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 1/2] rsockets: fix a race-condition in
 rs_free()
Date: Tue, 22 Aug 2017 22:50:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB17BAB5@ORSMSX109.amr.corp.intel.com>
References: <29EC6B54-616C-4263-BC75-C37A3286ABD8@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29EC6B54-616C-4263-BC75-C37A3286ABD8-YOWKrPYUwWM@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If rs_free() releases the fd before calling rs_remove(), a second
> thread in rsocket() may acquire the same fd and store its own rs in
> the corresponding index-element.  When the first thread then gets
> around to calling rs_remove() it ends up removing the rs of the second
> thread, and storing a NULL there.
> 
> Several functions still do not check for NULL after retrieving an rs
> from the index for an open rsocket.  Thus, the second thread would get
> a segfault in any of the following functions: rrecv, rrecvfrom, rsend,
> rsendto, rsendv, riomap, riounmap, riowrite.
> 
> Fixes:  cf7aae3 "rsocket: Index map item is cleaned before it is used
> in iomapping cleanup"
> 
> Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
