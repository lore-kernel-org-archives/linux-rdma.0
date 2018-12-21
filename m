From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get
 rid of page operation after dma_alloc_coherent)
Date: Thu, 20 Dec 2018 20:31:59 -0700
Message-ID: <20181221033159.GF23877@ziepe.ca>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
 <20181220174318.GA21404@ziepe.ca>
 <20181220174448.GA21149@lst.de>
 <1545328145.185366.500.camel@acm.org>
 <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 06:25:05PM -0800, Joe Perches wrote:

> I agree it's not a very good message nor is bool use
> of structure members a real problem except in very
> few cases.

I think the issue is that the link it shows lacks the context of the
discussion thread - and the actual guidance here is more
complicated.

A discussion in coding style would probably be better.

- Don't put multiple true/false fields in a single struct (be it bool,
  u8, int, etc) - use bit-fields instead.
- Don't use bool if cache line layout matters, its size and alignment
  varies
- Do use bool to clearly express that the variable, parameter or
  structure member can only take on a true/false value.

.. and I also seem to remember there is a small performance downside
to bool stores in some ABIs as the compiler has to cannonize stores to
0 or 1? But this also eliminates certain bug classes..

Jason
