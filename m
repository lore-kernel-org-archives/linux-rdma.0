From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3] net: mlx5: Add a missing check on idr_find, free buf
Date: Tue, 19 Mar 2019 09:03:11 -0700
Message-ID: <60539cb4-1dfb-d307-f761-61ff5459e3ac@gmail.com>
References: <20190319155524.6978-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319155524.6978-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 03/19/2019 08:55 AM, Aditya Pakki wrote:
> idr_find() can return a NULL value to 'flow' which is used without a check.
> The patch adds a check to avoid potential NULL pointer dereference.
> In case of mlx5_fpga_sbu_conn_sendmsg() failure, free buf allocated
> using kzalloc.
> 
> ---
> v2: failure to return in case of flow failure.
> v1: Failed to free buf in case of flow failure.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>


Please add an appropriate Fixes: tag, thanks.
