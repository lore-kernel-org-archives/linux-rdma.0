From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 12 Jan 2017 21:35:08 +0200
Message-ID: <20170112193508.GO20392@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484246776.123135.19.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2017 at 01:46:16PM -0500, Doug Ledford wrote:
> On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > In datagram mode, the IB UD (Unreliable Datagram) transport is used
> > so the MTU of the interface is equal to the IB L2 MTU minus the
> > IPoIB encapsulation header. Any request to change the MTU value
> > above the maximum range will change the MTU to the max allowed, but
> > will not show any warning message. An ipoib_warn is issued in such
> > cases, letting the user know that even though the value is legal,
> > it can't be currently applied.
> >
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > =A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++++
> > =A01 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index 3ce0765..a550cc6 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -229,6 +229,10 @@ static int ipoib_change_mtu(struct net_device
> > *dev, int new_mtu)
> > =A0
> > =A0	priv->admin_mtu =3D new_mtu;
> > =A0
> > +	if (priv->mcast_mtu < priv->admin_mtu)
> > +		ipoib_warn(priv, "MTU must be smaller than mcast_mtu
> > (%u)\n",
> > +			=A0=A0=A0priv->mcast_mtu);
> > +
> > =A0	dev->mtu =3D min(priv->mcast_mtu, priv->admin_mtu);
> > =A0
> > =A0	return 0;
>
> I don't like this patch. =A0First, there's no need for a warning here.
> =A0That's entirely too noisy for this issue. =A0Second, the wording of the
> message is poor. =A0The user thinks they are setting the MTU, and there
> is no means of setting a multicast MTU, so telling them that their new
> MTU must be less than the mcast MTU that they can't do anything about
> and don't necessarily know how it is generated makes no sense. =A0This
> should be no more than ipoib_dbg if we even print anything out at all,
> and the message should be more like "MTU must be <=3D the link layer MTU
> - 4, use ibv_devinfo on the RDMA device to get the link layer MTU"

First of all, thank you for fixing wording, for me it is the hardest
part of every commit.

Second, I have a different view from you on the issue. User configured
some value, which is not correct for IPoIB. In ideal world (without legacy),
we were supposed to return error to him with proper message, but in our
case (legacy applications) we can't (we tried and it broke some legacy
ifcongfig, if I remember well). So it leaves us with one available
option is to warn user about improper value.

User should know that he supplied wrong parameter.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh32mwACgkQ5GN7iDZy
WKeC5w/8CtxmvtbCLq1hIMwusvCr4PELJk+93pBAn9vL+N0F094ZsYPYuTprt/W4
ER7Xuk6rkNQlYEFMieuMTdrY/zY6qmn9RLQdb8IlwmkLEN6V/fcRtrluCohMebcP
1CwwHYDeFF+94xQVsykSJ4Ll5in4T4vdGBuaTw2lgaNVq1H1ik0jRWDbS/oXgjCW
UBPHPpZYfQDqwGru2DV5/pYx5F8zrLMTloUAwY9PtpmH4IKJN6IeXf9QJIi9+tZF
H8JWEahlnBd3LTW100je2rfPAomp4dcQFycmpjIT/88yifd1kJkF898tyGHwWROO
Yzd3s1+jUqCWIt8ngtX3GZPQCP1Z034IFaiGn11/v+Oj+l4aELw7fEPJq3yyztWm
RAMQczI72/Tguz7xyF2WpItASoXs4mvMC/5BjwjPPEKQ+D4TayeADYdTSqwyDnqj
GubZntFS0tDs+yWNHspFCo+rZvOFUIKanwVcLVB9J8tHqtinlyMbmVhE7QdhQOJu
WmVB0xVcJnG4//VOvuuof+CHaX0KxwtqlVQu9n/3WTwO2Qk4S+D2W2RBiyqsekZm
p+BER/CJN/NuqHiXTUznZijYoWhwb0MysIKinTkEI15Rm5Cg6ngExuPNzoh/8TT9
QBqz+Bh7xbtZxIMdo00DkfUoYxaC/k5r8Kp7KW9AdG56crSiQs4=
=UrgU
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
