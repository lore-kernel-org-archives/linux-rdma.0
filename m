From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 30 May 2016 15:51:46 +0300
Message-ID: <20160530125146.GB7477@leon.nu>
References: <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
 <VI1PR05MB1391B1C6DFE620C31A6474A0D2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <561a675d-89d2-e675-cf83-e86ecb7519b6@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EDE332@CRSMSX101.amr.corp.intel.com>
 <20160523085809.GF25500@leon.nu>
 <57430E34.3090501@redhat.com>
 <VI1PR05MB13910E30E227D4DCDBC19033D24E0@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <1464586394.13055.426.camel@ifi.uio.no>
 <20160530063349.GA7477@leon.nu>
 <1464608255.20967.27.camel@oracle.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464608255.20967.27.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2016 at 01:37:35PM +0200, Knut Omang wrote:
> > > The separation feels natural, and it allows a more piecemeal approach=
 -
> > > a device can be loaded and tested with one WR at a time. Once ib_mad
> > > gets loaded, a lot of "traffic" is created and just about the whole H=
CA
> > > under development needs to work to support it.
> >=20
> > Adding new device to IB is not an easy task and we clearly need to impr=
ove in
> > that area, however these merges are targeted to the end-user of IB stac=
k which
> > constantly needs to load all these modules.
>=20
> In a well configured system, this should all happen automatically -
> this is why we have udev? End users should never have to struggle at
> this level.
>=20
> > For the easy development, you can simply revert them in your tree.
>=20
> :-)
> Development and debugging needs aside: Keeping separation between
> layers is still a good idea IMHO.

We tried it for the first version of IB router patches which required
conversion ib_netlink to be a module and found ourselves with bazillion
little modules for every file in IB core.

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTDdiAAoJEORje4g2clindiMQAKUGfbDAkKpyMD24DfvauSTN
lNXtBrZHx5isF1/1z2QL1zmFFqrY6AUxBTBe1iiqURzTxSu6TpLuHppsfkxQETQL
6hREl6UIGE9LyXCbEpT6w7V9QhAzUmqgZTHWQg9pKFhxcVDtfSruMOSwnoE++H/B
Ro6fHOZNFzzUb8z+VE1tXUh3j+sQK2haRURXlRSO14bhNapHwukNetivrJih772L
b9yQH6zGa0dKATKlcDzQ+NANontcOO+C7XOub++mB5wTMnvH/sjw7rEr12JBcjm5
LH3rHi3e/cDGbmqL8X5IwyaBP9nPA7Z01ZKA61U0j31DY3aLgb+r3oAPxpovfZCe
oCGrnwAS6/DFSWiVixybYrCWtXbaTUouI7qTzv1pb8sdzLEZV5jukq0p/RC3OTwl
omLbHbYPegyaeqzCA2l2Nv8W9Bf0QcVxEdeb4Sc9f5N77mtcn2d+idBI8ugtTEaD
fie5XNF1opxKY28F/X/TUSW5W9FVuDx1TvZPZzaenlKBoeA7MwDylkkVD4AnAweW
y6bXUNeqgdEwtIbKHfc1YWpS3i2tsv9nOQ0W6VId66QjCcEUzdSUibaMVwK1G6kx
dxu4/BLy33P7u3ceK6shKDxXWxCQ9r5PrwWSltIUkYygkBDtrNb/ln3GWVpBDLLg
wiL/X/ccmi3N+9w6YrYv
=tGdN
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
