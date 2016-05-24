From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Tue, 24 May 2016 16:15:24 -0600
Message-ID: <20160524221524.GH7950@obsidianresearch.com>
References: <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
 <a4477030-c966-636e-e395-96857454c7de@redhat.com>
 <20160524201317.GK25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB050188@ORSMSX109.amr.corp.intel.com>
 <20160524205425.GA7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05027E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05027E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 10:08:10PM +0000, Hefty, Sean wrote:
> > > Ioctl commands are naturally scoped per open file.  Unless the
> > > opened file supports ioctls directed to every piece of hardware, I
> > > don't see why there's an obsession with command space.
> > 
> > The kernel standard is to have ioctl numbers be globally unique, even
> > though technically you are right and they are scoped to a file.
> 
> I thought the reason behind that was so that an app that sent an
> ioctl to the wrong file would get an error, rather than unspecified
> behavior.

Yes, that is an oft quoted reason, but it also allows strace to decode
all the ioctls.

> If so, collapsing all ioctls to a single command doesn't
> really solve the issue.  It's kind of like using a write interface
> instead of an ioctl interface to avoid using ioctls.  :)

The idea isn't to collapse, but to expand the decode to include some
data from the header. Instead of just dispatching on the ioctl, you
dispatch on the (ioctl,domain,command) tuple. In your patches domain
is encoded in the header, in Leon's domain & command are encoded in
the header. Doesn't really matter.

At the end of the day the decode is globally unique and does not
require scoping to the open'd file to understand.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
