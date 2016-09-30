From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v1] mlx4: remove unused fields
Date: Fri, 30 Sep 2016 01:57:09 -0400 (EDT)
Message-ID: <20160930.015709.1828493203935150678.davem@davemloft.net>
References: <1475085604-101493-1-git-send-email-ddecotig@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1475085604-101493-1-git-send-email-ddecotig@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: ddecotig@gmail.com
Cc: yishaih@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com, decot@googlers.com
List-Id: linux-rdma@vger.kernel.org

From: David Decotigny <ddecotig@gmail.com>
Date: Wed, 28 Sep 2016 11:00:04 -0700

> From: David Decotigny <decot@googlers.com>
> 
> This also can address following UBSAN warnings:
> [   36.640343] ================================================================================
> [   36.648772] UBSAN: Undefined behaviour in drivers/net/ethernet/mellanox/mlx4/fw.c:857:26
> [   36.656853] shift exponent 64 is too large for 32-bit type 'int'
> [   36.663348] ================================================================================
> [   36.671783] ================================================================================
> [   36.680213] UBSAN: Undefined behaviour in drivers/net/ethernet/mellanox/mlx4/fw.c:861:27
> [   36.688297] shift exponent 35 is too large for 32-bit type 'int'
> [   36.694702] ================================================================================
> 
> Tested:
>   reboot with UBSAN, no warning.
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

Applied to net-next, thanks.
