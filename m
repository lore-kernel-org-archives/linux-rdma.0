From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] net/rds: void function cannot return -1
Date: Mon, 16 Jul 2018 09:29:02 -0700
Message-ID: <df82aa42-133c-9381-ca97-1d80c8c3e3cc@oracle.com>
References: <20180716130009.1591379-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716130009.1591379-1-Haakon.Bugge@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <Haakon.Bugge@oracle.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 7/16/2018 6:00 AM, Håkon Bugge wrote:
> Commit b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void") did
> not change the comment accordingly.
> 
> Fixes: b6fb0df12db6 ("RDS/IB: Make ib_recv_refill return void")
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>   net/rds/ib_recv.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index b4e421aa9727..e5ce93419263 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -376,8 +376,6 @@ static void release_refill(struct rds_connection *conn)
>    * This tries to allocate and post unused work requests after making sure that
>    * they have all the allocations they need to queue received fragments into
>    * sockets.
> - *
> - * -1 is returned if posting fails due to temporary resource exhaustion.
>    */
>   void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
>   {
> 
Yep. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.ccom>
