From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
Date: Mon, 24 Jan 2011 20:42:36 +0100
Message-ID: <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ@mail.gmail.com>
References: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295800203-9552-1-git-send-email-ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 23, 2011 at 5:30 PM, Ralf Thielow
<ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
>
> Fixed compile warning by use "unsigned long" instead of "u64"
> on assign NULL to "c2_vq_req->reply_msg".
>
> Signed-off-by: Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> ---
> =A0drivers/infiniband/hw/amso1100/c2_vq.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/infinib=
and/hw/amso1100/c2_vq.c
> index 9ce7819..807b730 100644
> --- a/drivers/infiniband/hw/amso1100/c2_vq.c
> +++ b/drivers/infiniband/hw/amso1100/c2_vq.c
> @@ -107,7 +107,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2d=
ev)
> =A0 =A0 =A0 =A0r =3D kmalloc(sizeof(struct c2_vq_req), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (r) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0init_waitqueue_head(&r->wait_object);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 r->reply_msg =3D (u64) NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r->reply_msg =3D (unsigned long) NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r->event =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r->cm_id =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r->qp =3D NULL;
> @@ -123,7 +123,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2d=
ev)
> =A0*/
> =A0void vq_req_free(struct c2_dev *c2dev, struct c2_vq_req *r)
> =A0{
> - =A0 =A0 =A0 r->reply_msg =3D (u64) NULL;
> + =A0 =A0 =A0 r->reply_msg =3D (unsigned long) NULL;
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&r->refcnt)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(r);
> =A0 =A0 =A0 =A0}
> @@ -151,7 +151,7 @@ void vq_req_get(struct c2_dev *c2dev, struct c2_v=
q_req *r)
> =A0void vq_req_put(struct c2_dev *c2dev, struct c2_vq_req *r)
> =A0{
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&r->refcnt)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r->reply_msg !=3D (u64) NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r->reply_msg !=3D (unsigned long) N=
ULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vq_repbuf_free(c2dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (void *) (unsigned long) r->reply_msg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(r);

Hello Ralf,

Have you considered using "0" instead of "(u64) NULL" or "(unsigned
long) NULL" ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
