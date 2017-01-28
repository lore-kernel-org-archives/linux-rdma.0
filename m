From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Fri, 27 Jan 2017 19:05:52 -0500
Message-ID: <1485561952.2432.31.camel@redhat.com>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
         <1485552696.13218.0.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PJLc1fEdwwcxqSTq2n5X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485552696.13218.0.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org" <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-PJLc1fEdwwcxqSTq2n5X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-27 at 21:31 +0000, Bart Van Assche wrote:
> On Fri, 2017-01-27 at 14:15 +0100, Christophe JAILLET wrote:
> >=20
> > This test looks reverted.
> > We should log an error message only if 'ib_attach_mcast()' fails.
> >=20
> > Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/core/cma.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c
> > index cfefb941d729..175f62e5841e 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -3838,7 +3838,7 @@ static int cma_ib_mc_handler(int status,
> > struct ib_sa_multicast *multicast)
> > =C2=A0	if (!status && id_priv->id.qp) {
> > =C2=A0		status =3D ib_attach_mcast(id_priv->id.qp,
> > &multicast->rec.mgid,
> > =C2=A0					=C2=A0be16_to_cpu(multicast-
> > >rec.mlid));
> > -		if (!status)
> > +		if (status)
> > =C2=A0			pr_debug_ratelimited("RDMA CM:
> > MULTICAST_ERROR: failed to attach QP. status %d\n",
> > =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0status);
> > =C2=A0	}
>=20
> Hello Christophe,
>=20
> Do you think this patch needs "Fixes:" and "Cc: stable" tags?

It does not. =C2=A0I already tried to apply it to my 4.10-rc branch and it
doesn't apply there. =C2=A0In the for-4.11 queue is a patch to improve debu=
g
printouts in the core, and it is that patch that introduced this error.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-PJLc1fEdwwcxqSTq2n5X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYi+BgAAoJELgmozMOVy/dLIoQAJZ8DvTwJva81PjYuz5cDsko
pLaGSB/VaoIYHkCUftVDbrnYMC0NwdOGpwyKcWP/GSt6cWHPHIdfU/n5pkAJPvDa
RO/yrqcz0fkKZQ2cx7udzUQr/b97rDQJtBc4dMWJAVQ+AA1M6jTlJ6cLbfOlYILi
8Cf9vnvU25WSsVaToCjivSPJGBfx6x0Gtrl/iEwNvaX7Bo1y2j01tm7dpeRLMTxG
iQcMTxCtS2iJLmCDotrUM0iRn6mSwK6EWthiQ1wbvswBykjFXaoyrsO2N8SWLj2C
PBB6TpSd4GBHG84cSRVQstieosoXJVFbvr/BTzO3VaB71miGB8fzhIVw9rpU5ruh
kx/+Qp4SONjE2qMU532p3/iPFzKbz9hJ+SvdPsAXt6F0EoX4IeV12V0L3rj732C6
6RRSRKVbp4RQrHFE/3pCRC4xbxiofMqSgakP3r56qir3/lbBKIJLQDBzz0p9IOPA
ZKNH+ls04MT+KBfKjETXcRW+bjPT6jnm6ILM37khc80NU1H6kzEZfLIrjYUe4SuP
E1kojM6dBe8JpydPrpt4xJykd2medK8eAIZTSiHd5rRAipZZJdhSrQ9+rZuIn2h8
/BESCRW7UPfKwOUk8wKRflAx6KxoahmSPBjgkC2ON/r6dXuY3W4qHibTXt6lfOKH
3aImz1+W2BxMxkdqxxyS
=Z6p1
-----END PGP SIGNATURE-----

--=-PJLc1fEdwwcxqSTq2n5X--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
