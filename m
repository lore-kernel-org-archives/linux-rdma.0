From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 13:20:01 -0500
Message-ID: <20170801182001.GA284@ctung-MOBL3.amr.corp.intel.com>
References: <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <1501600807.2475.4.camel@wdc.com>
 <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
 <1501606508.2475.12.camel@wdc.com>
 <20170801171454.GA8484@ctung-MOBL3.amr.corp.intel.com>
 <1501608534.2475.14.camel@wdc.com>
 <20170801175236.GA14048@ctung-MOBL3.amr.corp.intel.com>
 <1501610305.2475.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501610305.2475.16.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 05:58:29PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 12:52 -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 05:28:54PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-08-01 at 12:14 -0500, Chien Tin Tung wrote:
> > > > On Tue, Aug 01, 2017 at 04:55:09PM +0000, Bart Van Assche wrote:
> > > > > Yes, I had read these e-mails but I do not agree with all of what was written
> > > > > in these e-mails. I'm not sure whether you are aware of the original design
> > > > > goal of the netlink mechanism? It was designed on purpose to be unreliable
> > > > > such that sending information from the kernel to user space would never block.
> > > > 
> > > > Please show me a feference to Netlink design document/email on mailing list
> > > > that specifically disallowed this?
> > > 
> > > As you probably know kernel developers do not write design documents. But there
> > > is plenty of evidence on the web that the netlink mechanism was designed to be
> > > unreliable. A quote from a Linux Journal article from 2005
> > > (http://www.linuxjournal.com/article/7356): "Netlink is asynchronous because,
> > > as with any other socket API, it provides a socket queue to smooth the burst
> > > of messages."
> > 
> > So what happens when the queue is full?  you can fail at that point or you
> > can choose the 1-shot retry with timeout as we have done.  What is _wrong_
> > with the 1-shot retry?
> 
> Why is the one-shot retry necessary? What aspect of the portmapper design makes
> this one-shot retry necessary? Why is this one-shot retry only necessary for the
> portmapper and not for any other Netlink client?

You are really asking why the 1-shot retry code is in Netlink.  We didn't code
it, we are simply using it with ibnl_unicast.  It being used as designed, when
the queue is full, try it one more time within the timeout parameter.  Other clients
can use it too, I'm not stopping them.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
