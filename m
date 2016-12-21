From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/i40iw: use designated initializers
Date: Wed, 21 Dec 2016 08:24:51 -0600
Message-ID: <20161221142451.GA12384@ssaleem-MOBL4.amr.corp.intel.com>
References: <20161217010542.GA140742@beast>
 <9DD61F30A802C4429A01CA4200E302A7301B89C9@fmsmsx116.amr.corp.intel.com>
 <CAGXu5j+Jj_yuNotEwLb-DjW3Pg--4EeZkthnd47PR-=KycxC_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Jj_yuNotEwLb-DjW3Pg--4EeZkthnd47PR-=KycxC_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 20, 2016 at 12:04:52PM -0800, Kees Cook wrote:
> On Mon, Dec 19, 2016 at 12:40 PM, Saleem, Shiraz
> <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > I see how this patch improves readability but not sure why it throws a compiler error/warning?
> 
> This doesn't cause a compiler warning without the gcc plugin
> "randstruct" (which is coming soon). Under randstruct, structure
> layouts can be randomized, so "ordered" initializers (as they are
> currently) cannot be used. Instead, "designated" initializers are
> needed, which is what this patch adds. There is no actual difference
> in the resulting output; it just allows for the randstruct plugin to
> operate correctly.
> 
> -Kees
> 
> >
> > Shiraz
> >
> >> Subject: RE: [PATCH] RDMA/i40iw: use designated initializers
> >>
> >> Hi Kees - Can you send the associated compiler warning?
> >>
> >> Shiraz
> >>
> >>
> >> > Subject: [PATCH] RDMA/i40iw: use designated initializers
> >> >
> >> > Prepare to mark sensitive kernel structures for randomization by
> >> > making sure they're using designated initializers. These were
> >> > identified during allyesconfig builds of x86, arm, and arm64, with most initializer
> >> fixes extracted from grsecurity.
> >> >
> >> > Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Thank you for the patch.

Acked-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
