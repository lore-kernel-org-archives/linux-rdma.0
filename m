From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error
 handling paths
Date: Mon, 4 Mar 2019 20:53:38 -0400
Message-ID: <20190305005338.GK8613@ziepe.ca>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
 <20190302202435.31889-1-jhubbard@nvidia.com>
 <20190302194402.GA24732@iweiny-DESK2.sc.intel.com>
 <2404c962-8f6d-1f6d-0055-eb82864ca7fc@mellanox.com>
 <20190303165550.GB27123@iweiny-DESK2.sc.intel.com>
 <bef8680b-acc5-9f13-f49e-8f36f1939387@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bef8680b-acc5-9f13-f49e-8f36f1939387@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>, "john.hubbard@gmail.com" <john.hubbard@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 04, 2019 at 03:11:05PM -0800, John Hubbard wrote:

> get_user_page(): increments page->_refcount by a large amount (1024)
> 
> put_user_page(): decrements page->_refcount by a large amount (1024)
> 
> ...and just stop doing the odd (to me) technique of incrementing once for
> each tail page. I cannot see any reason why that's actually required, as
> opposed to just "raise the page->_refcount enough to avoid losing the head
> page too soon".

I'd very much like to see this in the infiniband umem code - the extra
work and cost of touching every page in a huge page is very much
undesired.

Jason
