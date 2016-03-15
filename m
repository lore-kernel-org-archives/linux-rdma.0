From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Mon, 14 Mar 2016 21:20:50 -0400
Message-ID: <20160315012049.GA30055@phlsvsds.ph.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com> <CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com> <20160309002157.GA20105@phlsvsds.ph.intel.com> <20160309050731.GM13396@leon.nu> <20160309192109.GB15031@phlsvsds.ph.intel.com> <20160310045609.GC1977@leon.nu> <20160314070951.GB26456@leon.nu> <20160314120152.GA30838@phlsvsds.ph.intel.com> <CAJ3xEMiSgXFT46r0Y7DZGr3mpJFSLrtYrMdz+DbCXDozbMYZRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiSgXFT46r0Y7DZGr3mpJFSLrtYrMdz+DbCXDozbMYZRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2016 at 11:19:53PM +0200, Or Gerlitz wrote:
>On Mon, Mar 14, 2016 at 2:01 PM, Dennis Dalessandro
><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Mar 14, 2016 at 09:09:51AM +0200, Leon Romanovsky wrote:
>>>
>>> Hi Doug,
>>> I saw that you picked these patches and it is now in your github
>>> repository. Since the original author probably missed my and Or's
>>> questions, It
>>> will be great if you can share with us your technical view on the topic.
>>>
>>> In addition to my question regarding appropriate layer - IB/core. MM, I
>>> see that
>>> it can be natively implemented in user-space layer too.
>
>> The original author did not miss your questions. When I say "we" or "our"
>> you can be assured that includes the original author.
>
>Just to make sure we're on the same page(...) submitting code to the
>upstream kernel is not send-and-forget, authors should respond to
>questions posed on their patches and this is very much not the case
>how you act here.
>
>> Our position continues to be that this is best located in the hfi1 driver.
>> If something else comes along that can make use of the same/similar
>> functionality we can then move it to the core or elsewhere, once we have a
>> better understanding of the use cases and how best to generalize the code.
>
>As I wrote your on this thread, you have all you need in user-space,
>expect for mmu notifications for cache entries which were invalidated
>by memunmaps, which indeed should originate from the kernel -- as such
>the cache doesn't belong to the kernel at all. You didn't respond on
>that, just ignored, and now again talking on the cache being in the
>core, why?

I said "core or elsewhere". Elsewhere may well include user space. That is 
just a different solution than what we have proposed. I agree that it is 
certainly one alternative. I'd like to see what Doug's opinion on the matter 
is.

>Doug, As Dennis noted, you already picked ~300 patches for 4.6 / hfi1
>driver from him. I don't see why picking this patch series there too
>and not letting us to further discuss it out, thoughts?
>
>Or.

I believe in taking an iterative approach to kernel development, if the code 
doesn't cause problems I don't see any harm adding the series. If Doug 
agrees with you and doesn't like this approach but is willing to let it 
stand for now,  I think the changes can be done in a subsequent release.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
