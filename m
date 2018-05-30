From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Add FPGA QP error event
Date: Wed, 30 May 2018 18:21:05 +0200
Message-ID: <20180530162105.GF27537@lunn.ch>
References: <20180530001954.12000-1-saeedm@mellanox.com>
 <20180530001954.12000-3-saeedm@mellanox.com>
 <20180530010710.GC30239@lunn.ch>
 <da8acf8e4a2c976fd3ce4f8e17a969b3464fd263.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da8acf8e4a2c976fd3ce4f8e17a969b3464fd263.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilan Tayari <ilant@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Adi Nissim <adin@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 03:14:20PM +0000, Saeed Mahameed wrote:
> On Wed, 2018-05-30 at 03:07 +0200, Andrew Lunn wrote:
> > On Tue, May 29, 2018 at 05:19:54PM -0700, Saeed Mahameed wrote:
> > > From: Ilan Tayari <ilant@mellanox.com>
> > > 
> > > The FPGA QP event fires whenever a QP on the FPGA trasitions
> > > to the error state.
> > 
> > FPGA i know, field programmable gate array. Could you offer some clue
> > as to what QP means?
> > 
> 
> Hi Andre, QP "Queue Pair" is well known rdma concept, and widely used
> in mlx drivers, it is used as in the driver as a ring buffer to
> communicate with the FPGA device.

O.K. Thanks.

It is hard to get the right balance between assuming people know
everything, and know nothing. But you can help teach people these
terms i commit messages:

      The FPGA queue pair event fires whenever a QP on the FPGA
      transitions to the error state.

   Andrew
