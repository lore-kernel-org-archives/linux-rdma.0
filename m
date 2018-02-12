From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 2/3] Allow Verbs ordered flow spec definitions
Date: Mon, 12 Feb 2018 17:20:14 +0200
Message-ID: <CAFgAxU9c9+bMb3t_4AvnMyNiVQyJXzwzYUYSn63K7u2BrTjXnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applications can use IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST to declare
that the ibv_flow_spec_xxx rules should be created in order and should
be matched as a strict pattern of headers.

This flag allows applications to define a very precise network header
structure, which is very useful to represent many of the encapsulation
tunnel protocols.

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_flow.3 | 10 +++++++++-
 libibverbs/verbs.h               |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index a59cbe5..ee801fc 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -52,6 +52,7 @@ enum ibv_flow_flags {
 .in +8
 IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1 << 0,  /* Apply the rules on
packets that were sent from the attached QP through loopback */
 IBV_FLOW_ATTR_FLAGS_DONT_TRAP       = 1 << 1,  /* Rule doesn't trap
received packets, allowing them to match lower prioritized rules */
+IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST = 1 << 2,        /* Apply the
rules occording to the stacked order the user provided */
 .in -8
 };
 .fi
@@ -104,7 +105,14 @@ In addition to the domain, there is priority
within each of the domains.
 A lower priority numeric value (higher priority) takes precedence
over matching rules with higher numeric priority value (lower
priority).
 It is important to note that the priority value of a flow spec is
used not only to establish the precedence of conflicting flow matches
 but also as a way to abstract the order on which flow specs are
tested for matches. Flows with higher priorities will be tested before
flows with lower priorities.
-.PP
+
+.SS Rules definition ordering
+An application can provide the ibv_flow_spec_xxx rules in an
un-ordered scheme. In which case, each spec should be well defined and
match a specific network header layer.
+Alternatively, if an ibv_flow is created with flag
+.BR IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST\fR,
+then the ibv_flow_spec_xxx rules order will be matched as a stricted pattern.
+This mode allows the application to define a very precise network
header structure. This is very useful to represent many of the
encapsulation tunnel protocols.
+
 .SS ibv_destroy_flow()
 destroys the flow
 .I flow_id\fR.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index ec0504f..4f03bc9 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1348,6 +1348,7 @@ struct ibv_ah {
 enum ibv_flow_flags {
        IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1 << 0,
        IBV_FLOW_ATTR_FLAGS_DONT_TRAP = 1 << 1,
+       IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST = 1 << 2,
 };

 enum ibv_flow_attr_type {
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
