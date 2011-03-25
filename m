From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: nes: uninitialized variable
Date: Thu, 24 Mar 2011 17:15:26 -0700
Message-ID: <AANLkTi=PdMd+OZXDejON1Y=DJSEHxoAaq0GCPCnurz27@mail.gmail.com>
References: <20110324170035.552ab769@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110324170035.552ab769@nehalam>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Hemminger <shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org>
Cc: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 24, 2011 at 5:00 PM, Stephen Hemminger
<shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org> wrote:
> This commit:
> commit 2a4c97ead4b375a64063523210939b87ad225b85

Actually I think it was 1765a575334f ("net: make dev->master general")
which went in through the net tree and which had:

-       if (nesvnic->netdev->master)
+       if (netif_is_bond_slave(netdev))

presumably that should be netif_is_bond_slave(nesvnic->netdev).

I'll queue this up:

    RDMA/nes: Fix test of uninitialized netdev

    Commit 1765a575334f ("net: make dev->master general") introduced a
    test of an uninitialized netdev.  Fix the code so the intended netdev
    is tested.

    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c
b/drivers/infiniband/hw/nes/nes_cm.c
index ef32915..cfa3a2b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1116,7 +1116,7 @@ static int nes_addr_resolve_neigh(struct
nes_vnic *nesvnic, u32 dst_ip, int arpi
                return rc;
        }

-       if (netif_is_bond_slave(netdev))
+       if (netif_is_bond_slave(nesvnic->netdev))
                netdev = nesvnic->netdev->master;
        else
                netdev = nesvnic->netdev;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
