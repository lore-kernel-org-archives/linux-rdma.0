From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: PCIe 2.0 motherboard + ConnectX-3 cards
Date: Mon, 25 Nov 2013 21:08:15 -0500
Message-ID: <CADPSxAhD-aSuFa7qYP6XCvFpVhawv6n17uL1zFtcsKakVyWKZA@mail.gmail.com>
References: <CADPSxAhPhtMegUYmjVS6qZGsWVAbYKeOGRKz1CG9oK3S-pgD7w@mail.gmail.com>
	<CADPSxAi06+_zjJ50v7CgCDzv+abDowN0pxBEgAZKwKBGPCe1ig@mail.gmail.com>
	<CADPSxAjCqk8GqQ9cQiceZk2fbrPuQdRWDoBSfkgLesVpVOc-fg@mail.gmail.com>
	<52923E1B.6000003@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52923E1B.6000003-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve,

Thanks for the confirmation.

--Anuj

On Sun, Nov 24, 2013 at 12:57 PM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 11/22/2013 10:13 PM, Anuj Kalia wrote:
>>
>> Update: I found ways to improve active side performance from 10
>> million RDMA writes per second to 20 million (which I believe is the
>> PCIe bottleneck):
>>
>> 1. Use inline payload - I think this reduces PCIe traffic.
>
>
> Yes, without inline, each IO requires 2 PCIe transactions:  1 to fetch (or
> push) the work request, and one to fetch the payload/data.  If you use
> inline, the data is included in the work request.  So you cut the required
> transactions in half.
>
>
>> 2. Use non-signalled RDMA writes + don't poll for completion for every
>> write - I don't know if ibv_poll_cq() uses the PCIe much.
>
>
> Each signaled work request generates a completion entry (CQE) which is
> pushed from the adapter into the CQ in host memory.  So reducing the number
> of these required also reduces the PCIe transactions.
>
> Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
