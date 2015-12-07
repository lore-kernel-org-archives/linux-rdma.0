From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/37] IB/rdmavt: Add query and modify device stubs
Date: Mon, 7 Dec 2015 14:39:04 -0700
Message-ID: <20151207213904.GA3113@obsidianresearch.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204322.8144.60452.stgit@phlsvslse11.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE72C8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE72C8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 07, 2015 at 09:26:11PM +0000, Hefty, Sean wrote:
> > +static int rvt_query_device(struct ib_device *ibdev,
> > +			    struct ib_device_attr *props,
> > +			    struct ib_udata *uhw)
> > +{
> > +	/*
> > +	 * Return rvt_dev_info.props contents
> > +	 */
> > +	return -EINVAL;
> 
> ENOSYS on all of the function templates.  This and subsequent patches.

We recently had a long discussion about what the correct answer here
is.

ENOSYS and EINVAL are both wrong for different reasons.. Can't recall
if something else was settled on? I think I was suggesting one of the
ENOTSUP varients?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
