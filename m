From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH][next] RDMA/nes: remove redundant check on udata
Date: Mon, 4 Mar 2019 08:36:23 +0200
Message-ID: <20190304063623.GA15253@mtr-leonro.mtl.com>
References: <20190302230637.8624-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ma2pZxZcUUd0eybH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190302230637.8624-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Ma2pZxZcUUd0eybH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 02, 2019 at 11:06:36PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The non-null check on udata is redundant as this check was performed
> just a few statements earlier and the check is always true as udata
> must be non-null at this point. Remove redundant the check on udata
> and the redundant else part that can never be executed.
>
> Detected by CoverityScan, CID#1477317 ("Logically dead code")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/nes/nes_verbs.c | 73 +++++++++++++--------------
>  1 file changed, 34 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index 828e4af3f951..526092d435df 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1039,53 +1039,48 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>  				}
>  				if (req.user_qp_buffer)
>  					nesqp->nesuqp_addr = req.user_qp_buffer;
> -				if (udata) {
> -					nesqp->user_mode = 1;

It was single place where user_mode was set, you should continue and
remove all code which depends on "if (nesqp->user_mode)".

I looked on the change which triggered Coverity warning and looks like
your commit message should include this Fixes line:
Fixes: 899444505473 ("IB/{hw,sw}: Remove 'uobject->context' dependency in object creation APIs")

Thanks

--Ma2pZxZcUUd0eybH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcfMdnAAoJEORje4g2clin/0gP/3wzVBGqLbp+ZEORDYZus7nq
xalQQ6UDevH70HB6XnxeApRH/qBfwntDhN5H0qqt1SP3E9xCuZh/1Hb2PofB8HgR
H25DCA1pEihrLufrcU8ttGhEJk8JP19tCtqybpa4zAWLFXlO9f7Bn0vqAf8kzdoD
dSuCCed5xj+10IHeR9oDsPm4wDXu1eAKKHD4tuRxicHkgkxuPTC2iipiUBXxfJB2
UUVitYv9cg40SBRTQp5mjMnS4ZF+ItX7nWXmL9R+tCxsg8RIFXelfV5tjNIcA25I
jVaQHHDxZM+vIy55K3Fcwl4XOT18ec3648pyoDVqz2EzlKqqOiCgTldoLKd2uPWk
JSh+rWEZ5c6db93KloQpqkD42ZcPWkhOo6Bn3w5JFrud74kHS/HAHqzgTBjFNsOG
SHUPOpfpelCku/eMTUiWI+wiuecD9CDrzlY65QGJLok8WxYPjexHDMaJTx3ZYzBm
YiQ0e0Fpco24hL9Ft/1giw/eG8J5vGdo+ks6gdkJp3bRRM6kG1OpsaCpcKhhbtUF
eqasCPqJ/3EzfqR0OW0iECx4ArDOYsLB2h8pEVAwIx5XI3bsdfDbf5O7Mqs7EZFS
C/hxZr7A0HPCnPk+uUKkzFKjGadF9DXgqxBNksHrbd2u3vKeQfF+Mn1xIo28lem5
HLtqDwjiVXPdoJFRwhEY
=wQRA
-----END PGP SIGNATURE-----

--Ma2pZxZcUUd0eybH--
