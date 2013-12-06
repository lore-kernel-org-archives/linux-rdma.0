From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Size of Infiniband packets
Date: Fri, 6 Dec 2013 18:08:13 -0500
Message-ID: <CADPSxAh8StoEcmS+Gi9BBKnfWaU=VuFPq0PJcdrtE2WFZfLZvw@mail.gmail.com>
References: <CADPSxAgSdWTkNBF=XEptKU0oVmqiXRVtd-m-c+ntnQyxMzDFNA@mail.gmail.com>
	<20131205235334.GC20137@obsidianresearch.com>
	<1AC3E3259C454E07A5DD2216E79F2EA8@md.baymicrosystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1AC3E3259C454E07A5DD2216E79F2EA8-+IkoAhRkys/CbFgIbBqbbjGjJy/sRE9J@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

@Jason, Thanks! I'll read about the headers now.

@Suresh, Thanks for the correction. Sorry for the duplicate email..

On Fri, Dec 6, 2013 at 10:31 AM, Suresh Shelvapille
<suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org> wrote:
> It is more like 61.5Milpkts, but this is assuming PCIe-2 overhead 26Gpbs I think, but with pci3.0 we should get more
> like 70mil pkts/sec I believe.
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason
>> Gunthorpe
>> Sent: Thursday, December 05, 2013 6:54 PM
>> To: Anuj Kalia
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: Size of Infiniband packets
>>
>> On Thu, Dec 05, 2013 at 06:22:57PM -0500, Anuj Kalia wrote:
>>
>> > I'm trying to do a back-of-the-hand calculation of the number of
>> > packets per second that can be transmitted over 40Gbps Infiniband. I
>> > need some information about the packet size to do this calculation.
>> >
>> > Suppose I do an 8 byte RDMA write over RC transport. What is the
>> > packet size that is  transmitted on the wire? This should include
>> > Infiniband headers and the work request.
>>
>> See page 257 (Figure 76) of IB Spec volume 1.
>>
>> A RDMA write will contain:
>>  LRH 8
>>  BTH 12
>>  RETH 16
>>  data 8
>>  ICRC 4
>>  VCRC 2
>>
>> Plus 2 bytes of framing is 52 bytes. IB is defined to sustain
>> continuous back-to-back packets, so
>>   3200MB/sec / 52 bytes/packet = 615 million pkts/sec
>>
>> --
>> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
>> Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
