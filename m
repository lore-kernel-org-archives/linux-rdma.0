From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get
 rid of page operation after dma_alloc_coherent)
Date: Sun, 23 Dec 2018 16:53:12 +0000
Message-ID: <20181223165312.GE2217@ZenIV.linux.org.uk>
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
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dc6d4923-63bd-e133-310b-7b164b0c92f5@amazon.com>
Sender: netdev-owner@vger.kernel.org
To: Gal Pressman <galpress@amazon.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Joe Perches <joe@perches.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 23, 2018 at 06:42:20PM +0200, Gal Pressman wrote:
> > -17) Don't re-invent the kernel macros
> > +17) Using bool
> > +--------------
> > +
> > +The Linux kernel uses the C11 standard for the bool type. bool values can only

C99, surely?
