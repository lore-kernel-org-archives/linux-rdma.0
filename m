From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: QPN re-use?  was RE: rstream application
Date: Tue, 21 Nov 2017 16:26:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1AC922@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Rstream client connects to server, runs latency test, calls rs_close
> and then connects Again before running the bandwidth test. The issue
> occurs on the second connect (after latency and before bandwidth).
> Server does the same. It seems the close state in some cases doesn't
> complete Before the second connect request arrives.
> Yes, the hardware re-uses QPNs once they are destroyed.

If the issue is that the QP is in time wait, I'm not sure this is completely an application issue.  The QP being re-used could have been allocated by another application, with timewait being set to something large.  This wouldn't be an rstream issue, but something all applications would be required to handle.

It sounds like there needs to be some sort of coordination of QPN re-use between the drivers and CM, especially if the driver wants to re-use QPNs as LIFO.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
