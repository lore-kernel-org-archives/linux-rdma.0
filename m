From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: Set TOS field in IP header
Date: Fri, 2 Dec 2016 08:54:48 -0600
Message-ID: <20161202145448.GA22876@horosco-MOBL2.amr.corp.intel.com>
References: <20161130210934.18088-1-henry.orosco@intel.com>
 <CAJ3xEMicWkkBcz8OHqXH=ZUJZLVpJNY0qLFMBDXL-8iCm0aZWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMicWkkBcz8OHqXH=ZUJZLVpJNY0qLFMBDXL-8iCm0aZWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 30, 2016 at 10:17:22PM -0800, Or Gerlitz wrote:
> On Wed, Nov 30, 2016 at 11:09 PM, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> [...]
> > Set the TOS field in IP header with the value passed in from application.
> 
> How is TOS propagated from applications? is that through the verbs
> API, which function/param?

Using RDMA CM_API, rdma_set_option. With level = RDMA_OPTION_ID;
optname = RDMA_OPTION_ID_TOS; optval = tos value.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
