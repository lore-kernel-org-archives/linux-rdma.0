From: Stephen Hemminger <shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org>
Subject: nes: uninitialized variable
Date: Thu, 24 Mar 2011 17:00:35 -0700
Message-ID: <20110324170035.552ab769@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit:
commit 2a4c97ead4b375a64063523210939b87ad225b85
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Nov 24 17:29:30 2010 +0000

    RDMA/nes: Fix bonding on iw_nes
   =20
    Enable configuring bonds on nes devices by adding missing support f=
or
    master net_device to the driver.
   =20
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

introduced:
drivers/infiniband/hw/nes/nes_cm.c: In function =E2=80=98nes_addr_resol=
ve_neigh=E2=80=99:
include/linux/netdevice.h:2586: warning: =E2=80=98netdev=E2=80=99 may b=
e used uninitialized in this function
drivers/infiniband/hw/nes/nes_cm.c:1109: note: =E2=80=98netdev=E2=80=99=
 was declared here

here:
static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip,=
 int arpindex)
{
	struct net_device *netdev;
	struct nes_adapter *nesadapter =3D nesvnic->nesdev->nesadapter;

	rt =3D ip_route_output(&init_net, htonl(dst_ip), 0, 0, 0);
	if (IS_ERR(rt)) {
		printk(KERN_ERR "%s: ip_route_output_key failed for 0x%08X\n",
				__func__, dst_ip);
		return rc;
	}

	if (netif_is_bond_slave(netdev))
                                ^^^^^^

netdev is not set!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
