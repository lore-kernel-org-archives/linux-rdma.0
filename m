From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 00/11] New Caching mechanism for ib_core
Date: Mon, 7 Nov 2011 14:17:54 +0530
Message-ID: <20111107084747.GA11297@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

This series of patches introduces caching as a library in the ib_core 
as compared to the previous of implementation as a part of the
ib_device calls. Each driver can make use of this by including
the ib_cache data structure in the individual device structure.
The updation of the cache is the responsibility of the driver, and
is best incorporated in the pkey/gid query functions. However, the
driver may choose to pre-populate the cache on initialization.

The main motivations are:

1. Greater degree of control by individual drivers. Drivers have a
   choice to use it or not.
2. The library functions do not sleep, and can be called from any context.

In the bargain we lose the lmc cache. However, if we move it to the device
structure like the pkey_tbl_len, it can be accessed directly (TODO).
Let me know what you think about it.

I have changed only the mthca driver for now to use this API of the
cache. If I get positive comments, I will incorporate it in the
rest of the drivers as well. Let me know what you think.

TODO:
Use finer granuality of locking for pkey and gid tables.

Suggestions welcome.

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
