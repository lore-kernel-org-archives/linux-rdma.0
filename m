From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/4] RDMA/hns: Add IOMMU enable support in hip08
Date: Sat, 30 Sep 2017 19:10:23 +0300
Message-ID: <20170930161023.GI2965@mtr-leonro.local>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
 <1506763741-81429-3-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wjoFZxbW4tu+iR6v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506763741-81429-3-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wjoFZxbW4tu+iR6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 30, 2017 at 05:28:59PM +0800, Wei Hu (Xavier) wrote:
> If the IOMMU is enabled, the length of sg obtained from
> __iommu_map_sg_attrs is not 4kB. When the IOVA is set with the sg
> dma address, the IOVA will not be page continuous. and the VA
> returned from dma_alloc_coherent is a vmalloc address. However,
> the VA obtained by the page_address is a discontinuous VA. Under
> these circumstances, the IOVA should be calculated based on the
> sg length, and record the VA returned from dma_alloc_coherent
> in the struct of hem.
>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---

Doug,

I didn't invest time in reviewing it, but having "is_vmalloc_addr" in
driver code to deal with dma_alloc_coherent is most probably wrong.

Thanks


>  drivers/infiniband/hw/hns/hns_roce_alloc.c |  5 ++++-
>  drivers/infiniband/hw/hns/hns_roce_hem.c   | 30 +++++++++++++++++++++++++++---
>  drivers/infiniband/hw/hns/hns_roce_hem.h   |  6 ++++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 22 +++++++++++++++-------
>  4 files changed, 52 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
> index 3e4c525..a69cd4b 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
> @@ -243,7 +243,10 @@ int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
>  				goto err_free;
>
>  			for (i = 0; i < buf->nbufs; ++i)
> -				pages[i] = virt_to_page(buf->page_list[i].buf);
> +				pages[i] =
> +					is_vmalloc_addr(buf->page_list[i].buf) ?
> +					vmalloc_to_page(buf->page_list[i].buf) :
> +					virt_to_page(buf->page_list[i].buf);
>
>  			buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP,
>  					       PAGE_KERNEL);
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
> index 8388ae2..4a3d1d4 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hem.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
> @@ -200,6 +200,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
>  					       gfp_t gfp_mask)
>  {
>  	struct hns_roce_hem_chunk *chunk = NULL;
> +	struct hns_roce_vmalloc *vmalloc;
>  	struct hns_roce_hem *hem;
>  	struct scatterlist *mem;
>  	int order;
> @@ -227,6 +228,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
>  			sg_init_table(chunk->mem, HNS_ROCE_HEM_CHUNK_LEN);
>  			chunk->npages = 0;
>  			chunk->nsg = 0;
> +			memset(chunk->vmalloc, 0, sizeof(chunk->vmalloc));
>  			list_add_tail(&chunk->list, &hem->chunk_list);
>  		}
>
> @@ -243,7 +245,15 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
>  		if (!buf)
>  			goto fail;
>
> -		sg_set_buf(mem, buf, PAGE_SIZE << order);
> +		if (is_vmalloc_addr(buf)) {
> +			vmalloc = &chunk->vmalloc[chunk->npages];
> +			vmalloc->is_vmalloc_addr = true;
> +			vmalloc->vmalloc_addr = buf;
> +			sg_set_page(mem, vmalloc_to_page(buf),
> +				    PAGE_SIZE << order, offset_in_page(buf));
> +		} else {
> +			sg_set_buf(mem, buf, PAGE_SIZE << order);
> +		}
>  		WARN_ON(mem->offset);
>  		sg_dma_len(mem) = PAGE_SIZE << order;
>
> @@ -262,17 +272,25 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
>  void hns_roce_free_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem *hem)
>  {
>  	struct hns_roce_hem_chunk *chunk, *tmp;
> +	void *cpu_addr;
>  	int i;
>
>  	if (!hem)
>  		return;
>
>  	list_for_each_entry_safe(chunk, tmp, &hem->chunk_list, list) {
> -		for (i = 0; i < chunk->npages; ++i)
> +		for (i = 0; i < chunk->npages; ++i) {
> +			if (chunk->vmalloc[i].is_vmalloc_addr)
> +				cpu_addr = chunk->vmalloc[i].vmalloc_addr;
> +			else
> +				cpu_addr =
> +				   lowmem_page_address(sg_page(&chunk->mem[i]));
> +
>  			dma_free_coherent(hr_dev->dev,
>  				   chunk->mem[i].length,
> -				   lowmem_page_address(sg_page(&chunk->mem[i])),
> +				   cpu_addr,
>  				   sg_dma_address(&chunk->mem[i]));
> +		}
>  		kfree(chunk);
>  	}
>
> @@ -774,6 +792,12 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
>
>  			if (chunk->mem[i].length > (u32)offset) {
>  				page = sg_page(&chunk->mem[i]);
> +				if (chunk->vmalloc[i].is_vmalloc_addr) {
> +					mutex_unlock(&table->mutex);
> +					return page ?
> +						chunk->vmalloc[i].vmalloc_addr
> +						+ offset : NULL;
> +				}
>  				goto out;
>  			}
>  			offset -= chunk->mem[i].length;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
> index af28bbf..62d712a 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hem.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
> @@ -72,11 +72,17 @@ enum {
>  	 HNS_ROCE_HEM_PAGE_SIZE  = 1 << HNS_ROCE_HEM_PAGE_SHIFT,
>  };
>
> +struct hns_roce_vmalloc {
> +	bool	is_vmalloc_addr;
> +	void	*vmalloc_addr;
> +};
> +
>  struct hns_roce_hem_chunk {
>  	struct list_head	 list;
>  	int			 npages;
>  	int			 nsg;
>  	struct scatterlist	 mem[HNS_ROCE_HEM_CHUNK_LEN];
> +	struct hns_roce_vmalloc	 vmalloc[HNS_ROCE_HEM_CHUNK_LEN];
>  };
>
>  struct hns_roce_hem {
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index b99d70a..9e19bf1 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -1093,9 +1093,11 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
>  {
>  	struct hns_roce_v2_mpt_entry *mpt_entry;
>  	struct scatterlist *sg;
> +	u64 page_addr = 0;
>  	u64 *pages;
> +	int i = 0, j = 0;
> +	int len = 0;
>  	int entry;
> -	int i;
>
>  	mpt_entry = mb_buf;
>  	memset(mpt_entry, 0, sizeof(*mpt_entry));
> @@ -1153,14 +1155,20 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
>
>  	i = 0;
>  	for_each_sg(mr->umem->sg_head.sgl, sg, mr->umem->nmap, entry) {
> -		pages[i] = ((u64)sg_dma_address(sg)) >> 6;
> -
> -		/* Record the first 2 entry directly to MTPT table */
> -		if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
> -			break;
> -		i++;
> +		len = sg_dma_len(sg) >> PAGE_SHIFT;
> +		for (j = 0; j < len; ++j) {
> +			page_addr = sg_dma_address(sg) +
> +				    (j << mr->umem->page_shift);
> +			pages[i] = page_addr >> 6;
> +
> +			/* Record the first 2 entry directly to MTPT table */
> +			if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
> +				goto found;
> +			i++;
> +		}
>  	}
>
> +found:
>  	mpt_entry->pa0_l = cpu_to_le32(lower_32_bits(pages[0]));
>  	roce_set_field(mpt_entry->byte_56_pa0_h, V2_MPT_BYTE_56_PA0_H_M,
>  		       V2_MPT_BYTE_56_PA0_H_S,
> --
> 1.9.1
>

--wjoFZxbW4tu+iR6v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnPwe4ACgkQ5GN7iDZy
WKfRwA//ankFhVdIqJwOwNaq18znFA3fdkceRQCdFrJ3wJG69+lOvt0Z2QU3CRyY
J/ZD/U8dj/Hq1L7pJ2IAlfcfqqis0kgw5XTpCPw5P2yfU469QBm1KIbXPayMsOA8
veuDH9w7FhGdmpw4L+ikTFqe/CDXHM79qrJZ0NSSIj1AIAYZbx25yBGJICveeCO5
Av6q3Ruw1YQ1K8u+XtkbRsZAzpRC+v0u5gbP9xdVWoEdiwwohJeeHYzv2EJIc7y/
EsSiCgacVnwvzFm7Z3ZHPz8aWVIK4ypdGCajz5sZyexJXiLHWU1ks9zSdi/78Jer
EmfJZm+70Pt+FvBMVV95tZ8cK9uQlTOxxnKEMN8dRBP0Zu5isJRPzL3M0o4xar/D
SMX2C9evRMjqHMmEYd4pXK95LKwfQsk7UQFx/VzEWX21D42R9+qu8awiWbad0C8I
NTtys+Abb/FSEQ6+K2rucf+QwV6XY1YGJd6HuXkfIGxFDKBgyNqJ1FC2dgdfHM+E
/RALhkF70N1IcOc8w1dq3aV2A7hzHYxSTP8mHim1QPmfpCBPxHnWhPsemLAtec9q
dC1aZWNN78yaNeyUtwgECo7AxRBEE+ncnA8cmk0MeNwylnxmySmF6SDzlCNBexHm
JO6mZMq3XUnWCOXlVoYYfrJZ4tqrfduHdDEHITHxelBqlsru9PU=
=opeK
-----END PGP SIGNATURE-----

--wjoFZxbW4tu+iR6v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
