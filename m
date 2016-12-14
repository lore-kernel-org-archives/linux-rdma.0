From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Wed, 14 Dec 2016 14:21:03 -0700
Message-ID: <20161214212103.GA6947@obsidianresearch.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161214171111.GA4521-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 14, 2016 at 07:11:11PM +0200, Leon Romanovsky wrote:

> > > This patch duplicates already existing code in most of providers and libraries
> > > in rdma-core, while two of our main goals for creating this consolidated
> > > library were simplification for users and reduce code duplication.
> > >
> > > It will be very beneficial if you:
> > > 1. Use and promote general pr_debug(..), srp_tools has nice piece of code,
> > > to be general code.
> >
> > [Tatyana Nikolova] The debug/error printing macros available in
> > rdma-core use different mechanisms to report information, for
> > instance, they set/check one or more variables, or they use a bit
> > mask to enable debug level. They also print to different outputs:
> > stderr/stdout, debug files or syslog.
> 
> At the end, all these prints are for debug. It is hard to see any
> objections to see output from them in one place.

Yes, let us just use stderr for now for provider debugging. If someone
wants syslog then that can be a later patch. It makes no sense that
there are difference here.

> in rdma-core/util/env.h|c
> 
> #define SET_VAR(type, var, field) \
> 		(struct ##name*)env->field = get_env_var(...)
> 
> void *get_env_vars(enum typ)
> {
> 	void *env;
> 	switch(type) {
> 	case I40W_ENV:
> 		env = malloc(sizeof(struct i40w_env));
> 		....
> 		SET_VAR(i40w_env, "I40W_DEBUG", debug);
> 		...
> }

Why?

I was thinking more like a standard:

  VERBS_PROVIDER_DEBUG=qp,ah,blah

parser since other than mlx5 that is what providers use env vars for.

I'm not sure I agree at all with what mlx5 is doing with tuning
parameters via env vars :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
