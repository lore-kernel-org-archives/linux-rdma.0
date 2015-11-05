From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Thu, 5 Nov 2015 10:56:27 +0300
Message-ID: <20151105075627.GR18797@mwanda>
References: <1446689411-22263-1-git-send-email-ira.weiny@intel.com>
 <1446689411-22263-4-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446689411-22263-4-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 04, 2015 at 09:10:11PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add a module paramter to toggle prescan/Fast ECN Detection.
> 
> In addition change the PRESCAN_RXQ Kconfig default to "yes".
> 
> Reviewed-by: Arthur Kepner<arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vennila Megavannan<vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hm...  In the original code we had the config entry but the code to
support this was actually disabled.  Now we are turning on the config
entry by default but the module parameter defaults to disabled.  I think
the documentation is a bit tricky because it should say that actually
enabling the config is not enough, it's still disabled.

Do we really need the config to be there?  Distros are going to enable
it.  Who is it who wants to disable the config?  Also is it better to
default to off or on for this code, what are the upsides and downsides
of that choice?

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
