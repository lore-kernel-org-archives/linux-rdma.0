From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Sending and Receiving QPs with IPoIB
Date: Fri, 19 Jan 2018 12:34:28 -0700
Message-ID: <20180119193428.GA3437@ziepe.ca>
References: <5CDA63463B33C94CA80846587415F07728293A70@ORSMSX111.amr.corp.intel.com>
 <5CDA63463B33C94CA80846587415F0773A70EE41@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5CDA63463B33C94CA80846587415F0773A70EE41-8oqHQFITsIGkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wright, James C" <james.c.wright-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 19, 2018 at 06:28:15PM +0000, Sanchez, Sebastian wrote:

> Having a sending QP and a receiving QP per node in IPoIB connected
> mode is affecting HFI1 performance because of the resulting
> lopsidedness of QPn to hardware resource mappings. Therefore, we are
> investigating changing this behavior to be compliant to the RFC
> (https://tools.ietf.org/html/rfc4755#section-3.3).
> 
> On a separate email, Roland Dreier mentioned that IPoIB connected
> mode has 2 QPs for historical reasons. We *really* need to know if
> there is some technical reason the implementation is this way before
> cracking open IPoIB to change this.
> 
> Roland Dreier email:
> 
> I assume you're talking about IPoIB connected mode?
> 
> I think the reason is just historical - the code to use one QP in
> each direction was never written, and no one has cared enough to do
> it.

My strong advice is that if you care about IPoIB performance then you
implement the rdma_netdev interface and forget about connected mode.

It will be much easier for you than trying to get a patch to
completely rework IPoIB applied..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
