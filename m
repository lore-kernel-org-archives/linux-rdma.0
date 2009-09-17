From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Do not turn on carrier  to a non active port
Date: Thu, 17 Sep 2009 08:02:04 -0700
Message-ID: <ada4or1ehsj.fsf@cisco.com>
References: <4AB20C6C.9090005@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB20C6C.9090005-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org> (Moni Shoua's message of "Thu, 17
	Sep 2009 13:16:12 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > +	if (ib_query_port(priv->ca, priv->port, &attr) ||
 > +		attr.state != IB_PORT_ACTIVE) {
 > +		ipoib_dbg(priv, "wait with carrier until IB port is active\n");
 > +		if (test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
 > +			queue_delayed_work(ipoib_workqueue, &priv->carrier_on_task, HZ);
 > +		return;
 > +	}

This queueing delayed work to poll the port state seems a bit odd to
me... we get an event when the port changes state anyway, right?  So
can't we just turn the carrier on when we get an active event?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
