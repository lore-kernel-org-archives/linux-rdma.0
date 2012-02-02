From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and ipoib/gro
Date: Thu, 2 Feb 2012 23:55:42 +0200
Message-ID: <CAJZOPZLnb0+Qw1F7GKd3tcUT3V6V=hNd_ZbGpReTsYfJf4L9MA@mail.gmail.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
	<4F24F51F.20309@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237333498CF8@ORSMSX101.amr.corp.intel.com>
	<CAL1RGDW-uSrgpBhOr5gm4gWVrP3bqv2jihKqjpoPmbPoga_DJg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237333499FCE@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A823733349A32B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823733349A32B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 2, 2012 at 6:50 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:

> I don't understand why, but the GRO issue seems to be the problem tha=
t I see with low
> performance (0.06 Gbps transferring 4k packets in one direction). =A0=
2.6.36 and 2.6.37 work > fine for me. =A0I see problems with 2.6.38, 3.=
0, and 3.2. =A0I didn't test other versions. =A0I
> applied the 'fix GRO merge failure for IPoIB' patch to 2.6.38 and 3.2=
, and in both cases
> the performance improved. =A0I'll wait for and test the final fix.

Sean, on 2.6.38 LRO was removed from IPoIB and GRO added, so your
report makes sense, I will send you now the patch posted by Eric
enhanced such that ipoib sets the new gro_header_len field

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
