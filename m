From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 09:54:20 -0700
Message-ID: <20161215165420.GA3264@obsidianresearch.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161215064807.GB811-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2016 at 08:48:07AM +0200, Leon Romanovsky wrote:

> > I was thinking more like a standard:
> >
> >   VERBS_PROVIDER_DEBUG=qp,ah,blah
> >
> > parser since other than mlx5 that is what providers use env vars for.
> 
> It is not providers only, but many other libraries in rdma-core are
> using env variables for tuning (libibverbs/librdmacm/rdma-ndd).

Other things have different requirements, eg all the *daemons* should
be using the system log and use a command line arg to enable debug,
rdma-ndd is doing it OK for instance.

I think it is reasonable to focus on small tasks, considering how much
there is to do. In this case hoisting only the provider debug
mechanism to util seems like enough and fixes the ugly problem with
i40iw where it unconditionally prints debug information to stderr..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
