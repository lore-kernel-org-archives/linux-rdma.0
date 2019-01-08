From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3] coding-style: Clarify the expectations around bool
Date: Mon, 7 Jan 2019 20:21:35 -0700
Message-ID: <20190108032135.GD5336@ziepe.ca>
References: <20190107211117.GA24142@ziepe.ca>
 <8ec3603317f477fe9923b87499a33da7a2cf81ff.camel@perches.com>
 <20190107232513.GA5336@ziepe.ca>
 <9bc80bb861899633ba93e6c81d36d2201b05936b.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9bc80bb861899633ba93e6c81d36d2201b05936b.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 07, 2019 at 04:38:50PM -0800, Joe Perches wrote:
> On Mon, 2019-01-07 at 16:25 -0700, Jason Gunthorpe wrote:
> > On Mon, Jan 07, 2019 at 02:10:22PM -0800, Joe Perches wrote:
> > > On Mon, 2019-01-07 at 14:11 -0700, Jason Gunthorpe wrote:
> > > > There has been some confusion since checkpatch started warning about bool
> > > > use in structures, and people have been avoiding using it.
> > > > 
> > > > Many people feel there is still a legitimate place for bool in structures,
> > > > so provide some guidance on bool usage derived from the entire thread that
> > > > spawned the checkpatch warning.
> > > 
> > > Thanks Jason.
> > > 
> > > It'd be nice to combine this with some better checkpatch warning or
> > > even a removal of that misleading warning from checkpatch
> > > altogether.
> > 
> > Okay, do you have a preference?
> 
> Yes.

Great, done, thanks

Jason
