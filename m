From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] staging: amso1100: fix format string for 64-bit phys_addr
Date: Mon, 01 Feb 2016 17:34:52 +0100
Message-ID: <2307631.X1DYNXxKPZ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The amso1100 driver prints a phys_addr_t by casting it to a pointer,
which causes a warning when phys_addr_t is 64-bit and pointers
are 32-bit:

drivers/staging/rdma/amso1100/c2.c: In function 'c2_rx_error':
drivers/staging/rdma/amso1100/c2.c:430:4: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

This changes the format string to print the address as a 64-bit
number all the time to avoids the warnings. Ideally we would use
the %pap format string for phys_addr_t, but that doesn't work
here easily as it requires passing a pointer to the address.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
Found on ARM randconfig testing. This must have been there forever but is
rather hard to trigger even with randconfig builds.

diff --git a/drivers/staging/rdma/amso1100/c2.c b/drivers/staging/rdma/amso1100/c2.c
index b46ebd1ae15a..170a42a60552 100644
--- a/drivers/staging/rdma/amso1100/c2.c
+++ b/drivers/staging/rdma/amso1100/c2.c
@@ -426,8 +426,8 @@ static void c2_rx_error(struct c2_port *c2_port, struct c2_element *elem)
 		pr_debug("    index : %Zu\n",
 			elem - c2_port->rx_ring.start);
 		pr_debug("    len   : %u\n", rx_desc->len);
-		pr_debug("  rxp_hdr : %p [PA %p]\n", rxp_hdr,
-			(void *) __pa((unsigned long) rxp_hdr));
+		pr_debug("  rxp_hdr : %p [PA %016llx\n", rxp_hdr,
+			(u64)__pa((unsigned long) rxp_hdr));
 		pr_debug("    flags : 0x%x\n", rxp_hdr->flags);
 		pr_debug("    status: 0x%x\n", rxp_hdr->status);
 		pr_debug("    len   : %u\n", rxp_hdr->len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
