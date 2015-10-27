From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4 v2] staging: ipath: ipath_driver: Use setup_timer
Date: Tue, 27 Oct 2015 14:10:42 +0300
Message-ID: <20151027111042.GD7340@mwanda>
References: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
 <CALq1K=J-jEU=-BKjnAEvuxVfMmbPn4-gdj0i4StRbrVy6ho6Ag@mail.gmail.com>
 <20151027091903.GA7340@mwanda>
 <CALq1K=LLQd4CjVr=gB68MjLy0=uoY34nJxwTgsaEWtB0vBbUng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=LLQd4CjVr=gB68MjLy0=uoY34nJxwTgsaEWtB0vBbUng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 11:45:18AM +0200, Leon Romanovsky wrote:
> On Tue, Oct 27, 2015 at 11:19 AM, Dan Carpenter
> <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On Sun, Oct 25, 2015 at 01:21:11PM +0200, Leon Romanovsky wrote:
> >> On Sun, Oct 25, 2015 at 12:17 PM, Muhammad Falak R Wani
> >> <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> Please follow standard naming convention for the patches.
> >> It should be [PATCH v2 1/4] and not [PATCH 1/4 v2].
> >
> > Does this matter?  It's in a thread so it sorts fine either way.
> It will be wise if people read guides and follow examples.
> 
> [1] https://www.kernel.org/doc/Documentation/SubmittingPatches

That document doesn't really specify one way or the other.  And even if
it did then why would you care?  Stop being so picky for no reason.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
