From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: bnxt_re: qplib: Check the return value of
 send_message
Date: Tue, 1 Jan 2019 09:52:42 +0200
Message-ID: <20190101075242.GN10329@mtr-leonro.mtl.com>
References: <20181226185623.9324-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J+eNKFoVC4T1DV3f"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181226185623.9324-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--J+eNKFoVC4T1DV3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 26, 2018 at 12:56:22PM -0600, Aditya Pakki wrote:
> In bnxt_qplib_map_tc2cos(), bnxt_qplib_rcfw_send_message() can return
> an error value. The fix returns the error from the latter function
> upstream.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> index 5216b5f844cc..adb8eae5193c 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> @@ -778,9 +778,8 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
>  	req.cos0 = cpu_to_le16(cids[0]);
>  	req.cos1 = cpu_to_le16(cids[1]);
>
> -	bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp, NULL,
> -				     0);
> -	return 0;
> +	return bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp,
> +						NULL, 0);
>  }

AFAIK, there is no need to do casting to/from void*.

Thanks

>
>  int bnxt_qplib_get_roce_stats(struct bnxt_qplib_rcfw *rcfw,
> --
> 2.17.1
>

--J+eNKFoVC4T1DV3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcKxxKAAoJEORje4g2clinjZsP/1vavFeuhDosVrH+JHls5Yu1
s3CG5MZSXGXCj5G2nrIKTRe0X9hkR/aP3LWVjAz91q4b/RYiz3jw1uitPSn6k0HY
jiz2kNea1lr6fG3EzNPakRPc6+UzFXX66nOCWq7Z3tkVZOmLf+IxJo957UH8fBGF
+2A/CeZmvOa0fwfi6BbD5Yw5EkFLz1A4jUdMSYbkH6DiMT6z/jzMFMnzT9773jn3
035YHUuTFLDMTQLFGRXoGUQ0Ima15y82Av3w/RNWt4t7mMRJUvpnDiRNc4GRb8uC
u8mJhorpKeIY7ZhEve+pFkUp/YG5LJKYODpRpw/i8PFj8r/LioOP71TyeOJtiL4e
iIKXPAjbUzupVPT8Y80JqOkPNZwiZg51oVWTYK92LFrFHR9/Ef2og36bd20WkOE6
6KD0ojs4q2h+qYcHcQcA4htdAkWZcHkOPu39Aj/k2XPZFresfYjmjkdFIv2T6SVy
07j0R9iaAqD1Coukln7LESQl+qGiVxIEZMJbVxQuy+YX20g/iXpjcdtjepDX+Ydd
kNQLJfB3YUIDe9F7yHf7VIZROuOzh3qWNRo4xtKY2uxPr534g4g8Q+TEcmzc0vEH
5fswpGzCnIdPXyZa/wHDFmvVL7/hCQx0/ol0Hj8PR5Ls8LkoLhOTKb7S58SCoy2e
Axx4p7mQT31Q5JmeegQ8
=L+Ol
-----END PGP SIGNATURE-----

--J+eNKFoVC4T1DV3f--
