From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Revisit: [iscsi ifaces / multipathing / etc] thread from 2010
Date: Thu, 25 May 2017 12:30:01 -0600
Message-ID: <CAANLjFqRUSztbFw1GOwO4dodXCgWNYeo3jSpTa8f9SyLPpM5-w@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBKWFTTEQKGQENYYQP3Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have a need to have iSER bind to specific addresses in order to
accomplish the multipathing discussing in the previous thread [1]. In
inspecting the code, I can pass in a source IP address in the iSER
kernel module [2] and the connection happens as expected. I started
looking at how to get the source address from the iface I configured
and that is where things get messy. I'm looking for some direction and
pointers to get something that could be accepted upstream.
Userland/kernel integration is something new for me, so I'm trying to
learn without asking too many questions.

Or Gerlitz pointed me to where the userland tools communicates with
the kernel and I _think_ I know how I would have to change the
relevant code, but it raises a number of questions.

1. I can't find the iface information in the iscsi_conn_t struct that
is passed in ktransport_ep_connect(). I thought that the iface would
be tied to a specific connection, but maybe I misunderstand that
concept. I would have to extend iscsi_conn_t (or some child struct) to
hold the source IP address, but it seems that other technologies may
prefer something different, so it seems that the ideal case would to
just link the entire iface struct in iscsi_conn_t so that each
technology could choose what they like from it. I'm still not sure
where the best place would be to link the iface to iscsi_conn_t.
2. The source address would have to be appended to the parameter list
passed into ep_connect. If we pass in source_address, that seems
simple enough, but if we pass in the iface, the kernel then has to
know the iface format. In any case, I'm not sure how to address the
change in API. It seems that the iface info could make the cxgb[3,4]i
code simpler as it may not have to search for the adapter itself if
defined in an iface.
3. Is there some other way I should approach this issue?

Thank you.

[1] https://groups.google.com/forum/#!topic/open-iscsi/IywifztV7Xs
[2] diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a887ef..e9741df 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -59,6 +59,7 @@
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/module.h>
+#include <linux/inet.h>

#include <net/sock.h>

@@ -814,6 +815,10 @@ static int iscsi_iser_get_ep_param(struct
iscsi_endpoint *ep,
       int err;
       struct iser_conn *iser_conn;
       struct iscsi_endpoint *ep;
+       struct sockaddr_in s_addr;
+       memset(&s_addr, 0, sizeof(s_addr));
+       s_addr.sin_family = AF_INET;
+       s_addr.sin_addr.s_addr = in_aton("192.168.13.14");

       ep = iscsi_create_endpoint(0);
       if (!ep)
@@ -829,7 +834,8 @@ static int iscsi_iser_get_ep_param(struct
iscsi_endpoint *ep,
       iser_conn->ep = ep;
       iser_conn_init(iser_conn);

-       err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
+       err = iser_connect(iser_conn, (struct sockaddr *) &s_addr,
dst_addr, non_blocking);
       if (err)
               goto failure;

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c
b/drivers/infiniband/ulp/iser/iser_verbs.c
index c538a38..6ce1845 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -953,6 +953,7 @@ int iser_connect(struct iser_conn   *iser_conn,
       sprintf(iser_conn->name, "%pISp", dst_addr);

       iser_info("connecting to: %s\n", iser_conn->name);
+       iser_err("connecting from: %p\n", src_addr);

       /* the device is known only --after-- address resolution */
       ib_conn->device = NULL;
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
