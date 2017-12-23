From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/9] i40iw updates for 4.16
Date: Sat, 23 Dec 2017 10:27:08 -0600
Message-ID: <20171223162708.GA13848@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171222154702.12632-1-shiraz.saleem@intel.com>
 <20171222233650.GA17198@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171222233650.GA17198-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 22, 2017 at 04:36:50PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 22, 2017 at 09:46:53AM -0600, Shiraz Saleem wrote:
> > Hi Doug/Jason,
> >  
> > This patch set includes bug fixes, code refactoring, a new netdev
> > event notifier and misc. improvements. Please consider it for 4.16.
> 
> I took this from the v0 series and manually fixed the const myself.
> 
> I also fixed the checkpatch long line warnings, so please watch out
> for things like that.
> 
We try to keep our line length < 100 in general. 
Are we enforcing the 80 char line length limit? 

> Let me know if there are any errors.

Patches look fine. Thanks Jason!




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
