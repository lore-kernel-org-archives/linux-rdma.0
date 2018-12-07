From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/3]  Packet based credit mode
Date: Fri, 7 Dec 2018 13:29:31 -0700
Message-ID: <20181207202931.GT16806@ziepe.ca>
References: <20181130112206.19870-1-leon@kernel.org>
 <20181207032706.GA20134@ziepe.ca>
 <20181207060426.GC3845@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207060426.GC3845@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 07, 2018 at 08:04:26AM +0200, Leon Romanovsky wrote:
> On Thu, Dec 06, 2018 at 08:27:06PM -0700, Jason Gunthorpe wrote:
> > On Fri, Nov 30, 2018 at 01:22:03PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > >From Danit,
> > >
> > > Packet based credit mode is an alternative end-to-end credit mode for QPs
> > > set during their creation. Credits are transported from the responder
> > > to the requester to optimize the use of its receive resources.
> > > In packet-based credit mode, credits are issued on a per packet basis.
> > >
> > > The advantage of this feature comes while sending large RDMA messages
> > > through switches that are short in memory.
> > >
> > > The first commit exposes QP creation flag and the HCA capability. The
> > > second commit adds support for a new DV QP creation flag. The last
> > > commit report packet based credit mode capability via the MLX5DV device
> > > capabilities.
> > >
> > > Thanks
> > >
> > > Danit Goldberg (3):
> > >   net/mlx5: Expose packet based credit mode
> > >   IB/mlx5: Add packet based credit mode support
> > >   IB/mlx5: Report packet based credit mode device capability
> >
> > This looks fine to me, can you update the shared branch please
> 
> Done, thanks
> 3fd3c80acc17 net/mlx5: Expose packet based credit mode

Applied to for-next

Thanks,
Jason
