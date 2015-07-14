From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 11:50:35 +0300
Message-ID: <55A4CD5B.9030000@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150711103920.GE14741@infradead.org> <55A21DF6.6090909@dev.mellanox.co.il>
 <96901C8F-D916-4ECF-8DA4-C5C67FB8539E@oracle.com>
 <20150713064701.GB31842@infradead.org>
 <1D9C0527-E277-4C3F-A80D-C4FBAA3D82E9@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1D9C0527-E277-4C3F-A80D-C4FBAA3D82E9-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/13/2015 5:16 PM, Chuck Lever wrote:

>> NFS really should be using something more similar to a scatterlist,
>> as it maps pretty well to the sk_frags in the network layer as well.
>>
>> Struct scatterlist is imprtant because it's the way the DMA mapping
>> functions takes a multi-page argument, so ayone who wants to batch
>> the S/G mapping calls needs it.
>
> An excellent topic to bring up on linux-nfs-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
>
> In the meantime, I think rpcrdma.ko would have to be responsible for
> converting struct page to struct scatterlist.
>

Fine by me, so I take it that you are OK with the proposed API?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
