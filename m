From: Tariq Toukan <tariqt@mellanox.com>
Subject: RE: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 13:40:48 +0000
Message-ID: <HE1PR05MB3257758C6128AF87CCAD12C2AEBD0@HE1PR05MB3257.eurprd05.prod.outlook.com>
References: <20181214233254.5860-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181214233254.5860-1-swarren@wwwdotorg.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>, "Wei@wwwdotorg.org" <Wei@wwwdotorg.org>, "Hu@wwwdotorg.org" <Hu@wwwdotorg.org>, "\\ (Xavier\\)" <xavier.huwei@huawei.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

Hi Stephen,

Thanks for your patch.

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Stephen Warren
> Sent: Saturday, December 15, 2018 1:33 AM
> To: Tariq Toukan <tariqt@mellanox.com>; Wei@wwwdotorg.org;
> Hu@wwwdotorg.org; \ (Xavier\) <xavier.huwei@huawei.com>
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Doug Ledford
> <dledford@redhat.com>; Jason Gunthorpe <jgg@mellanox.com>; Stephen
> Warren <swarren@nvidia.com>
> Subject: [RFC PATCH] net/mlx4: Get rid of page operation after
> dma_alloc_coherent
>=20
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This is a port of commit 378efe798ecf ("RDMA/hns: Get rid of page operati=
on
> after dma_alloc_coherent") to the mlx4 driver. That change was described
> as:
>=20
> > In general, dma_alloc_coherent() returns a CPU virtual address and a
> > DMA address, and we have no guarantee that the underlying memory
> even
> > has an associated struct page at all.
> >
> > This patch gets rid of the page operation after dma_alloc_coherent,
> > and records the VA returned form dma_alloc_coherent in the struct of
> > hem in hns RoCE driver.
>=20

I need to review this patch first.

> Differences in this port relative to the hns patch:
>=20
> 1) The hns patch only needed to fix a dma_alloc_coherent path, but this
> patch also needs to fix an alloc_pages path. This appears to be simple ex=
cept
> for the next point.
>=20
> 2) The hns patch converted a bunch of code to consistently use
> sg_dma_len(mem) rather than a mix of that and mem->length However, it
> seems that sg_dma_len(mem) can be modified or zeroed at runtime, and so
> using it when calling e.g. __free_pages is problematic. I suspect the sam=
e
> issue affects mlx4_table_find() somehow too, and similarly I expect the h=
ns
> driver has an issue in this area. Instead, this patch converts everything=
 to use
> mem->length instead. I'd like some feedback on this issue.
>=20

OK. I will carefully go over this point.

Thanks.

> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Note: I've tested this patch in downstream 4.9 and 4.14 based kernels, bu=
t
> can't test it in mainline (at least ibping works) since my system isn't
> supported their yet. I have compile-tested it in mainline at least, for A=
RM64.
>=20
>  drivers/net/ethernet/mellanox/mlx4/icm.c | 51 ++++++++++++++----------
> drivers/net/ethernet/mellanox/mlx4/icm.h |  1 +
>  2 files changed, 30 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c
> b/drivers/net/ethernet/mellanox/mlx4/icm.c
> index 4b4351141b94..b14207cef69e 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/icm.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
> @@ -72,7 +72,7 @@ static void mlx4_free_icm_coherent(struct mlx4_dev
> *dev, struct mlx4_icm_chunk *
>  	for (i =3D 0; i < chunk->npages; ++i)
>  		dma_free_coherent(&dev->persist->pdev->dev,
>  				  chunk->mem[i].length,
> -				  lowmem_page_address(sg_page(&chunk-
> >mem[i])),
> +				  chunk->buf[i],
>  				  sg_dma_address(&chunk->mem[i]));
>  }
>=20
> @@ -95,9 +95,11 @@ void mlx4_free_icm(struct mlx4_dev *dev, struct
> mlx4_icm *icm, int coherent)
>  	kfree(icm);
>  }
>=20
> -static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
> +static int mlx4_alloc_icm_pages(struct mlx4_icm_chunk *chunk, int
> +order,
>  				gfp_t gfp_mask, int node)
>  {
> +	struct scatterlist *mem =3D &chunk->mem[chunk->npages];
> +	void **buf =3D &chunk->buf[chunk->npages];
>  	struct page *page;
>=20
>  	page =3D alloc_pages_node(node, gfp_mask, order); @@ -108,25
> +110,30 @@ static int mlx4_alloc_icm_pages(struct scatterlist *mem, int
> order,
>  	}
>=20
>  	sg_set_page(mem, page, PAGE_SIZE << order, 0);
> +	*buf =3D lowmem_page_address(page);
>  	return 0;
>  }
>=20
> -static int mlx4_alloc_icm_coherent(struct device *dev, struct scatterlis=
t
> *mem,
> -				    int order, gfp_t gfp_mask)
> +static int mlx4_alloc_icm_coherent(struct device *dev,
> +				   struct mlx4_icm_chunk *chunk, int order,
> +				   gfp_t gfp_mask)
>  {
> -	void *buf =3D dma_alloc_coherent(dev, PAGE_SIZE << order,
> -				       &sg_dma_address(mem), gfp_mask);
> -	if (!buf)
> +	struct scatterlist *mem =3D &chunk->mem[chunk->npages];
> +	void **buf =3D &chunk->buf[chunk->npages];
> +
> +	*buf =3D dma_alloc_coherent(dev, PAGE_SIZE << order,
> +				  &sg_dma_address(mem), gfp_mask);
> +	if (!*buf)
>  		return -ENOMEM;
>=20
> -	if (offset_in_page(buf)) {
> +	if (offset_in_page(*buf)) {
>  		dma_free_coherent(dev, PAGE_SIZE << order,
> -				  buf, sg_dma_address(mem));
> +				  *buf, sg_dma_address(mem));
>  		return -ENOMEM;
>  	}
>=20
> -	sg_set_buf(mem, buf, PAGE_SIZE << order);
>  	sg_dma_len(mem) =3D PAGE_SIZE << order;
> +	mem->length =3D PAGE_SIZE << order;
>  	return 0;
>  }
>=20
> @@ -174,6 +181,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev
> *dev, int npages,
>  			sg_init_table(chunk->mem,
> MLX4_ICM_CHUNK_LEN);
>  			chunk->npages =3D 0;
>  			chunk->nsg    =3D 0;
> +			memset(chunk->buf, 0, sizeof(chunk->buf));
>  			list_add_tail(&chunk->list, &icm->chunk_list);
>  		}
>=20
> @@ -186,11 +194,9 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev
> *dev, int npages,
>=20
>  		if (coherent)
>  			ret =3D mlx4_alloc_icm_coherent(&dev->persist-
> >pdev->dev,
> -						      &chunk->mem[chunk-
> >npages],
> -						      cur_order, mask);
> +						      chunk, cur_order, mask);
>  		else
> -			ret =3D mlx4_alloc_icm_pages(&chunk->mem[chunk-
> >npages],
> -						   cur_order, mask,
> +			ret =3D mlx4_alloc_icm_pages(chunk, cur_order, mask,
>  						   dev->numa_node);
>=20
>  		if (ret) {
> @@ -316,11 +322,11 @@ void mlx4_table_put(struct mlx4_dev *dev, struct
> mlx4_icm_table *table, u32 obj)  void *mlx4_table_find(struct
> mlx4_icm_table *table, u32 obj,
>  			dma_addr_t *dma_handle)
>  {
> -	int offset, dma_offset, i;
> +	int offset, dma_offset, i, length;
>  	u64 idx;
>  	struct mlx4_icm_chunk *chunk;
>  	struct mlx4_icm *icm;
> -	struct page *page =3D NULL;
> +	void *addr =3D NULL;
>=20
>  	if (!table->lowmem)
>  		return NULL;
> @@ -336,28 +342,29 @@ void *mlx4_table_find(struct mlx4_icm_table
> *table, u32 obj,
>=20
>  	list_for_each_entry(chunk, &icm->chunk_list, list) {
>  		for (i =3D 0; i < chunk->npages; ++i) {
> +			length =3D chunk->mem[i].length;
>  			if (dma_handle && dma_offset >=3D 0) {
> -				if (sg_dma_len(&chunk->mem[i]) >
> dma_offset)
> +				if (length > dma_offset)
>  					*dma_handle =3D
> sg_dma_address(&chunk->mem[i]) +
>  						dma_offset;
> -				dma_offset -=3D sg_dma_len(&chunk-
> >mem[i]);
> +				dma_offset -=3D length;
>  			}
>  			/*
>  			 * DMA mapping can merge pages but not split them,
>  			 * so if we found the page, dma_handle has already
>  			 * been assigned to.
>  			 */
> -			if (chunk->mem[i].length > offset) {
> -				page =3D sg_page(&chunk->mem[i]);
> +			if (length > offset) {
> +				addr =3D chunk->buf[i] + offset;
>  				goto out;
>  			}
> -			offset -=3D chunk->mem[i].length;
> +			offset -=3D length;
>  		}
>  	}
>=20
>  out:
>  	mutex_unlock(&table->mutex);
> -	return page ? lowmem_page_address(page) + offset : NULL;
> +	return addr;
>  }
>=20
>  int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table
> *table, diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h
> b/drivers/net/ethernet/mellanox/mlx4/icm.h
> index c9169a490557..a565188dc391 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/icm.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
> @@ -52,6 +52,7 @@ struct mlx4_icm_chunk {
>  	int			npages;
>  	int			nsg;
>  	struct scatterlist	mem[MLX4_ICM_CHUNK_LEN];
> +	void			*buf[MLX4_ICM_CHUNK_LEN];
>  };
>=20
>  struct mlx4_icm {
> --
> 2.19.2
