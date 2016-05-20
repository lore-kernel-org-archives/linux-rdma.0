From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] libibverbs: add ARM64 memory barrier macros
Date: Fri, 20 May 2016 15:20:23 -0500
Message-ID: <015501d1b2d5$0a020de0$1e0629a0$@opengridcomputing.com>
References: <20160520163207.B99DCE0B9D@smtp.ogc.us> <9C6B67F36DCAFC479B1CF6A967258A8C7DDBB201@ORSMSX115.amr.corp.intel.com> <011001d1b2c6$a95a6f40$fc0f4dc0$@opengridcomputing.com> <011e01d1b2c7$e9a70c10$bcf52430$@opengridcomputing.com> <2dc25c9c-748c-098c-f7a1-5d6e59504308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2dc25c9c-748c-098c-f7a1-5d6e59504308-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Woodruff Robert J' <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >> I could utilize the code from FreeBSD.  Does that allow me to submit this
to
> >> libibverbs under the dual GPL/BSD license?
> >>
> >
> > I think I can just re-implement these services myself based published works
> > describing the memory barrier assembly for ARM (like the document Jason
> > referenced earlier).  That will avoid any tainting.
> >
> > Doug: Will that work?
> 
> Either way works actually.  IANAL, but I've been told this multiple
> times and will relay my possibly flawed memory of the legal issue.  The
> original patch, even though lifted from the linux kernel, is likely to
> fall under the scope of "operationally defined" code.  In other words,
> the specific patch you wrote and the thing it implemented is so rigidly
> defined by what it does, that there really is little to no room for any
> different expression of the code.  When there is no room for different
> expressions, the code is not copyrightable.
> 

That makes too much sense... ;)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
