From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: Fix error in hfi1 driver build
Date: Fri, 20 Nov 2015 18:13:08 -0500
Message-ID: <1448061188-15701-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

hfi1 driver build fails with the following error:
In function =E2=80=98handle_receive_interrupt=E2=80=99:
error: implicit declaration of function =E2=80=98skip_rcv_packet=E2=80=99=
 [-Werror=3Dimplicit-function-declaration]
    last =3D skip_rcv_packet(&packet, thread);
    ^
This is due to the inclusion of the skip_rcv_packet() in the
CONFIG_PRESCAN_RXQ ifdef block. This function is independent of
CONFIG_PRESCAN_RXQ and should be outside this block.

=46ixes: 82c2611daaf0 ("staging/rdma/hfi1: Handle packets with invalid =
RHF on context 0")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/=
hfi1/driver.c
index 4c52e78..3b7a707 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -633,6 +633,7 @@ next:
 		update_ps_mdata(&mdata, rcd);
 	}
 }
+#endif /* CONFIG_PRESCAN_RXQ */
=20
 static inline int skip_rcv_packet(struct hfi1_packet *packet, int thre=
ad)
 {
@@ -659,7 +660,6 @@ static inline int skip_rcv_packet(struct hfi1_packe=
t *packet, int thread)
=20
 	return ret;
 }
-#endif /* CONFIG_PRESCAN_RXQ */
=20
 static inline int process_rcv_packet(struct hfi1_packet *packet, int t=
hread)
 {
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
