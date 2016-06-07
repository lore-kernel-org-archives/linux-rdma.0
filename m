From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/7] IB/core: Fix query port failure in RoCE
Date: Tue, 7 Jun 2016 10:22:52 +0300
Message-ID: <20160607072252.GD3663@leon.nu>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-2-git-send-email-leon@kernel.org>
 <018701d1c00a$29507640$7bf162c0$@opengridcomputing.com>
 <CALq1K=LuBvTEygAeUW1wuwzQLffGHn=+KWtnx67op+nj9ybegw@mail.gmail.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=LuBvTEygAeUW1wuwzQLffGHn=+KWtnx67op+nj9ybegw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Resending to the ML.

On Mon, Jun 06, 2016 at 10:13:50PM +0300, Leon Romanovsky wrote:
> Sent from mobile.
> On Jun 6, 2016 6:43 PM, "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> >
> > >
> > > From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > Currently ib_query_port always attempts to to read the subnet prefix =
by
> > > calling ib_query_gid(). For RoCE there is no subnet manager and no
> > > subnet prefix. Fix this by querying GID[0] only for IB networks.
> > >
> > > Fixes: fad61ad4e755 ('IB/core: Add subnet prefix to port info')
> > > Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/device.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/core/device.c
> > b/drivers/infiniband/core/device.c
> > > index 5516fb0..05e25a3 100644
> > > --- a/drivers/infiniband/core/device.c
> > > +++ b/drivers/infiniband/core/device.c
> > > @@ -661,6 +661,9 @@ int ib_query_port(struct ib_device *device,
> > >       if (err || port_attr->subnet_prefix)
> > >               return err;
> > >
> > > +     if (rdma_port_get_link_layer(device, port_num) !=3D
> > > IB_LINK_LAYER_INFINIBAND)
> > > +             return 0;
> > > +
> > >       err =3D ib_query_gid(device, port_num, 0, &gid, NULL);
> > >       if (err)
> > >               return err;
> >
> > This change assumes IB_LINK_LAYER_ETHERNET =3D=3D RoCE, which isn't tru=
e for
> iWARP
> > devices.  Still, the change is good for iWARP too,
>=20
> Thanks Steve,
> We spotted it during internal review too. We wanted to see this patch is
> accepted before sending followup patch which will remove such check from
> iwarp drivers.
>=20
> > but the comment should
> > perhaps reflect this.
> >
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > Steve.
> >

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVnZMAAoJEORje4g2clinHuAP/2hxEJU9jaZc9NiN4RyyljA0
N+zCXnRLYzSP+gSVGl4Pl+/UzvBq5KHnId/laQTzOU36/1KC3TNebHSewUFw+S/+
rLjH5CWC79i+LYlxECHS+/6bXqJRubs42JPIlb18M7Ot9RMafSqHZoDDDTehPdy3
gV9grx6zr0JHULrHTlnRY6RwIZl22/zUGguEPxEu7K3Gln+DXrShZzrBtuF1wa0M
hGq7mNfgWpYgJkqB/L4iJXiQAGs6zpEIMFbTh7+XhtnrlL8b9uMGQwJ7QaEa9k9a
bss6sCBMUfGL4VF4e9OdaFHk7xTt0pFmsR3O20VoUi7Gc/0mZqjnLhctuDIMdPtD
htszP9KGI1ueNEIRoogkQLy97UUP8j/o5otd1uC6i92UW2FauWUB5EEmLbWKvHHT
JdZ0h3x5R15E2v1etFTmuWeokZ1AcFYXD7s9w59n+VUw7KIEaLOSexo1g6Nv/jZS
rWfoQOU5pQ/7Rzo9wS2EgiJI6EBCsKYzJruLcCr3iNTyGJkobi8XVB1sI9cYnnYZ
Z7A9/XJZbsdN68fvaS1voChoIEFPq9Wmz9jpo3vIOzzXZwbG+xIRaNTkTvv40T/+
DahwyhBgeNrzooZV3vUiht3Sl5Anj1ggVEaDQZ1DVG9xXjTm7/n4BZ7CKczNOqf4
Zr/topiFhXnA+wpMLj6m
=i/T3
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
