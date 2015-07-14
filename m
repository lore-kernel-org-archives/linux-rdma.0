From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 14:58:20 -0400
Message-ID: <9EF1EEBD-5F17-4414-AA4F-5770EFB35DD7@oracle.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150711103920.GE14741@infradead.org> <55A21DF6.6090909@dev.mellanox.co.il> <96901C8F-D916-4ECF-8DA4-C5C67FB8539E@oracle.com> <20150713064701.GB31842@infradead.org> <1D9C0527-E277-4C3F-A80D-C4FBAA3D82E9@oracle.com> <55A4CD5B.9030000@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A4CD5B.9030000-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 14, 2015, at 4:50 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 7/13/2015 5:16 PM, Chuck Lever wrote:
>=20
>>> NFS really should be using something more similar to a scatterlist,
>>> as it maps pretty well to the sk_frags in the network layer as well=
=2E
>>>=20
>>> Struct scatterlist is imprtant because it's the way the DMA mapping
>>> functions takes a multi-page argument, so ayone who wants to batch
>>> the S/G mapping calls needs it.
>>=20
>> An excellent topic to bring up on linux-nfs-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
>>=20
>> In the meantime, I think rpcrdma.ko would have to be responsible for
>> converting struct page to struct scatterlist.
>>=20
>=20
> Fine by me, so I take it that you are OK with the proposed API?

I think I can make struct scatterlist work as well as struct struct
ib_fast_reg_page_list works now.

If Christoph is correct, the pay-off for this change would be when
the NFS upper layers are converted to use struct scatterlist instead
of struct page.

Until then, I don=92t see a specific benefit for RPC/RDMA. But I will
go with the flow.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
