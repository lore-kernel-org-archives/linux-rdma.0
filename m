From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error
 handling paths
Date: Tue, 5 Mar 2019 21:32:13 -0400
Message-ID: <20190306013213.GA1662@ziepe.ca>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <332021c5-ab72-d54f-85c8-b2b12b76daed@nvidia.com>
 <903383a6-f2c9-4a69-83c0-9be9c052d4be@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <903383a6-f2c9-4a69-83c0-9be9c052d4be@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Artemy Kovalyov <artemyko@mellanox.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Ira Weiny <ira.weiny@intel.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 06, 2019 at 03:02:36AM +0200, Artemy Kovalyov wrote:
> 
> 
> On 04/03/2019 00:37, John Hubbard wrote:
> > On 3/3/19 1:52 AM, Artemy Kovalyov wrote:
> > > 
> > > 
> > > On 02/03/2019 21:44, Ira Weiny wrote:
> > > > 
> > > > On Sat, Mar 02, 2019 at 12:24:35PM -0800, john.hubbard@gmail.com wrote:
> > > > > From: John Hubbard <jhubbard@nvidia.com>
> > > > > 
> > > > > ...
> > 
> > OK, thanks for explaining! Artemy, while you're here, any thoughts about the
> > release_pages, and the change of the starting point, from the other part of the
> > patch:
> > 
> > @@ -684,9 +677,11 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp,
> > u64 user_virt,
> > 	mutex_unlock(&umem_odp->umem_mutex);
> > 
> >    		if (ret < 0) {
> > -			/* Release left over pages when handling errors. */
> > -			for (++j; j < npages; ++j)
> release_pages() is an optimized batch put_page() so it's ok.
> but! release starting from page next to one cause failure in
> ib_umem_odp_map_dma_single_page() is correct because failure flow of this
> functions already called put_page().
> So release_pages(&local_page_list[j+1], npages - j-1) would be correct.

Someone send a fixup patch please...

Jason
