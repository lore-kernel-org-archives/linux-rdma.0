From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 10:06:41 -0700
Message-ID: <20161013170641.GA9094@infradead.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB095429-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 05:02:13PM +0000, Hefty, Sean wrote:
> > I doubt they have, but they change the kernel to user library API.  I'm
> > not so worried about that since it's entirely under our control.  It's
> > the user library to application API that I would be more concerned
> > with.
> 
> I thought there was an agreement that since verbs implies a hardware implementation, then all kernel to user ABI changes to verbs would go through some external organization, such as the OFVWG, for discussion and approval.  Has that changed? 

What makes OFVWG more qualified to review an ABI than linux-rdma?

That beeing said a review by an independent third party in addition to
the vensors (intentional plural here!) is important, but I think we can
handle that just fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
