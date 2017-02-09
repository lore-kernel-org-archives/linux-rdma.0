From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cxgb3: Use more common logging style
Date: Thu, 09 Feb 2017 14:39:43 -0800
Message-ID: <1486679983.2162.4.camel@perches.com>
References: <cover.1486678686.git.joe@perches.com>
         <15772862930dfd2f2e10574b86c063d781976a89.1486678686.git.joe@perches.com>
         <04c801d28324$a8459740$f8d0c5c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <04c801d28324$a8459740$f8d0c5c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-09 at 16:34 -0600, Steve Wise wrote:
> > Subject: [PATCH 1/4] cxgb3: Use more common logging style
[]
> > -#define MOD "iw_cxgb3: "
> > -#define PDBG(fmt, args...) pr_debug(MOD fmt, ## args)
> > +#ifdef pr_fmt
> > +#undef pr_fmt
> > +#endif
> 
> Is the ifdef/undef needed?  I see other modules just define pr_fmt() regardless.

Yes.

Because kernel.h may be included before this file,
kernel.h creates a define for pr_fmt, so this must
be undef'd before redefining it.

The other option, done in most files, is to add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
