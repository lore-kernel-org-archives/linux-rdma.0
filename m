From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/8] User space steering
Date: Wed, 24 Apr 2019 16:03:41 -0300
Message-ID: <20190424190341.GM16061@ziepe.ca>
References: <20190331164450.23618-1-leon@kernel.org>
 <20190424130714.GB5196@ziepe.ca>
 <4604e35554bb26c781bb685ae515fdfc06272d55.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4604e35554bb26c781bb685ae515fdfc06272d55.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "leon@kernel.org" <leon@kernel.org>, Eli Cohen <eli@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 24, 2019 at 04:40:54PM +0000, Saeed Mahameed wrote:
> On Wed, 2019-04-24 at 10:07 -0300, Jason Gunthorpe wrote:
> > On Sun, Mar 31, 2019 at 07:44:42PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > > 
> > > > From Ariel,
> > > 
> > > This series of patches adds user space managed steering
> > > infrastructure
> > > to the mlx5_ib driver.
> > > 
> > > User space managed steering requires the means to access a
> > > dedicated
> > > memory space that is used by the device to store the packet
> > > steering
> > > and header modification tables and rules in order to manage them
> > > directly
> > > without the device's firmware involvement. This dedicated memory is
> > > part
> > > of the ICM memory space.
> > > 
> > > The changes are introducing the mlx5_ib API to allocate, deallocate
> > > and
> > > register this dedicated SW ICM memory via the existing device
> > > memory API
> > > using a private attribute which specifies the memory type.
> > > 
> > > The allocated memory itself is not IO mapped and user can only
> > > access it
> > > using remote RDMA operations.
> > > 
> > > In addition, the series exposed the ICM address of the receive
> > > transport
> > > interface (TIR) of Raw Packet and RSS QPs to user since they are
> > > required
> > > to properly create and insert steering rules that direct flows to
> > > these QPs.
> > > 
> > > Thanks
> > > 
> > > Ariel Levkovich (8):
> > >   net/mlx5: Expose SW ICM related device memory capabilities
> > >   IB/mlx5: Support device memory type attribute
> > >   IB/mlx5: Warn on allocated MEMIC buffers during cleanup
> > >   IB/mlx5: Add steering SW ICM device memory type
> > >   IB/mlx5: Device resource control for privileged DEVX user
> > 
> > This doesn't apply, it conflicts with patches in mlx5-next, please
> > resent
> > 
> > >   net/mlx5: Expose TIR ICM address in command outbox
> > >   net/mlx5: Introduce new TIR creation core API
> > >   IB/mlx5: Expose TIR ICM address to user space
> > 
> 
> it is a 3 patch series:
>   net/mlx5: Expose TIR ICM address in command outbox
>   net/mlx5: Introduce new TIR creation core API
>   net/mlx5: Expose SW ICM related device memory capabilities
> 
> LGTM, I can apply them if you want, or do you want to wait for leon ?

Fine by me

Jason 
