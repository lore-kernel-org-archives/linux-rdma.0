From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Tue, 7 Aug 2012 10:37:03 +0300
Message-ID: <CAJZOPZLdcenewz4rd0+cOxLGPevPHz+tsYMR6Va36g77aCM5tA@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
	<CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com>
	<CALfB72B_Ge0+Tyb9zs+M8K7-8EvKJDQH0ErTxod+UnG6+-KxaA@mail.gmail.com>
	<501FE7E9.20606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <501FE7E9.20606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 6, 2012 at 6:51 PM, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> In the meanwhile I have found the root cause of the limit of log_num_mtt of 28. Plan to
> send in coming days an extra patch that enables value of 31 which match to 8TB.

nice doing. Just an ordering comment, for the upstream inclusion, it
seems that what we need is two patches

1. fix for some issues e.g around ints/longs and friends which is
likely to be the source of the bug which once fixed eliminated the
crashes you hit in the 28-30/31 range

2. the vmalloc etc patch you posted here

This way you avoid reverting some code from patch #2 in patch #1 - it
helps with maintainance

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
