From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH rdma-next 0/8] User space steering
Date: Mon, 1 Apr 2019 11:32:21 -0700
Message-ID: <20190401113221.6fbba319@cakuba.hsd1.ca.comcast.net>
References: <20190331164450.23618-1-leon@kernel.org>
        <20190331140633.33df25a7@cakuba.hsd1.ca.comcast.net>
        <20190401062816.GC8348@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190401062816.GC8348@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 1 Apr 2019 09:28:16 +0300, Leon Romanovsky wrote:
> On Sun, Mar 31, 2019 at 02:06:33PM -0700, Jakub Kicinski wrote:
> > On Sun, 31 Mar 2019 19:44:42 +0300, Leon Romanovsky wrote:  
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > From Ariel,
> > >
> > > This series of patches adds user space managed steering infrastructure
> > > to the mlx5_ib driver.
> > >
> > > User space managed steering requires the means to access a dedicated
> > > memory space that is used by the device to store the packet steering
> > > and header modification tables and rules in order to manage them directly
> > > without the device's firmware involvement. This dedicated memory is part
> > > of the ICM memory space.
> > >
> > > The changes are introducing the mlx5_ib API to allocate, deallocate and
> > > register this dedicated SW ICM memory via the existing device memory API
> > > using a private attribute which specifies the memory type.
> > >
> > > The allocated memory itself is not IO mapped and user can only access it
> > > using remote RDMA operations.
> > >
> > > In addition, the series exposed the ICM address of the receive transport
> > > interface (TIR) of Raw Packet and RSS QPs to user since they are required
> > > to properly create and insert steering rules that direct flows to these QPs.  
> >
> > Hi Leon!  Out of curiosity what protocols are you guys steering here?
> > Is this some form of RoCE or IB?  Is there a good resource to read up on
> > the DEVX stuff? (I presume this series is related?)  
> 
> mlx5 devices steering operates on packets without relation to specific
> protocol. The decision to steer is based on HW capabilities and user
> configuration for matching specific fields. Such configuration is done
> through kernel and through DEVX.
> 
> General description of DEVX can be found in manuals of libmlx5.
> https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/mlx5dv_devx_obj_create.3.md
> https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/

Thanks for those, looks quite powerful.  What's your primary use case
here?  Is there some flow steering and encapsulation going on in RDMA
world?
