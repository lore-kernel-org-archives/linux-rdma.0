From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 3/4] rdma: Add an option to rename IB
 device interface
Date: Fri, 2 Nov 2018 10:43:47 -0600
Message-ID: <220bb6af-743b-ee50-3063-102921fe78cb@gmail.com>
References: <20181031071758.6178-1-leon@kernel.org>
 <20181031071758.6178-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-4-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 10/31/18 1:17 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Enrich rdmatool with an option to rename IB devices,
> the command interface follows Iproute2 convention:
> "rdma dev set [OLD-DEVNAME] name NEW-DEVNAME"
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/dev.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 

applied to iproute2-next. Thanks
