From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/20] IB/hfi1,rdmavt,core: Patches for-next
Date: Fri, 28 Apr 2017 13:50:26 -0400
Message-ID: <8747fd5c-9d71-3503-186c-8a6b8ca51e75@intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <1493401510.3041.164.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493401510.3041.164.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/28/2017 01:45 PM, Doug Ledford wrote:
> On Sun, 2017-04-09 at 10:15 -0700, Dennis Dalessandro wrote:
>> Doug,
>>
>> Here are some patches for the next release. It includes the core fix
>> that did
>> not apply from my last series. Other than that this is the usual bug
>> fixes
>> and some minor clean ups.
>>
>> Patches apply on top of your for-4.12 branch and can also be found in
>> my
>> GitHub repo at: https://github.com/ddalessa/kernel/tree/for-4.12
>>
>
> Series, minus patch #2 because of community NAK, applied.
>

Looks like we are working at the same time. A v2 was literally sent 5 
minutes ago. The only changes were to drop that NAKed patch and fix up 
the soft-lockup patch so if you just want to grab:

https://patchwork.kernel.org/patch/9705175/

to replace the original:

https://patchwork.kernel.org/patch/9671675/

That would be good or I could send a separate patch with the fix-ups. 
Whichever is easiest.

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
