From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC: Run a dedicated hmm.git for 5.3
Date: Fri, 24 May 2019 13:53:01 -0300
Message-ID: <20190524165301.GD16845@ziepe.ca>
References: <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
 <20190524064051.GA28855@infradead.org>
 <20190524124455.GB16845@ziepe.ca>
 <20190524162709.GD21222@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190524162709.GD21222@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org, Dave Airlie <airlied@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-mm@kvack.org, dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 24, 2019 at 06:27:09PM +0200, Daniel Vetter wrote:
> Sure topic branch sounds fine, we do that all the time with various
> subsystems all over. We have ready made scripts for topic branches and
> applying pulls from all over, so we can even soak test everything in our
> integration tree. In case there's conflicts or just to make sure
> everything works, before we bake the topic branch into permanent history
> (the main drm.git repo just can't be rebased, too much going on and too
> many people involvd).

We don't rebase rdma.git either for the same reasons and nor does
netdev

So the usual flow for a shared topic branch is also no-rebase -
testing/etc needs to be done before things get applied to it.

Cheers,
Jason
