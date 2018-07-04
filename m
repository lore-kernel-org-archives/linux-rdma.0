From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/3] Dump and fill MKEY
Date: Wed, 4 Jul 2018 13:29:48 -0600
Message-ID: <20180704192948.GE30037@ziepe.ca>
References: <20180619054724.32677-1-leon@kernel.org>
 <20180704174739.GA9317@ziepe.ca>
 <20180704185459.GQ3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180704185459.GQ3014@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 04, 2018 at 09:54:59PM +0300, Leon Romanovsky wrote:
> On Wed, Jul 04, 2018 at 11:47:39AM -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 19, 2018 at 08:47:21AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > MLX5 IB HCA offers the memory key, dump_fill_mkey to increase
> > > performance, when used in a send or receive operations.
> > >
> > > It is used to force local HCA operations to skip the PCI bus access,
> > > while keeping track of the processed length in the ibv_sge handling.
> > >
> > > In this three patch series, we expose various bits in our HW
> > > spec file (mlx5_ifc.h), move unneeded for mlx5_core FW command and
> > > export such memory key to user space thought our mlx5-abi header file.
> > >
> > > Thanks
> >
> > This looks fine, can you send a pull request off the mlx5 branch
> > please?
> 
> Updated mlx5-next with first two commits,
> b183ee27f5fb net/mlx5: Add hardware definitions for dump_fill_mkey
> 4d4fb5dc988a net/mlx5: Limit scope of dump_fill_mkey function

Okay, applied to for-next, with the missing 'if (err)' fixed.

Thanks,
Jason
