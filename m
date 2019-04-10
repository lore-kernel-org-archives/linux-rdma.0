From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 00/12] Move IB representors to single IB device
 multiple ports
Date: Wed, 10 Apr 2019 15:06:40 -0300
Message-ID: <20190410180640.GO8997@ziepe.ca>
References: <20190328132742.12070-1-leon@kernel.org>
 <20190404130221.GA15890@ziepe.ca>
 <20190404174238.GC3201@mtr-leonro.mtl.com>
 <20190410064840.GJ3201@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190410064840.GJ3201@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 10, 2019 at 09:48:40AM +0300, Leon Romanovsky wrote:
> > > > Mark Bloch (12):
> > > >   net/mlx5: E-Switch, don't use hardcoded values for FDB prios
> > > >   net/mlx5: E-Switch, add a new prio to be used by the RDMA side
> > > >   RDMA/mlx5: Move netdev info into the port struct
> > > >   RDMA/mlx5: Free IB device on remove
> > > >   RDMA/mlx5: Move ports allocation to outside of INIT stage
> > > >   RDMA/mlx5: Use correct size for device resources
> > > >   RDMA/mlx5: Move rep into port struct
> > > >   RDMA/mlx5: Move default representors SQ steering to rule to modify QP
> > > >   RDMA/mlx5: Refactor netdev affinity code
> > > >   RDMA/mlx5: Move SMI caps logic
> > > >   RDMA/mlx5: Move to single device multiport ports in switchdev mode
> > > >   RDMA/mlx5: Remove VF representor profile
> > >
> > > This looks Ok, can you update the shared branch please
> >
> > Thanks Jason,
> >
> > I'll slightly delay update till Sunday, internally, we have doubts about
> > "RDMA/mlx5: Use correct size for device resources" patch.
> 
> Hi Jason,
> 
> I updated our mlx5-next with first two patches.
> d9cb06759eca net/mlx5: E-Switch, add a new prio to be used by the RDMA side
> b6d9ccb11250 net/mlx5: E-Switch, don't use hardcoded values for FDB prios
> 
> We found the reason for instability over bond interface and it was related to the patch
> "RDMA/mlx5: Move netdev info into the port struct". The following fixup is needed.
> It will be helpful if you can apply it internally, or I can resend rest of the series.
> 
> commit 775efa8dd53e5148d8d4942d2d0b7e72ca606d40
> Author: Mark Bloch <markb@mellanox.com>
> Date:   Tue Apr 9 03:28:59 2019 +0000
> 
>     fixup! RDMA/mlx5: Move netdev info into the port struct
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index fdcc76383ae9..6f479dc66b78 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1958,7 +1958,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
>  	print_lib_caps(dev, context->lib_caps);
> 
>  	if (dev->lag_active) {
> -		u8 port = mlx5_core_native_port_num(dev->mdev);
> +		u8 port = mlx5_core_native_port_num(dev->mdev) - 1;
> 
>  		atomic_set(&context->tx_port_affinity,
>  			   atomic_add_return(
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 832f6d176e25..31039fe1dd20 100644
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3491,7 +3491,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>  		    (ibqp->qp_type == IB_QPT_XRC_INI) ||
>  		    (ibqp->qp_type == IB_QPT_XRC_TGT)) {
>  			if (dev->lag_active) {
> -				u8 p = mlx5_core_native_port_num(dev->mdev);
> +				u8 p = mlx5_core_native_port_num(dev->mdev) - 1;
>  				tx_affinity = get_tx_affinity(dev, pd, base, p,
>  							      udata);
>  				context->flags |= cpu_to_be32(tx_affinity << 24);

Okay, done

Jason
