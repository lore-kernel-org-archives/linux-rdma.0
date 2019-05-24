From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: RFC: Run a dedicated hmm.git for 5.3
Date: Fri, 24 May 2019 09:44:55 -0300
Message-ID: <20190524124455.GB16845@ziepe.ca>
References: <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
 <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
 <20190524064051.GA28855@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190524064051.GA28855@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org, Dave Airlie <airlied@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-mm@kvack.org, dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 11:40:51PM -0700, Christoph Hellwig wrote:
> On Thu, May 23, 2019 at 04:10:38PM -0300, Jason Gunthorpe wrote:
> > 
> > On Thu, May 23, 2019 at 02:24:58PM -0400, Jerome Glisse wrote:
> > > I can not take mmap_sem in range_register, the READ_ONCE is fine and
> > > they are no race as we do take a reference on the hmm struct thus
> > 
> > Of course there are use after free races with a READ_ONCE scheme, I
> > shouldn't have to explain this.
> > 
> > If you cannot take the read mmap sem (why not?), then please use my
> > version and push the update to the driver through -mm..
> 
> I think it would really help if we queue up these changes in a git tree
> that can be pulled into the driver trees.  Given that you've been
> doing so much work to actually make it usable I'd nominate rdma for the
> "lead" tree.

Sure, I'm willing to do that. RDMA has experience successfully running
shared git trees with netdev. It can work very well, but requires
discipline and understanding of the limitations.

I really want to see the complete HMM solution from Jerome (ie the
kconfig fixes, arm64, api fixes, etc) in one cohesive view, not
forced to be sprinkled across multiple kernel releases to work around
a submission process/coordination problem.

Now that -mm merged the basic hmm API skeleton I think running like
this would get us quickly to the place we all want: comprehensive in tree
users of hmm.

Andrew, would this be acceptable to you?

Dave, would you be willing to merge a clean HMM tree into DRM if it is
required for DRM driver work in 5.3?

I'm fine to merge a tree like this for RDMA, we already do this
pattern with netdev.

Background: The issue that is motivating this is we want to make
changes to some of the API's for hmm, which mean changes in existing
DRM, changes in to-be-accepted RDMA code, and to-be-accepted DRM
driver code. Coordintating the mm/hmm.c, RDMA and DRM changes is best
done with the proven shared git tree pattern. As CH explains I would
run a clean/minimal hmm tree that can be merged into driver trees as
required, and I will commit to sending a PR to Linus for this tree
very early in the merge window so that driver PR's are 'clean'.

The tree will only contain uncontroversial hmm related commits, bug
fixes, etc.

Obviouisly I will also commit to providing review for patches flowing
through this tree.

Regards,
Jason
(rdma subsystem co-maintainer, FWIW)
