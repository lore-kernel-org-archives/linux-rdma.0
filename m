From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 06/12] RDMA/uverbs: Don't overwrite NULL
 pointer with ZERO_SIZE_PTR
Date: Mon, 25 Jun 2018 11:08:13 +0300
Message-ID: <20180625080813.GH17747@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-7-leon@kernel.org>
 <20180624195751.GM19151@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Rex5+51txc1ort/q"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180624195751.GM19151@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Rex5+51txc1ort/q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 24, 2018 at 01:57:51PM -0600, Jason Gunthorpe wrote:
> On Sun, Jun 24, 2018 at 11:23:47AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Number of specs is provided by user and in valid case can be equal to zero.
> > Such argument causes to call to kcalloc() with zero-length request and in
> > return the ZERO_SIZE_PTR is assigned. This pointer is different from NULL
> > and makes various if (..) checks to success.
>
> The one seems really weird. There is nothing wrong with ZERO_SIZE_PTR,
> but this description and fix suggest that something did
>
> ptr = kalloc(0);
> ptr[0] = ...;
>
> Which is not allowed of course. Doesn't this mean there is also a
> missing range check someplace?

I don't know, this issue was found during code review of
ib_uvrebs_ex_create_flow(), may or may not be real issue.

Thanks

>
> Jason

--Rex5+51txc1ort/q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMKLtAAoJEORje4g2clinzlIP/0N3dvIpeybAOh6qeVAGzUDu
Mu8/T2J5bLnkXO37nXJxGnObqifTinF5OPwSzbLZ1s3Ps2x9agndgpfzzGmHcqsx
zbpad+/sChv2k1rjT0oISbzpUShXbTFYE65FJD7R5u88S2WXTjE/34kACg6phM8A
AlJRMSE9cE6eLUb8vqzpXDE9LdnVm3Bk2deGdJe3RrKO98n67EzdTzBKMuGJXih3
k55K/2EYJ0Su6XRgnz4oPVfHjauSnJQyySvgfQQJAPGuevilCHLu/dY0HywLIKIU
hpbN+UZSxVHMz7Z7s63JGp6P5UpJ/57ESvlFycc5aOQMP+SE8wMuURNIKSic/6m7
oWx4WhFNtY5685XepIJaP9O5tXhTp2fhRKZdB4s4IQxNxbVg7IBalHNelRhJE+S4
+I1brN2pUrMQXLr+37egjigY3Z6jSrJsuiU2MhxNtAmMP56QBBrMsGsUcBNO8kSj
vTiE+/+6GJEnVgeR4IQoDwx+446ZSIK5NEHv6Ruzt0U9OIeznF7iTEiWClPqeJQb
AUajq/+1nikYT7HcciqwLlYW6kAoPEsrMWuIyrL+OQvCKcq138MUwgzFVTmk2Zgf
ZcWyw7SILdIVPqMe92cIeLvqZLgMFBSXayzhdgaspSm/qR0bD202raTMHnnyMLyP
OAIE09UNVT8CPWiSXRfw
=Ujlg
-----END PGP SIGNATURE-----

--Rex5+51txc1ort/q--
