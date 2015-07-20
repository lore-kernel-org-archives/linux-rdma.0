From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 14:55:15 -0700
Message-ID: <55AD6E43.60205@talpey.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com>
 <06BCEDB0-1589-454B-BDD1-9937290AAD29@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <06BCEDB0-1589-454B-BDD1-9937290AAD29-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 1:55 PM, Chuck Lever wrote:
> On Jul 20, 2015, at 4:34 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On 7/20/2015 12:03 PM, Chuck Lever wrote:
>>> All HCA providers have an ib_get_dma_mr() verb. Thus
>>> rpcrdma_ia_open() will either grab the device's local_dma_key if on=
e
>>> is available, or it will call ib_get_dma_mr() which is a 100%
>>> guaranteed fallback.
>>
>> I recall that in the past, some providers did not support mapping
>> all of the machine's potential physical memory with a single dma_mr.
>> If an rnic did/does not support 44-ish bits of length per region,
>> for example.
>
> The buffers affected by this change are small, so I=92m confident tha=
t
> restriction would not be a problem here.

It's not about the buffer size, it's about the region. Because the
get_dma_mr does not specify a base address and length, the rnic must
basically attempt to map a base of zero and a length of the largest
physical offset.

This is not the case with the previous phys_reg_mr, which specified
the exact phys page range.

> What might break with such restricted hardware is ALLPHYSICAL on
> large-memory systems. ALLPHYSICAL does rely on a single DMA MR that
> covers all of the NFS client=92s memory.

Yes, indeed it always did, but that mode was not intended for general
use.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
