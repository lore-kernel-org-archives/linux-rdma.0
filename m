From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] staging/rdma/hfi1: Method to toggle "fast ECN" detection
Date: Thu, 5 Nov 2015 12:02:25 -0500
Message-ID: <20151105170224.GB14837@phlsvsds.ph.intel.com>
References: <1446689411-22263-1-git-send-email-ira.weiny@intel.com> <1446689411-22263-4-git-send-email-ira.weiny@intel.com> <20151105075627.GR18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151105075627.GR18797@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 10:56:27AM +0300, Dan Carpenter wrote:
> On Wed, Nov 04, 2015 at 09:10:11PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Add a module paramter to toggle prescan/Fast ECN Detection.
> > 
> > In addition change the PRESCAN_RXQ Kconfig default to "yes".
> > 
> > Reviewed-by: Arthur Kepner<arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Mike Marciniszyn<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Vennila Megavannan<vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Hm...  In the original code we had the config entry but the code to
> support this was actually disabled.  Now we are turning on the config
> entry by default but the module parameter defaults to disabled.  I think
> the documentation is a bit tricky because it should say that actually
> enabling the config is not enough, it's still disabled.

We tried to make it clear but obviously missed the mark.

> 
> Do we really need the config to be there?  Distros are going to enable it.
> Who is it who wants to disable the config?

The config is maintained to be able to fully remove the code to obtain the
maximum receive performance _if_ the customer knows that they will never need
the prescanning.  This is the _ultimate_ in performance on this path.  We
anticipate some HPC customers who build their own kernels may want this option.

>
> Also is it better to
> default to off or on for this code, what are the upsides and downsides
> of that choice?
> 

I'll update the commit message.  But will also explain here.

Enabling the code with the config option introduces a _slight_ performance
impact but allows the user to determine if this congestion control fix should
be active or not at run time.  You are correct that most distros will enable
the config options (default Yes).  Therefore this becomes a system admin
control item for the fabric being configured.  After testing we found that this
was the best compromise for most systems in terms of performance and
flexibility.  This is because prescanning is not required most of the time.
Should a customer find that their topology and/or workload requires prescanning
they can then enable this option at run time.  This will result in a
significant reduction of performance at the node level but may for those
customers result in better overall fabric/cluster performance.

So in conclusion we have 3 performance levels and the combination in this patch
puts us at the "middle one".

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
