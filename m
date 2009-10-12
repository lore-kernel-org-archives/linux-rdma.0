From: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: switching the active interface for bonding
Date: Mon, 12 Oct 2009 09:27:53 -0700
Message-ID: <4AD35909.9020006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,

We are using OFED 1.4.2 and trying to simulate the effect of a bonding 
failover initiated by a switch failure using echo commands in parallel 
to the /sys/class/net/bond0/bonding/active_slave file on a few of the 
nodes attached to the switch. Is this an acceptable technique? We are 
trying to avoid actually resetting the switch to avoid affecting other 
nodes connected to the same switch, since the other nodes are being used 
for other purposes.

Would there be any difference in terms of the codepath which the bonding
driver/ofed stack follows when we do this as opposed to resetting the
switch?

- Sumeet


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
