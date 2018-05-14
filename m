From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] net/mlx4_core: Fix error handling in
 mlx4_init_port_info.
Date: Mon, 14 May 2018 16:29:45 -0400 (EDT)
Message-ID: <20180514.162945.673218440357756147.davem@davemloft.net>
References: <20180513233845.135290-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180513233845.135290-1-tarick@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tarick@google.com
Cc: tariqt@mellanox.com, gthelen@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tarick Bedeir <tarick@google.com>
Date: Sun, 13 May 2018 16:38:45 -0700

> Avoid exiting the function with a lingering sysfs file (if the first
> call to device_create_file() fails while the second succeeds), and avoid
> calling devlink_port_unregister() twice.
> 
> In other words, either mlx4_init_port_info() succeeds and returns zero, or
> it fails, returns non-zero, and requires no cleanup.
> 
> Fixes: 096335b3f983 ("mlx4_core: Allow dynamic MTU configuration for IB
> ports")
> Signed-off-by: Tarick Bedeir <tarick@google.com>
> ---
> v1 -> v2: Added "Fixes" tag.

Applied and queued up for -stable.
