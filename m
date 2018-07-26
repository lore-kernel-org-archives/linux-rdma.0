From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] IB/mlx5: avoid excessive warning msgs when creating
 VFs on 2nd port
Date: Thu, 26 Jul 2018 16:12:14 -0600
Message-ID: <20180726221214.GA13670@ziepe.ca>
References: <20180723211508.7078-1-qing.huang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723211508.7078-1-qing.huang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, leon@kernel.org, gerald.gibson@oracle.com, danielj@mellanox.com, sharon.s.liu@oracle.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 23, 2018 at 02:15:08PM -0700, Qing Huang wrote:
> When a CX5 device is configured in dual-port RoCE mode, after creating
> many VFs against port 1, creating the same number of VFs against port 2
> will flood kernel/syslog with something like
> "mlx5_*:mlx5_ib_bind_slave_port:4266:(pid 5269): port 2 already
> affiliated."
> 
> So basically, when traversing mlx5_ib_dev_list, mlx5_ib_add_slave_port()
> repeatedly attempts to bind the new mpi structure to every device
> on the list until it finds an unbound device.
> 
> Change the log level from warn to dbg to avoid log flooding as the warning
> should be harmless.
> 
> Signed-off-by: Qing Huang <qing.huang@oracle.com>
> Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
> ---
>   v1 -> v2: change the log level instead

Applied to for-next

Thanks,
Jason
