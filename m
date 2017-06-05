From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH V5] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon, 5 Jun 2017 15:49:43 +0300
Message-ID: <20170605124943.GL6868@mtr-leonro.local>
References: <1496665420-8100-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NgG1H2o5aFKkgPy/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496665420-8100-1-git-send-email-baijiaju1990@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: monis@mellanox.com, sean.hefty@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--NgG1H2o5aFKkgPy/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 08:23:40PM +0800, Jia-Ju Bai wrote:
> The driver may sleep under a spin lock, and the function call path is:
> post_one_send (acquire the lock by spin_lock_irqsave)
>   init_send_wqe
>     copy_from_user --> may sleep
>
> There is no flow that makes "qp->is_user" true, and copy_from_user may
> cause bug when a non-user pointer is used. So the lines of copy_from_user
> and check of "qp->is_user" are removed.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--NgG1H2o5aFKkgPy/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1U2cACgkQ5GN7iDZy
WKebJhAAhkkwSqvWuG+qY88KHsaqpemd6gOcm+mxMspSrqSYWmWlaKWukdvaSHcs
tYbtssc4V4MFBvI0yLeEm45eWWsaauZLPoxYSNhZk1DnQbGMUwcLtlJUchW+zROk
urBw1Ghvnvdc35cxGVF7nHaz0NIewVmQ2Qot6IImpnsvtDC6/4CF2yYMzHp2nJA7
Yd5j1nQDbS8n3eDGu8Y2T7X61GJTIb6X7tc50F1m2BuyOuIdqP95+0Mk21/XUN00
mgSLlmsucMERUTqT7XGUHLXyc9Nt/CE3h9S0eCRtcNiS0jJL+YTxoe33OKabar0o
vkFKAMaAJ5GRAwofaZJGh4Xs0ViLzN8oxCnSRxb1MXC3IdbnYsoj8QWA5TiZR0sJ
1dZ3regsRhe01pi3ZFrXjPc1JJoqgm54evmcZKahCvpEqSicKSQMdU+mCwS2IR0b
E+NBiilQ6ATUNjRmisJJwNUgjJlncU0r0DR6kzjkTmCVWzlI/1ZqYHmud61CbDrF
CAFcJrTK6iX2qOz+Sd0g+g+1E3kwF6UudMR7bukRpR89bvltZL9ePf7s/ooVe+5n
da+nzV+X63TKwaAEOmqPYHtApDR5Ya54XVDCWEum9HKUKyj+cj7eOchlL3tooDaz
lo+lj7fhyBbs11yMFR/vYXoxyQxOqlL8KsIDQ7kOzswudAi9lt4=
=oSXJ
-----END PGP SIGNATURE-----

--NgG1H2o5aFKkgPy/--
