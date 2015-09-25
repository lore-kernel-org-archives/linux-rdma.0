From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Fri, 25 Sep 2015 11:41:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org> <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com> <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 25 Sep 2015, Or Gerlitz wrote:

> On Thu, Sep 24, 2015 at 8:00 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> > Ok here is the fixed up and tested V2 of the patch. Can this go in with
> > Doug's  patch?
>
>
> Repeating myself... do you find some over complexity in Erez's
> implementation? what's the rational for not using his patch and yes
> using yours? Erez and Co were very busy with some internal deadlines
> and he's now OOO (it's a high Holiday season now) - will be able to
> review your patch once he's back (Oct 6, I believe). It seems that the
> patch does the job, but there are locking/contexts and such to
> consider here, so I can't just ack it, have you passed it through
> testing?

Yes the patch introduces a new callback and creates workqueues that
recheck conditions etc etc.

Makes it difficult to review and potentially creates new race conditions.
I'd rather have a straightforward solution.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
