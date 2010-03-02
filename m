From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IPoIB issues
Date: Tue, 2 Mar 2010 13:54:09 -0800
Message-ID: <a72123c41003021354y7880e74cud26d6010f23f9458@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I've been running into several issues using IPoIB.  The 2 primary uses
are for read-only NFS to the clients (over TCP) and access to an
ethernet-connected parallel filesystem (Panasas) through router nodes
passing IPoIB<-->10GbE.

All nodes are running CentOS 5.3 and OFED 1.4.2, although a have played
with OFED 1.5 and seen similar results.  Client nodes mount their NFS root
from boot servers via IPoIB with a ratio of 80:1.  The boot servers are the
ones that seem to have issues.  The fabric itself consists of ~1000 nodes
interconnected such that their is 2:1 oversubscription within any single rack,
and 20:1 oversubscription between racks (through the core switch).  I
don't know how much the oversubscription comes into play here as I can
reproduce the error within a single rack.

In datagram mode, I see errors on the boot servers of the form.

ib0: post_send failed
ib0: post_send failed
ib0: post_send failed


When using connected mode, I hit a different error:

NETDEV WATCHDOG: ib0: transmit timed out
ib0: transmit timeout: latency 1999 msecs
ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464
NETDEV WATCHDOG: ib0: transmit timed out
ib0: transmit timeout: latency 2999 msecs
ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464
...
...
NETDEV WATCHDOG: ib0: transmit timed out
ib0: transmit timeout: latency 61824999 msecs
ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464


The errors seem to hit only after NFS comes into play.  Once it
starts, the NETDEV WATCHDOG messages continue until I run
'ifconfig ib0 down up'.  I've tried tuning send_queue_size and
recv_queue_size on both sides, the txqueuelen of the ib0 interface, the
NFS rsize/wsize.  None of it seems to help greatly.  Does anyone have
any ideas about what can I do to try to fix
these problems?

-JE
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
