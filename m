From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] IB/ipoib: Leave stale send-only multicast groups
Date: Tue, 18 Jan 2011 14:09:28 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1101181406490.18059@router.home>
References: <4D34239D.9030004@Voltaire.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D34239D.9030004-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yossi Etigin <yosefe-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 17 Jan 2011, Moni Shoua wrote:

> Unlike with send/receive multicast groups, there is no indication for IPoIB
> that a send-only multicast group is useless. Therefore, even a single packet
> to a multicast destination leaves a multicast entry on the fabric until the
> host interface is down. This causes an MGID leakage in the SM.

There is such an indication. The igmp subsystem removes the multicast
group from the grouplist for the interface when the process terminates.

The ipoib layer will then release the MGID when the multicast groups are
reprocessed in ipoib_mcast_restart_task(). The sendonly detect logic puts
it onto the remove_list() and then mcast_mcast_leave() is called at the
end to dispose of the MC group.

That is at least what our tests show. MC sendonly groups vanish when a
task terminates. Lets leave it that way.

Did you leave the task that caused the sendonly join running until
shutdown?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
