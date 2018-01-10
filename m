From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC] Verbs requirement for GRH when working in GID based addressing
Date: Wed, 10 Jan 2018 21:28:34 +0200
Message-ID: <CAFgAxU_p4OR7qUe+HjK_rYP+LxUUOxYs+Qp6g4_e64WvOXMWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RDMA applications require an indication they are operating in an
environment which is based on GID addressing, such as SR-IOV IB
Virtualization. In this mode, all sent traffic must include a GRH.

This RFC exposes a new verbs port capability flag: GRH_REQUIRED.
When GRH_REQUIRED port capability flag is set, the applications must
create all AH with GRH configured. Meaning calling ibv_create_ah() with
'struct ibv_ah_attr { is_global = 1 }'

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_ah.3 | 4 ++++
 libibverbs/verbs.h             | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_ah.3 b/libibverbs/man/ibv_create_ah.3
index 0ca2198..b645ea3 100644
--- a/libibverbs/man/ibv_create_ah.3
+++ b/libibverbs/man/ibv_create_ah.3
@@ -53,6 +53,10 @@ destroys the AH
 .SH "RETURN VALUE"
 .B ibv_create_ah()
 returns a pointer to the created AH, or NULL if the request fails.
+.SH "NOTES"
+If port cap flag IBV_PORT_GRH_REQUIRED is set then
+.B ibv_create_ah()
+must be created with definition of 'struct ibv_ah_attr { .is_global =
1; .grh = {...}; }'.
 .PP
 .B ibv_destroy_ah()
 returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 997597a..12e80b3 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -338,7 +338,8 @@ enum ibv_port_cap_flags {
        IBV_PORT_BOOT_MGMT_SUP                  = 1 << 23,
        IBV_PORT_LINK_LATENCY_SUP               = 1 << 24,
        IBV_PORT_CLIENT_REG_SUP                 = 1 << 25,
-       IBV_PORT_IP_BASED_GIDS                  = 1 << 26
+       IBV_PORT_IP_BASED_GIDS                  = 1 << 26,
+       IBV_PORT_GRH_REQUIRED                   = 1 << 27
 };

 struct ibv_port_attr {
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
