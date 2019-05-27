From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC: Run a dedicated hmm.git for 5.3
Date: Mon, 27 May 2019 16:12:47 -0300
Message-ID: <20190527191247.GA12540@ziepe.ca>
References: <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
 <20190524064051.GA28855@infradead.org>
 <20190524124455.GB16845@ziepe.ca>
 <20190525155210.8a9a66385ac8169d0e144225@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190525155210.8a9a66385ac8169d0e144225@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-mm@kvack.org, dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 25, 2019 at 03:52:10PM -0700, Andrew Morton wrote:
> On Fri, 24 May 2019 09:44:55 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > Now that -mm merged the basic hmm API skeleton I think running like
> > this would get us quickly to the place we all want: comprehensive in tree
> > users of hmm.
> > 
> > Andrew, would this be acceptable to you?
> 
> Sure.  Please take care not to permit this to reduce the amount of
> exposure and review which the core HMM pieces get.

Certainly, thanks all

Jerome: I started a HMM branch on v5.2-rc2 in the rdma.git here:

git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=hmm

Please send a series with the initial cross tree stuff:
 - kconfig fixing patches
 - The full removal of all the 'temporary for merging' APIs
 - Fixing the API of hmm_range_register to accept a mirror

When these are ready I'll send a hmm PR to DRM so everyone is on the
same API page.

I'll also move the hugetlb patch that Andrew picked up into this git
so we don't have a merge conflict risk

In parallel let us also finish revising the mirror API and going
through the ODP stuff.

Regards,
Jason
