From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sat, 13 Jan 2018 12:15:58 -0700
Message-ID: <20180113191558.GC32353@ziepe.ca>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca>
 <1515775567.131759.42.camel@gmail.com>
 <85116e56-52b1-944d-6ee2-916ccfc3a7a6@mellanox.com>
 <1515788191.131759.48.camel@gmail.com>
 <e902138a-3508-3504-51e5-46152cc2fb31@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e902138a-3508-3504-51e5-46152cc2fb31-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 01:01:56PM -0800, Saeed Mahameed wrote:


> Simply putting a memory barrier on the top or the bottom of a functions,
> means nothing unless you are looking at the whole picture, of all the
> callers of that function to understand why is it there.

When I review code I want to see the memory barrier placed *directly*
before the write which allows the DMA.

So yes, this is my preference:

> update_doorbell() {
>     dma_wmb();
>     ring->db = prod;
> }

Conceptually what is happening here is very similar to what
smp_store_release() does for SMP cases. In most cases wmb should
always be strongly connected with a following write.

smp_store_release() is called 'release' because the write it
incorporates allows the other CPU to 'see' what is being
protected. Similarly here, the write to the db allows the device to
'see' the new ring data.

And this is bad idea:

> fill buffers();
> dma_wmb();
> update_doorbell();
 
> I simply like the 2nd one since with one look you can understand
> what this dma_wmb is protecting.

What do you think the wmb is protecting in the above? It isn't the fill.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
