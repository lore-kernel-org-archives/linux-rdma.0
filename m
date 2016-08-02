From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0254/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 02 Aug 2016 11:44:15 -0400
Message-ID: <1470152655.18081.1.camel@redhat.com>
References: <20160802105341.30676-1-baolex.ni@intel.com>
	 <006201d1ecc7$f6889bd0$e399d370$@opengridcomputing.com>
	 <20160802150832.GA26697@home.goodmis.org>
	 <00c701d1ecd1$5a4caef0$0ee60cd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-F7DcYzqLjVAVFwXTa72X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00c701d1ecd1$5a4caef0$0ee60cd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Steven Rostedt' <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: 'Baole Ni' <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, dougthompson-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-F7DcYzqLjVAVFwXTa72X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-08-02 at 10:20 -0500, Steve Wise wrote:
> >=20
> >=20
> > On Tue, Aug 02, 2016 at 09:12:54AM -0500, Steve Wise wrote:
> > >=20
> > > Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > >=20
> >=20
> > I have to ask, why did you ack all these? There's several things
> > wrong with
> > this patch series, but even the point of the patch is mistaken. It
> > makes
> > readable code much less readable. When you chmod a file, do you
> > type
> >=20
> > =C2=A0 chmod 0444 file
> >=20
> > or do you write
> >=20
> > =C2=A0 chmod S_IRUSR|S_IRGRP|S_IROTH file
> >=20
> > ?
> >=20
> > Which of the above is easier to figure what is being changed?
> >=20
>=20
> I assumed this was some global "fix up".=C2=A0=C2=A0=C2=A0

It is, but I'm not so sure I don't agree with Steve. =C2=A0I'm not sure thi=
s
actually makes things better. =C2=A0At a minimum, I would argue that Bart's
fix is mandatory before they would get my ack. =C2=A0I would also request
that even though the patches are split up for review, they be squashed
on commit (whoever would want to tackle this monstrous pile of dubious
janitorial stuff).

> >=20
> > Not to mention, because the subject is the same for all 1285
> > patches, and you
> > deleted the content of the patch in your ack, there's no way to
> > know what
> > exactly this ack is for (I haven't received the original patch yet
> > because
> > it's probably being ratelimited by some mail server).
> >=20
>=20
> I acked just the single patches that hit cxgb3/cxgb4.=C2=A0=C2=A0But if t=
his is
> really
> garbage, then ignore my ACKs...
>=20
> Steve.
>=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-F7DcYzqLjVAVFwXTa72X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoL/QAAoJELgmozMOVy/dj4cP/jIeTngHBfQ4EE1Bli+wjgS+
xvQaOgvUyq+CKdrxbWTbFOMUTwoMgUjCFjwoa5vb5CA25PwGRf1S5hwwMJ2f9SJe
HMvHUEb4hW/J34Q/nzRLj8SIwYEJp+dxwMZS/nVMX5fX8eJdhD/e7Dg42XiLMcwu
VHY18BRNO9k92ZNOtd6qHPTOYHRf2KCPXVvG5gqo1tn3RzQqhww8U5zcxDmL6L0G
VxH59PAohMrB8YrtnKRr+DJ8LaHzEXyK7aitvOs242ZVEGa4HrBA55bBXRaSRYkD
4VPPtVEWD8//i1DldevkgF4aAoAt9bg9ypZtNN+BvFz8VpsIveqFoy3+TTvpJI3G
pmwbrx2kqhspsdHdx709GsHkwQZJSyH3ATDPRVh4N2+adYackb0oA/5XGZWkGFsw
s9tN+a1hSbawGngGJvGyVChLZHPu9sy3zjybG92aq9dUwhes9pDzn92jPRcqwaIW
gOYCFjXvuoKY3i7iDOIgCfUPxty8fEtpAW0Ui5p6qRePt3VLlu2SKRkALzDt0RKu
wlfbD+l1c4QJZEt8DaNlpXXgA7Yq6J5JVUeowGC7BMrz61VhDHtR+RoUBa/o3Yi3
3PkNdiaS1it5lF3qPKdaLN7izPAkiY+Ryy2ouBKuMNlpZiujLqVTFnFY+Q7chxva
xbU5+j1YP4najCsHSvNK
=OFZO
-----END PGP SIGNATURE-----

--=-F7DcYzqLjVAVFwXTa72X--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
