From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Initialize hop_limit to a known default macro
 instead of 1 as is done currently.
Date: Fri, 15 Nov 2013 03:11:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D05B18@ORSMSX109.amr.corp.intel.com>
References: <07f80ed7-7ea4-4c30-afe5-3f9fc7dd37fb@CMEXHTCAS2.ad.emulex.com>,<1828884A29C6694DAF28B7E6B8A8237388D046BC@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D2C8AB76A@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D2C8AB76A-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>         This change was done precisely to enable us to do that i.e make it
> routable. This was the only suitable macro i could find that defines a
> certain default value for the hop limit and is used by the IPv6 layer in
> the kernel already. I'm open to other suggestions of values, but pegging to
> 1 means we are not allowing any scope for it to be routable in the future
> ..Would you agree ?

I agree that hop_limit of 1 restricts it from routing.  How far along is a routable RoCE definition?

Because underlying code behaves differently based on the hop_limit (changes the timeout and LID values), I'd like to see the hop_limit setting at least take into account whether the src/dst addresses are on different subnets, so that it can remain 1 when routing is not in use.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
