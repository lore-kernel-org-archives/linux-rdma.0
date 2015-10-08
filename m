From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 8 Oct 2015 09:14:49 +0300
Message-ID: <561609D9.2080404@mellanox.com>
References: <1443091747-13881-1-git-send-email-wen.gang.wang@oracle.com>
 <CAJ3xEMgN4_gk4_hVXOW2GhcfnXxgPnm=Lrc7JwkxBAeKv4KRAQ@mail.gmail.com>
 <56049A8A.6040101@oracle.com> <20151008060609.GA19101@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151008060609.GA19101-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/8/2015 9:06 AM, Leon Romanovsky wrote:
> Additionally, I want to spot Or's attention on the following discussion
> in MM-subsystem about kmalloc/vmalloc and general function to fallback
> from one to another.
>
>

too busy to read them now, if you have review comments speak now and 
provide them to the author.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
