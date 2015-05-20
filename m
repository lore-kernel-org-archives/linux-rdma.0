From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Wed, 20 May 2015 11:34:00 -0600
Message-ID: <20150520173400.GB28496@obsidianresearch.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB243E@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMhkpYYtzrsOw=8JQOekpVT6xQC9P2itH3H3oAjjPfWrng@mail.gmail.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB2677@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMj8zmqj_3=ms9CXxrFVmmk7ZHHtcPXGJcAO24n1U_MSiQ@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E11082B44@CRSMSX101.amr.corp.intel.com>
 <20150519192141.GS18675@obsidianresearch.com>
 <20150519192614.GA31717@phlsvsds.ph.intel.com>
 <20150519192842.GB23612@obsidianresearch.com>
 <20150520090505.GA19896@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDD971@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDD971-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 04:13:59PM +0000, Hefty, Sean wrote:
> > The other issue is that each caller in the kernel specifies a different
> > timeout.  Defining this in 1 central place and allowing user space to
> > control
> > the policy of that timeout is much better than allowing the kernel clients
> > to
> > specify the timeout as they do now.
> 
> Everything has been randomly hard-coded.  IMO, the sa_query module
> should use its own timeout value, which it updates based on how fast
> it actually gets responses.  But that takes too much work, and no
> one is ever going to write the code to do this.

The IB spec actually says how to compute the timeout for the SA, and
if done properly the SM will configure a timeout appropriate for the
network. It looks like everything the kernel does in this area is
basically wrong..

> For the netlink specific problem, I'll propose using a different
> randomly hard-coded value as a timeout.  Then define an 'MRA' type
> of message that user space can send to the kernel in order to ask it
> to wait longer.  The 'set timeout' message could apply to a single
> request or all future requests.  If we only wanted to the 'all
> future requests' option, the data value could be written into a
> file.  In any case, this pushes the policy of the timeout value into
> the hands of the responding daemon.

A fixed will known timeout (5s?) and require that user space send a
'operation in progress' positive liveness indication seems very
reasonable.

The only purpose of the timeout is to detect a locked up daemon so IB
doesn't lock up, so a watchdog like scheme seems appropriate.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
