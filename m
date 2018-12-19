From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V2] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 17:12:41 -0700
Message-ID: <5196b89a-0de5-a53e-95c6-6381b4ed0982@wwwdotorg.org>
References: <20181218190622.13046-1-swarren@wwwdotorg.org>
 <20181218205649.GA17958@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181218205649.GA17958@lst.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 12/18/18 1:56 PM, Christoph Hellwig wrote:
> This goes in the right direction, but I think we need to stop
> abusing the scatterlist for the coherent mapping entirely.  Something
> like the patch below (based on yours):

Oh, it was simple to get rid of the sg list usage than I thought; I'd 
assume it would be touched in a bunch of other files.

I had to make the additions shown below to get the adapter to get the 
driver to probe without errors, but with these changes, ibping, 
ib_read_bw, and ib_write_bw all work both directions:

(Sorry, this is pasted so the formatting may be broken)

> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
> index ee4fde7e465d..d305c9f575e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/icm.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
> @@ -167,6 +167,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
>  				if (!chunk)
>  					goto fail;
>  			}
> +			chunk->coherent = coherent;
>  
>  			if (!coherent)
>  				sg_init_table(chunk->sg, MLX4_ICM_CHUNK_LEN);
> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
> index 5ccf08ac47a3..574f4bcdd090 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/icm.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
> @@ -57,6 +57,7 @@ struct mlx4_icm_chunk {
>  	struct list_head	list;
>  	int			npages;
>  	int			nsg;
> +	int			coherent;
>  	union {
>  		struct scatterlist	sg[MLX4_ICM_CHUNK_LEN];
>  		struct mlx4_icm_buf	buf[MLX4_ICM_CHUNK_LEN];
> @@ -121,16 +122,20 @@ static inline void mlx4_icm_next(struct mlx4_icm_iter *iter)
>  	}
>  }
>  
> -/* Note: won't work on coherent tables */
>  static inline dma_addr_t mlx4_icm_addr(struct mlx4_icm_iter *iter)
>  {
> -	return sg_dma_address(&iter->chunk->sg[iter->page_idx]);
> +	if (iter->chunk->coherent)
> +		return iter->chunk->buf[iter->page_idx].dma_addr;
> +	else
> +		return sg_dma_address(&iter->chunk->sg[iter->page_idx]);
>  }
>  
> -/* Note: won't work on coherent tables */
>  static inline unsigned long mlx4_icm_size(struct mlx4_icm_iter *iter)
>  {
> -	return sg_dma_len(&iter->chunk->sg[iter->page_idx]);
> +	if (iter->chunk->coherent)
> +		return iter->chunk->buf[iter->page_idx].size;
> +	else
> +		return sg_dma_len(&iter->chunk->sg[iter->page_idx]);
>  }
>  
>  int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
