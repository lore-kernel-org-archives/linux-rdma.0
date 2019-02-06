From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 02/12] bnxt: Implement
 ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 13:59:44 +0100
Message-ID: <20190206125944.GC2189@nanopsycho>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-3-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205235326.14600-3-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Feb 06, 2019 at 12:53:16AM CET, f.fainelli@gmail.com wrote:
>BNXT only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
>great candidate to be converted to use the ndo_get_port_parent_id() NDO
>instead of implementing switchdev_port_attr_get(). The conversion is
>straight forward here since the PF and VF code use the same getter.
>
>Since bnxt makes uses of switchdev_port_same_parent_id() convert it to
>use netdev_port_same_parent_id().
>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

[...]

>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>index c683b5e96b1d..170d2fbbb91b 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>@@ -12,6 +12,7 @@
> #include <linux/if_vlan.h>
> #include <net/flow_dissector.h>
> #include <net/pkt_cls.h>
>+#include <net/switchdev.h>

You don't need this. Looks like a leftover.

Otherwise, looks fine.
Acked-by: Jiri Pirko <jiri@mellanox.com>


> #include <net/tc_act/tc_gact.h>
> #include <net/tc_act/tc_skbedit.h>
> #include <net/tc_act/tc_mirred.h>

[...]
