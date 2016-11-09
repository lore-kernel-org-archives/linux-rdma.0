From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 3/7] libhns: Add verbs of pd and mr support
Date: Wed, 9 Nov 2016 09:34:26 +0200
Message-ID: <20161109073426.GL27883@leon.nu>
References: <1477731826-10787-1-git-send-email-oulijun@huawei.com>
 <1477731826-10787-4-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="64LDleNqNegJ4g97"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477731826-10787-4-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--64LDleNqNegJ4g97
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 29, 2016 at 05:03:42PM +0800, Lijun Ou wrote:
> This patch mainly introduces the verbs with pd and mr,
> included alloc_pd, dealloc_pd, reg_mr and dereg_mr.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> v2:
> - No change over v1
>
> v1:
> - The initial submit
> ---
>  providers/hns/hns_roce_u.c       |  4 ++
>  providers/hns/hns_roce_u.h       | 18 +++++++++
>  providers/hns/hns_roce_u_abi.h   |  6 +++
>  providers/hns/hns_roce_u_verbs.c | 79 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 107 insertions(+)

<....>

> +struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
> +				 int access)
> +{
> +	int ret;
> +	struct ibv_mr *mr;
> +	struct ibv_reg_mr cmd;
> +	struct ibv_reg_mr_resp resp;
> +
> +	if (addr == NULL) {

It can be great if you use one style for all your code e.g. if(!addr) ....

> +		fprintf(stderr, "2nd parm addr is NULL!\n");
> +		return NULL;
> +	}
> +
> +	if (length == 0) {
> +		fprintf(stderr, "3st parm length is 0!\n");
> +		return NULL;
> +	}
> +
> +	mr = malloc(sizeof(*mr));
> +	if (mr)
> +		return NULL;

It looks like bug and you wanted if(!mr) and not if(mr).


--64LDleNqNegJ4g97
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYItGCAAoJEORje4g2clin8iYP/iq9IbdWROXNtWAJyOpByMA1
GRYCYKtk/GRT55BeZQrkHN9hsZIqXPLTKucTNuOErajkSU/NHZUysRuNCOBWlPnZ
SMvQh88H7yY53kmbSQTcB+HrhrXu0XtGneASK/XZeTPFdhOlLwvSn3bj/i2LJVc+
xrpnAahOTXEacSb7SnNBBInsDzNpSOlROV7MyIsTEHvnM2ZhMt47TiIjEKVMVJlN
OLTplwgIEJbghrgSPqT5ANluxtbnNjETqs1ibaAtKaiPnf+B2+evASV734cdN95h
ey0UfY1KP5LKs54QDZ8rihQD7me3XDmvqeaFqtf2BIeLvtUyNybGvGQAOTBnFn31
IUWP2xcsgxLKWW+DBpgRtZxE4opS4mtln2CjNb+1dg5VgdDtgFrtJLp12BiWFYOF
+Q+BZ+HlKYrm1ibToHrqUqfTXJLXMY13vJ4PodFxAM/HmM+FbOFyJY6mXtMGFQ9+
qxPpo3cqiBOWMd9M+dGqAf/Iud1y4ZNyyFU8s7G0JZOBnt8ad+k3c9zzwO/AYb2M
gdnSvi04qcE5gKsnKVk9Nqh6qecUBlKydxNZy/W1SEgjcwxxOflkFh8HT2jEF6Y8
fSowsspnch+1cJmqFGuqbLgvMbseYtgHev1r5J7IE3L34TJbqH43TgNt475n/ihf
ctWfY1Mk4Oc/JVELrOoO
=hItI
-----END PGP SIGNATURE-----

--64LDleNqNegJ4g97--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
