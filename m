From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 18:01:01 -0500
Message-ID: <54CF0111-E9C4-4196-BF92-7E134A6A329A@oracle.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com> <1447152255-28231-3-git-send-email-sagig@mellanox.com> <20151110114145.GA2810@infradead.org> <5641D920.5000409@mellanox.com> <20151110120432.GA8230@infradead.org> <20151110182546.GI12667@obsidianresearch.com> <56425AFB.30202@talpey.com> <20151110211716.GA21631@obsidianresearch.com> <564261EF.4000008@talpey.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564261EF.4000008-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 10, 2015, at 4:30 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 11/10/2015 4:17 PM, Jason Gunthorpe wrote:
>> On Tue, Nov 10, 2015 at 04:00:43PM -0500, Tom Talpey wrote:
>>=20
>>> Hmm, agreed, but it must still be acceptable to perform a registrat=
ion
>>> instead of using the local_dma_lkey. As mentioned earlier, there ar=
e
>>> scatter limits and other implications for all-physical addressing t=
hat
>>> an upper layer may choose to avoid.
>>=20
>> It is always acceptable to use a lkey MR instead of the local dma
>> lkey, but ULPs should prefer to use the local dma lkey if possible,
>> for performance reasons.
>=20
> Sure, the key words are "if possible". For example, a single 1MB
> RDMA Read is unlikely to be possible with the dma lkey, assuming
> worst-case physical page scatter it would need 256 SGEs. But 1MB
> can be registered easily.
>=20
> In any case, my point was that the ULP gets to choose, so, it looks
> like we agree.

I=92d like to see our NFS server use the local DMA lkey where it
makes sense, to avoid the cost of registering and invalidating
memory.

I have to agree with Tom that once the device=92s s/g limit is
exceeded, the server has to post an RDMA Read WR every few
pages, and appears to get expensive for large NFS requests.

The current mechanism of statically choosing either FRMR or
local DMA depending on the device is probably not adequate.
Maybe we could post all the Read WRs via a single chain? Or
stick with FRMR when the amount of data to read is significant.

I=92ve also tested Christoph=92s patch. The logic currently in
rdma_read_chunk_lcl does not seem up to the task. Once the
device=92s s/g limit is exceeded, the server starts throwing
local length exceptions, and the client workload hangs.

None of this is impossible to fix, but there is some work to
do here.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
