From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/15] IB/rxe: Remove an unused variable
Date: Tue, 3 Jan 2017 12:39:52 -0600
Message-ID: <CAG53R5WnJy1cLdEZOpzk03aAE2L6v86n_-qEBpoaG+arymCxPw@mail.gmail.com>
References: <1483353316.3592.14.camel@sandisk.com> <1483353498.3592.20.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353498.3592.20.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

Additionally, since struct rxe_send_wqe is not used in get_mtu() function,
Can you please update signature to just have rxe_qp* as input argument?

Parav

On Jan 2, 2017 5:05 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

The variable 'av' is not used so remove it.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c
b/drivers/infiniband/sw/rxe/rxe_req.c
index 73d4a97603a1..b95b6035e988 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -364,16 +364,11 @@ static inline int check_init_depth(struct rxe_qp
*qp, struct rxe_send_wqe *wqe)
 static inline int get_mtu(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 {
        struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
-       struct rxe_port *port;
-       struct rxe_av *av;

        if ((qp_type(qp) == IB_QPT_RC) || (qp_type(qp) == IB_QPT_UC))
                return qp->mtu;

-       av = &wqe->av;
-       port = &rxe->port;
-
-       return port->mtu_cap;
+       return rxe->port.mtu_cap;
 }

 static struct sk_buff *init_req_packet(struct rxe_qp *qp,
-- 
2.11.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
