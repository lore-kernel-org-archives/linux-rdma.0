From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/ipoib: Handle QP in SQE state
Date: Thu, 16 Apr 2015 17:32:26 +0300
Message-ID: <CAAk-MO_nojMF-xTOCSAwE6xO8-2Ad9Hb4GUqR3z5zZB8z7B+9Q@mail.gmail.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
	<1427971145-26943-4-git-send-email-ogerlitz@mellanox.com>
	<13F95634-36B6-4759-A300-E140CB7FF70D@redhat.com>
	<CAAk-MO8CX7zrbSnVc9NJt5pYTO4Apj_j4PSosXRKwe0BKv+1Aw@mail.gmail.com>
	<26D88BAE-0450-4191-AE16-088F3714DC0E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26D88BAE-0450-4191-AE16-088F3714DC0E-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 16, 2015 at 4:29 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>
>> On Apr 15, 2015, at 9:29 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>>
>> Hi Doug
>>
>> (now with "reply to all" :) )
>>
>> On Wed, Apr 15, 2015 at 3:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>
>>>> On Apr 2, 2015, at 6:39 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>>>>
>>>> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> As the result of a completion error the QP can moved to SQE state =
by
>>>> the hardware. Since it's not the Error state, there are no flushes
>>>> and hence the driver doesn't know about that.
>>>>
>>>> The fix creates a task that after completion with error which is n=
ot a
>>>> flush tracks the QP state and if it is in SQE state moves it back =
to RTS.
>>>
>>> I assume you found this particular issue while tracking down the ca=
use of the problem that you fixed in patch #6?  Otherwise, this is a =E2=
=80=9Cnever should happen=E2=80=9D situation, yes?
>>>
>>
>> Not only. it happened in the case that described in patch#6 and also
>> in some other errors that caused the FW/HW to decide move the UD QO =
to
>> SQE state (in the category of "bad thing happened.."  like damaged
>> WQE, FW problem, etc.)
>> The patch originally was written to solve such cases which we really
>> saw, at testing, customers etc. and not for patch#6
>>
>>>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>> drivers/infiniband/ulp/ipoib/ipoib.h    |    5 +++
>>>> drivers/infiniband/ulp/ipoib/ipoib_ib.c |   59 +++++++++++++++++++=
+++++++++++-
>>>> 2 files changed, 63 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infini=
band/ulp/ipoib/ipoib.h
>>>> index 769044c..2703d9a 100644
>>>> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
>>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>>>> @@ -299,6 +299,11 @@ struct ipoib_neigh_table {
>>>>      struct completion               deleted;
>>>> };
>>>>
>>>> +struct ipoib_qp_state_validate {
>>>> +     struct work_struct work;
>>>> +     struct ipoib_dev_priv   *priv;
>>>> +};
>>>
>>> Why did you choose to do an allocated work struct?  All of the othe=
r tasks we have use a static work struct that=E2=80=99s part of the ipo=
ib private dev, so this is a bit out of the norm.  In its current form,=
 you only use this on the single UD queue pair that the dev uses, and n=
ot ever on any connected mode queue pairs, so it could be static.  Or w=
ere you looking at the possibility of making the task work on the CM qu=
eue pairs and so left it allocated?  And if that, why not include a ref=
erence to the broken queue pair in the work struct instead of always us=
ing priv->qp?
>>>
>>
>> It looks (at least for me) more elegant to create "on-the-fly" work
>> create/queue and delete at the end (BTW, I saw it many times, other
>> than ipoib).
>> There is no need for that in the CM mode, there the connection and t=
he
>> QP are destroyed, and new one will be created, only in UD mode the Q=
P
>> is forever.
>
> I knew it wasn=E2=80=99t needed in CM mode currently, but I didn=E2=80=
=99t know if there was a plan in your mind to change the way CM worked =
so that it tried to rescue a queue pair instead of destroying and start=
ing over.
>
> However, I really think we need to be consistent in this driver.  If =
we allocate our work struct in one and only one place, then we run into=
 the problem where someone working on the driver in the future has to t=
ry and remember =E2=80=9CGee, is this the one function that allocates o=
ur work struct and we must then free it to avoid leaking memory, or was=
 that a different function?=E2=80=9D  I would overlook that if we had a=
 plan that involved this function ever operating on anything other than=
 the UD QP, in which case you would have to allocate a struct to design=
ate the QP in question, and you would have to allocate a struct per ins=
tance because it would technically be possible to have more than one QP=
 in an SQE state at once.  But if that=E2=80=99s not the plan, then ple=
ase rework this patch to add the work struct to the ipoib private dev l=
ike we do with all the other work structs.  I=E2=80=99d like to swap th=
is one out of my tree for your new one ASAP.
>

There is a plan to have more than one UD QP per device, in order to
have multi-queue interfaces (not according to the CM QP but with the
same idea that you said, many objects that can use different work
each).
So, i think that this way to allocate work object is still reasonable.

>>
>>>> /*
>>>> * Device private locking: network stack tx_lock protects members u=
sed
>>>> * in TX fast path, lock protects everything else.  lock nests insi=
de
>>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/inf=
iniband/ulp/ipoib/ipoib_ib.c
>>>> index 29b376d..63b92cb 100644
>>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>>>> @@ -327,6 +327,51 @@ static void ipoib_dma_unmap_tx(struct ib_devi=
ce *ca,
>>>>      }
>>>> }
>>>>
>>>> +/*
>>>> + * As the result of a completion error the QP Can be transferred =
to SQE states.
>>>> + * The function checks if the (send)QP is in SQE state and
>>>> + * moves it back to RTS state, that in order to have it functiona=
l again.
>>>> + */
>>>> +static void ipoib_qp_state_validate_work(struct work_struct *work=
)
>>>> +{
>>>> +     struct ipoib_qp_state_validate *qp_work =3D
>>>> +             container_of(work, struct ipoib_qp_state_validate, w=
ork);
>>>> +
>>>> +     struct ipoib_dev_priv *priv =3D qp_work->priv;
>>>> +     struct ib_qp_attr qp_attr;
>>>> +     struct ib_qp_init_attr query_init_attr;
>>>> +     int ret;
>>>> +
>>>> +     ret =3D ib_query_qp(priv->qp, &qp_attr, IB_QP_STATE, &query_=
init_attr);
>>>> +     if (ret) {
>>>> +             ipoib_warn(priv, "%s: Failed to query QP ret: %d\n",
>>>> +                        __func__, ret);
>>>> +             goto free_res;
>>>> +     }
>>>> +     pr_info("%s: QP: 0x%x is in state: %d\n",
>>>> +             __func__, priv->qp->qp_num, qp_attr.qp_state);
>>>> +
>>>> +     /* currently support only in SQE->RTS transition*/
>>>> +     if (qp_attr.qp_state =3D=3D IB_QPS_SQE) {
>>>> +             qp_attr.qp_state =3D IB_QPS_RTS;
>>>> +
>>>> +             ret =3D ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE=
);
>>>> +             if (ret) {
>>>> +                     pr_warn("failed(%d) modify QP:0x%x SQE->RTS\=
n",
>>>> +                             ret, priv->qp->qp_num);
>>>> +                     goto free_res;
>>>> +             }
>>>> +             pr_info("%s: QP: 0x%x moved from IB_QPS_SQE to IB_QP=
S_RTS\n",
>>>> +                     __func__, priv->qp->qp_num);
>>>> +     } else {
>>>> +             pr_warn("QP (%d) will stay in state: %d\n",
>>>> +                     priv->qp->qp_num, qp_attr.qp_state);
>>>> +     }
>>>> +
>>>> +free_res:
>>>> +     kfree(qp_work);
>>>> +}
>>>> +
>>>> static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct i=
b_wc *wc)
>>>> {
>>>>      struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>>>> @@ -358,10 +403,22 @@ static void ipoib_ib_handle_tx_wc(struct net=
_device *dev, struct ib_wc *wc)
>>>>              netif_wake_queue(dev);
>>>>
>>>>      if (wc->status !=3D IB_WC_SUCCESS &&
>>>> -         wc->status !=3D IB_WC_WR_FLUSH_ERR)
>>>> +         wc->status !=3D IB_WC_WR_FLUSH_ERR) {
>>>> +             struct ipoib_qp_state_validate *qp_work;
>>>>              ipoib_warn(priv, "failed send event "
>>>>                         "(status=3D%d, wrid=3D%d vend_err %x)\n",
>>>>                         wc->status, wr_id, wc->vendor_err);
>>>> +             qp_work =3D kzalloc(sizeof(*qp_work), GFP_ATOMIC);
>>>> +             if (!qp_work) {
>>>> +                     ipoib_warn(priv, "%s Failed alloc ipoib_qp_s=
tate_validate for qp: 0x%x\n",
>>>> +                                __func__, priv->qp->qp_num);
>>>> +                     return;
>>>> +             }
>>>> +
>>>> +             INIT_WORK(&qp_work->work, ipoib_qp_state_validate_wo=
rk);
>>>> +             qp_work->priv =3D priv;
>>>> +             queue_work(priv->wq, &qp_work->work);
>>>> +     }
>>>> }
>>>>
>>>> static int poll_tx(struct ipoib_dev_priv *priv)
>>>> --
>>>> 1.7.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> =E2=80=94
>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>        GPG Key ID: 0E572FDD
>>>
>>>
>>>
>>>
>>>
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
