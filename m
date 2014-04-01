From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH for v3.14 0/5] Coccicheck / coccinelle catched errors on ib/hw
Date: Tue, 1 Apr 2014 10:39:13 -0700
Message-ID: <CAG4TOxNrO2uxMUNkF3je3jafP5dWpOP8yxTK12qDbk02ANnnbQ@mail.gmail.com>
References: <cover.1394485254.git.ydroneaud@opteya.com> <1395753355.2895.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395753355.2895.12.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 25, 2014 at 6:15 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> Here removing stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org doesn't sound right.

Sorry, I've added that back.

> Could you help me to understand the reason why your selectively remove
> some 'Cc:' on some patches while leaving them on other patches.

Typically I don't see much point in putting a list of email addresses
of people who might (or might not) have some connection to the patch
into the changelog.  "Cc:" means "I tried to get this person's
attention on the patch but they didn't reply in time" and I don't see
much value in persisting that information forever, so I strip it when
I catch it.  The IB/RDMA community has a lot of people for whom
English is not their native language, so I'm pretty much in the habit
of trying to polish all changelogs as they go by.  "Cc: stable" is of
course the one exception to my stripping.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
