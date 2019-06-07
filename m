From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Date: Fri, 7 Jun 2019 15:57:49 -0300
Message-ID: <20190607185749.GQ14802@ziepe.ca>
References: <20190605232348.6452-1-saeedm@mellanox.com>
 <20190606071427.GU5261@mtr-leonro.mtl.com>
 <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
 <20190606130713.GC17392@mellanox.com>
 <9faeadac971aaf481b1066b1dde0fc9e77e893a5.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9faeadac971aaf481b1066b1dde0fc9e77e893a5.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "andy@greyhouse.net" <andy@greyhouse.net>, Tal Gilboa <talgi@mellanox.com>, "michael.chan@broadcom.com" <michael.chan@broadcom.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 07, 2019 at 06:14:11PM +0000, Saeed Mahameed wrote:
> On Thu, 2019-06-06 at 13:07 +0000, Jason Gunthorpe wrote:
> > On Thu, Jun 06, 2019 at 10:19:41AM +0300, Max Gurtovoy wrote:
> > > > > Solution:
> > > > > - Common logic is declared in include/linux/dim.h and
> > > > > implemented in
> > > > >    lib/dim/dim.c
> > > > > - Net DIM (existing) logic is declared in
> > > > > include/linux/net_dim.h and
> > > > >    implemented in lib/dim/net_dim.c, which uses the common
> > > > > logic from dim.h
> > > > > - Any new DIM logic will be declared in
> > > > > "/include/linux/new_dim.h" and
> > > > >     implemented in "lib/dim/new_dim.c".
> > > > > - This new implementation will expose modified versions of
> > > > > profiles,
> > > > >    dim_step() and dim_decision().
> > > > > 
> > > > > Pros for this solution are:
> > > > > - Zero impact on existing net_dim implementation and usage
> > > > > - Relatively more code reuse (compared to two separate
> > > > > solutions)
> > > > > - Increased extensibility
> > > > > 
> > > > > Tal Gilboa (6):
> > > > >        linux/dim: Move logic to dim.h
> > > > >        linux/dim: Remove "net" prefix from internal DIM members
> > > > >        linux/dim: Rename externally exposed macros
> > > > >        linux/dim: Rename net_dim_sample() to
> > > > > net_dim_update_sample()
> > > > >        linux/dim: Rename externally used net_dim members
> > > > >        linux/dim: Move implementation to .c files
> > > > > 
> > > > > Yamin Friedman (3):
> > > > >        linux/dim: Add completions count to dim_sample
> > > > >        linux/dim: Implement rdma_dim
> > > > >        RDMA/core: Provide RDMA DIM support for ULPs
> > > > Saeed,
> > > > 
> > > > No, for the RDMA patches.
> > > > We need to see usage of those APIs before merging.
> > > 
> > > I've asked Yamin to prepare patches for NVMeoF initiator and target
> > > for
> > > review, so I guess he has it on his plate (this is how he tested
> > > it..).
> > > 
> > > It might cause conflict with NVMe/blk branch maintained by Sagi,
> > > Christoph
> > > and Jens.
> > 
> > It looks like nvme could pull this series + the RDMA patches into the
> > nvme tree via PR? I'm not familiar with how that tree works.
> > 
> > But we need to get the patches posted right away..
> > 
> 
> What do you suggest here ?
> I think the netdev community also deserve to see the rdma patches, at
> least with an external link, I can drop the last patch (or two ) ? but
> i need an external rdma link for people who are going to review this
> series.

Yes, all the patches need to be posted. We should have a 'double
branch' where you send the linux/dim & net stuff to net and then we
add the RDMA stuff on top and send to nvme & rdma with the ULP
patches

Assuming nvme takes pull requests.

But the whole thing should be posted as a single series on the list to
get acks before the PRs are generated.

Similar to how we've run the mlx5 shared branch

Jason
