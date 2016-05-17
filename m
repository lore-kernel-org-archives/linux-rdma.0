From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Tue, 17 May 2016 08:51:03 +0300
Message-ID: <20160517055103.GE4662@leon.nu>
References: <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160516210327.GB10945@obsidianresearch.com>
 <20160517054652.GA17101@infradead.org>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160517054652.GA17101-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 10:46:52PM -0700, Christoph Hellwig wrote:
> On Mon, May 16, 2016 at 03:03:27PM -0600, Jason Gunthorpe wrote:
> > It is unfortunate that distro scripts have become such that they break
> > if the kernel changes even something small like dependencies.
>=20
> What script exactly break, btw?  We had quite a few module merges /
> split in other subsystems I contribute to, and they've not been major
> issues.

Debian Sid works like a charm with/without ib_addr.ko as a separate
module. It looks like breakage will be in testing scripts only.

>=20
>=20
> > Another alternative is to move only the parts of ib_addr that touch
> > netlink into ib_core. Hopefully that doesn't create an empty module.
>=20
> Or just create a dummy ib_addr module IFF it really is an issue.

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOrFHAAoJEORje4g2clin9uUP/R2Qp3zwk4TBN4Vs+0WxhD0L
Vp4fCYP+llWT5lZ4uJcsh/96oUx5nLCho3GXtOvGbyBNgFxJk7Srwikg3Hk0GtcQ
6QsiXMwCSRzjpnqVu2Kpv7PJIOUFw9twk7tY7ssMx+KZ2oh9Dg3lUIUrve8gocB2
g4oBZStxCh8cTFQy/UtkPBuUQo46aJeeXtYSHAONb0+G/P9TA4Pya5pwNNqwqiLR
Z6Alre/tHrg8/wCeAXoCD0t3i7+V8KCCRQJgL4AwQ21ARPRcY8+vQ/IciEyS/4z3
KX9rFZcGdrPt52/47/Ufvn9/D0MJz0ENSqnc21GPg/QX8UmgUtSq/5PZw2p4vP9a
A9VKalucTSg103ZPKfQtiHH8oKPdIMqgs2GL0VTK9V+z6A8ERsPOnnSVmsunXj6o
I4UqGq001ZWsR+MDw7TGykdEYkS5l/x7F0VNYhPEGLnTAnV8cPNJnAht9SAhI8qH
LajaSkOm5+xN13wST5Pompv1PWDDnHXwiL2i+JncutWUEBxws8UT9CdZZ5HVZRse
Z4pFNhx/0ZJB2eCfHBxswRcJVfMywbCQT7dSB0+oftgbQPRxeWxGsMJx4dn6CjIx
vmILX7a/m+XfFyuDUxaNfUuIqF/gm2aYI6NuTxkpucionrR+Vdr0tJtIKxbyFF0Q
ieHvc08eMThxYIlCe+IK
=FfCu
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
