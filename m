From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until
 vmxnet3 link is up
Date: Thu, 19 Jan 2017 01:45:17 -0500
Message-ID: <1484808317.2406.89.camel@redhat.com>
References: <cover.1484075557.git.aditr@vmware.com>
         <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
         <20170116073858.GA25853@mtr-leonro.local>
         <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
         <VI1PR0502MB30081629AE674E7F24337835D17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <ad2f92cd-f120-b04a-0e94-b49915cadf02@vmware.com>
         <20170118184236.GA4864@obsidianresearch.com>
         <c44cf5cf-6096-f2df-df79-e1c8da924e84@vmware.com>
         <20170118204130.GA6422@obsidianresearch.com>
         <caee0761-e791-a56b-e8ed-609c15bdc37a@vmware.com>
         <VI1PR0502MB3008DAF4097F78DB313AE73CD17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <7b3e522d-b70c-b09b-19c7-358bb5efcc91@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Kidbz3bJHw6yeWXo5wjA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7b3e522d-b70c-b09b-19c7-358bb5efcc91-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Kidbz3bJHw6yeWXo5wjA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 16:31 -0800, Adit Ranadive wrote:
> On Wed, Jan 18, 2017 at 10:50:54PM +0000, Parav Pandit wrote:
> >=20
> > Hi Adit,
> >=20
> > >=20
> > > -----Original Message-----
> > > From: Adit Ranadive [mailto:aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org]
> > > Sent: Wednesday, January 18, 2017 2:53 PM
> > > To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
> > > <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TaqPxH82wqD4g@public.gmane.org
> > > g; pv-
> > > drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org; Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device
> > > until
> > > vmxnet3 link is up
> > >=20
> > > On Wed, Jan 18, 2017 at 1:41:30PM -0700, Jason Gunthorpe wrote:
> > > >=20
> > > > On Wed, Jan 18, 2017 at 12:30:07PM -0800, Adit Ranadive wrote:
> > > >=20
> > > > >=20
> > > > > In order to recover QP1 correctly after a link transition we
> > > > > had to
> > > > > go through a register/unregister since it is placed in error
> > > > > state when the
> > > port is down.
> > > >=20
> > > > >=20
> > > > > In this case can the MAD layer re-initialize QP1 if link
> > > > > transitions are
> > > performed?
> > > >=20
> > > >=20
> > > > Your driver needs to deal with this. Do whatever it takes to
> > > > recover
> > > > your QP1 without re-registring and do not bother the rest of
> > > > the
> > > > system with it.
> > >=20
> > > Ok. We'll investigate internally on for a better recovery process
> > > for QP1.
> >=20
> > By the time I reply, most others requested same.
> > Thanks for addressing it.
>=20
> Hi Doug,
>=20
> Please consider taking the other two patches in this series if
> possible
> for your next set of rc fixes.

If you want me to take these for the -rc cycle, then they need to be
presented appropriately. =C2=A0This patch (1/3) is gone just because it was
the wrong solution (but it at least sounded like a fix). =C2=A0Patch 2/3
starts its subject with "Cleanup unused...", that doesn't sound
remotely like a fix. =C2=A0Patch 3/3 starts with "Don't hardcode...", which
also doesn't sound remotely like a fix. =C2=A0If you want these in the -rc
cycle, then please repost the two other patches with suitable subjects
and commit logs that make it clear these are real fixes needed in an
-rc and not simple patches that should get applied in the for-next
area.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Kidbz3bJHw6yeWXo5wjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYgGB9AAoJELgmozMOVy/dFdgP/iGQHBkH5S9cWKX6hA4ZVBEK
2oJXsSWRlsQLMlb1wO/l7c0X4bimYKqTQRGX93HB7ZqwnbhTMrWif+Uc7ndnJlie
pRLylndharNTGmx4tGoZqhHMNzoHUBamhlyiLUh2WIfPNQz8/L8rGAQZBwtn+VYJ
q8dcIY1+snxQITnTY+WOtouNT3fIMGCMr5jaYdNSwSO5A5mi9fXoCEULOhzm32RL
Hw1Xx188Z40S4xOuzW4C5I/QVSlVwHOXJ8YvznCzK1qOcplLZWPsMSfk01cESr9p
mMLuUyKW4Ta6G+xVznyvqz0Unob7cxlG8LQuzcp67TK5OemCi8m1Yo3DhNrNbSEw
IW028Ecs56gMCvPS3zXK0VZZ8JMFCyK2M0+I4yAmUcOjIg9rH4haLKit2RvkMdUc
y03Z9CTdd37iUxoQrW1b45BEbuKj1Kr0mQrV6sNQGvPb9UrfV31RWopK/DDrGRhu
4HJ8yeXn4GNH/UD7hohJG/KS3mWLgkgpIyv4D9RHAZG6M9Z9McLvyMYhK71LY6wX
xmcorBoH+A2j2igzXW9kSY1jJvSN+G2rnxFiXw8muCwhxiAmso4AIH17rM3uYVad
+/tA34PJcDqYxYJ/Kbawr1iltes+Y5DBzbR9hX3uNTl6OAYnYlLirH0RcfXuwx4S
ENYCKmo1M8yrIkBLC+Me
=Kaye
-----END PGP SIGNATURE-----

--=-Kidbz3bJHw6yeWXo5wjA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
