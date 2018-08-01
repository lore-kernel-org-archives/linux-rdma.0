From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Date: Wed, 1 Aug 2018 11:13:46 -0600
Message-ID: <20180801171346.GC10824@ziepe.ca>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
 <20180727024832.GA30023@mellanox.com>
 <20180727132847.2be8563b@canb.auug.org.au>
 <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180727150903.0f2816ba@canb.auug.org.au>
 <VI1PR0502MB3008076016496152D4898D8ED12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180801153345.22692adb@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801153345.22692adb@canb.auug.org.au>
Sender: netdev-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Parav Pandit <parav@mellanox.com>, David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 01, 2018 at 03:33:45PM +1000, Stephen Rothwell wrote:
> Hi Parav,
> 
> On Tue, 31 Jul 2018 21:12:00 +0000 Parav Pandit <parav@mellanox.com> wrote:
> >
> > You might want to consider this compatibility patch in Linux-rdma
> > tree to avoid a merge conflict of smc.
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=7aaa1807e698f73094b78f0ef25b1a37a4409a55
> 
> Ok, since commit that is now in the rdma tree, my resolution of the
> original conflicts comes down to dropping all the changes to
> net/smc/smc_core.c net/smc/smc_ib.c that come from the rdma tree and
> adding
> 
> #include <rdma/ib_cache.h>
> 
> to net/smc/smc_ib.c.

Oh, that means I put the compat inline in the wrong header? Sigh.

Jason
