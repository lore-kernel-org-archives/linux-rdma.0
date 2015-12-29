From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 29 Dec 2015 01:21:26 -0800
Message-ID: <20151229092126.GB8445@infradead.org>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
 <20151222181905.GA742@phlsvsds.ph.intel.com>
 <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com>
 <20151223200727.GA6886@phlsvsds.ph.intel.com>
 <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com>
 <20151224161415.GA674@phlsvsds.ph.intel.com>
 <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Moni,

On Sun, Dec 27, 2015 at 07:54:46PM +0200, Moni Shoua wrote:
> But you post *now* a so called generic driver so it must now fit any
> possible driver (including Soft RoCE)

it's never going to fit any possible future driver.  Dennis and folks
have done great work to move code outside the drivers into a shared
library.  So far it's been driven just by the Intel drivers as that's
the only thing they were interested in.

If you are interested in supporting SoftROCE please work with them
by adjusting the code towards your requirements.  In Linux we have
great results with iterative appoaches and I'd suggest you try it
as well.

> What kind of a feedback you expect when I don't have an idea about
> your plans for rdmavt
> Interfaces, flows, data structures... all is missing from the
> documentation to rdmavt.

You've got the code, so let's work based on that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
