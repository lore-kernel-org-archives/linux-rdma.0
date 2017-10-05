From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] IB/hfi1, core, rdmavt: Driver fixes for
 10/2/2017
Date: Wed, 4 Oct 2017 21:22:06 -0400
Message-ID: <2e195006-92f1-0d6c-1418-5c541f38f8e3@intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <1507146261.46071.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507146261.46071.8.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/4/2017 3:44 PM, Doug Ledford wrote:
> On Mon, 2017-10-02 at 11:03 -0700, Dennis Dalessandro wrote:
>> Hi Doug,
>> There are a couple fixes in here that would have been nice to get
>> into the RC
>> cycle, including one marked stable. However I think you will find
>> them to be
>> too many LOC for an rc-4 submission so I have sent them in one series
>> for-next.
>> Patches 2,3,4 and 5 are the fixes. Patch 2 is small but it's not
>> really that
>> important to the end user.
>>
>> There are some clean ups in here from Don from the 16B changes. One
>> takes care
>> of some sparse warnings and the other two are from a WARN_ON_ONCE
>> that needed
>> special cased for OPA.
>>
>> Patches can can also be found in my GitHub repo at:
>> https://github.com/ddalessa/kernel/tree/for-4.15
> 
> Hi Denny,
> 
> I didn't process that you mixed for-rc and for-next stuff in a single
> thread before I had gone through and looked at the patches and
> processed them.  So, this time they all went to for-next.  In the
> future, you really need patches you want in for-rc separate from the
> patches intended for for-next.

Maybe I wasn't too clear, I didn't intend any of those to go for-rc. So 
yep for-next was the right target.

I would have liked to get the fixes into -rc but they were just too 
complex for this late in the game is all I meant.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
