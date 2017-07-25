From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 13:55:21 -0500
Message-ID: <011801d30577$91200c00$b3602400$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com> <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com> <20170725164004.GA20959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > And you should have a reasonable set of modules loaded. Check the
> > journal for interesting errors also..

Oh and here's the journal after bringing up the cxgb4 interface.  I think it
looks good.


Jul 25 11:43:21 stevo3.asicdesigners.com kernel: iw_cxgb4:0000:04:00.4: Up
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: 0000:04:00.4: On-Chip Queues
not supported on this device.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started RDMA Node
Description Daemon.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting RDMA Node
Description Daemon...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Created slice
system-rdma\x2dload\x2dmodules.slice.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting
system-rdma\x2dload\x2dmodules.slice.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/iwarp.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/rdma.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/iwpmd.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/iwarp.conf.
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: IPv6: ADDRCONF(NETDEV_UP):
enp4s0f4: link is not ready
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: cxgb4 0000:04:00.4 enp4s0f4:
passive DA module inserted
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: Loading iSCSI transport class
v2.0-870.
Jul 25 11:43:21 stevo3.asicdesigners.com avahi-daemon[808]: Joining mDNS
multicast group on interface enp4s0f4.IPv4 with address 172.16.3.3.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2573]: Inserted
module 'iw_cm'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/iwpmd.conf.
Jul 25 11:43:21 stevo3.asicdesigners.com avahi-daemon[808]: New relevant
interface enp4s0f4.IPv4 for mDNS.
Jul 25 11:43:21 stevo3.asicdesigners.com avahi-daemon[808]: Registering new
address record for 172.16.3.3 on enp4s0f4.IPv4.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started iWarp Port Mapper.
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting iWarp Port
Mapper...
Jul 25 11:43:21 stevo3.asicdesigners.com iWarpPortMapper[2583]: get_iwpm_param:
Got param (name = nl_sock_rbuf_size val = 419430400)
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: ib_core:ibnl_rcv_msg: Index 3
wasn't found in client list
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'ib_iser'
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: iscsi: registered transport
(iser)
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'ib_uverbs'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'rdma_ucm'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'rpcrdma'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/rdma.conf.
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: RPC: Registered rdma transport
module.
Jul 25 11:43:21 stevo3.asicdesigners.com kernel: RPC: Registered rdma
backchannel transport module.
Jul 25 11:43:22 stevo3.asicdesigners.com kernel: cxgb4 0000:04:00.4 enp4s0f4:
link up, 10Gbps, full-duplex, Tx/Rx PAUSE
Jul 25 11:43:22 stevo3.asicdesigners.com kernel: IPv6: ADDRCONF(NETDEV_CHANGE):
enp4s0f4: link becomes ready
Jul 25 11:43:22 stevo3.asicdesigners.com NetworkManager[781]: <info>
(enp4s0f4): link connected
Jul 25 11:43:23 stevo3.asicdesigners.com avahi-daemon[808]: Registering new
address record for fe80::207:43ff:fe29:2f20 on enp4s0f4.*.
Jul 25 11:50:01 stevo3.asicdesigners.com systemd[1]: Started Session 4 of user
root.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
