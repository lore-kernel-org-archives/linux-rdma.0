From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC] IB/mad: Use IDR instead of per-port list
Date: Thu, 7 Jun 2018 20:11:25 -0600
Message-ID: <20180608021125.GB19611@ziepe.ca>
References: <20180607190832.GA24370@bombadil.infradead.org>
 <20180607222646.GX14597@mellanox.com>
 <20180607234926.GA8260@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180607234926.GA8260@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 07, 2018 at 04:49:26PM -0700, Matthew Wilcox wrote:
> On Thu, Jun 07, 2018 at 04:26:46PM -0600, Jason Gunthorpe wrote:
> > On Thu, Jun 07, 2018 at 12:08:32PM -0700, Matthew Wilcox wrote:
> > > 
> > > Hans reports a bug where the mlx4 driver uses the MSB of the agent number
> > > to store slave number, meaning we can only use agent numbers up to 2^24.
> > > Fix this by using an IDR to assign the agent numbers and also look up the
> > > agent when a MSD packet is received.
> > > 
> > > I've changed the locking substantially, so this may well have a
> > > performance issue.  There are a few different possibilities for fixing
> > > that, including moving to an RCU-based lookup.
> > 
> > I do like this better than the last series..
> > 
> > This are is somewhat performance sensitive and it would be nice to
> > avoid this global lock.
> 
> OK, I wasn't sure whether it was worth it.
> 
> > What about using a read/write spinlock instead of the IDR internal
> > lock? Then all the per-port reading threads calling find_mad_agent can
> > run concurrently..
> 
> It'd be better to switch to RCU ... the IDR is RCU-safe, but the
> version/class/method or OUI match isn't.  Do you have any feeling on
> the relative frequency of the two types of "routing"?

I would say they are close to equally important, perhaps the
version/class/method is slightly more important.

> Actually, I think we can use the radix tree data structure for the
> version/class/method too ... that's going to take a little more work.

I was wondering about that as well, this code is very old so there
must be better data structure helpers these days.

Jason
