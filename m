From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/ipoib: Handle QP in SQE state
Date: Wed, 15 Apr 2015 16:29:42 +0300
Message-ID: <CAAk-MO8CX7zrbSnVc9NJt5pYTO4Apj_j4PSosXRKwe0BKv+1Aw@mail.gmail.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
	<1427971145-26943-4-git-send-email-ogerlitz@mellanox.com>
	<13F95634-36B6-4759-A300-E140CB7FF70D@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13F95634-36B6-4759-A300-E140CB7FF70D-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug

(now with "reply to all" :) )

On Wed, Apr 15, 2015 at 3:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>
>> On Apr 2, 2015, at 6:39 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
>>
>> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> As the result of a completion error the QP can moved to SQE state by
>> the hardware. Since it's not the Error state, there are no flushes
>> and hence the driver doesn't know about that.
>>
>> The fix creates a task that after completion with error which is not=
 a
>> flush tracks the QP state and if it is in SQE state moves it back to=
 RTS.
>
> I assume you found this particular issue while tracking down the caus=
e of the problem that you fixed in patch #6?  Otherwise, this is a =E2=80=
=9Cnever should happen=E2=80=9D situation, yes?
>

Not only. it happened in the case that described in patch#6 and also
in some other errors that caused the FW/HW to decide move the UD QO to
SQE state (in the category of "bad thing happened.."  like damaged
WQE, FW problem, etc.)
The patch originally was written to solve such cases which we really
saw, at testing, customers etc. and not for patch#6

>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> drivers/infiniband/ulp/ipoib/ipoib.h    |    5 +++
>> drivers/infiniband/ulp/ipoib/ipoib_ib.c |   59 +++++++++++++++++++++=
+++++++++-
>> 2 files changed, 63 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniba=
nd/ulp/ipoib/ipoib.h
>> index 769044c..2703d9a 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>> @@ -299,6 +299,11 @@ struct ipoib_neigh_table {
>>       struct completion               deleted;
>> };
>>
>> +struct ipoib_qp_state_validate {
>> +     struct work_struct work;
>> +     struct ipoib_dev_priv   *priv;
>> +};
>
> Why did you choose to do an allocated work struct?  All of the other =
tasks we have use a static work struct that=E2=80=99s part of the ipoib=
 private dev, so this is a bit out of the norm.  In its current form, y=
ou only use this on the single UD queue pair that the dev uses, and not=
 ever on any connected mode queue pairs, so it could be static.  Or wer=
e you looking at the possibility of making the task work on the CM queu=
e pairs and so left it allocated?  And if that, why not include a refer=
ence to the broken queue pair in the work struct instead of always usin=
g priv->qp?
>

It looks (at least for me) more elegant to create "on-the-fly" work
create/queue and delete at the end (BTW, I saw it many times, other
than ipoib).
There is no need for that in the CM mode, there the connection and the
QP are destroyed, and new one will be created, only in UD mode the QP
is forever.

>> /*
>>  * Device private locking: network stack tx_lock protects members us=
ed
>>  * in TX fast path, lock protects everything else.  lock nests insid=
e
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infin=
iband/ulp/ipoib/ipoib_ib.c
>> index 29b376d..63b92cb 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>> @@ -327,6 +327,51 @@ static void ipoib_dma_unmap_tx(struct ib_device=
 *ca,
>>       }
>> }
>>
>> +/*
>> + * As the result of a completion error the QP Can be transferred to=
 SQE states.
>> + * The function checks if the (send)QP is in SQE state and
>> + * moves it back to RTS state, that in order to have it functional =
again.
>> + */
>> +static void ipoib_qp_state_validate_work(struct work_struct *work)
>> +{
>> +     struct ipoib_qp_state_validate *qp_work =3D
>> +             container_of(work, struct ipoib_qp_state_validate, wor=
k);
>> +
>> +     struct ipoib_dev_priv *priv =3D qp_work->priv;
>> +     struct ib_qp_attr qp_attr;
>> +     struct ib_qp_init_attr query_init_attr;
>> +     int ret;
>> +
>> +     ret =3D ib_query_qp(priv->qp, &qp_attr, IB_QP_STATE, &query_in=
it_attr);
>> +     if (ret) {
>> +             ipoib_warn(priv, "%s: Failed to query QP ret: %d\n",
>> +                        __func__, ret);
>> +             goto free_res;
>> +     }
>> +     pr_info("%s: QP: 0x%x is in state: %d\n",
>> +             __func__, priv->qp->qp_num, qp_attr.qp_state);
>> +
>> +     /* currently support only in SQE->RTS transition*/
>> +     if (qp_attr.qp_state =3D=3D IB_QPS_SQE) {
>> +             qp_attr.qp_state =3D IB_QPS_RTS;
>> +
>> +             ret =3D ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE);
>> +             if (ret) {
>> +                     pr_warn("failed(%d) modify QP:0x%x SQE->RTS\n"=
,
>> +                             ret, priv->qp->qp_num);
>> +                     goto free_res;
>> +             }
>> +             pr_info("%s: QP: 0x%x moved from IB_QPS_SQE to IB_QPS_=
RTS\n",
>> +                     __func__, priv->qp->qp_num);
>> +     } else {
>> +             pr_warn("QP (%d) will stay in state: %d\n",
>> +                     priv->qp->qp_num, qp_attr.qp_state);
>> +     }
>> +
>> +free_res:
>> +     kfree(qp_work);
>> +}
>> +
>> static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_=
wc *wc)
>> {
>>       struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>> @@ -358,10 +403,22 @@ static void ipoib_ib_handle_tx_wc(struct net_d=
evice *dev, struct ib_wc *wc)
>>               netif_wake_queue(dev);
>>
>>       if (wc->status !=3D IB_WC_SUCCESS &&
>> -         wc->status !=3D IB_WC_WR_FLUSH_ERR)
>> +         wc->status !=3D IB_WC_WR_FLUSH_ERR) {
>> +             struct ipoib_qp_state_validate *qp_work;
>>               ipoib_warn(priv, "failed send event "
>>                          "(status=3D%d, wrid=3D%d vend_err %x)\n",
>>                          wc->status, wr_id, wc->vendor_err);
>> +             qp_work =3D kzalloc(sizeof(*qp_work), GFP_ATOMIC);
>> +             if (!qp_work) {
>> +                     ipoib_warn(priv, "%s Failed alloc ipoib_qp_sta=
te_validate for qp: 0x%x\n",
>> +                                __func__, priv->qp->qp_num);
>> +                     return;
>> +             }
>> +
>> +             INIT_WORK(&qp_work->work, ipoib_qp_state_validate_work=
);
>> +             qp_work->priv =3D priv;
>> +             queue_work(priv->wq, &qp_work->work);
>> +     }
>> }
>>
>> static int poll_tx(struct ipoib_dev_priv *priv)
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> =E2=80=94
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>         GPG Key ID: 0E572FDD
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
