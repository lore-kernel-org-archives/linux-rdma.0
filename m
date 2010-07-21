From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: knockdown voltair switch with ARP multicast
Date: Wed, 21 Jul 2010 00:35:43 -0700
Message-ID: <20100721073543.GA16373@nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


I've been able to duplicate a nasty problem that took
down our system last week. I believe its caused by
IPoIB ARP multicast traffic. The 4036 switch subscribes
to the IPoIB multicast group whether the SM is running
or disabled. When the switch goes belly up, and it can't be
programmed by the SM.

ERR 3113: MAD completed in error (IB_TIMEOUT): SubnSet(SwitchInfo),
attr_mod 0x0, TID 0x22322

smpquery works (nodeinfo/switchinfo) but perfquery fails with
ibwarn: [26748] _do_madrpc: recv failed: Connection timed out

I can log into the switch, but wouldn't know what to look for there.

Voltaire support case number 
 US Case 00018085: Re: NASA Issue [[ ref:00D38IO.5008BPc6T:ref]]

Maybe someone on the voltaire side can help.

I'm working the issue now
Wed Jul 21 00:34:14 PDT 2010



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
