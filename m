From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Sun, 27 Sep 2015 11:39:32 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org> <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com> <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com> <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org> <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Sat, 26 Sep 2015, Or Gerlitz wrote:

> It's possible that this was done for a reason, so

> sounds good, so taking into account that Erez is away till Oct 6th, we
> can probably pick your patch and later, if Erez proves us that there's
> deep problem there, revert it and take his.

Ok but if Erez does not have the time to participate in code development
and follow up on the patch as issues arise then I would rather rework the
code so that it is easily understandable and I will continue to follow up
on the issues with the code as they develop. This seems to be much more
important to my company than Mellanox.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
