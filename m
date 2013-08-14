From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Wed, 14 Aug 2013 17:04:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA5D3E@ORSMSX109.amr.corp.intel.com>
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
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The first question I would have is: why is the rpoll() split into
> these two pieces? There must have been some reason to do a busy
> loop on some local state information rather than just call the
> real poll() directly.

As Scott mentioned in his email, this is done for performance reasons.  The cost of always dropping into the kernel is too high for HPC.

> I am looking at a multithreaded application here, and I believe that
> the race is between thread A calling the rpoll() for POLLIN event and
> thread B calling the shutdown(SHUT_RDWR) for reading and writing of
> the (r)socket almost immediately afterwards.

Ah - this is likely the issue.  I did not assume that rshutdown() would be called simultaneously with rpoll().  I need to think about how to solve this, so that rpoll() unblocks.
 
> I think that the shutdown itself does not cause a POLLHUP event to be
> generated from the kernel to interupt the real poll().
> (BTW: which kernel module implements the poll() for rsockets?
> Is that ib_uverbs.ko with ib_uverbs_poll_cq()?)

The POLLHUP event in rsockets is just software indicating that such an 'event' occurred - basically when a call to rpoll() detects that the rsocket state is disconnected.

I believe that the real poll() call traps into ib_uverbs_event_poll() in the kernel.  The fd associated with the poll call corresponds to a 'completion channel', which is used to report events which occur on a CQ.  Connection related events don't actually go to that fd - only completions for data transfers.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
