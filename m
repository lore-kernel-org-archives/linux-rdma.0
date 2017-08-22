From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 2/2] rsockets: fix segfaults when rs is not
 found in the index
Date: Tue, 22 Aug 2017 22:51:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB17BACC@ORSMSX109.amr.corp.intel.com>
References: <84854B07-B6A2-4C89-8AAC-EFFF2754B19A@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84854B07-B6A2-4C89-8AAC-EFFF2754B19A-YOWKrPYUwWM@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Fixes: 0b6aff4 "librdmacm: Define streaming over RDMA interface
> (rsockets)"
> Fixes: bb9fcba "rsocket: Add APIs for direct data placement"
> 
> Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>

These are reasonable validation checks IMO.

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
