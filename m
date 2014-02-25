From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: issues with the rdma-cm server side mapping of IP to GID
Date: Tue, 25 Feb 2014 10:18:55 +0200
Message-ID: <530C51EF.2000509@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

We came across a pretty deadly situation with rdma-cm based 
client/server application where the client set their RC QP to send to 
HCA X on the server node but the server app opened their QP on HCA Y. 
The result was un-acked RC packets and RC session failure.

This happened because the mapping between destination IP to destination 
GID as seen by the client was different from what's present in the 
server IP stack at the time the connection request arrived -- the server 
side rdma-cm IP --> GID mapping is established by the 
cma_translate_addr() call in cma_new_conn_id() which is done on the 
destination IP taken from the RDMA-CM header in the CM REQ.

Such situation can happen in the following cases:

1. net.ipv4.conf.default.arp_ignore equals 0 (the default)
2. server side bonding/teaming fail-over when the Gratitous ARP sent was 
lost
3. re-order of ibM net-devices mapping to HCA PCI devices after server 
boot/crash
4. etc more

Basically, when the rdma-cm observes difference between the destination 
GID as present in the IB path within
the CM REQ to the one resolved locally,  we should at least print a 
warning. Perhaps, we should reject the connection request? (in that 
case, I wasn't sure what would be the appropriate reject reason), any 
more ideas?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
