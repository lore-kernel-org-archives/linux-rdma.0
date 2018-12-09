From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4_core: Correctly set PFC param if global pause
 is turned off.
Date: Sat, 08 Dec 2018 21:27:25 -0800 (PST)
Message-ID: <20181208.212725.171565172090619908.davem@davemloft.net>
References: <20181207083026.173789-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207083026.173789-1-tarick@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tarick@google.com
Cc: eranbe@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tarick Bedeir <tarick@google.com>
Date: Fri,  7 Dec 2018 00:30:26 -0800

> rx_ppp and tx_ppp can be set between 0 and 255, so don't clamp to 1.
> 
> Fixes: 6e8814ceb7e8 ("net/mlx4_en: Fix mixed PFC and Global pause user control requests")
> Signed-off-by: Tarick Bedeir <tarick@google.com>

Applied and queued up for -stable.
