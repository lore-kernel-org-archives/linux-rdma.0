From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt and IB/hfi1: Disable by default
Date: Mon, 18 Jul 2016 08:10:14 -0700
Message-ID: <1a4e1438-dbdc-edc1-611d-3b8b845f56c3@sandisk.com>
References: <ef7f1f80-68c4-b8d5-f40b-9bcef5b95e21@sandisk.com>
 <1468853088.2650.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468853088.2650.7.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/18/2016 07:44 AM, Dalessandro, Dennis wrote:
> On Mon, 2016-07-18 at 07:18 -0700, Bart Van Assche wrote:
>> There is a strict policy in the Linux kernel that new drivers must be
>> disabled by default. Hence change "default m" into "default n" for
>> the rdmavt and the hfi1 drivers.
>
> Looking at the other drivers in the rdma tree they don't seem to
> specify a default, is that the same as 'n'?

Hello Denny,

Although I haven't found any information about this in 
https://www.kernel.org/doc/Documentation/kbuild/kconfig-language.txt, I 
assume that leaving out "default n" is the same as "default n".

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
