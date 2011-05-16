From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: don't declare wr_wait objects on the stack.
Date: Mon, 16 May 2011 08:53:03 -0700
Message-ID: <BANLkTimGzzo1xDTvApAVxvv4C8WcYuCdUA@mail.gmail.com>
References: <20110513183727.32157.8873.stgit@build.ogc.int> <4DD14036.9050704@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DD14036.9050704-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2011 at 8:18 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
> Roland, I need to recall this patch. =A0It appears to have some probl=
em.

Good thing I didn't apply it yet.

I did think it should be possible to declare wait objects on the stack.=
=2E. the
origin of completions was to handle exactly that issue; the older semap=
hore
structure was vulnerable to the wakeup after free, but completions hand=
le
that.  But I didn't look at the cxgb4 code at all...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
