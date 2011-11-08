From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/11] New Caching mechanism for ib_core
Date: Tue, 8 Nov 2011 23:46:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8DDCE@ORSMSX101.amr.corp.intel.com>
References: <20111107084747.GA11297@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111107084747.GA11297-DN/iB9hNKqpUanf73oPxOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The main motivations are:
> 
> 1. Greater degree of control by individual drivers. Drivers have a
>    choice to use it or not.

I believe that some callers need to know that specific query calls will not sleep.  That capability should either be required or exposed through the API.

> 2. The library functions do not sleep, and can be called from any context.
> 
> In the bargain we lose the lmc cache. However, if we move it to the device
> structure like the pkey_tbl_len, it can be accessed directly (TODO).
> Let me know what you think about it.

The LMC cache is accessed by the MAD layer.  I know that MADs aren't considered a performance path, but we don't want to query the device for every MAD.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
