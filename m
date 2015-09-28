From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 09:37:36 +0300
Message-ID: <CAJ3xEMg5aC8oeBVA9qygVJyLd2GM9C4sVLZqAL=kFGBcgBq_oQ@mail.gmail.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
	<alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
	<CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
	<alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
	<CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
	<alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
	<CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
	<alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1509271136570.14486-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 27, 2015 at 7:39 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> Ok but if Erez does not have the time to participate in code development
> and follow up on the patch as issues arise then I would rather rework the
> code so that it is easily understandable and I will continue to follow up
> on the issues with the code as they develop.

As I mentioned to you earlier on this thread, currently it's not a
matter of having time to participate but rather happily going through
the Jewish new year holidays, this time Sukkot with many people being
off for the whole of it till Oct 6.

Personally, up to few weeks ago, I was under the misimpression that
not only IPoIB joins as full member also on the sendonly flow, but
also that such group can be actually opened under that flow, and it
turns out they don't. Later you said that your production environment
was running a very old non upstream stack that had a knob to somehow
make it work and as of that didn't realize that something goes wrong
for years w.r.t a gateway functionality with upstream/inbox code, so
we all screwed up here over a time period with is few orders of
magnitude longer than a holiday duration.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
