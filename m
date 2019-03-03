From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error
 handling paths
Date: Sun, 3 Mar 2019 08:55:51 -0800
Message-ID: <20190303165550.GB27123@iweiny-DESK2.sc.intel.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Artemy Kovalyov <artemyko@mellanox.com>
Cc: "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 03, 2019 at 11:52:41AM +0200, Artemy Kovalyov wrote:
> 
> 
> On 02/03/2019 21:44, Ira Weiny wrote:
> > 
> > On Sat, Mar 02, 2019 at 12:24:35PM -0800, john.hubbard@gmail.com wrote:
> > > From: John Hubbard <jhubbard@nvidia.com>
> > > 
> > > ...
> > > 3. Dead code removal: the check for (user_virt & ~page_mask)
> > > is checking for a condition that can never happen,
> > > because earlier:
> > > 
> > >      user_virt = user_virt & page_mask;
> > > 
> > > ...so, remove that entire phrase.
> > > 
> > >   		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
> > >   		mutex_lock(&umem_odp->umem_mutex);
> > >   		for (j = 0; j < npages; j++, user_virt += PAGE_SIZE) {
> > > -			if (user_virt & ~page_mask) {
> > > -				p += PAGE_SIZE;
> > > -				if (page_to_phys(local_page_list[j]) != p) {
> > > -					ret = -EFAULT;
> > > -					break;
> > > -				}
> > > -				put_page(local_page_list[j]);
> > > -				continue;
> > > -			}
> > > -
> > 
> > I think this is trying to account for compound pages. (ie page_mask could
> > represent more than PAGE_SIZE which is what user_virt is being incrimented by.)
> > But putting the page in that case seems to be the wrong thing to do?
> > 
> > Yes this was added by Artemy[1] now cc'ed.
> 
> Right, this is for huge pages, please keep it.
> put_page() needed to decrement refcount of the head page.

You mean decrement the refcount of the _non_-head pages?

Ira

> 
