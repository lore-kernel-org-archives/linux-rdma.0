From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/3] svcrdma: handle rdma read with a non-zero initial
 page offset
Date: Mon, 28 Sep 2015 09:31:25 -0500
Message-ID: <56094F3D.2030002@opengridcomputing.com>
References: <20150921172423.9761.92399.stgit@build2.ogc.int>
 <20150921172428.9761.27838.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150921172428.9761.27838.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/21/2015 12:24 PM, Steve Wise wrote:
> The server rdma_read_chunk_lcl() and rdma_read_chunk_frmr() functions
> were not taking into account the initial page_offset when determining
> the rdma read length.  This resulted in a read who's starting address
> and length exceeded the base/bounds of the frmr.
>
> Most work loads don't tickle this bug apparently, but one test hit it
> every time: building the linux kernel on a 16 core node with 'make -j
> 16 O=/mnt/0' where /mnt/0 is a ramdisk mounted via NFSRDMA.
>
> This bug seems to only be tripped with devices having small fastreg page
> list depths.  I didn't see it with mlx4, for instance.
>
> Fixes: 0bf4828983df ('svcrdma: refactor marshalling logic')
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>
>

Hey Bruce, can this make 4.3-rc?  Also, what do you think about pushing 
it to stable?

Thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
