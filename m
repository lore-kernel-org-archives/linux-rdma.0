From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: how new GIDs are notified to IB stack in OFED 1.5.1?
Date: Mon, 27 Sep 2010 10:59:59 -0700 (PDT)
Message-ID: <709363.14225.qm@web30107.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

So as we know GIDs are based on IPv6 addresses, and GID table entries are updated on the fly when new IPv6 addresses are assigned to eth and vlan based eth interfaces.

How does IB stack will get to know about new GIDs which are added into the table?
So that query_gid() can be called with right index?

Regards,
Parav Pandit



      
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
