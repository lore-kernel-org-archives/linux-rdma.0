From: Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Wed, 21 Aug 2013 19:44:27 +0800
Message-ID: <CAJA05U=hROsNESLXjpSgTuZfLLofXF7CzYW+=i0nvy6Y-cDDHw@mail.gmail.com>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
	<CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
	<20130812075513.43c338e1@andylap>
	<CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
	<20130812180644.447ca089@andylap>
	<CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
	<20130813075312.7cac0d46@andylap>
	<20130813160612.037ea9f2@andylap>
	<1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
	<1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
	<20130814092124.3f8c3b03@doppio>
	<1828884A29C6694DAF28B7E6B8A8237388CA6C27@ORSMSX109.amr.corp.intel.com>
	<20130820092113.612cf7a2@andylap>
	<20130820123046.2ceb5e77@andylap>
	<1828884A29C6694DAF28B7E6B8A8237388CA6F25@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA6F25-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I tested out the patch and unfortunately had the same results as
Andreas. About 50% of the time the rpoll() thread in Ceph still hangs
when rshutdown() is called. I saw a similar behaviour when increasing
the poll time on the pre-patched version if that's of any relevance.

Thanks

On Tue, Aug 20, 2013 at 11:04 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I have added the patch and re-tested: I still encounter
>> hangs of my application. I am not quite sure whether the
>> I hit the same error on the shutdown because now I don't hit
>> the error always, but only every now and then.
>
> I guess this is at least some progress... :/
>
>> WHen adding the patch to my code base (git tag v1.0.17) I notice
>> an offset of "-34 lines". Which code base are you using?
>
> This patch was generated against the tip of the git tree.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
