From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Sun, 14 Aug 2016 20:23:44 +0300
Message-ID: <20160814172344.GA5548@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718124652.GE6165@yuval-lap.uk.oracle.com>
 <BLUPR0501MB8363954E94FE9D268E66CB7C5000@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160729123711.GU4628@leon.nu>
 <BLUPR0501MB8364D3CE8FF7DE654D1E045C5010@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160731061547.GV4628@leon.nu>
 <20160814112536.GA3404@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160814112536.GA3404@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 14, 2016 at 02:25:36PM +0300, Yuval Shaia wrote:
> On Sun, Jul 31, 2016 at 09:15:47AM +0300, Leon Romanovsky wrote:
> > On Fri, Jul 29, 2016 at 09:31:16PM +0000, Adit Ranadive wrote:
> > > On Fri, 29 Jul 2016 12:37:29 +0000, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>=
 wrote:
> > > > On Thu, Jul 28, 2016 at 10:51:39PM +0000, Adit Ranadive wrote:
> > > > > On Mon, 18 Jul 2016 15:46:53 +0300 Yuval Shaia <yuval.shaia@oracl=
e.com> wrote:
> > > > > > On Tue, Jul 12, 2016 at 12:36:32PM -0700, Adit Ranadive wrote:
> > > > > > > This patch enables posting Verb requests and receiving respon=
ses to/from
> > > > > > > the backend PVRDMA emulation layer.
> > > > > > >
> > > > >
> > > > > ...
> > > > >
> > > > > > > +int
> > > > > > > +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req=
 *req,
> > > > > > > +		bool expect_resp, union pvrdma_cmd_resp *resp)
> > > > > > > +{
> > > > > > > +	int err;
> > > > > > > +
> > > > > > > +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> > > > > > > +
> > > > > > > +	/* Serializiation */
> > > > > > > +	down(&dev->cmd_sema);
> > > > > > > +
> > > > > > > +	spin_lock(&dev->cmd_lock);
> > > > > > > +	memcpy(dev->cmd_slot, req, sizeof(*req));
> > > > > >
> > > > > > Just to protect against memory corruption suggesting to do:
> > > > > > 	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));
> > > > > >
> > > > >
> > > > > Done.
> > > >=20
> > > > Hi Adit,
> > > > I didn't check how "dev->cmd_slot" was declared and if it is equal =
to
> > > > req in size. Additionally I didn't check if memcpy has any size
> > > > limitations, but wanted to warn you that implementation of this
> > > > suggestion as is will leave your system in much worse situation of
> > > > partially copied data.
> > > >=20
> > > > if you really want to check sizes, please do it with BUILD_ON compi=
lation
> > > > macro. I have serious doubts if you need it.
> > > >=20
> > > > Thanks
> > >=20
> > > Hi Leon,
> > >=20
> > > Thanks for taking a look!
> > > I think this is okay to do was that we allocate a page for cmd_slot a=
nyways
> > > and the size of req will always be smaller than PAGE_SIZE. If the req=
uest is
> > > malformed, our virtual hardware should throw an error for it.
> > > I dont think we would run into partially copied data.
> > >=20
> > > Having said that, I dont see a necessary advantage of using min here =
so am
> > > willing to drop it if you feel strongly about it.
> > >=20
> > > Can you clarify what you mean by memcpy size limitations?
> >=20
> > I didn't have time to look after reasons for Yuval's comment about
> > min(..), so I assumed that one of the possibilities will be limitation
> > of memcpy which I'm not aware.
>=20
> I understand that it is not such realistic that one of the structures in
> union pvrdma_cmd_req will be more then PAGE_SIZE but any other alternative
> to protect from such case?

BUILD_BUG_ON(...) is a perfect way to achieve it.

>=20
> >=20
> > >=20
> > > Thanks,
> > > Adit
>=20
>=20

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXsKkfAAoJEORje4g2clinH8kQAIwtGS4qapzTQ/Ir8OvfHBVa
TrySj3flsm3k4Z44YLUc4aIyIfNGwh3/+5bhuF2Lr8LZVg2kqA8hH5kYiwg2PdOE
mNWp7pitWqdFMuBb+uTRrhRSzMIVW+2lt2455OdG0c+M65qXf5d6u2MaIkIVueTK
X2auIf0j7UFay+QnQvpcbjZRmb7BRk824Utuo30CAZnxzMxNqLerF/YwssJjcIPp
4POjdw7tR8iyNiffFdP+QsZz/fdS3ZbssTzmWWNZL2pNFw9/ZvWgosU9bayey62/
D52NTCIaiQ/gPYxaaUkTpO48mNBmcr3zC58EbnYtgYgSmIWmqdRQ7gOxGBR2gNVH
ji24akGYxKnEfryxlaWUq1HjSpvQohvE0/xEBgiG/BCtj4u2Nf6B8Rc88J/OaQ7s
eKRq2HDYVXJRWRnBwC0bjP/bL9AywWtfEX8uFGuYnbJ+yYqIjAhZ28+ZqTKNA7oO
nc/mcnECpQTc1N64VCOYuv2qLocTqCdGLji7+JjEDy7NKuW41ylI38y4GNQTE00S
7pe5oSTzlQ/h/FWHV4AeWNHRPttk3Jpmcegc2lmNOYGkSBFquNXOMabSG4FNJPUE
KtYvP7ERFQq3gJvRTOVK01Bylj2Vmz6grNpyPUDd1s7HBZI1vMUI9M2EQsqWOic5
TZC7ro+kYaNgJSDNv+2a
=CJlq
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
