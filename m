From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 13:40:49 -0700
Message-ID: <20190211204049.GB2771@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211201643.7599-1-ira.weiny@intel.com>
Sender: netdev-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 12:16:40PM -0800, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> NOTE: This series depends on my clean up patch to remove the write parameter
> from gup_fast_permitted()[1]
> 
> HFI1 uses get_user_pages_fast() due to it performance advantages.  Like RDMA,
> HFI1 pages can be held for a significant time.  But get_user_pages_fast() does
> not protect against mapping of FS DAX pages.

If HFI1 can use the _fast varient, can't all the general RDMA stuff
use it too? 

What is the guidance on when fast vs not fast should be use?

Jason
