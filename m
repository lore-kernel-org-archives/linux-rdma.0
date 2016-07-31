From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Sun, 31 Jul 2016 09:15:47 +0300
Message-ID: <20160731061547.GV4628@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718124652.GE6165@yuval-lap.uk.oracle.com>
 <BLUPR0501MB8363954E94FE9D268E66CB7C5000@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160729123711.GU4628@leon.nu>
 <BLUPR0501MB8364D3CE8FF7DE654D1E045C5010@BLUPR0501MB836.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qRqofxetdBO9L27H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0501MB8364D3CE8FF7DE654D1E045C5010-84Rf5TRaNBMVDhIuTCx1aJLWcSx1hRipwIZJ9u9yWa8oOQlpcoRfSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qRqofxetdBO9L27H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2016 at 09:31:16PM +0000, Adit Ranadive wrote:
> On Fri, 29 Jul 2016 12:37:29 +0000, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wro=
te:
> > On Thu, Jul 28, 2016 at 10:51:39PM +0000, Adit Ranadive wrote:
> > > On Mon, 18 Jul 2016 15:46:53 +0300 Yuval Shaia <yuval.shaia-QHcLZuEGTsthl2p70BpVqQ@public.gmane.org=
m> wrote:
> > > > On Tue, Jul 12, 2016 at 12:36:32PM -0700, Adit Ranadive wrote:
> > > > > This patch enables posting Verb requests and receiving responses =
to/from
> > > > > the backend PVRDMA emulation layer.
> > > > >
> > >
> > > ...
> > >
> > > > > +int
> > > > > +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *re=
q,
> > > > > +		bool expect_resp, union pvrdma_cmd_resp *resp)
> > > > > +{
> > > > > +	int err;
> > > > > +
> > > > > +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> > > > > +
> > > > > +	/* Serializiation */
> > > > > +	down(&dev->cmd_sema);
> > > > > +
> > > > > +	spin_lock(&dev->cmd_lock);
> > > > > +	memcpy(dev->cmd_slot, req, sizeof(*req));
> > > >
> > > > Just to protect against memory corruption suggesting to do:
> > > > 	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));
> > > >
> > >
> > > Done.
> >=20
> > Hi Adit,
> > I didn't check how "dev->cmd_slot" was declared and if it is equal to
> > req in size. Additionally I didn't check if memcpy has any size
> > limitations, but wanted to warn you that implementation of this
> > suggestion as is will leave your system in much worse situation of
> > partially copied data.
> >=20
> > if you really want to check sizes, please do it with BUILD_ON compilati=
on
> > macro. I have serious doubts if you need it.
> >=20
> > Thanks
>=20
> Hi Leon,
>=20
> Thanks for taking a look!
> I think this is okay to do was that we allocate a page for cmd_slot anywa=
ys
> and the size of req will always be smaller than PAGE_SIZE. If the request=
 is
> malformed, our virtual hardware should throw an error for it.
> I dont think we would run into partially copied data.
>=20
> Having said that, I dont see a necessary advantage of using min here so am
> willing to drop it if you feel strongly about it.
>=20
> Can you clarify what you mean by memcpy size limitations?

I didn't have time to look after reasons for Yuval's comment about
min(..), so I assumed that one of the possibilities will be limitation
of memcpy which I'm not aware.

>=20
> Thanks,
> Adit

--qRqofxetdBO9L27H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXnZeTAAoJEORje4g2clinY+YQAIlhfhfoC7t0o2JBDG+X87IG
xHfdTspD0Wq+i9wr27hDtfhVIkA1OojGMCcUpiveMwKdV+qwnve3DFEYvqi6KvVS
e+x7avT8sdoXOR+as0kkvoruasfjMX0wQf7+qfihKdyzdrllykmchUKQcCvbplc2
Q/0mUQC8kmnujgVi4xT+5Y+VIsUTgkIQVqK7yGd725mWheMJyT/gwX/ds1eq3i3Z
SIJprPUkSZYIyiLnp2nTh075mRDjlHSuQpaiAoGUCcEl3kzT5Y0GhsVoSNHmOhZd
8udInMqwq56VXp/r6GXe91PqqYsNarYYtzblWkrzTYl3Tw3T+jhYjxEpkN1J3Q3d
IdexBv+FNbzoY5j0aZlEARQ9r0cx0gc7PGnCHbFNuFd+SFegm8q7DFemgOa4+XDU
x91dBK4qqGi/LUMoDpvkIDLDi6ph0bym8KWT3ZjJUVw1I0P850HaMiQU2S/p31C6
PcLun86NG0VRBs/Hpk+VsVGPLEhK1l+P9SQRkwoOH+d5VBHtofZS16Twe4dXbmT1
FDGiX5EHLGhuB/M5bx4gi+QCEpenhNuE/UGVDcWNwdCli7OOlsRIg4Rq46MJX/nt
JfdMtk0gR6dfYkw3BoSWFiSCiR84foUEUJVKs+YnvqR8y1LjzUxHkuhMcqkdkWFe
OlWaNJHl9/kdJfkPcMvF
=bTrH
-----END PGP SIGNATURE-----

--qRqofxetdBO9L27H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
