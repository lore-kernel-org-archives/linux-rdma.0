From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: Re: [PATCH] IPoIB: use kvzalloc to allocate an array of bucket
 pointers
Date: Mon, 16 Jul 2018 19:19:53 +0300
Message-ID: <20180716191953.28b7821d@virtuozzo.com>
References: <1531144263-24717-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531144263-24717-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Yuval Shaia <yuval.shaia@oracle.com>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Kees Cook <keescook@chromium.org>, Evgenii Smirnov <evgenii.smirnov@profitbricks.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Mon,  9 Jul 2018 16:51:03 +0300
Jan Dakinevich <jan.dakinevich@virtuozzo.com> wrote:

> This table by default takes 32KiB which is 3rd memory order.
> Meanwhile, this memory is not aimed for DMA operation and could be
> safely allocated by vmalloc.
> 
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c index 26cde95..cb752df
> 100644 --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1526,7 +1526,7 @@ static int ipoib_neigh_hash_init(struct
> ipoib_dev_priv *priv) return -ENOMEM;
>  	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
>  	size = roundup_pow_of_two(arp_tbl.gc_thresh3);
> -	buckets = kcalloc(size, sizeof(*buckets), GFP_KERNEL);
> +	buckets = kvcalloc(size, sizeof(*buckets), GFP_KERNEL);
>  	if (!buckets) {
>  		kfree(htbl);
>  		return -ENOMEM;
> @@ -1554,7 +1554,7 @@ static void neigh_hash_free_rcu(struct rcu_head
> *head) struct ipoib_neigh __rcu **buckets = htbl->buckets;
>  	struct ipoib_neigh_table *ntbl = htbl->ntbl;
>  
> -	kfree(buckets);
> +	kvfree(buckets);
>  	kfree(htbl);
>  	complete(&ntbl->deleted);
>  }

ping

-- 
Best regards
Jan Dakinevich
