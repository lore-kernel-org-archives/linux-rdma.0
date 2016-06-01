From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore
 spin lock
Date: Wed, 1 Jun 2016 19:47:32 +0300
Message-ID: <20160601164732.GI7477@leon.nu>
References: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
 <20160601154440.GH7477@leon.nu>
 <20160601161459.GB9144@kroah.com>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601161459.GB9144@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01, 2016 at 09:14:59AM -0700, Greg KH wrote:
> On Wed, Jun 01, 2016 at 06:44:40PM +0300, Leon Romanovsky wrote:
> > On Wed, Jun 01, 2016 at 10:38:12AM -0400, Mike Marciniszyn wrote:
> > > Upstream commit 7049de65c9e5 into 4.6.
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Is it part of the commit message?
>=20
> It's enough for me to know what to do here :)

Good to know, I always used CC: stable notation.

>=20
> thanks,
>=20
> greg k-h

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTxGjAAoJEORje4g2clinwFsP/iBXWr2/+2238C9bdmwyuMIg
AurlLRAB/AWhxs+ptd6KVy72UKZMPPK6MtCD3LxqlUuRyK6O0nnqGE8fm0BP2wwp
k/o0aiQEL9m0E7O5lZFhLnCLMELILGRshE4P/IxvR6+t4OCFwQyC81Dd+5+8aC8s
DYMCiRJ0WuCUVXvFofshzTnj2mPnRZfTxa9fFZDtipfuFa3fgH1WlHe9QzjQ05Vh
gGRnI7WJdqu0Kn1LLBpyVkWP2aC3c9SztdjBGIJFFw+2SQC0HA6ilKtOv1GMsg9J
PiQxuogxjCyeVp8ikYO4jW2UZA3LJKVWpeQm5Za79VicmLmMwUJd2xd5CWh4RINN
AR1iPWMcZs/iM2u3Myq1TughoYNIubHzrdwqeO0x1ydOTRawFetmlxgEekkeimQR
msOhlylf0pzCP4wg2WanlmE2dNt2Nr9krych9jKjgdhLwSulaJJ3d80kC/q6uBFr
KCWrdX8t6QuRobbcSbaVtrshk7quFcNO17O7uYlo3HhvniHRgmd3wRgC40Wp7ZcD
gkbbFRwjvBTuD76+XXsWdmBVaPf5mKsgmLRmPEEyRRqkvDRDUWDfTnz44TOpReez
ZCHAOc8UeiEvE59pZCUGHYEdbacBdoqTxvjw0lY3ILIQDbSW2pkWBTUtFyJ3a6Vn
YRPEXKXktlCONygD3ERz
=Em6g
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
