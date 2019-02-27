From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [RFC v1 11/19] RDMA/irdma: Add PBLE resource manager
Date: Wed, 27 Feb 2019 08:58:04 +0200
Message-ID: <20190227065804.GD11231@mtr-leonro.mtl.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-12-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8G1nIWD3RY794FAy"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-12-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org


--8G1nIWD3RY794FAy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2019 at 11:10:58AM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Implement a Physical Buffer List Entry (PBLE) resource manager
> to manage a pool of PBLE HMC resource objects.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/pble.c | 520 +++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/pble.h | 135 ++++++++++
>  2 files changed, 655 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/pble.c
>  create mode 100644 drivers/infiniband/hw/irdma/pble.h
>
> diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
> new file mode 100644
> index 0000000..66fab69
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/pble.c
> @@ -0,0 +1,520 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2019, Intel Corporation. */
> +
> +#include "osdep.h"
> +#include "status.h"
> +#include "hmc.h"
> +#include "defs.h"
> +#include "type.h"
> +#include "protos.h"
> +#include "pble.h"
> +
> +static enum irdma_status_code add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc);
> +
> +/**
> + * irdma_destroy_pble_prm - destroy prm during module unload
> + * @pble_rsrc:	pble resources
> + */
> +void irdma_destroy_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
> +{
> +	struct irdma_sc_dev *dev = pble_rsrc->dev;
> +	struct irdma_chunk *chunk;
> +	struct irdma_pble_prm *pinfo = &pble_rsrc->pinfo;
> +
> +	while (!list_empty(&pinfo->clist)) {
> +		chunk = (struct irdma_chunk *)pinfo->clist.next;
> +		list_del(&chunk->list);
> +		if (chunk->type == PBLE_SD_PAGED)
> +			irdma_pble_free_paged_mem(chunk);
> +		if (chunk->bitmapbuf)
> +			irdma_free_virt_mem(dev->hw, &chunk->bitmapmem);
> +		irdma_free_virt_mem(dev->hw, &chunk->chunkmem);
> +	}
> +}
> +
> +/**
> + * irdma_hmc_init_pble - Initialize pble resources during module load
> + * @dev: irdma_sc_dev struct
> + * @pble_rsrc:	pble resources
> + */
> +enum irdma_status_code
> +irdma_hmc_init_pble(struct irdma_sc_dev *dev,
> +		    struct irdma_hmc_pble_rsrc *pble_rsrc)
> +{
> +	struct irdma_hmc_info *hmc_info;
> +	u32 fpm_idx = 0;
> +	enum irdma_status_code status = 0;
> +
> +	hmc_info = dev->hmc_info;
> +	pble_rsrc->dev = dev;
> +	pble_rsrc->fpm_base_addr = hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].base;
> +	/* Start pble' on 4k boundary */
> +	if (pble_rsrc->fpm_base_addr & 0xfff)
> +		fpm_idx = (PAGE_SIZE - (pble_rsrc->fpm_base_addr & 0xfff)) >> 3;
> +	pble_rsrc->unallocated_pble =
> +		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt - fpm_idx;
> +	pble_rsrc->next_fpm_addr = pble_rsrc->fpm_base_addr + (fpm_idx << 3);
> +	pble_rsrc->pinfo.pble_shift = PBLE_SHIFT;
> +
> +	spin_lock_init(&pble_rsrc->pinfo.prm_lock);
> +	INIT_LIST_HEAD(&pble_rsrc->pinfo.clist);
> +	if (add_pble_prm(pble_rsrc)) {
> +		irdma_destroy_pble_prm(pble_rsrc);
> +		status = IRDMA_ERR_NO_MEMORY;
> +	}
> +
> +	return status;
> +}
> +
> +/**
> + * get_sd_pd_idx -  Returns sd index, pd index and rel_pd_idx from fpm address
> + * @ pble_rsrc:	structure containing fpm address
> + * @ idx: where to return indexes
> + */
> +static void get_sd_pd_idx(struct irdma_hmc_pble_rsrc *pble_rsrc,
> +			  struct sd_pd_idx *idx)
> +{
> +	idx->sd_idx = (u32)(pble_rsrc->next_fpm_addr) /
> +		      IRDMA_HMC_DIRECT_BP_SIZE;
> +	idx->pd_idx = (u32)(pble_rsrc->next_fpm_addr) / IRDMA_HMC_PAGED_BP_SIZE;
> +	idx->rel_pd_idx = (idx->pd_idx % IRDMA_HMC_PD_CNT_IN_SD);

The amount of type-casting in this driver is astonishing. It will be
better to declare all types to be aligned from the beginning.


> +}
> +
> +/**
> + * add_sd_direct - add sd direct for pble
> + * @pble_rsrc: pble resource ptr
> + * @info: page info for sd
> + */
> +static enum irdma_status_code
> +add_sd_direct(struct irdma_hmc_pble_rsrc *pble_rsrc,
> +	      struct irdma_add_page_info *info)
> +{
> +	struct irdma_sc_dev *dev = pble_rsrc->dev;
> +	enum irdma_status_code ret_code = 0;
> +	struct sd_pd_idx *idx = &info->idx;
> +	struct irdma_chunk *chunk = info->chunk;
> +	struct irdma_hmc_info *hmc_info = info->hmc_info;
> +	struct irdma_hmc_sd_entry *sd_entry = info->sd_entry;
> +	u32 offset = 0;
> +
> +	if (!sd_entry->valid) {
> +		ret_code = irdma_add_sd_table_entry(dev->hw, hmc_info,
> +						    info->idx.sd_idx,
> +						    IRDMA_SD_TYPE_DIRECT,
> +						    IRDMA_HMC_DIRECT_BP_SIZE);
> +		if (ret_code)
> +			return ret_code;
> +
> +		chunk->type = PBLE_SD_CONTIGOUS;
> +	}
> +
> +	offset = idx->rel_pd_idx << HMC_PAGED_BP_SHIFT;
> +	chunk->size = info->pages << HMC_PAGED_BP_SHIFT;
> +	chunk->vaddr = (u64)((u8 *)sd_entry->u.bp.addr.va + offset);
> +	chunk->fpm_addr = pble_rsrc->next_fpm_addr;
> +	irdma_debug(dev, IRDMA_DEBUG_PBLE,
> +		    "chunk_size[%lld] = 0x%llx vaddr=0x%llx fpm_addr = %llx\n",
> +		    chunk->size, chunk->size, chunk->vaddr, chunk->fpm_addr);
> +
> +	return 0;
> +}
> +
> +/**
> + * fpm_to_idx - given fpm address, get pble index
> + * @pble_rsrc: pble resource management
> + * @addr: fpm address for index
> + */
> +static u32 fpm_to_idx(struct irdma_hmc_pble_rsrc *pble_rsrc, u64 addr)
> +{
> +	u64 idx;
> +
> +	idx = (addr - (pble_rsrc->fpm_base_addr)) >> 3;
> +
> +	return (u32)idx;

lower_32_bits()

Thanks

--8G1nIWD3RY794FAy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcdjT8AAoJEORje4g2clinvVMQAIGpFwR0ehD7O5HJNeRaowjG
m44GmDz89PvtiQqui0NBnAb8UT5EPsRdGpcZp2UbybTQZloy8u9wwaBt1Sp229xl
Jf0Hi4Kt7/aVfP/8OhapqbOj0OlXlhBEbvIdoa8zEWg1nXfK9S4IUI6EPpsYQb/8
WGmeaD+2tgaU6keATzttxAgRyvvGzm3zKcW+lCw3Bz35OiSk3JkLHY+KrRWNP5Y6
vTaqX57Cu1vIO7+MzCAKQeLpit08fNNNjAQ1svQ/Xwc6tveuIDv5mZDTPC6Qq/eW
FoGSVeWJXFiKdI4J2ETR5QNEZTgIDzApyZiAy/dDpGoLXbZ7tesLSeU0cubVNLd4
kcCFYZDYTNaIfsFXsV3Vzx+tFBJtLLZv/6HdhUMzeDtPN7Kt9XoLc05Fst/tLixP
0Ukgfpw93RayQJbP8bEw6hDLgxgiUe4YvOlqtrumUO/AjgUpNk6LY6NvMtX251Yh
np6MXDXVp3xYY5EMCovBW4ECZykpZRhNIhDOLKwmNuAAXy679in4ZWKxKcUmqlkl
V/16iN+dalds58XlKDuhhDCcAwoWVgJogMVqMBtnfGctEJwt3eGMGr5QXiEa6yka
xPdF8wyH8So7xymnJN9nbyEG0JWd2Zkxvpm7F5UVqLWD96HTvBSXcWR+5UrRfONb
7YWAjQwgwTfXBbwmLgn8
=c0wF
-----END PGP SIGNATURE-----

--8G1nIWD3RY794FAy--
