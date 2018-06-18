From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 2/2] IB/mad: Use IDR for agent IDs
Date: Mon, 18 Jun 2018 11:26:05 -0600
Message-ID: <20180618172605.GA32003@ziepe.ca>
References: <20180613123403.25233-1-willy@infradead.org>
 <20180613123403.25233-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613123403.25233-3-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: willy@infradead.org
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 05:34:03AM -0700, willy@infradead.org wrote:
> Allocate agent IDs from a global IDR instead of an atomic variable.
> This eliminates the possibility of reusing an ID which is already in
> use after 4 billion registrations.  We limit the assigned ID to be less
> than 2^24 as the mlx4 driver uses the most significant byte of the agent
> ID to store the slave number.  Users unlucky enough to see a collision
> between agent numbers and slave numbers see messages like:
> 
>  mlx4_ib: egress mad has non-null tid msb:1 class:4 slave:0
> 
> and the MAD layer stops working.
> 
> We look up the agent under protection of the RCU lock, which means we
> have to free the agent using kfree_rcu, and only increment the reference
> counter if it is not 0.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> Reported-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Acked-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> Tested-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> ---
>  drivers/infiniband/core/mad.c      | 83 ++++++++++++++++++------------
>  drivers/infiniband/core/mad_priv.h |  7 +--
>  2 files changed, 55 insertions(+), 35 deletions(-)

Applied to for-next, thanks everyone

Jason
