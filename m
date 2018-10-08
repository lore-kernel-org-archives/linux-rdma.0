From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 3/3] infiniband/mm: convert put_page() to
 put_user_page*()
Date: Mon, 8 Oct 2018 14:56:02 -0600
Message-ID: <20181008205602.GD27639@ziepe.ca>
References: <20181006024949.20691-1-jhubbard@nvidia.com>
 <20181006024949.20691-4-jhubbard@nvidia.com>
 <20181008194240.GA27639@ziepe.ca>
 <15d3daac-ba59-b1c9-873d-1876b58bde9d@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15d3daac-ba59-b1c9-873d-1876b58bde9d@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 08, 2018 at 01:37:35PM -0700, John Hubbard wrote:
> On 10/8/18 12:42 PM, Jason Gunthorpe wrote:
> > On Fri, Oct 05, 2018 at 07:49:49PM -0700, john.hubbard@gmail.com wrote:
> >> From: John Hubbard <jhubbard@nvidia.com>
> [...]
> >>  drivers/infiniband/core/umem.c              |  7 ++++---
> >>  drivers/infiniband/core/umem_odp.c          |  2 +-
> >>  drivers/infiniband/hw/hfi1/user_pages.c     | 11 ++++-------
> >>  drivers/infiniband/hw/mthca/mthca_memfree.c |  6 +++---
> >>  drivers/infiniband/hw/qib/qib_user_pages.c  | 11 ++++-------
> >>  drivers/infiniband/hw/qib/qib_user_sdma.c   |  8 ++++----
> >>  drivers/infiniband/hw/usnic/usnic_uiom.c    |  7 ++++---
> >>  7 files changed, 24 insertions(+), 28 deletions(-)
> > 
> > I have no issues with this, do you want this series to go through the
> > rdma tree? Otherwise:
> > 
> > Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> > 
> 
> The RDMA tree seems like a good path for this, yes, glad you suggested
> that.
> 
> I'll post a v4 with the comment fix and the recent reviewed-by's, which
> should be ready for that.  It's based on today's linux.git tree at the 
> moment, but let me know if I should re-apply it to the RDMA tree.

I'm unclear who needs to ack the MM sections for us to take it to
RDMA?

Otherwise it is no problem..

Jason
