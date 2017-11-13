From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] mlx4 RSS fixes for 4.15
Date: Mon, 13 Nov 2017 16:13:23 -0500
Message-ID: <1510607603.3735.36.camel@redhat.com>
References: <20171025193935.1075-1-leon@kernel.org>
         <1510337143.3735.6.camel@redhat.com>
         <20171113112013.GI18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FJjVKG5FducLFwnfhbR0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113112013.GI18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FJjVKG5FducLFwnfhbR0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-13 at 13:20 +0200, Leon Romanovsky wrote:
> On Fri, Nov 10, 2017 at 01:05:43PM -0500, Doug Ledford wrote:
> > On Wed, 2017-10-25 at 22:39 +0300, Leon Romanovsky wrote:
> > > Hi Doug,
> > >=20
> > > There are two mlx4 RSS fixes for v4.15
> > >=20
> > > Thanks
> > >=20
> > > The patches are available in the git repository at:
> > >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rd=
ma-next-2017-10-25
> > >=20
> > > 	Thanks
> > > ---------------------------------------
> > >=20
> > > Guy Levi (2):
> > >   IB/mlx4: Add report for RSS capabilities by vendor channel
> > >   IB/mlx4: Fix RSS's QPC attributes assignments
> > >=20
> > >  drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++++++
> > >  drivers/infiniband/hw/mlx4/mlx4_ib.h | 16 +++++++++++-----
> > >  drivers/infiniband/hw/mlx4/qp.c      | 16 +++++++++-------
> > >  3 files changed, 37 insertions(+), 12 deletions(-)
> > >=20
> > > --
> > > 2.14.2
> > >=20
> >=20
> > Series applied, thanks.
>=20
> Doug,
>=20
> I can't find it in your k.o repo.
> Where can I find it?

Sorry, I took it, and I was waiting on 0day before I pushed to k.o, but
I forgot to push it to github so 0day wasn't gonna come.  It's been
pushed to k.o today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-FJjVKG5FducLFwnfhbR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKCvMACgkQuCajMw5X
L90mGw/+NcMiWS7wTuaguMmzHuSGkS2YG+ncSdyLM+UMrrG3KJ59nRn7q4oKUpbo
wktMsTBQPEebfuKvAVkLL2FcSmhbWKO+QV4fM9lbKU2VYUhjwtU3vPCKf9o76JQ6
QSJjnfgdvBMqUmBHKAzouVEtvpiI0A4C9oS4u4Gz1SIXVkKTLGJGZzfNSsrrWKb9
iWifQBrMd0dfp/87H6pQx8fElUS+1TSmeo5hrJ5Q1199GhfZxQNwczjMWCMcggRQ
KiHKPS9WXj1M/bubKqUOqhvgzPEA8uMcNdQIvv8ZSvIU1m2oHQqPRNnypWsgRCft
SopyZOE2+/k6ONPnfqxDDHFVu7YGuUjsrKx8Au8sdz5krbPfkQCZmRz9VCZMtIOC
GJ9sfLuvJipOY+vcRAOgdPm8/Od+VnG7OpwvG3WaO/DgVUeGbivOXNGwzUUOflU4
uZtUfDuQ/GkUfzvilE5G7r0mTRJ8oQVFAUReKlaBO1/DsWo3YHQvN9t40qR26bMa
VZ6WQQxWO6VRvydZnuAMwC8ArBvGVogllv4RR6n5+VGzpnoG733PB+jT/W48aNUe
DFtTo0RlBpso1Kd95nyQBND+U64NEhoZ+u9x3TpCrkYVwWRtaSBNns/SyP2Tdlyc
mojy/1BikWwQNmm7GlnomSX75IP/fMr+YLt50KtI9/U5yyDJMBk=
=Lvy5
-----END PGP SIGNATURE-----

--=-FJjVKG5FducLFwnfhbR0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
