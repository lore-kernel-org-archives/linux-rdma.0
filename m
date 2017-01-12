From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: function interface change
Date: Thu, 12 Jan 2017 11:01:43 +0200
Message-ID: <20170112090143.GF20392@mtr-leonro.local>
References: <1484206741-15218-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484206741-15218-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 12, 2017 at 02:39:01AM -0500, Zhu Yanjun wrote:
> The ipoib_ib_dev_down/ipoib_ib_dev_stop return zero unconditionally
> and the callers never check the returned values,
> change the return type to void and remove the redundant return values.
>
> Reviewed-by: Shan Hai <shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h    | 4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 8 ++------
>  2 files changed, 4 insertions(+), 8 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh3RfcACgkQ5GN7iDZy
WKe8RQ/9GqSIu5nycjGvleiWDP/ssIAxVX22JFD113AtXLSdnCQI6DzFJUdrBdAX
aw6TlZ6ryUGhuMkljsq2fN7zmFwtFEiz/zcPuaxm9lXoC5e+NYZjxCZHpOYdfBcy
nMTV4qgHYmZ79FBdIg/ulNDX5JJC9X7R9SciJEdVqXV4jhkjedNu2OdnRoMDpDnz
LwbXy3FVzkWHBcqFGH8AHs6N+sCfhfTZmlnQWCW0ulyNKz3ezTvDzdkn59LBVYR4
miJGLkDgFjoLA9Q+h7TZY/wHM5VNSqEEAM+F7fuUU3Fm064F5iMgvKoWag5wN9x/
BocSKC/UWnO620/KxxxPUlRdwYtUwMNgSwY5xBrFbhQZH68rPYDX0OFZ2WyXHM4U
GinJXgaKmysFaVlPiW4mP3xhSIapaRYN0dcOrBJtYfREHaYF7e2YDp37OuJf9RJe
K2tkSbZ1zitQCsnwYntMQDRQV9u9DpWStyuW4W1VOAG3uO3qhjuu8VAUj+fejLPz
krK9BU8cP2sMQhPob0RepA5JXngShmVzLzyLiG8TXcFzUnLwuARhuEG5dV28STn9
whDYB1VB4gN9eWVtNauqQ6KHiiy+BbkgjffOEDpm+8PfPVuKpP7B9v2zEav8PN3G
kz4yBiXYMHY693gzJ9D6UHMPqoMRiP4jfwe7ZWjTurDVqkmK85I=
=KG7q
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
