From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4: vmalloc for mlx4_ib_wq.wrid and mlx4_ib_srq.wrid
Date: Thu, 24 Sep 2015 08:33:25 +0300
Message-ID: <56038B25.1010901@mellanox.com>
References: <1443060654-10402-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443060654-10402-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 5:10 AM, Wengang Wang wrote:
> Use __vmalloc to allocate memory for mlx4_ib_wq.wrid and mlx4_ib_srq.wrid.
>
> Several hits that the kmalloc for wrid failed with the following like
> call back stack:

Using vmalloc and friends should be done with care, specifically, we'd like
to go there only when needed (namely when kmalloc fails), else we can 
get into
another set of troubles.

Please use the practice introduced in commit 89dd86d "mlx4_core: Allow 
large mlx4_buddy bitmaps"
to go the vmalloc way only when needed, note you can just call kvfree 
later, no need to branch
when freeing things (as was fixed later in commit 914efb0 "mlx4: don't 
duplicate kvfree()")

And have the patch title to be

IB/mlx4: Use vmalloc  for WR buffers when needed

I don't think the OOM oops in the change log helps, skip it.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
