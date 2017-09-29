From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-4.14-rc] RDMA/core: Correct nlmsg_len after
 appending attributes
Date: Fri, 29 Sep 2017 11:04:33 -0500
Message-ID: <20170929160433.GA15492@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170929132501.15440-1-shiraz.saleem@intel.com>
 <20170929144117.GA2965@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929144117.GA2965-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 29, 2017 at 05:41:17PM +0300, Leon Romanovsky wrote:
> On Fri, Sep 29, 2017 at 08:25:01AM -0500, Shiraz Saleem wrote:
> > Commit 1a1c116f3dcf removes nlmsg_len calculation in
> > ibnl_put_attr causing netlink messages to be rejected due
> > to incorrect length.
> >
> > Add nlmsg_end after all attributes are appended to calculate
> > the nlmsg_len.
> >
> > Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Except the fact that title is a little bit misleading and better to be
> "IB/iwpm: Properly mark end of netlink messages".
> 
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> And while you are there, can you please fix manual usage of NLMSG_DONE?
> 
> The need to call manually to send_nlmsg_done() indicates wrongly
> implemented calculations of netlink size and improper handling of
> multi messages.
> 
> In properly handled netlink code, the NLMSG_DONE is sent automatically.
> 

Ok. We ll review the usage of send_nlmsg_done() and send a seperate patch
to fix if required.

Shiraz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
