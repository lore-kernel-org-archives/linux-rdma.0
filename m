From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Mon, 23 Jan 2017 12:24:42 -0700
Message-ID: <CAANLjFoLUo6oLGaE6toeuL+dUOsCBeqriu0RpyB5Packvv8K=A@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <1485198613.2825.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485198613.2825.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 23, 2017 at 12:10 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On Mon, 2017-01-23 at 12:01 -0700, Robert LeBlanc wrote:
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index 8368764..ed36748 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -2089,3 +2089,19 @@ void ib_drain_qp(struct ib_qp *qp)
>>                ib_drain_rq(qp);
>> }
>> EXPORT_SYMBOL(ib_drain_qp);
>> +
>> +void ib_reset_sq(struct ib_qp *qp)
>> +{
>> +       struct ib_qp_attr attr = { .qp_state = IB_QPS_RESET};
>> +       int ret;
>> +
>> +       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> +}
>> +EXPORT_SYMBOL(ib_reset_sq);
>> +
>> +void ib_reset_qp(struct ib_qp *qp)
>> +{
>> +       printk("ib_reset_qp calling ib_reset_sq.\n");
>> +       ib_reset_sq(qp);
>> +}
>> +EXPORT_SYMBOL(ib_reset_qp);
>
> These are one liners. Is it really worth to add one-line functions to the
> IB core?
>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
>> b/drivers/infiniband/ulp/isert/ib_isert.c
>> index 6dd43f6..619dbc7 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -2595,10 +2595,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
>>        isert_conn_terminate(isert_conn);
>>        mutex_unlock(&isert_conn->mutex);
>>
>> -       ib_drain_qp(isert_conn->qp);
>> +       ib_reset_qp(isert_conn->qp);
>>        isert_put_unsol_pending_cmds(conn);
>> -       isert_wait4cmds(conn);
>> -       isert_wait4logout(isert_conn);
>> +       cancel_work_sync(&isert_conn->release_work);
>>
>>        queue_work(isert_release_wq, &isert_conn->release_work);
>> }
>
> Sorry but leaving out the ib_drain_qp() and isert_wait*() calls seems wrong
> to me. Additionally, resetting the send queue should not be needed since the
> iSER target driver should guarantee that no new WRs will be queued on the
> send queue after isert_wait_conn() is called.
>
> Seeing this patch makes me wonder whether this behavior can be reproduced
> with any other HBA than ConnectX-4 Lx? Is this a software or a firmware bug?
>
> Thanks,
>
> Bart.

Yes, it all feels wrong which is why I need some guidance. The
backtrace of the Infiniband and RoCE target D state processes are
identical, I believe that there is an additional bug in the
ConnectX-4-LX firmware that causes the D state problem on the target
to be triggered much easier. The release notes seem to indicate that
it may firmware bug may be fixed in 14.17.2020, but there is not a
SuperMicro version yet and I can't match up the board IDs with enough
confidence yet to flash the Mellanox firmware to test.

In summary, I think there are two bugs. One in iSER causing the target
to go into D state when something funky happens with the connection on
both Infiniband and RoCE. And a second one in the ConnectX-4-LX
firmware which easily triggers the first more critical issue.

Is there someway to inspect what may be in the queue pair to see what
may be blocking things?

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
