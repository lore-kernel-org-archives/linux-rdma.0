From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/2] svcrdma: Change DMA mapping logic to avoid the page_address
 kernel API
Date: Wed, 17 Nov 2010 23:26:59 -0600
Message-ID: <4CE4B923.6030102@opengridcomputing.com>
References: <20101012203332.22154.37230.stgit@build.ogc.int>	<20101012203351.22154.42528.stgit@build.ogc.int> <AANLkTik0LkdD-Gm0FAZ-KDS605ZGTewbfejC3GEOK=2x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik0LkdD-Gm0FAZ-KDS605ZGTewbfejC3GEOK=2x-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/16/10 1:39 PM, Or Gerlitz wrote:
>   Tom Tucker<tom-/Yg/VP3ZvrM@public.gmane.org>  wrote:
>
>> This patch changes the bus mapping logic to avoid page_address() where necessary
> Hi Tom,
>
> Does "when necessary" comes to say that invocations of page_address
> which remained in the code after this patch was applied are safe and
> no kmap call is needed?

That's the premise. Please let me know if something looks suspicious.

Thanks,
Tom

> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
