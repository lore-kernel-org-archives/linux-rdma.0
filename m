From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma] IB/cache: Restore compatibility for ib_query_gid
Date: Sun, 29 Jul 2018 13:42:30 -0600
Message-ID: <20180729194230.GB15106@ziepe.ca>
References: <20180727155402.GA15253@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180727155402.GA15253@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Parav Pandit <parav@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 27, 2018 at 09:54:02AM -0600, Jason Gunthorpe wrote:
> Code changes in smc have become so complicated this cycle that the RDMA
> patches to remove ib_query_gid in smc create too complex merge conflicts.
> Allow those conflicts to be resolved by using the net/smc hunks by
> providing a compatibility wrapper. During the second phase of the merge
> window this wrapper will be deleted and smc updated to use the new API.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>  include/rdma/ib_cache.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> The resolution Stephen had to make is too complicated, I think we
> should go this way instead. Parav can send a patch to DaveM during the
> 2nd half of the merge window to safely update SMC and delete this
> wrapper.
> 
> Parav, can you check this?
> 
> Ursula, this is only for SMC, are you able to test SMC with it? You
> will need to apply it to the RDMA tree here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=for-next
> 
> Thanks,
> Jason

I applied this to rdma for-next with Parav's notes.

Jason
