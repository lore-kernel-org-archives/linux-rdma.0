From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] IB/ipoib: Leave stale send-only multicast groups
Date: Mon, 17 Jan 2011 13:30:09 +0200
Message-ID: <4D342841.7020700@voltaire.com>
References: <4D34239D.9030004@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D34239D.9030004-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yossi Etigin <yosefe-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moni Shoua wrote:
> Unlike with send/receive multicast groups, there is no indication for IPoIB
> that a send-only multicast group is useless. Therefore, even a single packet
> to a multicast destination leaves a multicast entry on the fabric until the
> host interface is down. This causes an MGID leakage in the SM.

Just few quick comments on the change-log: the SM doesn't control/manage MGIDs, its
the application (ipoib in this case), so I assume you are referring to MLIDs. I believe 
that the Linux IB stack doesn't support send-only groups ala the IB spec, so you're talking 
on "stale groups" which are practically send-only, I would add that to the change log

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
