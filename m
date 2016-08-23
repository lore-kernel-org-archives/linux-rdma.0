From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Tue, 23 Aug 2016 21:43:22 +0300
Message-ID: <20160823184322.GM15065@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
 <20160823151341.GA10264@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/jvaajy/zP2g41+Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823151341.GA10264@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/jvaajy/zP2g41+Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2016 at 06:13:42PM +0300, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
> > + */
> > +int pvrdma_query_port(struct ib_device *ibdev, u8 port,
> > +		      struct ib_port_attr *props)
> > +{
> > +	struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > +	union pvrdma_cmd_req req;
> > +	union pvrdma_cmd_resp rsp;
> > +	struct pvrdma_cmd_query_port *cmd =3D &req.query_port;
> > +	struct pvrdma_cmd_query_port_resp *resp =3D &rsp.query_port_resp;
> > +	int err;
> > +
> > +	memset(cmd, 0, sizeof(*cmd));
> > +	cmd->hdr.cmd =3D PVRDMA_CMD_QUERY_PORT;
> > +	cmd->port_num =3D port;
> > +
> > +	err =3D pvrdma_cmd_post(dev, &req, &rsp);
>=20
> Patch order again, this guy is added in patch 7/15 ("IB/pvrdma: Add device
> command support").
> Maybe it is only me having trouble to read it so do not want to be a nagg=
er
> here but don't we have some (hidden) agreement that each patch is atomic
> and i should be able to compile the kernel after each one?

IMHO, Doug will squash all these patches to one a second before adding
it into his tree. The patches divided here for easy review.

Thanks

--/jvaajy/zP2g41+Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvJlJAAoJEORje4g2cline0EP/Rphky+rlB3bCDJeZGtamLtn
FoL+Mg7neBJpOrC5S2/krOCMx7fSlJdVqsGXCf8392rN66BvfqgcpJWhZI4Iqa3i
St29C+ta7Pyg1Ja2r8A8Mu7m8ZNvGCkJz3kC3Q4m+/sJCrtq9VFDeesZ3UKezh2F
nFaZ38NBJmgNGvnJmGMlD+yhYWyYFikP8dRyx5ZoTWIjR1+bHM4DLwTQy7PpGpvN
6lkGIe6cIc+Yn99ARLIm1qSGyl2JDoCR8o0syVLL8mBIk4NpD4CDxTnPgnEBjSu3
s+0U7r47gCU6ekPTP7LFtWn2XaOq1G3BNnu4lP1W+jDVBBn/M5sj39oM/k28IUtR
guSUp9mGWykaD2AhEj/jNSjGl4p4BoNYXO4i1PHmEYiWyiapABCkdX/3BYnZBdkQ
0doN49jBa//nXjFVMqCMfaATW6HEMpDCL77YmXRgCK6VU+TcLO/juelyMzzoeJXA
M49BeqfltzVuxhFhjmmDHV7lxOBUnbphTfwE2xDQSs83vC49I5vX+Q5QQIhTJ3kk
SiHVx8wFWT75gziOmN0KOmRYIfzA6faS/c1Enxu5HuIlftoOzetB+K2Ab/q72Fod
wtznBA5ySJUkwxKrcL33IsqOhR2s3SdoLyuobCXF06oD0nl0DBRsECCiMg4q/mJd
gzGA1PPVU883BUoqfKUC
=lzst
-----END PGP SIGNATURE-----

--/jvaajy/zP2g41+Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
