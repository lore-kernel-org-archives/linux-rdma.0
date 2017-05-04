From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma] IB/rxe: Update caller's CRC for RXE_MEM_TYPE_DMA
 memory type
Date: Thu, 04 May 2017 19:46:32 -0400
Message-ID: <1493941592.3041.236.camel@redhat.com>
References: <20170504123607.22708-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504123607.22708-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-04 at 15:36 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Callers of rxe_mem_copy() provide pointer to store updated CRC
> value. That pointer was supposed to be updated, but the
> commit cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> mistakenly removed that assignment for RXE_MEM_TYPE_DMA memory type.
> 
> The code worked because there are no actual callers with
> RXE_MEM_TYPE_DMA, who are interested in returned value of crcp.
> The one caller in read_reply(), who uses the returned crcp didn't
> set RXE_MEM_TYPE_DMA as mem->type.
> 
> Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> Reported-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
> 
> It will be great if you forward this patch as part of your second
> pull request.
> As you can see from the commit message, it fixes issue spotted by
> Andrew.

I've queued it for my second pull request, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
