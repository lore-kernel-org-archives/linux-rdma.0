From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get
 rid of page operation after dma_alloc_coherent)
Date: Mon, 24 Dec 2018 16:12:28 -0700
Message-ID: <20181224231228.GB17036@ziepe.ca>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
 <20181220174318.GA21404@ziepe.ca>
 <20181220174448.GA21149@lst.de>
 <1545328145.185366.500.camel@acm.org>
 <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
 <20181221033159.GF23877@ziepe.ca>
 <b906bec0fd12d25474561263087a26b8b0519fe4.camel@perches.com>
 <20181221235230.GC13168@ziepe.ca>
 <dc6d4923-63bd-e133-310b-7b164b0c92f5@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dc6d4923-63bd-e133-310b-7b164b0c92f5@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gal Pressman <galpress@amazon.com>
Cc: Joe Perches <joe@perches.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 23, 2018 at 06:42:20PM +0200, Gal Pressman wrote:
> On 22-Dec-18 01:52, Jason Gunthorpe wrote:
> > On Thu, Dec 20, 2018 at 09:12:43PM -0800, Joe Perches wrote:
> >> Care to submit a coding_style.rst patch or
> >> improve the one below this?
> > 
> > I took yours and revised it a little bit. I spent some time looking at
> > assembly and decided to drop the performance note, the number of cases
> > that run into overhead seems pretty small and probably already
> > requires !! to be correct. There is also an equally unlikely gain, ie
> > 'if (a & b)' optimizes a tiny bit better for bool types.
> > 
> > I also added a small intro on bool, as I know some people are
> > unfamiliar with C11 _Bool and might think bool is just '#define bool
> > u8'
> > 
> > (for those added to the cc) I'm looking at cases, like the patch that
> > spawned this, where the struct has a single bool and no performance
> > considerations. As CH said, seeing that get converted to int due to
> > checkpatch is worse than having used bool. Using u8 won't make this
> > struct smaller or faster.
> > 
> 
> Since a "Using bool" section is added, perhaps it's worth documenting the bool
> usage as a function parameter [1]?
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg72336.html

I'm not really sure how to express that as something concrete.. That
specific case clearly called out for a flags as it was a widely used
API - maybe less spread out cases like static functions or something
are OK??

Jason
