From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in uverbs create_flow
Date: Mon, 21 Oct 2013 09:46:32 -0700
Message-ID: <CAL1RGDUV1QX4ekbUYiwVs6iOu6+_0JubBq77zcjn0UqD_H7c-A@mail.gmail.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
 <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org>
 <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com>
 <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org> <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com>
 <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg@mail.gmail.com>
 <CAL1RGDW7KwSOmmsRxDokUHR-Mh1OzaQvDege5Rq7JsSU8AgEHQ@mail.gmail.com>
 <525FABA2.6000507@mellanox.com> <80c62f070af55a176923315b3fbb7b0d@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <80c62f070af55a176923315b3fbb7b0d-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 17, 2013 at 8:29 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
>> Just to double check, by no means we are talking on reverting the
>> whole series, flow-steering will be in
>> 3.12 in the IB core and mlx4_ib

Correct, just hiding the unstable userspace ABI for now.

> I believe it will disable by #if 0 / #endif.
> It could be protected by #ifdef
> CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
> instead, but I don't know if it's acceptable practice for such piece of code
> that should be exposed in its current state.

I like the Kconfig option -- I just made a patch that does that (and
made the option depend on STAGING), I'll post it for comments.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
