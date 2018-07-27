From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Date: Thu, 26 Jul 2018 20:48:32 -0600
Message-ID: <20180727024832.GA30023@mellanox.com>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180727123301.3ac97ddc@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Parav Pandit <parav@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 27, 2018 at 12:33:01PM +1000, Stephen Rothwell wrote:

> I fixed it up (I wasn't sure how to fix this up as so much has changed
> in the net-next tree and both modified functions had been (re)moved,
> so I effectively reverted the rdma tree commit) and can carry the fix
> as necessary.  Please come to some arrangement about this.

How does that still compile? We removed ib_query_gid() from the rdma
tree and replaced it with rdma_get_gid_attr()..

I think the merge resolution is going to be a bit nasty to absorb
that much changing..

Perhaps we should add a compatability ib_query_gid back to the RDMA
tree and then send DaveM a commit to fix SMC and remove it during the
next cycle? Linus can resolve smc_ib.c by using the net version

Does someone else have a better idea?

Thanks,
Jason
