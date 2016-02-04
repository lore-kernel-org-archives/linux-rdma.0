From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging: rdma: use setup_timer() api
Date: Thu, 4 Feb 2016 12:32:07 -0500
Message-ID: <20160204173206.GA23057@phlsvsds.ph.intel.com>
References: <20160204132316.GA25672@IND12F0122> <32E1700B9017364D9B60AED9960492BC25A05B89@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25A05B89-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Gujulan Elango, Hari Prasath (H.)" <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 04, 2016 at 09:38:32AM -0600, Mike Marciniszyn wrote:
> > Subject: [PATCH] staging: rdma: use setup_timer() api
> > 
> > From: Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>
> > 
> 
> Doug,
> 
> We are going to add this to the rdmavt/hfi1/qib work, with the appropriate authorship credit.   Otherwise, there will certainly be conflicts.
> 
> Hari,
> 
> Note that ehca is going away.

Actually ehca is already gone.  From Dougs for-4.5-rc tree.

12:30:25 > ls
Kconfig  Makefile  hfi1/

Ira

> 
> In addition,  you missed exploiting the third argument to setup_timer() for the callback context.
> 
> Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
