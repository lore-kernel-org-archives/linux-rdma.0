From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v4 rdma-next 2/3] RDMA/qedr: Add doorbell overflow
 recovery support
Date: Tue, 25 Jun 2019 20:04:08 +0000
Message-ID: <20190625200404.GA17378@mellanox.com>
References: <20190624102809.8793-1-michal.kalderon@marvell.com>
 <20190624102809.8793-3-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190624102809.8793-3-michal.kalderon@marvell.com>
Content-Language: en-US
Content-ID: <78478FDD0C3D784E8B2F45758E4C374E@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <michal.kalderon@marvell.com>
Cc: "ariel.elior@marvell.com" <ariel.elior@marvell.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 01:28:08PM +0300, Michal Kalderon wrote:

> +/* Map the kernel doorbell recovery memory entry */
> +int qedr_mmap_db_rec(struct vm_area_struct *vma)
> +{
> +	unsigned long len =3D vma->vm_end - vma->vm_start;
> +
> +	return remap_pfn_range(vma, vma->vm_start,
> +			       vma->vm_pgoff,
> +			       len, vma->vm_page_prot);
> +}
> +
>  int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
>  {
>  	struct qedr_ucontext *ucontext =3D get_qedr_ucontext(context);
> @@ -390,6 +446,8 @@ int qedr_mmap(struct ib_ucontext *context, struct vm_=
area_struct *vma)
>  	unsigned long phys_addr =3D vma->vm_pgoff << PAGE_SHIFT;
>  	unsigned long len =3D (vma->vm_end - vma->vm_start);
>  	unsigned long dpi_start;
> +	struct qedr_mm *mm;
> +	int rc;
> =20
>  	dpi_start =3D dev->db_phys_addr + (ucontext->dpi * ucontext->dpi_size);
> =20
> @@ -405,29 +463,28 @@ int qedr_mmap(struct ib_ucontext *context, struct v=
m_area_struct *vma)
>  		return -EINVAL;
>  	}
> =20
> -	if (!qedr_search_mmap(ucontext, phys_addr, len)) {
> -		DP_ERR(dev, "failed mmap, vm_pgoff=3D0x%lx is not authorized\n",
> +	mm =3D qedr_remove_mmap(ucontext, phys_addr, len);
> +	if (!mm) {
> +		DP_ERR(dev, "failed to remove mmap, vm_pgoff=3D0x%lx\n",
>  		       vma->vm_pgoff);
>  		return -EINVAL;
>  =09

This is so gross, please follow the pattern other drivers use for
managing the mmap cookie

In fact I am sick of seeing drivers wrongly re-implement this, so you
now get the job to make some proper core helpers to manage mmap
cookies for drivers.

The EFA driver is probably the best example, I suggest you move that
code to a common file in ib-core and use it here instead of redoing
yet again another broken version.

siw has another copy of basically the same thing.

> +static int qedr_init_user_db_rec(struct ib_udata *udata,
> +				 struct qedr_dev *dev, struct qedr_userq *q,
> +				 bool requires_db_rec)
> +{
> +	struct qedr_ucontext *uctx =3D
> +		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
> +					  ibucontext);
> +
> +	/* Aborting for non doorbell userqueue (SRQ) or non-supporting lib */
> +	if (requires_db_rec =3D=3D 0 || !uctx->db_rec)
> +		return 0;
> +
> +	/* Allocate a page for doorbell recovery, add to mmap ) */
> +	q->db_rec_data =3D (void *)get_zeroed_page(GFP_KERNEL);

Pages obtained by get_zeroed_page shuld not be inserted by
remap_pfn_range, those cases need to use vm_insert_page instead.

>  struct qedr_alloc_ucontext_resp {
>  	__aligned_u64 db_pa;
> @@ -74,6 +83,7 @@ struct qedr_create_cq_uresp {
>  	__u32 db_offset;
>  	__u16 icid;
>  	__u16 reserved;
> +	__u64 db_rec_addr;
>  };

All uapi u64s need to be __aligned_u64 in this file.

> +/* doorbell recovery entry allocated and populated by userspace doorbell=
ing
> + * entities and mapped to kernel. Kernel uses this to register doorbell
> + * information with doorbell drop recovery mechanism.
> + */
> +struct qedr_user_db_rec {
> +	__aligned_u64 db_data; /* doorbell data */
> +};

like this one :\

Jason
