From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: And I found the other reason (Re: Found one reason
 libibnetdisc is slower than subnet_discover)
Date: Sun, 24 Jan 2010 12:56:38 +0200
Message-ID: <20100124105638.GC13519@me>
References: <20100121181418.a9e955bb.weiny2@llnl.gov>
 <20100122101113.16c6bd20.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100122101113.16c6bd20.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:11 Fri 22 Jan     , Ira Weiny wrote:
> It looks like subnet_discover was actually allowing n+1 smps on the wire.  With this patch:
> 
> diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
> index acc8c23..22b092a 100644
> --- a/tests/subnet_discover.c
> +++ b/tests/subnet_discover.c
> @@ -189,7 +189,7 @@ static void run_request_queue(int fd, int agent)
>         struct request_queue *q = request_queue.next;
>  
>         while (q) {
> -               if (outstanding > max_outstanding)
> +               if (outstanding >= max_outstanding)
>                         break;
>                 if (send_request(fd, agent, q->trid, q->path, q->path_cnt,
>                                  q->attr_id, q->attr_mod) < 0)

Yes, this is the fix. Thanks. Applied.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
