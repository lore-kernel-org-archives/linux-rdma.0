From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 2/8] i40iw: Allocate a sdbuf per CQP WQE
Date: Mon, 20 Nov 2017 11:38:00 -0700
Message-ID: <20171120183800.GD29075@ziepe.ca>
References: <20171117164657.14824-1-henry.orosco@intel.com>
 <20171117164657.14824-3-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171117164657.14824-3-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 10:46:51AM -0600, Henry Orosco wrote:
> From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Currently there is only one sdbuf per Control QP(CQP) for programming
> Segment Descriptor(SD) command thus limiting the number of SD work
> requests that can be posted to one.  Allocate enough memory for one
> sdbuf per CQP SQ WQE to allow more than one SD command at a time.
> When a SD command is posted, it will use the corresponding sdbuf for
> the WQE.

It is not clear to me from this description why this would be a rc
candidate?

Is this is a bug? or is it adding a feature of increasing the number
of 'SD work requests'?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
