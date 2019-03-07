From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH][next] RDMA/nes: remove redundant check on udata
Date: Thu, 7 Mar 2019 19:01:08 +0200
Message-ID: <20190307170108.GQ1789@mtr-leonro.mtl.com>
References: <20190302230637.8624-1-colin.king@canonical.com>
 <20190304063623.GA15253@mtr-leonro.mtl.com>
 <815dea03-ef9a-39c0-3ec5-cdd58a545911@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ah40dssYA/cDqAW1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <815dea03-ef9a-39c0-3ec5-cdd58a545911@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2019 at 10:23:28AM +0000, Colin Ian King wrote:
> On 04/03/2019 06:36, Leon Romanovsky wrote:
> > On Sat, Mar 02, 2019 at 11:06:36PM +0000, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> The non-null check on udata is redundant as this check was performed
> >> just a few statements earlier and the check is always true as udata
> >> must be non-null at this point. Remove redundant the check on udata
> >> and the redundant else part that can never be executed.
> >>
> >> Detected by CoverityScan, CID#1477317 ("Logically dead code")
> >>
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >> ---
> >>  drivers/infiniband/hw/nes/nes_verbs.c | 73 +++++++++++++--------------
> >>  1 file changed, 34 insertions(+), 39 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> >> index 828e4af3f951..526092d435df 100644
> >> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> >> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> >> @@ -1039,53 +1039,48 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
> >>  				}
> >>  				if (req.user_qp_buffer)
> >>  					nesqp->nesuqp_addr = req.user_qp_buffer;
> >> -				if (udata) {
> >> -					nesqp->user_mode = 1;
> >
> > It was single place where user_mode was set, you should continue and
> > remove all code which depends on "if (nesqp->user_mode)".
>
> This is not the only place where user_mode is being set; we currently have:

ok, It doesn't matter, I'll clean it later with my memory allocation
conversion patches.

Thanks

--Ah40dssYA/cDqAW1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcgU5UAAoJEORje4g2clinhMYQAMVjNOhrTtcq5zyPak5Slih1
fO1U0u7DXwIR4nyPd1Dim4+6/DsgX3Tzx7H7sjB+7kmBjQU/F0gppDuYvhH/+GA7
zgcLhkHT9G52/fvH2CZPZNb2c9y1S3CweV2e4s4wr0bHSEjJ9UnfEdJQ6jRRS4/V
gJlNWGM5Mv3f2GFmjpPeGGdmW7Z870y8aKS3TTTKt+YzcO7ArdJMfYS8LPSY2pds
tbJdFnrrG4YE7wlpmfCkyOThaulnT12eKjR/Bmwrwv5vWPl+DrCrn0mZ/ZgGDIyV
q/bNm5eRfIAt38pOFnC5vyAge8Pr3s05SW+rhqKGtVl4m0mbGumOEAKs5FZfT0iG
ULAjcHyiZfb6aQrg5B9Mv5eWOok2q4OGzlG0R4QWrP8dnj4I6Gl1ZFwaL8T6qL+8
ACfmtqZdR2PpHMf8YL7e/oNCRzGpZj9+w71r+cuBj6P44+PZbuDJ/PQ4mIoMUOII
sIWMocbFOb6wPT+Hx5qFhrZncJpYlKYWTm5gy7zd9Mv4u3V8PYJjlzzXwSJSjupL
XDdnwnBhpi7c2/28FrW6afd6qh+J2rYdQ2kP0DUL1Vvo6Ylxis3qy+Ce1CNLiQxN
eS+F7d8MJHeQr+eU5nta3XAVHLLKWQy5VuIXCw36iuvBzXC/xCJIS/d7QUkNRX6c
QMXOKHG/EXsJHpAn9S0m
=aqqe
-----END PGP SIGNATURE-----

--Ah40dssYA/cDqAW1--
