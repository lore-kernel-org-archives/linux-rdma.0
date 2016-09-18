From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/5] mlx5 IB RoCE LAG
Date: Sun, 18 Sep 2016 20:47:59 +0300
Message-ID: <1474220884-21341-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This feature keeps track, using netdev LAG events,
of the bonding and link status of each port's PF netdev.

When both of the card's PF netdevs are enslaved exclusively
to the same bond master, LAG state is active.
Bond mode must be one of:
1 (active-backup), 2 (XOR), or 4 (802.3ad).

During LAG, a single IB device is present for both ports.
This allows for load balancing and high availability to be
managed by the driver, abstracting it away from ULPs.
Such an IB device is given a name of "mlx5_bond_X".

LAG mode is determined by the bond driver.
In load balancing (modes 2 and 4), QPs are assigned to ports
in a round-robin fashion, on QP transition from RESET->INIT.
In high availability (mode 1), all QPs are assigned to the active
slave, determined by bond driver.

Please note that if the link state of a port becomes down when
mode is load balancing, all QPs will be moved to the other port,
and will be moved back once both ports are up again.

This feature itself split into mlx5_core and mlx5_ib parts, while mlx5_core was
already submitted and accepted:
  1) mlx5_core: Implements RoCE LAG infrastructure and API.
    a) Bond device LAG events tracking.
    b) Decisions as to whether LAG state is active.
    c) Firmware commands to enter and exit LAG state.
    d) Manages HA behavior.
  2) mlx5_ib: Uses core infrastructure to implement RoCE LAG.
    a) Chooses an "mlx5_bond_X" device name when LAG is active.
    b) Implements QP load balancing.
    c) Merges steering, such that both port's traffic arrives on
       PF0's root flow table. This is used for processing
       both port's usermode Ethernet traffic on PF0.
    d) Creates a special flow table that diverts all
       non-usermode Ethernet traffic received on port 2
       back to PF1's root flow table (since non-usermode Ethernet
       should not be affected by LAG).

Available in the "topic/roce-lag-mlx5" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/roce-lag-mlx5

Changelog v0 -> v1:
 * Rebased over k.o/for-4.9 branch to fix compilation issues

Thanks

Aviv Heller (5):
  IB/mlx5: Port events in RoCE now rely on netdev events
  IB/mlx5: Merge vports flow steering during LAG
  IB/mlx5: Port status track LAG master, when LAG is active
  IB/mlx5: Set unique device name on LAG
  IB/mlx5: LAG QP load balancing

 drivers/infiniband/hw/mlx5/main.c    | 150 +++++++++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   2 +
 drivers/infiniband/hw/mlx5/qp.c      |  61 ++++++++++++--
 3 files changed, 191 insertions(+), 22 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
