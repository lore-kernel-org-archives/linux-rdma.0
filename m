From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Tue, 20 Aug 2013 15:04:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA6F25@ORSMSX109.amr.corp.intel.com>
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
	<1828884A29C6694DAF28B7E6B8A8237388CA6C27@ORSMSX109.amr.corp.intel.com>
	<20130820092113.612cf7a2@andylap> <20130820123046.2ceb5e77@andylap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20130820123046.2ceb5e77@andylap>
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
To: Andreas Bluemle <andreas.bluemle@itxperts.de>
Cc: "Atchley, Scott" <atchleyes@ornl.gov>, Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> I have added the patch and re-tested: I still encounter
> hangs of my application. I am not quite sure whether the
> I hit the same error on the shutdown because now I don't hit
> the error always, but only every now and then.

I guess this is at least some progress... :/
 
> WHen adding the patch to my code base (git tag v1.0.17) I notice
> an offset of "-34 lines". Which code base are you using?

This patch was generated against the tip of the git tree. 

