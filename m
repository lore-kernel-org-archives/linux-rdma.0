From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 17:21:27 -0700
Message-ID: <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441729478-19375-1-git-send-email-dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2015 at 9:24 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Matan Barak (5):
>       net: Add info for NETDEV_CHANGEUPPER event

Why the hell is this coming in through the infiniband tree? Especially
with the networking tree having done the same thing differently?

I see that Stephen Rothwell reported this almost two weeks ago, and
informed you.

The commit you send me, though, has been rebased since then, BUT IT
STILL EXISTS.

The commit is wrong, and you knew about it. So tell me, why the hell
should I pull this shit?

Oh, yes, I can fix it in the merge. This is not a "I can't resolve
this pull request" email. Resolving it in favor of the existing
networking infrastructure is easy.

This is a "why should I even bother?" email.

The two different commits have very similar logic, somewhat similar
names, but the details are different. Both were written by somebody
with a "mellanox.com" address.

One huge glaring difference is that one of them went through the
networking maintainer, which matters a great deal since this is a
networking notifier.

I did the pull, did most of the resolve, but then decided that I don't
even want to merge this considering how questionable it was.

This needs a good explanation, because for now this pull request is dead to me.

                 Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
