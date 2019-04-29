From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Mon, 29 Apr 2019 08:40:37 +0000
Message-ID: <20190429084030.GA4275@mellanox.com>
References: <20190428115207.GA11924@ziepe.ca> <20190429060947.GB3665@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429060947.GB3665@osiris>
Content-Language: en-US
Content-ID: <D84A4BA2DBDFB64FAFEE2F21A1758E89@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Doug Ledford <dledford@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 08:09:47AM +0200, Heiko Carstens wrote:
> On Sun, Apr 28, 2019 at 11:52:12AM +0000, Jason Gunthorpe wrote:
> > Hi Linus,
> >=20
> > Third rc pull request
> >=20
> > Nothing particularly special here. There is a small merge conflict
> > with Adrea's mm_still_valid patches which is resolved as below:
> ...
> > Jason Gunthorpe (3):
> >       RDMA/mlx5: Do not allow the user to write to the clock page
> >       RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
> >       RDMA/ucontext: Fix regression with disassociate
>=20
> This doesn't compile. The patch below would fix it, but not sure if
> this is what is intended:
>=20
> drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
> drivers/infiniband/core/uverbs_main.c:898:28: error: 'struct vm_fault' ha=
s no member named 'vm_start'
>    vmf->page =3D ZERO_PAGE(vmf->vm_start);
>                             ^~
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/c=
ore/uverbs_main.c
> index 7843e89235c3..65fe89b3fa2d 100644
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -895,7 +895,7 @@ static vm_fault_t rdma_umap_fault(struct vm_fault *vm=
f)
> =20
>  	/* Read only pages can just use the system zero page. */
>  	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> -		vmf->page =3D ZERO_PAGE(vmf->vm_start);
> +		vmf->page =3D ZERO_PAGE(vmf->vma->vm_start);
>  		get_page(vmf->page);
>  		return 0;
>  	}
>=20

Thanks Heiko, this looks right to me.=20

I'm surprised to be seeing this at this point, these patches should
have been seen by 0 day for several days now, and they were in
linux-next already too..

Doug, can you send this to Linus today?

Thanks,
Jason
