From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/8] IB/odp: export rbt_ib_umem_for_each_in_range()
Date: Tue, 21 Jul 2015 11:30:01 +0300
Message-ID: <55AE0309.4090606@mellanox.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
 <1437159665-6612-4-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437159665-6612-4-git-send-email-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17/07/2015 22:01, J=C3=A9r=C3=B4me Glisse wrote:
> The mlx5 driver will need this function for its driver specific bit
> of ODP (on demand paging) on HMM (Heterogeneous Memory Management).
>=20
> Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/umem_rbtree.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniba=
nd/core/umem_rbtree.c
> index 727d788..f030ec0 100644
> --- a/drivers/infiniband/core/umem_rbtree.c
> +++ b/drivers/infiniband/core/umem_rbtree.c
> @@ -92,3 +92,4 @@ int rbt_ib_umem_for_each_in_range(struct rb_root *r=
oot,
> =20
>  	return ret_val;
>  }
> +EXPORT_SYMBOL(rbt_ib_umem_for_each_in_range);
>=20

Perhaps it would be better if the driver didn't access the internal
rbtree directly, and instead used something like an
ib_mirror_for_each_range() to do this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
