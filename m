From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 15/15] RDMA/mlx5: Cleanup rep when doing unload
Date: Tue, 18 Jun 2019 10:38:25 +0000
Message-ID: <20190618103823.GG4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-16-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190617192247.25107-16-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <92BFC6D9B624BF4BA7520001F32A998D@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Bodong Wang <bodong@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 17, 2019 at 07:23:39PM +0000, Saeed Mahameed wrote:
> From: Bodong Wang <bodong@mellanox.com>
>
> When an IB rep is loaded, netdev for the same vport is saved for later
> reference. However, it's not cleaned up when doing unload. For ECPF,
> kernel crashes when driver is referring to the already removed netdev.
>
> Following steps lead to a shown call trace:
> 1. Create n VFs from host PF
> 2. Distroy the VFs
> 3. Run "rdma link" from ARM
>
> Call trace:
>   mlx5_ib_get_netdev+0x9c/0xe8 [mlx5_ib]
>   mlx5_query_port_roce+0x268/0x558 [mlx5_ib]
>   mlx5_ib_rep_query_port+0x14/0x34 [mlx5_ib]
>   ib_query_port+0x9c/0xfc [ib_core]
>   fill_port_info+0x74/0x28c [ib_core]
>   nldev_port_get_doit+0x1a8/0x1e8 [ib_core]
>   rdma_nl_rcv_msg+0x16c/0x1c0 [ib_core]
>   rdma_nl_rcv+0xe8/0x144 [ib_core]
>   netlink_unicast+0x184/0x214
>   netlink_sendmsg+0x288/0x354
>   sock_sendmsg+0x18/0x2c
>   __sys_sendto+0xbc/0x138
>   __arm64_sys_sendto+0x28/0x34
>   el0_svc_common+0xb0/0x100
>   el0_svc_handler+0x6c/0x84
>   el0_svc+0x8/0xc
>
> Cleanup the rep and netdev reference when unloading IB rep.
>
> Fixes: 26628e2d58c9 ("RDMA/mlx5: Move to single device multiport ports in=
 switchdev mode")
> Signed-off-by: Bodong Wang <bodong@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
