From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in uverbs create_flow
Date: Tue, 15 Oct 2013 09:44:48 -0700
Message-ID: <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com> <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <122f1a29d6fe45449a6a153a3a9ba8b1-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 15, 2013 at 7:08 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> But, in the mean time, we failed at providing the required fixes/cleanups
> before v3.12-rc5.
> We have not agreed on a definitive, small, urgent patchset for v3.12-rc5.
> And I think, and it's easy to think so, that Linus will be very upset to see
> more
> than a couple of patches for the Infiniband subsystem for v3.12-rc6. If
> there's a v3.12-rc6.
>
> So instead of fighting to squeeze the last good patch hunk for v3.12, we
> should think
> on what command/response scheme we need for v3.13.

I agree.  So as I said before, I think the best idea is just to
disable the half-baked command extension stuff before 3.12, and get
things right for 3.13.

Do you still think the patch you provided to disable the new stuff is good?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
