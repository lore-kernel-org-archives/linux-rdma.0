From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [Patch v2] opensm/main.c: force stdout to be line-buffered
Date: Thu, 17 Jun 2010 17:29:51 +0300
Message-ID: <20100617142951.GK20172@me>
References: <4C10D3F2.700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C10D3F2.700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:00 Thu 10 Jun     , Yevgeny Kliteynik wrote:
> When stdout is assigned to a terminal, it is line-buffered.
> But when opensm's stdout is redirected to a file, stdout
> becomes block-buffered, which means that '\n' won't cause
> the buffer to be flushed.
> 
> Forcing stdout to always be line-buffered and to have a
> more predictable behavior when used as "opensm > some_file".
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
