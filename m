From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] Add flow control to the portmapper
Date: Tue, 02 Aug 2016 13:16:50 -0400
Message-ID: <1470158210.18081.15.camel@redhat.com>
References: <1469736146-17640-1-git-send-email-shiraz.saleem@intel.com>
	 <20160729044746.GT4628@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/mPdSata8oodvvP9zllV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160729044746.GT4628-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/mPdSata8oodvvP9zllV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-29 at 07:47 +0300, Leon Romanovsky wrote:
> On Thu, Jul 28, 2016 at 03:02:26PM -0500, Shiraz Saleem wrote:
> >=20
> > From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > During connection establishment with a large number of
> > connections, it is possible that the connection requests
> > might fail. Adding flow control prevents this failure.
> > Change ibnl_unicast to use blocking to enable flow control.
> >=20
> > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >=20
> > V3: update to use blocking ver. of netlink_unicast() in=C2=A0
> > ibnl_unicast(), instead of creating new function in=C2=A0
> > netlink header for this purpose; as was done in V1.
> >=20
> > V2: update commit message with justification for flow control.=C2=A0
> > CC'ing linux-netdev mailing list.
> >=20
> > =C2=A0drivers/infiniband/core/netlink.c | 9 ++++++++-
> > =C2=A01 file changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/core/netlink.c
> > b/drivers/infiniband/core/netlink.c
> > index 9b8c20c..a6b3acb 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -229,7 +229,13 @@ static void ibnl_rcv(struct sk_buff *skb)
> > =C2=A0int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
> > =C2=A0			__u32 pid)
> > =C2=A0{
> > -	return nlmsg_unicast(nls, skb, pid);
> > +	int err;
> > +
> > +	err =3D netlink_unicast(nls, skb, pid, 0);
> > +	if (err > 0)
> > +		err =3D 0;
> > +
> > +	return err;
>=20
> It can be simplified a little bit to remove number of lines.
> 4 last lines can be replaced to be one in ANSI C.
>=20
> return (err < 0)?:0;

return (err < 0) ? err : 0; is more readable to me.

With fixup and minor change to commit subject, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-/mPdSata8oodvvP9zllV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNWCAAoJELgmozMOVy/dsKIQALFMlhNTvDBnSiD6P+D3ppYy
LdW/Ta6ZUS6r8+jMcxXMINV/hozDcgwsXyomIoFQ7Wyg5u54Cnai33dt1QAAlhnD
vAKIZ+zqMOBuyT+lYtuSoNgKpcsUetG9ft6HpWrj1W2GPqtUsuxMuKVRkMmOwNXA
U3U6JT2rsC0c9bWS2xr7Lo88nExJGP9y8AR/VsJaxP4NVDOsGuBdLWZrtbWY6W75
FUH1ng/5YFi0CHHDpuUNNfvzHBP+MlrFcqVI79iLOV4015OSHWCIKW5erK6P2xRx
rnhinJwDKC5kERreqTwGyLKt1xVg1dND3Po4ORhzrwZRdpZDLpmamicNvD4Z0len
tab0VZi7/UfHGy5lvuKOyQiQGgn3CTLKWPlxVdBsH3D0pNPsHrW/G0UToVtNgXt8
SPY2/WSO5xVcylCDxFeadMmbaQIpM1R/AXSCLiVWn0Te3y4pKT23vf5tyiL+76IK
huB71KBbo2nhCDtzU2tIvBI9dCDcrfW0j5/L6J7MBTX7+bp6BWBNb5vWQFp4HYXR
fknwD3wHU0OmPUW2gP8zL3ZoO7HIuJvL4hxtZryMOiX49CmiNhkeVjtVm6D3dEgC
1Y4oRFA+7wLJ41YLF3W7OSRnZ9kX+OqH34YYz8eO0oPe7KechOcgBonto6/FCE77
41i7cuKZts9BaAAWNKHU
=BM8Y
-----END PGP SIGNATURE-----

--=-/mPdSata8oodvvP9zllV--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
