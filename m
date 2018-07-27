From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma
 tree
Date: Fri, 27 Jul 2018 15:09:03 +1000
Message-ID: <20180727150903.0f2816ba@canb.auug.org.au>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
        <20180727132847.2be8563b@canb.auug.org.au>
        <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ag3SSCB8sRIv52EdCbiJq_m"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Sig_/ag3SSCB8sRIv52EdCbiJq_m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Parav,

On Fri, 27 Jul 2018 04:57:41 +0000 Parav Pandit <parav@mellanox.com> wrote:
>
> >  	for (i =3D 0; i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
> > -		memset(&_gid, 0, SMC_GID_SIZE);
> > -		memset(&gattr, 0, sizeof(gattr));
> > -		if (ib_query_gid(smcibdev->ibdev, ibport, i, &_gid, &gattr))
> > +		gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
> > +		if (IS_ERR(gattr))
> >  			continue;
> > -		if (!gattr.ndev)
> > +		if (!gattr->ndev)
> >  			continue; =20
> This requires a small fix.
> If (!gattr->ndev {
> 	rdma_put_gid_attr(gattr);
> 	continue;
> }

Thanks, I have fixed this up for Monday.
--=20
Cheers,
Stephen Rothwell

--Sig_/ag3SSCB8sRIv52EdCbiJq_m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltaqO8ACgkQAVBC80lX
0Gxj2gf/cGH4xP5XiC5RN6dQEw44mUZPC9/9aOF2QhcWj/6AmlFYWqdYzqKtlKhg
UiwaQ0uYQhxYbmbJr4/nvuwemDwwF1H2RmoWBvgxTJIBtjnI1kQm02aKm8ikwYoP
RkSHlmi9+CESZQ2hFDMs09nD9hZIk1GxVwPZ0XAUQJa4n6emcThqoanEvOeCb00B
IiA0gS5ETYF6KBxXpTzWHQVtR9sUmBt7927jy2AwsBKBJHTahEO4oOFJrmYZVuBJ
naa4Fa4zCpzj3f1gwHhxRf9UONYPqIMIcX7P1IlfCaKASuFIRJrbhPehpqvLDD6F
QurSJ3XodiwHbsvCXHiA8xzYdmx5IA==
=2BXY
-----END PGP SIGNATURE-----

--Sig_/ag3SSCB8sRIv52EdCbiJq_m--
