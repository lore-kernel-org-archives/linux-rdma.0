From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and
 ipoib/gro
Date: Wed, 1 Feb 2012 17:26:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237333499FCE@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
 <4F24F51F.20309@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237333498CF8@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW-uSrgpBhOr5gm4gWVrP3bqv2jihKqjpoPmbPoga_DJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW-uSrgpBhOr5gm4gWVrP3bqv2jihKqjpoPmbPoga_DJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Did you try 3.1?  ie do you know that the 3.2 bad results are a recent
> regression?

I don't know if this is a recent regression, but then the test is new.  I tried it on another system yesterday, but it was running 2.6.18 (RH EL 5?) with some OFED installation.  My plan is to start pulling older versions of the kernel.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
