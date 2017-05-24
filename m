From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Wed, 24 May 2017 12:14:53 -0600
Message-ID: <CAANLjFpHbMXjMnxO0B7sn9rRz2Sn3CEx-bEWKW5BrYj3itQ0HQ@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
 <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com>
 <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA@mail.gmail.com> <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 23, 2017 at 5:17 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> I could not replicate ping6 working today without passing the -I
> parameter. I created https://github.com/linux-rdma/rdma-core/pull/136
> and now you can pass -I to rping to have it bind to a source address
> just like ping and the rules and additional routing table works for
> rping.
>
> However, iSER is not able to find a network route. Where do you think
> I should look next? It seems that RDMA_CM is able to work properly if
> given the right information.
>
> Thanks,
> Robert
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>

Looks like the bug is in iSER, it is always passing NULL for the source address.

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
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
+       //err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
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

Hard coding the source IP address allows the connection to work fine.
It seems for some reason, it is not using the information from the
iface that we configured. I can try to create a patch, but I'm not
sure where to query the ifaces for the required info. If you can point
me in the right place, I can give it a shot.

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
