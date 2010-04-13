From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_subnet.c: fixing some options to not
 "hot-swappable"
Date: Tue, 13 Apr 2010 14:03:05 +0300
Message-ID: <20100413110305.GD10830@me>
References: <4BC44A23.8010509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BC44A23.8010509-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:40 Tue 13 Apr     , Yevgeny Kliteynik wrote:
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: 7bit
> Return-Path: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
> X-OriginalArrivalTime: 13 Apr 2010 10:40:45.0762 (UTC) FILETIME=[C6063A20:01CADAF5]
> 
> The following options are not hot-swappable:
> 
>   transaction_timeout
>   transaction_retries
>   use_ucast_cache
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
