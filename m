From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: How to handle illegal multicast addresses in IPoIB?
Date: Mon, 21 Sep 2009 16:31:44 +0300
Message-ID: <4AB78040.9000606@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
The problem in short: Illegal multicast addresses can be passed to ib_ipoib which will add them to the queue of multicast addresses it needs to join. From this point on ib_ipoib will get stuck in the attempt to join an illegal multicast group and without a giving a chance for other groups to try.

Recently 2 patches were sent to to deal with this problem. Both of them were rejectedm mainly from technical reasons.
Since I think that it is important to have the problem fixed I want to revive the discussion and resubmit one of them or both, according to the opinions here.

One patch (http://lists.openfabrics.org/pipermail/general/2009-August/061663.html) checks each multicast address for validity before it lets it get into the queue. 

The other patch (http://lists.openfabrics.org/pipermail/general/2009-August/061693.html) queues all addresses it gets but adds fairness to the join attempts.

My questions is: Do we need both patches? If not, which one to choose?

I think that the first patch (check validity) is good enough.

thanks
 MoniS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
