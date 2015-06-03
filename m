From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 8/9] IB/mlx4: Support extended create_cq and
 query_device uverbs
Date: Wed, 3 Jun 2015 21:58:25 +0300
Message-ID: <CAJ3xEMhGdX-35WAjauKZE7+Wg39kbXP35UzYX33J6OB8g_9rYA@mail.gmail.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	<1433074457-26437-9-git-send-email-ogerlitz@mellanox.com>
	<20150601165649.GC14391@obsidianresearch.com>
	<CAAKD3BBsTFYKwOBK+6u04x6deRYzjYESJzbpyy83UtoChZhpOA@mail.gmail.com>
	<20150602170736.GA17776@obsidianresearch.com>
	<CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA@mail.gmail.com>
	<20150603163146.GD12073@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150603163146.GD12073-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 3, 2015 at 7:31 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jun 03, 2015 at 11:57:12AM +0300, Matan Barak wrote:
>> That's a general comment regarding the extension mechanism.
>
> Yes, but it is also a specific comment about patch #4 which adds,
> ib_uverbs_ex_create_cq.
>
> Based on the implementation of create_cq, it is pretty clear that
> every driver supports ib_uverbs_ex_create_cq, so patch #4 should just
> force the flag in the device register function so it is globally enabled.

But the other drivers currently do not support any CQ creation flag
and hence no extended functionality, I don't see the point signaling
towards user-space that the verb is supported, please elaborate.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
