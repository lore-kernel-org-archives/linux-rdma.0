From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 03/37] IB/rdmavt: Add protection domain to rdmavt.
Date: Tue, 8 Dec 2015 09:20:27 +0200
Message-ID: <20151208072027.GF7313@leon.nu>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204309.8144.26707.stgit@phlsvslse11.ph.intel.com>
 <20151208062816.GE7313@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208062816.GE7313-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 08:28:17AM +0200, Leon Romanovsky wrote:
> On Mon, Dec 07, 2015 at 03:43:10PM -0500, Dennis Dalessandro wrote:
> > +
> > +/*
> > + * Things that are driver specific, module parameters in hfi1 and qib
> > + */
> > +struct rvt_driver_params {
> > +	int max_pds;
> Can it be negative value?
> > +};
Forget my question, I see, you removed this variable in the following patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
