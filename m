From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 29 Dec 2015 16:03:27 +0200
Message-ID: <CAG9sBKPxMe_fbmB3tm+rwj3rFyTHdeTXn6jcUaQz_5rDViEdRg@mail.gmail.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
	<20151222181905.GA742@phlsvsds.ph.intel.com>
	<CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com>
	<20151223200727.GA6886@phlsvsds.ph.intel.com>
	<CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com>
	<20151224161415.GA674@phlsvsds.ph.intel.com>
	<CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com>
	<20151228203249.GA4213@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228203249.GA4213-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> No. PIO and SDMA is driver specific and lives in the driver. Rdmavt has no
> concept of this. I'm agreeing that the send will be generic and have no hw
> specific stuff.
>
I understand that PIO/SDMA are not a concept of RVT. However, making
the send from RVT to driver exactly as the interface from ib_core to
RVT raises the question: What exactly do we achieve by this?
>
>
> As I've stated a number of times across multiple threads: It must not do
> anything that would prevent another driver from using it.
>
The question is not how Soft RoCE fits into this framework but how
does this framework achieve its goals.

>
>
> I expect feedback based on the code submissions. More will be coming
> shortly. I have taken all the feedback from the first post and will be
> sending a v2 shortly.
>
Again, I have no idea about the complete interfaces between both
pieces of the suggested solution.
- If you have them then please publish
- if you don't but plan to have them then why did you submit a half baked idea
- If you say that final interface is what we see now then I say that
the problem of code duplication isn't going to be resolved
So, what it is from the 3?

>
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
