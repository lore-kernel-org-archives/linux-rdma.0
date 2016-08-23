From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Tue, 23 Aug 2016 23:56:49 +0300
Message-ID: <20160823205649.GO15065@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
 <20160823151341.GA10264@yuval-lap>
 <20160823184322.GM15065@leon.nu>
 <BLUPR0501MB836B1C542C1296616A05080C5EB0@BLUPR0501MB836.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f0PSjARDFl/vfYT5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0501MB836B1C542C1296616A05080C5EB0-84Rf5TRaNBMVDhIuTCx1aJLWcSx1hRipwIZJ9u9yWa8oOQlpcoRfSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--f0PSjARDFl/vfYT5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 06:52:28PM +0000, Adit Ranadive wrote:
> On Tue, Aug 23, 2016 at 11:43:27 -0700, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>=
 wrote:
> > On Tue, Aug 23, 2016 at 06:13:42PM +0300, Yuval Shaia wrote:
> > > On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
> > > > + */
> > > > +int pvrdma_query_port(struct ib_device *ibdev, u8 port,
> > > > +		      struct ib_port_attr *props)
> > > > +{
> > > > +	struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > > > +	union pvrdma_cmd_req req;
> > > > +	union pvrdma_cmd_resp rsp;
> > > > +	struct pvrdma_cmd_query_port *cmd =3D &req.query_port;
> > > > +	struct pvrdma_cmd_query_port_resp *resp =3D &rsp.query_port_resp;
> > > > +	int err;
> > > > +
> > > > +	memset(cmd, 0, sizeof(*cmd));
> > > > +	cmd->hdr.cmd =3D PVRDMA_CMD_QUERY_PORT;
> > > > +	cmd->port_num =3D port;
> > > > +
> > > > +	err =3D pvrdma_cmd_post(dev, &req, &rsp);
> > >
> > > Patch order again, this guy is added in patch 7/15 ("IB/pvrdma: Add d=
evice
> > > command support").
> > > Maybe it is only me having trouble to read it so do not want to be a =
nagger
> > > here but don't we have some (hidden) agreement that each patch is ato=
mic
> > > and i should be able to compile the kernel after each one?
> >=20
> > IMHO, Doug will squash all these patches to one a second before adding
> > it into his tree. The patches divided here for easy review.
> >=20
>=20
> Thanks Leon! I was hoping Doug would do that :).
> While I do agree about the fact that each patch should be atomic, I don't=
 know
> if it's possible in each case. I'm still new to the upstreaming process s=
o correct
> me if I'm wrong.
> If it's easier to review I'll be happy to try to keep each patch as indep=
endent as possible.

I don't expect more than one cycle of review. Please resubmit your
series with latest fixes so it will have enough time before 4.9 will
close.

Thanks.

>=20
> Thanks,
> Adit
>=20

--f0PSjARDFl/vfYT5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvLiQAAoJEORje4g2clinAUIQANMwpzr2teImv3HHxZ8oZjfH
QMXQ9RZLh16f5KfoVrApCZJ1qdQ7eGp2xVpdW2klM52DIdv43itk7ol5VN89zpuo
hcaXcEGyt/wgDAO5w3iMxG7JwZ7meMaR++GkmSVwz91QO7cTmZPDR7lTbWyPjjK1
NWKZnf8/GW23Im/JMkPzmLIYktupLpc95+78/o8Rc6MVin1Z2EVgJxgLWxNFH4sO
cZSR+3v1w4AbnzIgJmKGKtDu9o6jM4mM9NPmDgoOv2bZKQP7sdvkGWIsUs/PJQzP
u9pwRbTEJweaZ6/AXAzKLoW0AtTkgDSuwcBRCGPXmCWI3kdCbgNxPYFrwJu9oI28
/B2ft1XngDW+Yy0BDbt/t4a2AA/0xWOlQP/gMqSdKkWKyCYvVwag+iIjvW3kqwph
yMn8bnoSw3atPoRUPWcDr2uEzad7/NsZ5gTFyVvFKFPuJ0tGmRAWYGqnfxTsdFNb
gcwG5kO6L8EEJtlPi1CY0Zatug0RvII/bTHh5W19LYIuVzdv/yo91OX8HPEkmGXR
arEcKjjpNhl+dctA/LPpLwUsHA5Q2avZZsFhruYMbazPYoRlLMQkGgAcBZZ1maxJ
VN18Yaoa9F872HZjAzIhXDI+2iMPnIC7V/abB5V7IH6cQsMwK9SGS16hH1XEjR4V
PEACJVYlmpG48A8hJk7U
=vRd3
-----END PGP SIGNATURE-----

--f0PSjARDFl/vfYT5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
