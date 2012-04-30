From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] iw_cxgb4: don't BUG_ON if we get an abort with no
 endpoint found.
Date: Mon, 30 Apr 2012 13:22:09 -0700
Message-ID: <CAL1RGDWSYyw0G3gW=tyOXDCSfYbJV_3OxBGcM9HEZNWK=hKqNg@mail.gmail.com>
References: <20120427145915.27184.35216.stgit@build.ogc.int>
 <20120427145922.27184.74574.stgit@build.ogc.int> <4F9EE916.9010708@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9EE916.9010708-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sbest-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 30, 2012 at 12:33 PM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> Hey Roland, this patch is incorrect. =A0It erroneously changes abort_=
rpl()
> instead of peer_abort_intr(). =A0I will resubmit the correct patch as=
ap.

OK, consider it dropped.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
