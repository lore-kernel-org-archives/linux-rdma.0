From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 2/6] IB/mlx5: Unify e-switch representors load
 approach between uplink and VFs
Date: Thu, 13 Dec 2018 03:37:06 +0000
Message-ID: <20181213033701.GB2883@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
 <20181213031141.12783-3-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-3-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <144C17A2D044484CB6A1B86BCCEF5CC5@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 12, 2018 at 07:11:37PM -0800, Saeed Mahameed wrote:
> From: Mark Bloch <markb@mellanox.com>
>=20
> When in switchdev mode and the add function is called by the core
> level driver, make sure we only register the callbacks, but don't
> create the mlx5 IB device or initialize anything. With this change
> all the IB devices in switchdev mode are created only once the load
> callback is invoked by the e-switch core sub-module. This follows
> the design paradigm under which the all the Eth representors must
> be loaded before any of IB reprs is loaded.
>=20
> Signed-off-by: Mark Bloch <markb@mellanox.com>
> Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c  | 11 ++++++++++-
>  drivers/infiniband/hw/mlx5/main.c    | 29 +++++++++-------------------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
>  3 files changed, 19 insertions(+), 22 deletions(-)

Why is this going in the shared branch? This looks like an IB patch??

Jason
