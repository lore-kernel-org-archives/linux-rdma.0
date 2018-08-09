From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next 0/6] Mellanox, mlx5 next updates 2018-08-09
Date: Wed, 08 Aug 2018 19:37:02 -0700 (PDT)
Message-ID: <20180808.193702.960669524487101933.davem@davemloft.net>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com, jgg@mellanox.com, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed,  8 Aug 2018 16:23:47 -0700

> This series includes mlx5 core driver updates and mostly simple
> cleanups.
> 
> From Denis: Use max #EQs reported by firmware to request MSIX vectors.
> 
> From Eli: Trivial cleanups, unused arguments/functions and reduce
> command polling interval when command interface is in polling mode.
> 
> From Eran: Rename vport state enums, to better reflect their actual
> usage.

Series applied to net-next, thank you.
