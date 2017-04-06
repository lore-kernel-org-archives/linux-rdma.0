From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu refcount
 optional for user MRs
Date: Thu, 6 Apr 2017 07:45:16 -0400
Message-ID: <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569@intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
 <20170406074955.GG2269@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170406074955.GG2269-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/06/2017 03:49 AM, Leon Romanovsky wrote:
> On Wed, Apr 05, 2017 at 08:09:16PM +0000, Marciniszyn, Mike wrote:
>>  > Is there a another way we should be looking at for setting things like this?
>>>
>>> Use vendor channel interface to configure your driver.
>>>
>>
>> What is that? configfs or something else?
>
> An immediate answer without digging into your code is Matan's KABI work.
> https://github.com/matanb10/linux/tree/abi-devel-latest

Until that code is formally accepted and actually in the kernel we can't 
base our changes that are ready to go now (for 4.12) on it.

> However, I have an question, how do you ensure that user memory has no
> users without refcounts? Will it be possible to dereg the memory despite
> the fact that there are users?

Mike can correct me if I'm wrong but it is still refcounted. Just not 
per CPU, global if you will.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
