From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:55:47 -0400
Message-ID: <06BCEDB0-1589-454B-BDD1-9937290AAD29@oracle.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <55AD5B48.3010906@talpey.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AD5B48.3010906-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Tom-


On Jul 20, 2015, at 4:34 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:

> On 7/20/2015 12:03 PM, Chuck Lever wrote:
>> All HCA providers have an ib_get_dma_mr() verb. Thus
>> rpcrdma_ia_open() will either grab the device's local_dma_key if one
>> is available, or it will call ib_get_dma_mr() which is a 100%
>> guaranteed fallback.
>=20
> I recall that in the past, some providers did not support mapping
> all of the machine's potential physical memory with a single dma_mr.
> If an rnic did/does not support 44-ish bits of length per region,
> for example.

The buffers affected by this change are small, so I=92m confident that
restriction would not be a problem here.

What might break with such restricted hardware is ALLPHYSICAL on
large-memory systems. ALLPHYSICAL does rely on a single DMA MR that
covers all of the NFS client=92s memory.

That would be a problem both before and after this patch, as far as
I can tell.


> Have you verified that all current providers do in fact support the
> necessary physical address range for this, and that the requirement
> is stated in the verbs going forward?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
