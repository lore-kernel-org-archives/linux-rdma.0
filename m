From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Replace mdelay with msleep in i40iw_wait_pe_ready
Date: Sun, 24 Dec 2017 13:57:30 +0200
Message-ID: <20171224115730.GQ2942@mtr-leonro.local>
References: <1514111980-30502-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iamKNtDj9HjMhSdE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514111980-30502-1-git-send-email-baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--iamKNtDj9HjMhSdE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 24, 2017 at 06:39:40PM +0800, Jia-Ju Bai wrote:
> i40iw_wait_pe_ready is not called in an interrupt handler
> nor holding a spinlock.
> The function mdelay in it can be replaced with msleep,
> to reduce busy wait.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--iamKNtDj9HjMhSdE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo/likACgkQ5GN7iDZy
WKfwww/9GXik8uiZEYKzMmN4NTm8OvEqcRhnqjFqH4IShsuf1HE/J6Z8l6eohd7v
/cTAs60APnmLp69+h0A0PMNM3oJoQKF79TZ/KDZ4KGNCf98x1pvEY17MxQyP5pEK
u4hD1GvgvZqY09Fq/ViSbHvbCBQQ6BTGHn0pOzbh/BTcddVf+hvSPvA0CL/WMiMT
Rjt4mKSoooisG2oGawWCCTQHRdXe5j9ev0lIffDLIy8zWSNJkgjNqUkIHKLmyAyx
oUrVBtWnOdkcmi8Lp2/cJpBaZVnH/8iInUm0hX3xHGPHmX7BK0GP6mwu6zs2htGY
Ymbng81UaNyiBH+h1hmkHiBF5zCERXx7LmquXdoas8EUUr6Yd3fcOXT7PQ0UPVGe
iz8GM8hI8O2q0vscAJzT5cAYbfvur/KHXGj/KF6vW2PK1EKkMqJH7ZArlsDrswF9
YAcL3GXzaei0p9WSPoC8vSL2jRZHzg9uCVXlNYcYOE+EfvWxev/nKpJ6uvXxzxSf
F7jyYreHFT+6+AKungSCT2JIWYlwYwV+8LMFJAZgd25VoMUooPgzF19hXnsp7mrW
a2E2hZKeXyVmjjTqi4abbYHUwjKyH3VEa6dH28JSSkn4exY74J89h4wwbvA+xaNT
4UEqzDi6PjQ3vPySQzx22icwPBwI/8aaQ7ehF41sIbYML4vuqOc=
=s+RX
-----END PGP SIGNATURE-----

--iamKNtDj9HjMhSdE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
