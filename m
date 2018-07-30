From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 00/27] Flow actions to mutate packets
Date: Mon, 30 Jul 2018 11:09:58 -0600
Message-ID: <20180730170958.GK15118@mellanox.com>
References: <20180729125905.31989-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 29, 2018 at 03:58:38PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This is PATCH variant of RFC posted in previous week to the ML.
> https://patchwork.ozlabs.org/cover/944184/
> 
> Changelog:
>  RFC -> v0:
>   * Patch 1 a new patch which refactors the logic
>     when getting a flow namespace.
>   * Patch 2 was split into two.
>   * Patch 3: Fixed a typo in commit message
>   * Patch 5: Updated commit message
>   * Patch 7: Updated commit message
>     Renamed:
>       - MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID to
>         MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT
>       - packet_reformat_id to reformat_id in struct mlx5_flow_act
>       - packet_reformat_id to encap_id in struct mlx5_esw_flow_attr
>       - packet_reformat_id to encap_id in struct mlx5e_encap_entry
>       - PACKET_REFORMAT to REFORMAT when printing trace points
>   * Patch 9: Updated commit message
>     Updated function declaration in mlx5_core.h, could of lead
>     to compile error on bisection.
>   * Patch 11: Disallow egress rules insertion when in switchdev mode
>   * Patch 12: A new patch to deal with passing enum values using
>     the IOCTL infrastructure.
>   * Patch 13: Use new enum value attribute when passing enum
>     mlx5_ib_uapi_flow_table_type
>   * Patch 15: Don't set encap flags on flow tables if in switchdev mode
>   * Patch 17: Use new enum value attribute when passing enum
>     mlx5_ib_uapi_flow_table_type and enum
>     mlx5_ib_uapi_flow_action_packet_reformat_type
>   * Patch 19: Allow creation of both
>     MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL
>     and MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2 packet
>     reformat actions.
>   * Patch 20: A new patch which allows attaching packet reformat
>     actions to flow tables on NIC RX.
> 
> Thanks
> 
> From Mark:
> This series exposes the ability to create flow actions which can
> mutate packet headers. We do that by exposing two new verbs:
>  * modify header - can change existing packet headers. packet
>  * reformat - can encapsulate or decapsulate a packet.
>               Once created a flow action must be attached to a steering
>               rule for it to take effect.

Mark, this got a bit big in terms of patch count, however most of the
patches fit on one screen and the overall line count isn't too bad.

Can this be split somehow?

Thanks,
Jason
