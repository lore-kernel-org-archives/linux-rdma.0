From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3] staging/rdma/hfi1: set Gen3 half-swing for integrated
 devices
Date: Fri, 20 Nov 2015 07:21:11 -0800
Message-ID: <20151120152111.GA13281@kroah.com>
References: <1447711429-10389-1-git-send-email-ira.weiny@intel.com>
 <20151120011215.GI11695@kroah.com>
 <32E1700B9017364D9B60AED9960492BC259BD75C@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259BD75C-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 03:14:19PM +0000, Marciniszyn, Mike wrote:
> > > +	dd_dev_info(dd, "%s: program XMT margin, CcePcieCtrl 0x%llx\n",
> > > +		    fname, pcie_ctrl);
> > 
> > Why spam the log with this all the time?  Shouldn't this be a debug line
> > instead?
> 
> The current implementation is layered on dev_info().
> 
> Are you saying dev_dbg() is a better choice?

Yes, why would a user ever want to see that above line?  What can they
do with it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
