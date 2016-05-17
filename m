From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Tue, 17 May 2016 16:38:54 +0300
Message-ID: <20160517133854.GG4662@leon.nu>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
 <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
 <20160514043353.GG11827@leon.nu>
 <f9210e1d-667d-5f62-f1bd-7545a0ff6153@redhat.com>
 <20160515060005.GH11827@leon.nu>
 <04c7b983-66b4-0609-9cf4-3c7b1e126a53@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <04c7b983-66b4-0609-9cf4-3c7b1e126a53-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 04:15:45PM -0400, Doug Ledford wrote:
> On 05/15/2016 02:00 AM, Leon Romanovsky wrote:
> > On Sat, May 14, 2016 at 09:09:54AM -0400, Doug Ledford wrote:
> >> On 05/14/2016 12:33 AM, Leon Romanovsky wrote:
> >>> On Fri, May 13, 2016 at 12:31:55PM -0400, Doug Ledford wrote:
> > There are three issues with this request:
> > 1. It is not silence, but readiness to merge, since all feedback is
> > answered and everything is understandable. LSO patches are great
> > example for it, if the people don't understand they will ask and will
> > request to adjust patches accordingly.
>=20
> No, you don't merge things before they are understood and then adjust
> them.  You merge things you already understand.
>=20
> > 2. It will limit ability to move IB stack further and will eliminate
> > fair competitive market.
>=20
> Competition is not a valid reason to merge poorly understood or poorly
> designed code.

No one expects to see this code merged, this is why I gave LSO as an
example: people don't understand -> they ask questions, exactly as was
in LSO, and it is OK that this code wasn't merged due to limited
explanation which will be improved in next version.

The not OK is to expect from hardware vendors better review than
community can perform.

Hardware vendors signature in the limited IB world won't help to anyone
to get good commit messages or better design.

These patches are written by engineers for other engineers for real use
and not for marketing purposes.

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOx7uAAoJEORje4g2clinAw0P/iCL8C4RVpSQKCreJCEXEz0M
WhJ+qjwOX5l0HyJVKgnMYc7lLxD05b8UM2jVBNK9anf3gYl+zw267KQsk/4fBGWR
9wK+GjsQZGQyOxB+NDo8AeBb+viAx7xq4AWVrNF4IbCwNkXYBCGjwIrT+s5LCAXC
ZVR/gyuhEOikz5RWeoPrh9h0JXq/+CR/wFyb+CFNrqSvNay32cFZmDEe+ny5EFXR
JsNCtpwI8yMk+N9D4/ODxwcU6vyINdLaWnVxpg+wt/s5JK1jBouEVVlzvbkbdSEV
YeKRFPgfnKUk1ul+EqVK/gfhBQW+mTFl0GE0rdJ5KAEmKW3LZzT9mQf0PPTLnylk
N/fEzahRSeU4MXYBVTTDrG4y8vDL/E8G9ZEoqBNUVE8eHAfdrOJaVLA17Jxje1sY
G+ZmFU641H3Q0YpscKpvgig1N0+4p7LO0i+ivmXdUvrLX2q0QIIEC6Qft2oPLM4M
OCu3RNdLWl91WB/8ATWPemBLqdM6U1hWWI1eWsWhDu7+mIrjxZJL+spmZa0Kv/yk
cH0rVmADuNFyq0/CDoQr3M9XCcQIRacMUtjkTWfxwDEiSjcThNz1zgAHV95d3G6a
mmjyfbZ27OIXag3tUeon3NQQZl8zPqRJh/jTTGujtGe7Pxuw6KAG+GCCEWPbOMTA
yTBHIyGT0xK+OBILVD1Y
=zrij
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
