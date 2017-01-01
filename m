From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] IB/umem: Release pid in error and ODP flow
Date: Sun, 1 Jan 2017 08:47:12 +0200
Message-ID: <20170101064712.GQ26885@mtr-leonro.local>
References: <1483093109-188428-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4T94Hejb80K+e1gX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483093109-188428-1-git-send-email-liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4T94Hejb80K+e1gX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 30, 2016 at 06:18:29PM +0800, Kenneth Lee wrote:
> There are two bugfixes in this patch:
>
> Fixes: 87773dd56d54 ("IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get")
> 	This patch introduce the get_task_pid but not put it back on all error
> 	path
>
> Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")
> 	This patch introduce a ODP flow without release pid before enter it
>
>
> Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Change from v1 to v2:
>   Correcting the patch title and description
> Change from v2 to v3:
>   Update the title and add "Fixes" fields in the description

OK,

I see that you still didn't read Documentation/SubmittingPatches. You
must read that document before you are sending patches.

But I'll stop here, the code is correct (it fixes bugs) and commit message
more usefull than before.


>
>  drivers/infiniband/core/umem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 1e62a5f..4609b92 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
>
>  	if (access & IB_ACCESS_ON_DEMAND) {
> +		put_pid(umem->pid);
>  		ret = ib_umem_odp_get(context, umem);
>  		if (ret) {
>  			kfree(umem);
> @@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>
>  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>  	if (!page_list) {
> +		put_pid(umem->pid);
>  		kfree(umem);
>  		return ERR_PTR(-ENOMEM);
>  	}
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4T94Hejb80K+e1gX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhope8ACgkQ5GN7iDZy
WKciQw/+O8CnfbhNcsBmAUIyhiTdLgmtqIiREnbTKL6NTDDMNcBFzbW7kAqJHV0p
bjfeeCIB4J0MZGayVGUBWUsyqBWyvEoYn3WnLfdLReRVBiNqRCBhHdkrR9RXTI1W
mVPwtJBrwpPwdgkd/lIPi6o+me73FzklLR13txplJjGpY9iOMQXrbbZdOarwXtv6
CElRIGabzr1l5yqWDl7pioPex7R/IgothxBZ8+ak/c3WXeBUriXkathkompKWW8r
ENQXVNUnc7Y57KaEtnwXjcC9tm+6GhRp489nqtnhko8uwbpmZZT7PoO8qNKAo8cB
4v5dHv7UZpuQomoLuQzFC8yYATCXKvmswNm+dy89O/70hgGvhTPKHb85G/sWlg+e
FAC9Bh2Bl9zS6c1jU+5I7So0FJqU2eWEcr2Dy3Lyn4vqOORotuKCL1+wdpQ5HFUV
eKQ2P8jKiPXO4JE7bGrrZhqfvpR4zYjmTlJKM5h8B/5JbBvRPZ2HNKKBKAQE6VEg
ZYU8z5d0+W/4sj2M67LDmoJ5gcI7+ZdwelAwBkwMrFiDqhNL4mF+9GZ2C+PO1glZ
glxNdkQ2zlwBubP0z5hX1jDIbPgC5S/253oovJuMT7+sPx/8JygBv9nS08Q2f6nm
BMNC8HF79kMLJ+R2sHAJt06pAZThonPCWd7O3U3bMAAkHf+uHPs=
=uDy5
-----END PGP SIGNATURE-----

--4T94Hejb80K+e1gX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
