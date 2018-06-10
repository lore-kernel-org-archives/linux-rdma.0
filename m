From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Sun, 10 Jun 2018 15:25:05 +0300
Message-ID: <20180610122505.GM12407@mtr-leonro.mtl.com>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180610063028.GH12407@mtr-leonro.mtl.com>
 <20180610104305.GA9284@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180610104305.GA9284@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 10, 2018 at 03:43:05AM -0700, Matthew Wilcox wrote:
> On Sun, Jun 10, 2018 at 09:30:28AM +0300, Leon Romanovsky wrote:
> > 1. IBTA spec doesn't talk at all about the size of TransactionID, more
> > on that in section "13.4.6.4 TRANSACTION ID USAGE", the specification
> > says: "The contents of the TransactionID (TID) field are implementation-
> > dependent. So let's don't call it mlx4 bug.
>
> I was loosely paraphrasing the original bug report; suggested rewording
> of the comments gratefully accepted.

Just replace "mlx4 bug" with something like "to comply with mlx4
implementation".

>
> > 2. The current implementation means that in mlx5-only network we will
> > still have upto (1 << 24) TIDs. I don't know if it is really important,
> > but worth to mention.
>
> Actually, the TIDs will be up to 2^56.  We're limited to 2^24 clients,
> each of which can send up to 2^32 messages.

It sounds like more than enough.

Thanks

>

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbHRihAAoJEORje4g2clinYlkP/0vfiftoDnbAo2tWAQm2FfxV
y0PPkTiSeI0o+uFp0R37d0iQnaUoiAqTnfEE48rDY7OEzIvp39+CE5KDuTKH3H0T
jIEuTKSEZoVyWkNIg+ukL1ihgQdBVFB4v9N+LWyj3ZqxP0DCtOA/QegNel99DPFR
nLFPWJNeGAVMCQTSxuhZrmY5ms3pC83N7PjdddHT2BSXDAFFRjRRa+Q9gG7QcrGV
vH+YFs3QOvipR2dCOOIcS797FxSYbtTHQTceooNjp+IoC5Vf/Uu3vYSshsQALvZT
piCo+RUBbQbBdKIqh/OQBw+bIxSiUWNbUVMFNw74aehXhLJld9BBw+Y8ldNDlUkN
scGeuT3ODU/fqcLtOurpbJ4Kt2m8C3itGRDhKFwJzLqBwpMJwGCcBwN1SPUf5Fti
eJLpWkP9e74Uypx981f41GooC9SApsEGG80t7QZ1pa7Xief5yRbAI9PcrvNV5xxz
9w1/5LiFwL0jF7mYzzqytorKun/lfxIkP2FI2AQoDkedQTaa+q3/Kll10rYvLo9m
OeSHsPtpyKhGbiHXQLHpgm0Rsl1ss77xlNKEhsSVFO62rwoeJQCobHfUfwPGkzOp
tlyrH3c1O+yQqH21U25YrZz1qWJ66gUTJYER7oAD2XpgLj/+xwj+ZNGl5STv5qgP
eNr1RB5Ci9qra1cpHlgO
=x3xM
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
