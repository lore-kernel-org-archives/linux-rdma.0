From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/4] IB/ipath: remove ib_sg_dma_address() and
 ib_sg_dma_len() overloads
Date: Fri, 28 Mar 2014 19:09:51 +0100
Message-ID: <1396030191.3297.81.camel@localhost.localdomain>
References: <20140328172606.23646.35980.stgit@phlsvslse11.ph.intel.com>
	 <20140328172647.23646.58499.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140328172647.23646.58499.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le vendredi 28 mars 2014 =C3=A0 13:26 -0400, Mike Marciniszyn a =C3=A9c=
rit :
> The lack of these methods is compensated for by code changes
> to .map_sg to insure that the vanilla sg_dma_address() and
> sg_dma_len() will do the same thing as the equivalent
> former ib_sg_dma_address() and ib_sg_dma_len() calls
> into the drivers.
>=20

And struct ipath_dma_mapping_ops was converted to C99 initializer.

> Suggested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/ipath/ipath_dma.c |   43 +++++++++++----------=
----------
>  1 file changed, 15 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infini=
band/hw/ipath/ipath_dma.c
> index 644c2c7..123a8c0 100644
> --- a/drivers/infiniband/hw/ipath/ipath_dma.c
> +++ b/drivers/infiniband/hw/ipath/ipath_dma.c
> @@ -115,6 +115,10 @@ static int ipath_map_sg(struct ib_device *dev, s=
truct scatterlist *sgl,
>  			ret =3D 0;
>  			break;
>  		}
> +		sg->dma_address =3D addr + sg->offset;
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +		sg->dma_length =3D sg->length;
> +#endif
>  	}
>  	return ret;
>  }
> @@ -126,21 +130,6 @@ static void ipath_unmap_sg(struct ib_device *dev=
,
>  	BUG_ON(!valid_dma_direction(direction));
>  }
> =20
> -static u64 ipath_sg_dma_address(struct ib_device *dev, struct scatte=
rlist *sg)
> -{
> -	u64 addr =3D (u64) page_address(sg_page(sg));
> -
> -	if (addr)
> -		addr +=3D sg->offset;
> -	return addr;
> -}
> -
> -static unsigned int ipath_sg_dma_len(struct ib_device *dev,
> -				     struct scatterlist *sg)
> -{
> -	return sg->length;
> -}
> -
>  static void ipath_sync_single_for_cpu(struct ib_device *dev,
>  				      u64 addr,
>  				      size_t size,
> @@ -176,17 +165,15 @@ static void ipath_dma_free_coherent(struct ib_d=
evice *dev, size_t size,
>  }
> =20
>  struct ib_dma_mapping_ops ipath_dma_mapping_ops =3D {
> -	ipath_mapping_error,
> -	ipath_dma_map_single,
> -	ipath_dma_unmap_single,
> -	ipath_dma_map_page,
> -	ipath_dma_unmap_page,
> -	ipath_map_sg,
> -	ipath_unmap_sg,
> -	ipath_sg_dma_address,
> -	ipath_sg_dma_len,
> -	ipath_sync_single_for_cpu,
> -	ipath_sync_single_for_device,
> -	ipath_dma_alloc_coherent,
> -	ipath_dma_free_coherent
> +	.mapping_error =3D ipath_mapping_error,
> +	.map_single =3D ipath_dma_map_single,
> +	.unmap_single =3D ipath_dma_unmap_single,
> +	.map_page =3D ipath_dma_map_page,
> +	.unmap_page =3D ipath_dma_unmap_page,
> +	.map_sg =3D ipath_map_sg,
> +	.unmap_sg =3D ipath_unmap_sg,
> +	.sync_single_for_cpu =3D ipath_sync_single_for_cpu,
> +	.sync_single_for_device =3D ipath_sync_single_for_device,
> +	.alloc_coherent =3D ipath_dma_alloc_coherent,
> +	.free_coherent =3D ipath_dma_free_coherent
>  };
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
