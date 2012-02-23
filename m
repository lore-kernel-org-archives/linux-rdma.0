From: =?iso-8859-1?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Used of deprecated CAP_SYS_MODULE leads to inconsistent network device and routing info
Date: Thu, 23 Feb 2012 10:03:27 -0500
Message-ID: <9EDB02ED-6562-4AF1-A5E8-101DAD423050@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1426\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello list,

The problem appears using IPoIB with OFED 1.5.4 over RoCEE on a Mellanox
Technologies MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] board.

The kernel complains about the use of CAP_SYS_MODULE, deprecated in favor of
CAP_SYS_ADMIN. Consequently, ifup of ib0 or ib1 end up in eth2, and the routing
information are completely screwed-up, borrowing some configuration from eth0.

The linux kernel version used is 2.6.32-220.4.2.el6.x86_64 on a AMD64 RHEL 6.1.

<snip title="dmesg output">

Loading kernel module for a network device with CAP_SYS_MODULE (deprecated). 
Use CAP_NET_ADMIN and alias netdev-ib0 instead.

</snip>

Is this a known issue (I did not find any related bug in the bugzilla)? How do I fix this?

Thanks,
Xavier--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
