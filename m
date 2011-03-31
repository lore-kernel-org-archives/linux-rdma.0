From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Don't change QP state outside EP lock.
Date: Thu, 31 Mar 2011 10:16:14 -0700
Message-ID: <AANLkTimefbrzq1FxZT-SBfPoXR2XnU+sTcYDjfdfx5-x@mail.gmail.com>
References: <20110331161418.4653.90690.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110331161418.4653.90690.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2011 at 9:14 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
> Concurrent ingress CLOSE and ULP ABORT operations causes a crash due
> to a race condition where the close path releases the EP lock and the=
n
> tries to move the QP state to CLOSED. =A0This must be done inside the=
 EP
> lock to avoid the race.

Thanks, applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
