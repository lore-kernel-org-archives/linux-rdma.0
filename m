From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add rdmavt support in HFI1
Date: Tue, 22 Dec 2015 14:15:08 -0500
Message-ID: <20151222191508.GO3860@phlsvsds.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com> <20151221061214.GD3860@phlsvsds.ph.intel.com> <20151221220235.GA14142@kroah.com> <20151222001943.GM3860@phlsvsds.ph.intel.com> <20151222010148.GB2145@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151222010148.GB2145-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 05:01:48PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> On Mon, Dec 21, 2015 at 07:19:43PM -0500, ira.weiny wrote:
> > On Mon, Dec 21, 2015 at 02:02:35PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> > > On Mon, Dec 21, 2015 at 01:12:14AM -0500, ira.weiny wrote:
> > > > Greg, Doug,
> > > > 
> > > > As mentioned below, these patches depend on the new rdmavt library submitted to
> > > > Doug on linux-rdma.
> > > > 
> > > > We continue to identify (and rework) patches by our other developers which can
> > > > be submitted without conflicts with this series.  Furthermore, We have, as much
> > > > as possible, placed fixes directly into rdmavt such that those changes can be
> > > > dropped from hfi1.  But at this point, we need to know if and where these are
> > > > going to land so that we can start reworking as appropriate.
> > > > 
> > > > Therefore, I would like to discuss plans to get hfi1 under the same maintainer
> > > > to work through this transitional period.
> > > > 
> > > > Basically, At what point should we stop submitting patches to Greg and start
> > > > submitting to Doug?
> > > > 
> > > > Should we consider the merge window itself as the swap over point and submit
> > > > changes to Doug at that point?  If so, should we continue to submit what we can
> > > > to Greg until then (and continue rebase'ing the series below on that work)?  Or
> > > > given Gregs backlog, should we stop submitting to Greg sometime prior to the
> > > > merge window?
> > > > 
> > > > That brings up my final question, at the point of swap over I assume anything
> > > > not accepted by Greg should be considered rejected and we need to resubmit to
> > > > Doug?
> > > 
> > > If Doug accepts the library changes, let me know that public git commit
> > > and I can pull it into the staging-next branch and you can continue to
> > > send me staging patches that way.
> > 
> > Won't this cause a conflict during the merge window?
> 
> No, git is good :)
> 
> > How do we handle changes which affect both qib and hfi1?
> 
> I don't know, now this gets messy...
> 

Agreed and this is what we are worried about.

Can we do what Dan and Doug have proposed in the past and have Doug take over
the staging/rdma sub-tree?

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-November/081922.html

I think the upcoming merge window is a reasonable time for him to do that.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
