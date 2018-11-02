From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 16:15:52 -0600
Message-ID: <20181102221552.GC17096@ziepe.ca>
References: <20181102153316.1492515-1-arnd@arndb.de>
 <9f214f12ec89020ceb14c1aec25b3a0d968507aa.camel@mellanox.com>
 <2727f37b-1742-5532-317e-3be8a984266b@gmail.com>
 <4ebfc3aeb5335a1f671602f9a906f948c39a30da.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ebfc3aeb5335a1f671602f9a906f948c39a30da.camel@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>, "leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Eran Ben Elisha <eranbe@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>, Kamal Heib <kamalh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 02, 2018 at 10:07:02PM +0000, Saeed Mahameed wrote:
> On Fri, 2018-11-02 at 14:39 -0700, Eric Dumazet wrote:
> > 
> > On 11/02/2018 02:05 PM, Saeed Mahameed wrote:
> >  
> > > temp will be mem copied to priv->stats.sw at the end,
> > > memcpy(&priv->stats.sw, &s, sizeof(s)); 
> > > 
> > > one other way to solve this as suggested by Andrew, is to get rid
> > > of
> > > the temp var and make it point directly to priv->stats.sw 
> > > 
> > 
> > What about concurrency ?
> > 
> > This temp variable is there to make sure concurrent readers of stats
> > might
> > not see mangle data (because another 'reader' just did a memset() and
> > is doing the folding)
> > 
> > 
> > mlx5e_get_stats() can definitely be run at the same time by multiple
> > threads.
> > 
> 
> hmm, you are right, i was thinking that mlx5e_get_Stats will trigger a
> work to update stats and grab the state_lock, but for sw stats this is
> not the case it is done in place.

That was my guess when I saw this.. the confusing bit is why is there
s and temp, why not just s?

> BTW memcpy itself is not thread safe.

At least on 64 bit memcpy will do > 8 byte stores when copying so on
most architectures it will cause individual new or old u64 to be
returned and not a mess..

32 bit will always make a mess.

If the stats don't update that often then kmalloc'ing a new buffer and
RCU'ing it into view might be a reasonable alternative to this?

Jason
