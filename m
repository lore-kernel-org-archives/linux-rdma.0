From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in uverbs create_flow
Date: Tue, 15 Oct 2013 17:04:41 -0700
Message-ID: <CAL1RGDW7KwSOmmsRxDokUHR-Mh1OzaQvDege5Rq7JsSU8AgEHQ@mail.gmail.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
 <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org> <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
 <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 15, 2013 at 2:34 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Roland, after applying a small fix which was sent to you by Matan on
> Sep 22nd + another tiny fix by Yann to Matan's patch (the two can be
> surely squashed into one small patch), things are working OK. Yann is
> suggesting to enhance them to work and look even better and for some
> reasons (life) he didn't get to do that on the 3-4 months the patches
> spent on the list and went through review of Sean/Jason/Shawn and you
> (RD). I don't see how/why you use the term half-baked here.

Unless I'm misunderstanding, Yann's suggestion for enhancement is not
user/kernel ABI compatible with what is in the tree now.  Given that
we should really try to find an ABI that lasts for a long time, and
that we already have a proposal to improve things, shouldn't we hold
off on freezing the new ABI for one more kernel cycle?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
