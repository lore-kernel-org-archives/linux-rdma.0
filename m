From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 4/8] IB/mlx5: Add steering SW ICM device memory
 type
Date: Wed, 24 Apr 2019 12:53:13 -0300
Message-ID: <20190424155313.GI16061@ziepe.ca>
References: <20190331164450.23618-1-leon@kernel.org>
 <20190331164450.23618-5-leon@kernel.org>
 <20190424130440.GA5196@ziepe.ca>
 <20190424131222.GG27901@mtr-leonro.mtl.com>
 <20190424131405.GE16061@ziepe.ca>
 <20190424132516.GH27901@mtr-leonro.mtl.com>
 <20190424133553.GF16061@ziepe.ca>
 <20190424134604.GI27901@mtr-leonro.mtl.com>
 <20190424134703.GG16061@ziepe.ca>
 <20190424154937.GJ27901@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190424154937.GJ27901@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 24, 2019 at 06:49:37PM +0300, Leon Romanovsky wrote:
> On Wed, Apr 24, 2019 at 10:47:03AM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 24, 2019 at 04:46:04PM +0300, Leon Romanovsky wrote:
> > > On Wed, Apr 24, 2019 at 10:35:53AM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Apr 24, 2019 at 04:25:16PM +0300, Leon Romanovsky wrote:
> > > > > On Wed, Apr 24, 2019 at 10:14:05AM -0300, Jason Gunthorpe wrote:
> > > > > > On Wed, Apr 24, 2019 at 04:12:22PM +0300, Leon Romanovsky wrote:
> > > > > > > On Wed, Apr 24, 2019 at 10:04:40AM -0300, Jason Gunthorpe wrote:
> > > > > > > > On Sun, Mar 31, 2019 at 07:44:46PM +0300, Leon Romanovsky wrote:
> > > > > > > > > From: Ariel Levkovich <lariel@mellanox.com>
> > > > > > > > >
> > > > > > > > > This patch adds support for allocating, deallocating and registering
> > > > > > > > > a new device memory type, STEERING_SW_ICM.
> > > > > > > > > This memory can be allocated and used by a privileged user for direct
> > > > > > > > > rule insertion and management of the device's steering tables.
> > > > > > > > >
> > > > > > > > > The type is provided by the user via the dedicated attribute in
> > > > > > > > > the alloc_dm ioctl command.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> > > > > > > > > Reviewed-by: Eli Cohen <eli@mellanox.com>
> > > > > > > > > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > > > > > > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > > > > > > >  drivers/infiniband/hw/mlx5/Kconfig        |   2 +-
> > > > > > > > >  drivers/infiniband/hw/mlx5/cmd.c          | 127 +++++++++++++++++++-
> > > > > > > > >  drivers/infiniband/hw/mlx5/cmd.h          |   6 +-
> > > > > > > > >  drivers/infiniband/hw/mlx5/main.c         | 136 +++++++++++++++++++++-
> > > > > > > > >  drivers/infiniband/hw/mlx5/mlx5_ib.h      |  17 +++
> > > > > > > > >  drivers/infiniband/hw/mlx5/mr.c           |   7 ++
> > > > > > > > >  include/uapi/rdma/mlx5_user_ioctl_verbs.h |   2 +
> > > > > > > > >  7 files changed, 291 insertions(+), 6 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
> > > > > > > > > index 8d651c05de62..347d457fcb2f 100644
> > > > > > > > > +++ b/drivers/infiniband/hw/mlx5/Kconfig
> > > > > > > > > @@ -1,6 +1,6 @@
> > > > > > > > >  config MLX5_INFINIBAND
> > > > > > > > >  	tristate "Mellanox 5th generation network adapters (ConnectX series) support"
> > > > > > > > > -	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
> > > > > > > > > +	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE && PHYS_ADDR_T_64BIT
> > > > > > > >
> > > > > > > > Why do we need this?
> > > > > > >
> > > > > > > We are using phys_addr_t type and not u64 as an input to FW to emphasize
> > > > > > > the caller interface, but it is different between 32 and 64 bits systems.
> > > > > > > Such PHYS_ADDR_T_64BIT will ensure that phys_addr_t will be always 64 bits.
> > > > > >
> > > > > > ???
> > > > > >
> > > > > > PHYS_ADDR_T should only ever be used to store a bus address - and if
> > > > > > you are passing a bus address to/from FW then you 0 extend it on 32
> > > > > > bit, and range check on 64 bit.
> > > > > >
> > > > > > This is not a reason to force PHYS_ADDR_T_64BIT from a driver
> > > > >
> > > > > So how will I mark that we are forwarding physical address to FW?
> > > >
> > > > I don't know what this means.. phys_addr_t will transparently 0 extend
> > > > to 64 bit which is the correct thing to do when passing a phys_addr_t
> > > > to HW.
> > >
> > > It looks to me very similar to what I wanted: mark input as an address
> > > and ensure that it is always u64 as our FW expects.
> >
> > So there is no reason for the kconfig hunk then
> 
> The kconfig is needed to ensure that u64 value is truncated to be u32 on
> 32bits systems.

What?

Jason
