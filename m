From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until
 vmxnet3 link is up
Date: Wed, 18 Jan 2017 15:23:10 -0500
Message-ID: <1484770990.2406.46.camel@redhat.com>
References: <cover.1484075557.git.aditr@vmware.com>
         <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
         <20170116073858.GA25853@mtr-leonro.local>
         <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-o9OFiqGMKYoyrDBUuZwo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35f6cce2-00c8-16b6-e3e0-481f234bd9c9-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-o9OFiqGMKYoyrDBUuZwo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-17 at 16:31 -0800, Adit Ranadive wrote:
> On Mon, Jan 16, 2017 at 09:38:58AM +0200, Leon Romanovsky wrote:
> >=20
> > On Tue, Jan 10, 2017 at 11:15:39AM -0800, Adit Ranadive wrote:
> > >=20
> > > From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > >=20
> > > Currently on bootup, ethernet drivers seem to load before RDMA
> > > ones
> > > in Linux. So while the vmxnet3 module is loaded before
> > > vmw_pvrdma,
> > > the vmxnet3 link state may not necessarily be enabled by the
> > > stack
> > > before pvrdma is loaded. This is a problem because if the pvrdma
> > > module is loaded on bootup (by installing it in /lib/modules/*),
> > > the pvrdma device comes up in a port down state.
> > >=20
> > > Since this is the most common use case scenario, defer the
> > > activation
> > > of the device till the paired vmxnet3 link actually comes up. One
> > > downside of doing this is, if a user doesn't have the vmxnet3
> > > link
> > > up when the pvrdma driver is loaded, they may not see any output
> > > for ibv_devinfo until the paired vmxnet3 link is enabled too. The
> > > users somehow need to be aware of this.
> > >=20
> >=20
> > I wouldn't call it "fix", the more appropriate name is "hack".
> > It doesn't look right that users should be aware of such non-
> > intuitive
> > driver behavior.
>=20
> Well its a partial fix for 4.10 to let the RDMA device come up
> correctly
> Since this is a RoCE device we want to mimic to eth port status for
> the
> RDMA link. Currently, for us there isnt an easy way to do this if the
> vmxnet3 device comes up after we have already registered the IB
> device.
> This patch moves the IB device registration to after the ethernet
> link is
> up.
> I wanted to get this in so that in the common case of VM power on,
> the=C2=A0
> PVRDMA device is in the port active state along with the vmxnet3
> link.
>=20
> Doug, any thoughts?

Yes, I'm wondering why the vmw_pvrdma driver doesn't detect link state
changes and act appropriately?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-o9OFiqGMKYoyrDBUuZwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYf86uAAoJELgmozMOVy/diMQQALsG194kGirF/Pz95OJvBXgJ
dqhzRBQB6rFVCU8z6EY6rBfEFY5Ucp90PwWheqcE+WL6R+moKCfNi4eHTgeRW1Ki
hG6hhlwzKbjhVKfe2ZCb5jk9pAiDVQ4tb3fTnzaOH46IYmyXMBx9jIcuKzkd0si7
hMOzfzmLidkhYfdn61cMUtbeoummg6Eh8mEKKT6w5gJxEFJY5MS3rQtgKy0AfWVL
Q/5+OWUkzZdt8M8pqqHCmGCv4/YW59DnCEAsXhW1AIyFiUsAD92do2FDVs1q2O21
pbRPzy4LuYSqSKQgONt6azJZruaSF6yg//r9x7Ac6g49gqoOffG+UT0yeCGY9aGN
eUg0f7cnxHH2jbdqTZqPV1hlpHFAlAxlAtuVDaXHd8k7nzLyqDpVopsRaAYk2QbA
VCrm3KQVD07Vc71rs2KjOQvhTsrzLSBnvtvzI/XIRL+7uqxd4il4P50scrUJM3Fl
eoUdMF/F4HAT1HGz24xvMsUSsvE2mlVUKxGzDEw1iNF8VsAgzqo78Afehd/6mPJw
vO2/kg766fv/Kbnv4Z4iDX2bEftWEMgdh2Eri7GdAMlLhZeiSgW89N98M1qE8RIb
dijse4smfehmYI0toR3zmgta/Ve/PDfLdnbRCizmeodRDPlU+h7RmHgjnBqxpD1R
cUqs7j9tZSAO1qOiJQIl
=eeNy
-----END PGP SIGNATURE-----

--=-o9OFiqGMKYoyrDBUuZwo--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
