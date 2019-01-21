From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] rdma: Add unbound workqueue to list of poll
 context types
Date: Mon, 21 Jan 2019 09:20:30 -0700
Message-ID: <9cc02f4f-4472-da56-c88b-7955e4a7bcb8@gmail.com>
References: <20190117151443.25368-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190117151443.25368-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 1/17/19 8:14 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Kernel commit f794809a7259 ("IB/core: Add an unbound WQ type to the new CQ API")
> added new CQ poll context type, reflect this change in rdmatool.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to iproute2-next. Thanks
