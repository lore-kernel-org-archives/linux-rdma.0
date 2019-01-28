From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] mm: make mm->pinned_vm an atomic64 counter
Date: Mon, 28 Jan 2019 13:10:56 -0800
Message-ID: <20190128131056.101a126f222929318bb2ea83@linux-foundation.org>
References: <20190121174220.10583-1-dave@stgolabs.net>
        <20190121174220.10583-2-dave@stgolabs.net>
        <20190123183353.GA15768@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190123183353.GA15768@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Davidlohr Bueso <dave@stgolabs.net>, dledford@redhat.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, Christoph Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Daniel Jordan <daniel.m.jordan@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, 23 Jan 2019 11:33:53 -0700 Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Jan 21, 2019 at 09:42:15AM -0800, Davidlohr Bueso wrote:
> > Taking a sleeping lock to _only_ increment a variable is quite the
> > overkill, and pretty much all users do this. Furthermore, some drivers
> > (ie: infiniband and scif) that need pinned semantics can go to quite
> > some trouble to actually delay via workqueue (un)accounting for pinned
> > pages when not possible to acquire it.
> > 
> > By making the counter atomic we no longer need to hold the mmap_sem
> > and can simply some code around it for pinned_vm users. The counter
> > is 64-bit such that we need not worry about overflows such as rdma
> > user input controlled from userspace.
> 
> I see a number of MM people Reviewed-by this so are we good to take
> this in the RDMA tree now?

Please do.
