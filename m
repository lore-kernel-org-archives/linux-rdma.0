From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: switching the active interface for bonding
Date: Wed, 14 Oct 2009 13:15:23 +0200
Message-ID: <4AD5B2CB.8070706@voltaire.com>
References: <4AD35909.9020006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD35909.9020006-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sumanta Chatterjee <sumanta.chatterjee-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sumeet Lahorani wrote:
> We are [...] trying to simulate the effect of a bonding failover 
> initiated by a switch failure using echo commands in parallel to the 
> /sys/class/net/bond0/bonding/active_slave file on a few of the nodes 
> attached to the switch. Is this an acceptable technique?
yes

> We are trying to avoid actually resetting the switch to avoid 
> affecting other nodes connected to the same switch, since the other 
> nodes are being used for other purposes
There's no need to reboot a switch in order to cause an IB link down 
event on an HCA port across the wire connected to one of the switch 
ports. You can administratively disable the switch port you want and 
later administratively enable it. This is simple as

    $ ibportstate disable/query/enable $LID $PORT

using the switch one and the switch port the hca port is connected to.

> Would there be any difference in terms of the code path which the 
> bonding driver/ofed stack follows when we do this as opposed to 
> resetting the switch?
yes and yes.

Bonding wise, when setting the active slave through sysfs, the bonding 
driver doesn't go through the link monitoring code, wheres if you do 
cause a link down it does.

As for the IB stack (there's nothing like "ofed stack", ofed is just a 
bunch of rpms installed over your distro), when a port goes down, things 
happen...  if the software you're using counts/uses IB port down events, 
you may exercise a different flow, e.g IPoIB is using these events, and 
you will not go through the port down flow of it. Next, if some code 
you're working with uses the IB RC transport, then depending on the 
timeout programmed to the RC QP, a transport timeout may happen which in 
turn causes the HW to move the QP into the error state, and so on.

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
