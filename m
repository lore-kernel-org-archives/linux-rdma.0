From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1] rdma: Print net device name and index
 for RDMA device
Date: Fri, 6 Apr 2018 12:54:20 -0600
Message-ID: <c37f7312-27c9-8e2c-1b7f-691c79211bea@gmail.com>
References: <20180403042914.23360-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180403042914.23360-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 4/2/18 10:29 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The RDMA devices are operated in RoCE and iWARP modes have net device
> underneath. Present their names in regular output and their net index
> in detailed mode.
> 
> [root@nps ~]# rdma link show mlx5_3/1
> 4/1: mlx5_3/1: state ACTIVE physical_state LINK_UP netdev ens7
> [root@nps ~]# rdma link show mlx5_3/1 -d
> 4/1: mlx5_3/1: state ACTIVE physical_state LINK_UP netdev ens7 netdev_index 7
>     caps: <CM, IP_BASED_GIDS>
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  Changes v0->v1:
>   * Resend after commit 29122c1aae35 ("rdma: update rdma_netlink.h")
>     which updated relevant netlink attributes.
>   * Added Steve's ROB
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h |  4 ++++
>  rdma/link.c                           | 21 +++++++++++++++++++++
>  rdma/utils.c                          |  2 ++
>  3 files changed, 27 insertions(+)
> 

applied to iproute2-next
