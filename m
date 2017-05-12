From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: iSER with policy based routing error
Date: Fri, 12 May 2017 15:02:31 -0600
Message-ID: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are trying to leverage multiple cards/ports for iSER for
performance and resiliency reasons. The ports are configured with only
IPv6 addresses and each port is on a separate VLAN/subnet that is
routable to each other subnet. We are using rules with tables to set a
default gateway for each adapter/subnet based on the source IPv6
address (policy based routing). Using TCP for iSCSI, everything works
fine and traffic ingresses/egresses the right ports. However, when we
try using iSER, we get connection errors.

May 12 13:39:27 prv-0-14-roberttest kernel: iser: iser_connect:
rdma_resolve_addr failed: -101
May 12 13:39:27 prv-0-14-roberttest iscsid: Received iferror -101:
Network is unreachable.
May 12 13:39:27 prv-0-14-roberttest iscsid: cannot make a connection
to 2604:3140:40:300:0:580:d0:0:3260 (-101,0)

If we put a default gateway for IPv6 in the 'default' table, then iSER
is able to make a connection, but we can only use one port. It looks
as if iSER is not following the rules in the default routing table to
find the appropriate default gateway in a different table.

In iscsiadm, we are setting up an iface with iface.net_ifacename,
iface.ipaddress, and iface.transport_name appropriately and using that
iface with a default gateway in the 'default' routing table works, so
we feel confident that our problem is not with the iface
configuration.

Any ideas how to fix this? We are running CentOS 7.2 with 4.9.13 Linux
kernel, in-box drivers and ConnectX-4 LX 25 Gb cards.

Thanks.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
