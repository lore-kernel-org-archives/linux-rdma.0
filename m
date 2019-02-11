From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 21:14:56 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79BCF04C@CRSMSX101.amr.corp.intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211204049.GB2771@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211204049.GB2771@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Feb 11, 2019 at 12:16:40PM -0800, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> >
> > NOTE: This series depends on my clean up patch to remove the write
> > parameter from gup_fast_permitted()[1]
> >
> > HFI1 uses get_user_pages_fast() due to it performance advantages.
> > Like RDMA,
> > HFI1 pages can be held for a significant time.  But
> > get_user_pages_fast() does not protect against mapping of FS DAX pages.
> 
> If HFI1 can use the _fast varient, can't all the general RDMA stuff use it too?
> 
> What is the guidance on when fast vs not fast should be use?

Right now it can't because it holds mmap_sem across the call.  Once Shiraz's patches are accepted removing the umem->hugetlb flag I think we can change  umem.c.

Also, it specifies FOLL_FORCE which can't currently be specified with gup fast.  One idea I had was to change get_user_pages_fast() to use gup_flags instead of a single write flag.  But that proved to be a very big cosmetic change across a lot of callers so I went this way.

Ira

> 
> Jason
