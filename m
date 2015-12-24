From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add rdmavt support in HFI1
Date: Thu, 24 Dec 2015 12:50:37 -0500
Message-ID: <20151224175037.GB22759@phlsvsds.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com> <20151221061214.GD3860@phlsvsds.ph.intel.com> <20151221220235.GA14142@kroah.com> <20151222001943.GM3860@phlsvsds.ph.intel.com> <20151222010148.GB2145@kroah.com> <20151222191508.GO3860@phlsvsds.ph.intel.com> <20151223022757.GA5562@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151223022757.GA5562-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 06:27:57PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> On Tue, Dec 22, 2015 at 02:15:08PM -0500, ira.weiny wrote:
> > On Mon, Dec 21, 2015 at 05:01:48PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:

[snip]

> > > 
> > > No, git is good :)
> > > 
> > > > How do we handle changes which affect both qib and hfi1?
> > > 
> > > I don't know, now this gets messy...
> > > 
> > 
> > Agreed and this is what we are worried about.
> > 
> > Can we do what Dan and Doug have proposed in the past and have Doug take over
> > the staging/rdma sub-tree?
> > 
> > http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-November/081922.html
> > 
> > I think the upcoming merge window is a reasonable time for him to do that.
> 
> Ok, but keeping on top of all of the generic staging patches that come
> in is a tough thing to do, that's up to Doug, if he is ready for it...
> 

To help this process, once the change over happens, we will help to monitor
driverdev-devel for anything submitted to staging/rdma.  If something is
submitted which was not to Doug and linux-rdma we can handle alerting the
submitter to make sure it gets submitted to Doug as per the current MAINTAINERS
file.

Hope this helps,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
