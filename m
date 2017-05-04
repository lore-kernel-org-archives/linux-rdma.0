From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH rdma] IB/rxe: Update caller's CRC for RXE_MEM_TYPE_DMA
 memory type
Date: Thu, 4 May 2017 13:21:15 +0000
Message-ID: <D530A2EB.16906%Andrew.Boyer@emc.com>
References: <20170504123607.22708-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504123607.22708-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <DDFEAD2B4878384C92855EB5E99F4EEE-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 5/4/17, 8:36 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Leon
Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>Callers of rxe_mem_copy() provide pointer to store updated CRC
>value. That pointer was supposed to be updated, but the
>commit cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
>mistakenly removed that assignment for RXE_MEM_TYPE_DMA memory type.
>
>The code worked because there are no actual callers with
>RXE_MEM_TYPE_DMA, who are interested in returned value of crcp.
>The one caller in read_reply(), who uses the returned crcp didn't
>set RXE_MEM_TYPE_DMA as mem->type.
>
>Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
>Reported-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>---
>Hi Doug,
>
>It will be great if you forward this patch as part of your second pull
>request.
>As you can see from the commit message, it fixes issue spotted by Andrew.
>
>Thanks
>---
> drivers/infiniband/sw/rxe/rxe_mr.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
