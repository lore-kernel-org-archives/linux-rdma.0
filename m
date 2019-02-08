From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Date: Fri, 8 Feb 2019 16:38:19 +0000
Message-ID: <20190208163813.GC25136@mellanox.com>
References: <20190207222647.GA30974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Content-Language: en-US
Content-ID: <EBDE82DA2EA0DC4DB64DC1DCB43403FB@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>, "Koenig, Christian" <Christian.Koenig@amd.com>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 03:26:47PM -0700, Jason Gunthorpe wrote:
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm=
/vmwgfx/vmwgfx_ttm_buffer.c
> index 31786b200afc47..e84f6aaee778f0 100644
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> @@ -311,7 +311,13 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_pi=
ter *viter)
> =20
>  static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
>  {
> -	return sg_page_iter_dma_address(&viter->iter);
> +	/*
> +	 * FIXME: This driver wrongly mixes DMA and CPU SG list iteration and
> +	 * needs revision. See
> +	 * https://lore.kernel.org/lkml/20190104223531.GA1705@ziepe.ca/
> +	 */
> +	return sg_page_iter_dma_address(
> +		(struct sg_dma_page_iter *)&viter->iter);

Occured to me this would be better written as:

	return sg_page_iter_dma_address(
		container_of(&viter->iter, struct sg_dma_page_iter, base));

Since I think we are done with this now I'll fix it when I apply this
patch

Thanks for all the acks everyone

Regards,
Jason
