From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 2/4] Move rdma_netlink compat into CMake
Date: Fri, 28 Oct 2016 09:59:16 -0500
Message-ID: <002501d2312b$da377cf0$8ea676d0$@opengridcomputing.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com> <1477609570-8087-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477609570-8087-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Latif, Faisal'" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

+Tatyana
+Faisal

Intel, please have a look.

> 
> Steve,
> 
> Can you check if the changes to iwpmd/iwarp_pm_server.c make sense?

I was confused at first, but I see that the iwarp_clients array still has
clients 2 and 3, so it should work fine and still preserve compatibility with
older drivers that embedded the iwarp port mapping in iw_cxgb4 and iw_nes.  And
the RDMA_NL_* enum is consistent with the local header and the kernel uapi
header.  So it looks fine.  I should test this though to make sure...

>
> Should we do something to fix the kernel header?
>

What is wrong with the kernel header exactly?

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
