From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Fri, 11 Sep 2009 21:50:21 +0200
Message-ID: <f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <4A9FA945.4070408@vlnb.net>
	 <f3177b9e0909031038s22f0a1bg401629d4208fd82@mail.gmail.com>
	 <f3177b9e0909031620i10db945ep69ddc36a7044334a@mail.gmail.com>
	 <e2e108260909060617y13a1ded8jd6686d02521ecb4@mail.gmail.com>
	 <f3177b9e0909060636k6e293c06la3dfe9f929da4915@mail.gmail.com>
	 <f3177b9e0909060641i296c7aefp322712f52de9786a@mail.gmail.com>
	 <4AA4F561.504@vlnb.net>
	 <f3177b9e0909081529i4dd74faq9a6c5a4783b5ded4@mail.gmail.com>
	 <e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909090938x6b72c519teed7dfd280eac804-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 9, 2009 at 6:38 PM, Bart Van Assche<bart.vanassche-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> On Wed, Sep 9, 2009 at 12:29 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> I'm wondering why it's so easily repeatable by me, and those I work
>> with, and nobody else? =A0I have another completely different
>> configuration w/ the same issue...
>
> It would help if you could run the following test:
> * Connect an SRP initiator back-to-back to the SRP target.

Many of my tests have been back-to-back, and using different switches,
with  no effect.

> * Install an operating system combination on initiator and target wit=
h
> which SRP did not work properly under heavy load.

I'm not sure what test is being requested.  I have tried many tests
using the same OS/Dirtro/etc... combination on both target/initiator
sides.

> * Install and run OpenSM on the target if this software is not yet
> running on the target.

I do generally avoid running it in the target, so will try this test.

> * Repeat the SRP stress test on the initiator system that is connecte=
d
> back-to-back to the SRP target.

Does "SRP Stress Test" mean some specific test included w/ SCST?

>
> This will tell us whether or not the IB switch or its firmware is
> causing the SRP issues.

I've definitely removed the switch/firmware from being the cause.

I'm thinking the reason you can't repeat the test may be latency
related.  We get ~50usecs average latency (on small block sizes),
which can't be achieved using regular SSD's (and rotating drives are
nowhere close).  Maybe a ramdisk would help repeat the issue.

Thanks,

Chris
>
> Bart.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
