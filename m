From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Sat, 17 Aug 2013 00:07:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA67BD@ORSMSX109.amr.corp.intel.com>
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
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20130814092124.3f8c3b03@doppio>
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
To: Andreas Bluemle <andreas.bluemle@itxperts.de>
Cc: "Atchley, Scott" <atchleyes@ornl.gov>, Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> I am looking at a multithreaded application here, and I believe that
> the race is between thread A calling the rpoll() for POLLIN event and
> thread B calling the shutdown(SHUT_RDWR) for reading and writing of
> the (r)socket almost immediately afterwards.

I modified a test program, and I can reproduce the hang as you describe -- calling rpoll() then rshutdown() from another thread.

These calls end up calling rpoll->poll followed by rshutdown->read.  The read completes, which completes rshutdown, but the poll continues to wait for an event.  In the kernel, poll ends up in uverbs.c::ib_uverbs_event_poll, and read in uverbs.c::ib_uverbs_event_read().

The behavior of poll/read seems reasonable, so I don't think this is a kernel issue.  I'm still trying to figure out a simple solution to fixing this.

- Sean
