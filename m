From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 09/14] RDMA/cxgb4: Use common error handling code in
 recover_lost_dbs()
Date: Thu, 9 Feb 2017 20:57:14 +0200
Message-ID: <20170209185714.GQ6005@mtr-leonro.local>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
 <3da7cff6-9f94-2ae8-a173-7ad6efdb524b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XAvhOFWJb7CBzhKn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3da7cff6-9f94-2ae8-a173-7ad6efdb524b@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--XAvhOFWJb7CBzhKn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 10:19:41PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Feb 2017 18:08:08 +0100
>
> Add a jump target so that a bit of exception handling can be better reused
> from an in branch in this function.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 2931920d7c4c..86cf7026619f 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -1402,9 +1402,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
>  			       pci_name(ctx->lldi.pdev),
>  			       ": Fatal error - DB overflow recovery failed - error syncing ",
>  			       qp->wq.sq.qid);
> -			spin_unlock(&qp->lock);
> -			spin_unlock_irq(&qp->rhp->lock);
> -			return;
> +			goto unlock;
>  		}
>  		qp->wq.sq.wq_pidx_inc = 0;
>
> @@ -1418,6 +1416,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
>  			       pci_name(ctx->lldi.pdev),
>  			       ": Fatal error - DB overflow recovery failed - error syncing ",
>  			       qp->wq.rq.qid);
> +unlock:
>  			spin_unlock(&qp->lock);
>  			spin_unlock_irq(&qp->rhp->lock);
>  			return;


These patches are completely insane.
Goto label in the middle of the loop, just to exit from it.

> --
> 2.11.1
>

--XAvhOFWJb7CBzhKn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlicu4kACgkQ5GN7iDZy
WKciXQ/+JtIK4lP9GgLQQEZmOuJ8Zrwl6NLsI/bSFdYhz+BYQLpVxk+ClKBancOc
0np/euRMo3nW5ykttMfehIw25rKXUIaXlW3Wb6kN5x4vrh+4EZCnOoEaG5zXw5E7
D4wyb93XWBgHHQh8xOmLWuA7b/LXEH1x6rvRCowllgrmDrpWL8+kgn2xHQFHMlbT
bq5EcQ6YMWczYTrR2VUuB30PoWmVgCcjKiu8boKT3O3YkSiMMrO4w9XAt4cCdKB9
xN1boVjGW5gv3U9FYxv1fBWK9R2mfX3AUx1/enZF20gQLBZhtvZ1wAMw3zX8aNx/
uX5FqzbbuCETbwwqMID4PVAU4k92mRiJEDVsoFvSqgTOMaAxqFMLBA0qTEvg3G7c
gRRot1sptRg57+MhVJqWHAd5/PivGwLiUcgTn0t3B1mQ5FMIL4fnHpDGu9yzTV2h
YzVsxDxrz+pHdxnxC6Jkgs+Kyl0lYotdJzbYDZ3i6uTp4MA0LnNWCB4TFuOceRWi
VB7oXmJoK2UUDU9uTMvXXCeu7J5o8kJG2oAQsNqDZ4Glg8DMkDT2lOa7kPyz435m
/GqOYprbSTcqTfIwnH0JcQMK7irOF66G6Pg4ThFPTJ8vzJMcFeoKqZ0vYfCT+xOS
iD5n+8NUuRaVSsOah1ZN8U3N9LJt17+L0MnuqhnEKXd6p2YcnOM=
=hTIp
-----END PGP SIGNATURE-----

--XAvhOFWJb7CBzhKn--
