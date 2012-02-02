From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and
 ipoib/gro
Date: Thu, 2 Feb 2012 16:50:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823733349A32B@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
 <4F24F51F.20309@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237333498CF8@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW-uSrgpBhOr5gm4gWVrP3bqv2jihKqjpoPmbPoga_DJg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237333499FCE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237333499FCE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I don't know if this is a recent regression, but then the test is new.  I
> tried it on another system yesterday, but it was running 2.6.18 (RH EL 5?)
> with some OFED installation.  My plan is to start pulling older versions of
> the kernel.

I don't understand why, but the GRO issue seems to be the problem that I see with low performance (0.06 Gbps transferring 4k packets in one direction).  2.6.36 and 2.6.37 work fine for me.  I see problems with 2.6.38, 3.0, and 3.2.  I didn't test other versions.  I applied the 'fix GRO merge failure for IPoIB' patch to 2.6.38 and 3.2, and in both cases the performance improved.  I'll wait for and test the final fix.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
