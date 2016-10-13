From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 19:43:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161013170641.GA9094-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > I doubt they have, but they change the kernel to user library API.
> I'm
> > > not so worried about that since it's entirely under our control.
> It's
> > > the user library to application API that I would be more concerned
> > > with.
> >
> > I thought there was an agreement that since verbs implies a hardware
> implementation, then all kernel to user ABI changes to verbs would go
> through some external organization, such as the OFVWG, for discussion
> and approval.  Has that changed?
> 
> What makes OFVWG more qualified to review an ABI than linux-rdma?

We've had this discussion on the list before.  The issue is that verbs isn't just a software API.  It defines a hardware implementation.  The consensus was that some 'standards' body needed to be able to review the proposed changes and its impact.  The OFVWG was selected as the best available option.  If we want to say no, and let the linux-rdma maintainer dictate the hardware interface exported by the kernel, then, yes, that's an option.

Now, if we want to kill the notion that there's some sort of common rdma/verbs interface that all devices will be able to use effectively, and replace it with vendor specific interfaces, I would completely go along with that.  Then let user space figure out how to deal with the results.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
