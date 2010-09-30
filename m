From: Sumeet <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: gratuitous arps lost during IB switch failure
Date: Thu, 30 Sep 2010 23:23:40 +0000 (UTC)
Message-ID: <loom.20101001T010729-594@post.gmane.org>
References: <4C9942F3.5090206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


It turns out that this problem was being caused because we had multiple IPs
configured on the bonded infiniband interface. It appears that grat. arps are
being sent out for only one of those IPs. 

For example, if we configure the bonded interfaces as below, and we trigger a
failover, we only see grat arps go out for the bond0:1 IP. Can the bonding
driver be fixed to send out grat arps for both these IPs? 

# cat ifcfg-bond0
DEVICE=bond0
USERCTL=no
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.50.118
NETMASK=255.255.254.0
NETWORK=192.168.50.0
BROADCAST=192.168.51.255
BONDING_OPTS="mode=active-backup miimon=100 downdelay=5000 updelay=5000"
MTU=65520

# cat ifcfg-bond0:1
DEVICE=bond0:1
USERCTL=no
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.169.50.118
NETMASK=255.255.254.0
NETWORK=192.169.50.0
BROADCAST=192.169.51.255
BONDING_OPTS="mode=active-backup miimon=100 downdelay=5000 updelay=5000"
MTU=65520

- Sumeet




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
