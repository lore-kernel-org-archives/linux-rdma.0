From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA_OPTION_ID_TOS option
Date: Thu, 28 Feb 2013 06:29:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F35599C@ORSMSX101.amr.corp.intel.com>
References: <512E27A1.3090201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512E27A1.3090201-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Are there any examples out there of IB applications that use
> RDMA_OPTION_ID_TOS?  I'm looking to make this available for iwarp
> transports, but I'm still trying to understand how its currently used,
> and what values are used.  Since this option is level RDMA_OPTION_ID, I
> guess it is transport-neutral?

It's transport neutral, but only defined to do anything in the kernel with IB.  For IB, it ends up being used as input into the path record query (as qos_class).  The SA uses the value as input for the resulting path record, most likely to set the SL value.

For iWarp I would expect it to behave similar to RFC 2474, which I haven't look at in a while.  Note the RoCE ends up using the TOS value to set the path record SL using this code:

        route->path_rec->sl = netdev_get_prio_tc_map(
                        ndev->priv_flags & IFF_802_1Q_VLAN ?
                                vlan_dev_real_dev(ndev) : ndev,
                        rt_tos2priority(id_priv->tos));

I don't know if this helps with iWarp, but it may be worth looking at those calls in more detail.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
