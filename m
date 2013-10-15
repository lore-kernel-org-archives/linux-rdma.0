From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in uverbs create_flow
Date: Wed, 16 Oct 2013 00:34:21 +0300
Message-ID: <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg@mail.gmail.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
	<ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
	<525C0BF2.2060201@mellanox.com>
	<72b95284386dc57dfa1c7c883b4f45af@meuh.org>
	<CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
	<122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org>
	<CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 15, 2013 at 7:44 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> I agree.  So as I said before, I think the best idea is just to
> disable the half-baked command extension stuff before 3.12, and get
> things right for 3.13.

Roland, after applying a small fix which was sent to you by Matan on
Sep 22nd + another tiny fix by Yann to Matan's patch (the two can be
surely squashed into one small patch), things are working OK. Yann is
suggesting to enhance them to work and look even better and for some
reasons (life) he didn't get to do that on the 3-4 months the patches
spent on the list and went through review of Sean/Jason/Shawn and you
(RD). I don't see how/why you use the term half-baked here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
