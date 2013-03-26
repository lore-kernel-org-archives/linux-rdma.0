From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Tue, 26 Mar 2013 12:16:34 -0600
Message-ID: <20130326181634.GB22775@obsidianresearch.com>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com>
 <5151CF60.3010100@acm.org>
 <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 26, 2013 at 09:46:28AM -0700, Roland Dreier wrote:
> > Checkpatch recommends since some time to use sizeof(e) instead of sizeof e,
> > isn't it ?
> 
> I actually prefer "sizeof e" since sizeof is an operator, not a
> function.  "sizeof(e)" looks just as silly as "return(e)" to me.

Sizeof is used as an expression, return is not.

They have different precedence rules:
 return e + 1; // == return (e + 1)
vs
 sizeof e + 1;  // == sizeof(e) + 1

Or weirder:
 return (void *)x; // OK
vs
 sizeof (void *)x; // <-- compile error

Coding sizeof as a function call frees the reader from having to
check/know the obscure precedence rules for sizeof.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
