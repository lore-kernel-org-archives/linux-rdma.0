From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: switch iwpm to ccan list.h
Date: Mon, 10 Oct 2016 11:41:51 +0200
Message-ID: <1476092514-18188-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've started running sparse on the rdma-core code, and one of the
worst offenders is the iwpmd list code, so this (untested) patch
set converts it over to the ccan list.h helpers.  Reviews and
testing appreciated.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
