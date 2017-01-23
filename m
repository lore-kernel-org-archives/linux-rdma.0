From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D
 state
Date: Mon, 23 Jan 2017 19:10:27 +0000
Message-ID: <1485198613.2825.4.camel@sandisk.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <9D7BEE95EB7D684FBEC79E379E7C16E5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-01-23 at 12:01 -0700, Robert LeBlanc wrote:
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index 8368764..ed36748 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -2089,3 +2089,19 @@ void ib_drain_qp(struct ib_qp *qp)
>                ib_drain_rq(qp);
> }
> EXPORT_SYMBOL(ib_drain_qp);
> +
> +void ib_reset_sq(struct ib_qp *qp)
> +{
> +       struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_RESET};
> +       int ret;
> +
> +       ret =3D ib_modify_qp(qp, &attr, IB_QP_STATE);
> +}
> +EXPORT_SYMBOL(ib_reset_sq);
> +
> +void ib_reset_qp(struct ib_qp *qp)
> +{
> +       printk("ib_reset_qp calling ib_reset_sq.\n");
> +       ib_reset_sq(qp);
> +}
> +EXPORT_SYMBOL(ib_reset_qp);

These are one liners. Is it really worth to add one-line functions to the
IB core?

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
> b/drivers/infiniband/ulp/isert/ib_isert.c
> index 6dd43f6..619dbc7 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2595,10 +2595,9 @@ static void isert_wait_conn(struct iscsi_conn *con=
n)
>        isert_conn_terminate(isert_conn);
>        mutex_unlock(&isert_conn->mutex);
>=20
> -       ib_drain_qp(isert_conn->qp);
> +       ib_reset_qp(isert_conn->qp);
>        isert_put_unsol_pending_cmds(conn);
> -       isert_wait4cmds(conn);
> -       isert_wait4logout(isert_conn);
> +       cancel_work_sync(&isert_conn->release_work);
>=20
>        queue_work(isert_release_wq, &isert_conn->release_work);
> }

Sorry but leaving out the ib_drain_qp() and isert_wait*() calls seems wrong
to me. Additionally, resetting the send queue should not be needed since th=
e
iSER target driver should guarantee that no new WRs will be queued on the
send queue after isert_wait_conn() is called.

Seeing this patch makes me wonder whether this behavior can be reproduced
with any other HBA than ConnectX-4 Lx? Is this a software or a firmware bug=
?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
