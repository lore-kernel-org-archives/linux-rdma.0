From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v6 17/46] infiniband: dma-mapping: Use unsigned long for
 dma_attrs
Date: Wed, 13 Jul 2016 13:03:36 +0200
Message-ID: <57862008.1080502@samsung.com>
References: <1468399167-28083-1-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-5-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-6-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-7-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-8-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-9-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-10-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-11-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-12-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-13-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-14-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-15-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-16-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-17-git-send-email-k.kozlowski@samsung.com>
 <3ed39f35-f19e-1593-72a5-0d7240fa7a4e@sandisk.com>
 <57861C2A.2090206@samsung.com>
 <6f3511c2-0795-ce1a-44c4-426feaf97c03@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <6f3511c2-0795-ce1a-44c4-426feaf97c03-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/13/2016 12:56 PM, Bart Van Assche wrote:
> On 07/13/2016 05:47 PM, Krzysztof Kozlowski wrote:
>> On 07/13/2016 12:37 PM, Bart Van Assche wrote:
>>> On 07/13/2016 03:41 PM, Krzysztof Kozlowski wrote:
>>>> Split out subsystem specific changes for easier reviews. This will be
>>>> squashed with main commit.
>>>
>>> Apparently my comment has been ignored
>>> (http://thread.gmane.org/gmane.linux.ports.m68k/8746/focus=37703). Are
>>> you aware that you are expected to reply to feedback on patches?
>>
>> Of course your comment was not ignored. I am sorry that you have such
>> impression. However I thought you are referring only to local variable
>> which name I changed.
>>
>> Do you want me to rename also the argument in the ib_dma_map_sg_attrs()
>> and ib_dma_unmap_sg_attrs() functions?
> 
> Hello Krzysztof,
> 
> Sorry if I was not clear enough in the comment I had posted in reply to
> the previous version of this patch series. In my comment I wanted indeed
> to refer to the name of the ib_dma_map_sg_attrs() /
> ib_dma_unmap_sg_attrs() function argument. An argument with the name
> "attrs" namely does not explain what kind of attributes that argument
> refers to ...

I can rename it, no problem. It looks to me a little bit redundant
information as these are just wrappers over dma_{map,unmap}_sg_attrs()
where the attrs are also used. Everything there refers to the mapping of
scatter gather list. Anyway, renaming won't harm neither so let me send
a follow up only for this patch.

Thanks for feedback!
Krzysztof

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
