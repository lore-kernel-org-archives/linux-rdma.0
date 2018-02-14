From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loopback with RXE?
Date: Wed, 14 Feb 2018 21:25:59 +0200
Message-ID: <20180214192559.GC8800@yuvallap>
References: <2145E340-3297-4ED2-BEC9-09E4CD582D24@rbird.tech>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2145E340-3297-4ED2-BEC9-09E4CD582D24-DzDj5FMp9MpyDzI6CaY1VQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Bairen <byron-DzDj5FMp9MpyDzI6CaY1VQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 05:13:07PM +0000, Yi Bairen wrote:
> Hi folks,
> 
> Seems I can’t get a Linux 4.9 (Debian 9.3) VM working with single box SoftRoCE loopback. I installed rdma-core 16. The rdma_client & rdma_server in the same box seems working. However, when I use ib_write_bw in the same box, the QPs can’t be connected through the same rxe device.

If the QPs connection is problematic then how come rdma_* is working?

> 
> I’d like to know if rxe loopback is known to be broken, and how to fix it.
>  
> Best,
> Bairen Yi
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
