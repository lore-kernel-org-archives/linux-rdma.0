From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/8] i40iw: Change accelerated flag to bool
Date: Mon, 20 Nov 2017 15:31:55 -0600
Message-ID: <20171120213155.GB14928@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171117164657.14824-1-henry.orosco@intel.com>
 <20171117164657.14824-9-henry.orosco@intel.com>
 <20171120183954.GE29075@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171120183954.GE29075-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 11:39:54AM -0700, Jason Gunthorpe wrote:
> On Fri, Nov 17, 2017 at 10:46:57AM -0600, Henry Orosco wrote:
> > The accelerated flag only utilizes two values: 0 and 1.
> > Modify accelerated flag in struct i40iw_cm_node to bool.
> 
> I think this is not rc material
>

That's right. It can be deferred for 4.16

Shiraz
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
