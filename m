From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: "cookie" can stay in host endianness
Date: Tue, 05 Feb 2013 21:51:30 +0100
Message-ID: <1360097490.14826.23.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Work requests are passed and reflected between the host and the
firmware with a "cookie". This cookie is swapped to big endianness when
passed to the firmware and to host endianness on reflection. This
swapping seems to be implemented incorrectly. Moreover, the byte
swapping triggers GCC warnings on 32 bit:
    drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98passive_ofld=
_conn_reply=E2=80=99:
    drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to pointer =
from integer of different size [-Wint-to-pointer-cast]
    drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98send_fw_pass=
_open_req=E2=80=99:
    drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from pointe=
r to integer of different size [-Wpointer-to-int-cast]
    [...]

But byte swapping isn't needed as the firmware doesn't actually touch
the cookie. Dropping byte swapping makes the warnings go away too.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
---
0) Compile tested only (but on 32 and 64 bit little endian).

1) Please have a careful look at my commit explanation. It's mostly a
bit of creative writing based on my understanding of Steve's feedback.=20

 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/c=
xgb4/cm.c
index c13745c..cd072fb 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2800,7 +2800,7 @@ static void passive_ofld_conn_reply(struct c4iw_d=
ev *dev, struct sk_buff *skb,
 	struct cpl_pass_accept_req *cpl;
 	int ret;
=20
-	rpl_skb =3D (struct sk_buff *)cpu_to_be64(req->cookie);
+	rpl_skb =3D (struct sk_buff *)(unsigned long)req->cookie;
 	BUG_ON(!rpl_skb);
 	if (req->retval) {
 		PDBG("%s passive open failure %d\n", __func__, req->retval);
@@ -2938,7 +2938,7 @@ static void send_fw_pass_open_req(struct c4iw_dev=
 *dev, struct sk_buff *skb,
 	 * TP will ignore any value > 0 for MSS index.
 	 */
 	req->tcb.opt0 =3D cpu_to_be64(V_MSS_IDX(0xF));
-	req->cookie =3D cpu_to_be64((u64)skb);
+	req->cookie =3D (unsigned long)skb;
=20
 	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
 	cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
--=20
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
