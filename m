From: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: correct ib api use with sg_dma_address/sg_dma_len
Date: Thu, 19 Apr 2012 14:38:56 -0500
Message-ID: <4F9069D0.4090108@oracle.com>
References: <20120419161517.713.76674.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419161517.713.76674.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/19/2012 11:15 AM, Mike Marciniszyn wrote:
> From: Mike Marciniszyn<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> 0b088e00 ("RDS: Use page_remainder_alloc() for recv bufs")
> added uses of sg_dma_len() and sg_dma_address().
>
> IB ulps should use ib_sg_dma_len() and ib_sg_dma_address
> respectively since some HCAs overload ib_sg_dma* operations.
>
> Signed-off-by: Mike Marciniszyn<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
Acked-by: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Venkat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
