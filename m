From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [patch] IB/hfi1: checking for NULL instead of IS_ERR
Date: Sun, 20 Sep 2015 10:26:27 -0700
Message-ID: <20150920172627.GC27148@kroah.com>
References: <20150916062220.GC21542@mwanda>
 <55FC32ED.1000404@redhat.com>
 <20150919030153.GA30373@kroah.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1CB98D06@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CB98D06-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 19, 2015 at 10:49:52PM +0000, Weiny, Ira wrote:
> > 
> > On Fri, Sep 18, 2015 at 11:51:09AM -0400, Doug Ledford wrote:
> > > On 09/16/2015 02:22 AM, Dan Carpenter wrote:
> > > > __get_txreq() returns an ERR_PTR() but this checks for NULL so it
> > > > would oops on failure.
> > > >
> > > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >
> > > Thanks, applied.
> > 
> > Applied to what?  Should I just ignore these types of patches and not take them
> > in my tree and you will send them on later on?  I don't remember what we
> > agreed to do, sorry.
> 
> My recollection was that Doug was going to handle the staging/rdma sub-tree because of the large churn he expected between the rdma subsystem and those drivers.
> 
> Therefore, I have been submitting my patches against staging/rdma/hfi directly to Doug and Linux-rdma.

Ok, but Doug better start syncing up with me soon, as we are about to
start to get a ton of staging patches due to the Outreachy application
process, and we will start to get merge errors very quickly.

Doug, what's the plan for this?  Can you just forward me patches every
so often to sync up?  Or I can take anything that is cc: me and/or the
driverdevel mailing list.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
