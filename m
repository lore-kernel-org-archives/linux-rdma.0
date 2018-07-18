From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5: fix an unused-function warning
Date: Thu, 19 Jul 2018 05:39:03 +0900 (KST)
Message-ID: <20180719.053903.2078135194846496238.davem@davemloft.net>
References: <20180717135009.3584984-1-arnd@arndb.de>
        <CALzJLG_r5pkBWGvyE+e7PVtPOnLnXS8oee_ka+=UEAkbqDP-Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALzJLG_r5pkBWGvyE+e7PVtPOnLnXS8oee_ka+=UEAkbqDP-Kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: saeedm@dev.mellanox.co.il
Cc: arnd@arndb.de, saeedm@mellanox.com, leon@kernel.org, ilyal@mellanox.com, borisp@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date: Tue, 17 Jul 2018 17:42:25 -0700

> On Tue, Jul 17, 2018 at 6:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> These dummy helpers are all intended to be inline functions,
>> but one of them by accident came without the 'inline' keyword,
>> causing a harmless warning:
>>
>> In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:63:
>> drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h:79:1: error: 'mlx5_accel_tls_add_flow' defined but not used [-Werror=unused-function]
>>  mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
>>
>> Fixes: ab412e1dd7db ("net/mlx5: Accel, add TLS rx offload routines")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Dave, you can take this one to net-next.

Sure, done.
