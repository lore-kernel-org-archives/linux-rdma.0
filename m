From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Mon, 5 May 2014 22:57:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F899C@ORSMSX109.amr.corp.intel.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
 <53619638.48ae0e0a.2e40.ffffec09SMTPIN_ADDED_BROKEN@mx.google.com>
 <5361E5C7.5030805@mellanox.com>
 <1980561.1785.1398958457283.JavaMail."DougALedford"@Phenom>
 <1828884A29C6694DAF28B7E6B8A82373992F869F@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.10.1405051754260.5069@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1405051754260.5069-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have no earthly idea what this is or where it came from.  It doesn't show up in my sent items folder as this.

> PiBJJ20gY3VyaW91cyB3aHkgdGhpcyBpcyBkb25lIGF0IFFQIGNyZWF0aW9uIHRpbWUuICBTaG9
> 1
> >
> bGQgdGhpcyBub3QNCj4gYmUgZG9uZSBhdCBtdWx0aWNhc3Qgam9pbiB0aW1lPyAgQSBzaW5nbGU
> g
> >
> UVAgY2FuIGJlIGEgbWVtYmVyIG9mIG1vcmUNCj4gdGhhbiBvbmUgTUMgZ3JvdXAsIHdvdWxkIGl
> 0
> >
> IG5vdCBzZWVtIG1vcmUgY29ycmVjdCB0byB5b3UgdGhhdCB0aGUNCj4gbG9vcGJhY2sgc2hvdWx
> k
> >
> IGJlIHNwZWNpZmllZCBvbiBhIHBlciBncm91cCBiYXNpcyBhbmQgbm90IGEgcGVyIFFQDQo+IGJ
> h
> >
> c2lzPw0KDQpJIGFncmVlIHdpdGggRG91ZyBoZXJlLiAgVGhpcyBtYWtlcyBtb3JlIHNlbnNlIHR
> v
> >
> IHNwZWNpZnkgb24gbXVsdGljYXN0IGF0dGFjaCB0aW1lLCBub3QgUVAgY3JlYXRpb24gdGltZS4
> g
> > DQo=
> >

What I said was:

I agree with Doug here.  This makes more sense to specify on multicast attach time, not QP creation time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
