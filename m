From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Wed, 14 Aug 2013 09:05:11 -0400
Message-ID: <EB7BC8BD-DBB6-41EE-8D98-144F955E129C@ornl.gov>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
 <CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
 <20130812075513.43c338e1@andylap>
 <CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
 <20130812180644.447ca089@andylap>
 <CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
 <20130813075312.7cac0d46@andylap>	<20130813160612.037ea9f2@andylap>
 <1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
 <20130814092124.3f8c3b03@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130814092124.3f8c3b03@doppio>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 14, 2013, at 3:21 AM, Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org> wrote:

> Hi,
> 
> maybe some information about the environment I am
> working in:
> 
> - CentOS 6.4 with custom kernel 3.8.13
> - librdmacm / librspreload from git, tag 1.0.17
> - application started with librspreload in LD_PRELOAD environment
> 
> Currently, I have increased the value of the spin time by setting the
> default value for polling_time in the source code.
> 
> I guess that the correct way to do this is via
> configuration in /etc/rdma/rsocket/polling_time?
> 
> Concerning the rpoll() itself, some more comments/questions
> embedded below.
> 
> On Tue, 13 Aug 2013 21:44:42 +0000
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
>>>> I found a workaround for my (our) problem: in the librdmacm
>>>> code, rsocket.c, there is a global constant polling_time, which
>>>> is set to 10 microseconds at the moment.
>>>> 
>>>> I raise this to 10000 - and all of a sudden things work nicely.
>>> 
>>> I am adding the linux-rdma list to CC so Sean might see this.
>>> 
>>> If I understand what you are describing, the caller to rpoll()
>>> spins for up to 10 ms (10,000 us) before calling the real poll().
>>> 
>>> What is the purpose of the real poll() call? Is it simply a means
>>> to block the caller and avoid spinning? Or does it actually expect
>>> to detect an event?
>> 
>> When the real poll() is called, an event is expected on an fd
>> associated with the CQ's completion channel. 
> 
> The first question I would have is: why is the rpoll() split into
> these two pieces? There must have been some reason to do a busy
> loop on some local state information rather than just call the
> real poll() directly.

Sean can answer specifically, but this is a typical HPC technique. The worst thing you can do is handle an event and then block when the next event is available. This adds 1-3 us to latency which is unacceptable in HPC. In HPC, we poll. If we worry about power, we poll until we get no more events and then we poll a little more before blocking. Determining the "little more" is the fun part. ;-) 

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
