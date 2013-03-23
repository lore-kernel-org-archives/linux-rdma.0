From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Sat, 23 Mar 2013 17:54:35 -0500
Message-ID: <514E32AB.3060309@opengridcomputing.com>
References: <20130130210006.GA22134@elgon.mountain> <51099270.5070406@opengridcomputing.com> <20130323213038.GA14080@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130323213038.GA14080@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/23/2013 4:30 PM, Dan Carpenter wrote:
> On Wed, Jan 30, 2013 at 03:36:48PM -0600, Steve Wise wrote:
>> I wonder, then, what the correct service is to get the cpu physical
>> address from a kernel virtual address returned from
>> dma_alloc_coherent()?  I think this is correct as-is, since I think
>> dma_alloc_coherent() falls under the "directly mapped" addresses in
>> the virt_to_phys() prototype comment.
>>
>> What do you think Roland?
> In the end, we decided this was correct as-is?

I think the code is correct as-is.

> I'm about to complain to the caif network people about the
> dma_alloc_coherent() -> virt_to_phys() thing, but the truth is I
> don't understand this stuff very well and I'm not sure when it's ok
> or not.
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
