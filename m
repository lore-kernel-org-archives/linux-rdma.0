From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 15:27:23 -0500
Message-ID: <c3d23cf8-ed10-73a3-7b5b-8c58b7aa4781@intel.com>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca> <20171128061517.GO29104@mtr-leonro.local>
 <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
 <20171128183910.GA21325@ziepe.ca> <1511895042.28512.6.camel@wdc.com>
 <20171128193311.GB21325@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171128193311.GB21325-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xavier_huwei-9Onoh4P/yGk@public.gmane.org" <xavier_huwei-9Onoh4P/yGk@public.gmane.org>, "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-WVlzvzqoTvw@public.gmane.org" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/28/2017 2:33 PM, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2017 at 06:50:44PM +0000, Bart Van Assche wrote:
>> On Tue, 2017-11-28 at 11:39 -0700, Jason Gunthorpe wrote:
>>> On Tue, Nov 28, 2017 at 08:20:09AM -0500, Dennis Dalessandro wrote:
>>>> I could resubmit just the series, or you could just pick the 4 driver
>>>> patches from patchworks whatever is easiest.
>>>
>>> I marked them in patchworks, but can you review the commit messages
>>> and make sure you think Linus will see them as rc material too?
>>
>> My understanding is that the rc stage is intended primarily for fixes for
>> bugs introduced during the merge window. For all patches that do not fix
>> bugs introduced during the merge window it should be evaluated carefully
>> whether or not these are important enough to be included in a rc pull request.
> 
> Oh? I thought it was more up to the maintainer discretion within some
> limits. Eg I thought we were running rdma more with the 'if it is OK
> for -stable, then it is OK -rc' kind of mentality?

That's always been my understanding.

> eg -rc is for stablization and bugfixing only, and not restricted only
> to bugs introduced in the latest merge window??

Makes no sense to me to have a hard restriction here. Security fixes, 
panics, and other serious bugs should certainly qualify. Of course that 
is subject to how complex the fix is.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
