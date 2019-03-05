From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH v3] RDMA/umem: minor bug fix in error handling path
Date: Tue, 5 Mar 2019 17:04:06 +0200
Message-ID: <20190305150406.GA12098@lap1>
References: <20190304194645.10422-1-jhubbard@nvidia.com>
 <20190304194645.10422-2-jhubbard@nvidia.com>
 <20190304115814.GE30058@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190304115814.GE30058@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: john.hubbard@gmail.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 04, 2019 at 03:58:15AM -0800, Ira Weiny wrote:
> On Mon, Mar 04, 2019 at 11:46:45AM -0800, john.hubbard@gmail.com wrote:
> > From: John Hubbard <jhubbard@nvidia.com>
> >=20
> > 1. Bug fix: fix an off by one error in the code that
> > cleans up if it fails to dma-map a page, after having
> > done a get_user_pages_remote() on a range of pages.
> >=20
> > 2. Refinement: for that same cleanup code, release_pages()
> > is better than put_page() in a loop.
> >=20
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>=20
> I meant...
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20
> <sigh>  just a bit too quick on the keyboard before lunch...  ;-)
>=20
> Ira

I have this mapping in vimrc so i just have to do shift+!

map ! o=0DReviewed-by: Yuval Shaia <yuval.shaia@oracle.com>=0D=1B

>=20
>=20
> > ---
> >  drivers/infiniband/core/umem_odp.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
> > index acb882f279cb..d45735b02e07 100644
> > --- a/drivers/infiniband/core/umem_odp.c
> > +++ b/drivers/infiniband/core/umem_odp.c
> > @@ -40,6 +40,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/hugetlb.h>
> >  #include <linux/interval_tree_generic.h>
> > +#include <linux/pagemap.h>
> > =20
> >  #include <rdma/ib_verbs.h>
> >  #include <rdma/ib_umem.h>
> > @@ -684,9 +685,11 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *=
umem_odp, u64 user_virt,
> >  		mutex_unlock(&umem_odp->umem_mutex);
> > =20
> >  		if (ret < 0) {
> > -			/* Release left over pages when handling errors. */
> > -			for (++j; j < npages; ++j)
> > -				put_page(local_page_list[j]);
> > +			/*
> > +			 * Release pages, starting at the the first page
> > +			 * that experienced an error.
> > +			 */
> > +			release_pages(&local_page_list[j], npages - j);
> >  			break;
> >  		}
> >  	}
> > --=20
> > 2.21.0
> >=20
