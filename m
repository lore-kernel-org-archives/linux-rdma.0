From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_read_lat question
Date: Thu, 21 Feb 2013 18:27:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F35235F@ORSMSX101.amr.corp.intel.com>
References: <51265E60.1070609@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51265E60.1070609-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> ib_read_lat displays RTT latency, while the other lat programs display
> RTT/2.  Is this intended?  Or is read_lat.c/print_report() missing a
> divide-by-two?

The tests should measure how long it takes the data to reach the destination.  For writes/sends, that would be RTT/2.  For reads, the destination is local, so you should want RTT.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
