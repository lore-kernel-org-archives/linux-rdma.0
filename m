From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/nes: do not leak uninitialized resp.reserved to
 userspace
Date: Mon, 4 Sep 2017 15:17:01 +0300
Message-ID: <20170904121701.GS10539@mtr-leonro.local>
References: <20170904112316.23832-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mpb+VUhBqKoEsre9"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170904112316.23832-1-colin.king@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--mpb+VUhBqKoEsre9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 04, 2017 at 12:23:16PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> resp.reserved has not been initialized and so the copy_to_user (via
> ib_copy_to_udata) is copying uninitialized data from the stack back
> to user space which is a potential information leak. Fix this by
> setting resp.reserved to zero.
>
> Fixes: 3c2d774cad5b ("RDMA/nes: Add a driver for NetEffect RNICs")
> Cc: <stable@vger.kernel.org> [2.6.24+]
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/nes/nes_verbs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index f0dc5f4aa177..052c3822dfed 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1666,6 +1666,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
>  		resp.cq_id = nescq->hw_cq.cq_number;
>  		resp.cq_size = nescq->hw_cq.cq_size;
>  		resp.mmap_db_index = 0;
> +		resp.reserved = 0;

Right and it is better to initialize the "struct nes_create_cq_resp resp" to zero
at the beginning of the function.

Thanks


>  		if (ib_copy_to_udata(udata, &resp, sizeof resp - sizeof resp.reserved)) {
>  			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
>  			kfree(nescq);
> --
> 2.14.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mpb+VUhBqKoEsre9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmtRDYACgkQ5GN7iDZy
WKdiXBAArhqWCC8Zob9DWdfU6xIkul2RpFUozNKYb+3zCWaClCtF+WykZwOb3aks
crB7VIhyW3SUcKQPy2sSPO7NDNlDkT3EyybuGjAG/FK9CxhXfIrAv8xsrEsZEyQe
7LutmI6NnYSzAn9LIla89yAD6idknNphlJdPBYnoc3IHlKDyI/mHADHvHWoKXJqY
khsS4sVjfX6RrJXfmk3T15O+QG6skc/vDnHDMqXNnv2HnZQASrjGtU2+M+fA9TOg
gwGkPRrXZPUc03syYA/Ij1NFmZef6kjWVmuZU76xl/vOaAdBrE86ZDT058kc8PBW
3Um1B1pSsOkVbqFQroJ8iha78+YsX8TmHVfwRsrIxMeBhhOpYCi2yNo0Qr65hzuc
OejG0W5RPn2ix4EkWho/MagvgsqDPz2HGjwH0XQ46bxLKEh18BSedK0XkvshfSpb
w3OVknrfHEtgTX1E4XLA71Ehftenqj0zfGkfxJXK8kVV17nak0mSXwGItrqHR54e
Y0/e8eu0NOnl4ofNSvR5ey0vGF5rORtv3n+H87s7vTD5e3RMIeNVd80GftBaqIrh
NJFBooE1ue3Ox/QSkY9yk71t8QuR4edjOiwV36m7JWSOjIPYTcX4j5NZtkJrMmQV
0WuSezjfxM6gxSKaE8wIh8fxn+iYQ8ufU3as4i0ujaZqb+6ryOk=
=GU6M
-----END PGP SIGNATURE-----

--mpb+VUhBqKoEsre9--
