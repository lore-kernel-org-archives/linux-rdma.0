From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Mon, 23 Jan 2017 15:42:04 -0700
Message-ID: <CAANLjFosiwscM+eBJ0ZsaUXpG60cjyZvJnamrF=tr15in5Lwtg@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <1485198613.2825.4.camel@sandisk.com> <1131067681.19851058.1485202831888.JavaMail.zimbra@redhat.com>
 <854924612.19878721.1485207662742.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <854924612.19878721.1485207662742.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I still haven't been able to reproduce it on Infiniband like I was
able to a month ago. I'm still trying to figure out what I was doing
differently.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Jan 23, 2017 at 2:41 PM, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> ----- Original Message -----
>> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Sent: Monday, January 23, 2017 3:20:31 PM
>> Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
>>
>>
>>
>> ----- Original Message -----
>> > From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> > To: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > Sent: Monday, January 23, 2017 2:10:27 PM
>> > Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D
>> > state
>> >
>> > On Mon, 2017-01-23 at 12:01 -0700, Robert LeBlanc wrote:
>> > > diff --git a/drivers/infiniband/core/verbs.c
>> > > b/drivers/infiniband/core/verbs.c
>> > > index 8368764..ed36748 100644
>> > > --- a/drivers/infiniband/core/verbs.c
>> > > +++ b/drivers/infiniband/core/verbs.c
>> > > @@ -2089,3 +2089,19 @@ void ib_drain_qp(struct ib_qp *qp)
>> > >                ib_drain_rq(qp);
>> > > }
>> > > EXPORT_SYMBOL(ib_drain_qp);
>> > > +
>> > > +void ib_reset_sq(struct ib_qp *qp)
>> > > +{
>> > > +       struct ib_qp_attr attr = { .qp_state = IB_QPS_RESET};
>> > > +       int ret;
>> > > +
>> > > +       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> > > +}
>> > > +EXPORT_SYMBOL(ib_reset_sq);
>> > > +
>> > > +void ib_reset_qp(struct ib_qp *qp)
>> > > +{
>> > > +       printk("ib_reset_qp calling ib_reset_sq.\n");
>> > > +       ib_reset_sq(qp);
>> > > +}
>> > > +EXPORT_SYMBOL(ib_reset_qp);
>> >
>> > These are one liners. Is it really worth to add one-line functions to the
>> > IB core?
>> >
>> > > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
>> > > b/drivers/infiniband/ulp/isert/ib_isert.c
>> > > index 6dd43f6..619dbc7 100644
>> > > --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> > > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> > > @@ -2595,10 +2595,9 @@ static void isert_wait_conn(struct iscsi_conn
>> > > *conn)
>> > >        isert_conn_terminate(isert_conn);
>> > >        mutex_unlock(&isert_conn->mutex);
>> > >
>> > > -       ib_drain_qp(isert_conn->qp);
>> > > +       ib_reset_qp(isert_conn->qp);
>> > >        isert_put_unsol_pending_cmds(conn);
>> > > -       isert_wait4cmds(conn);
>> > > -       isert_wait4logout(isert_conn);
>> > > +       cancel_work_sync(&isert_conn->release_work);
>> > >
>> > >        queue_work(isert_release_wq, &isert_conn->release_work);
>> > > }
>> >
>> > Sorry but leaving out the ib_drain_qp() and isert_wait*() calls seems wrong
>> > to me. Additionally, resetting the send queue should not be needed since
>> > the
>> > iSER target driver should guarantee that no new WRs will be queued on the
>> > send queue after isert_wait_conn() is called.
>> >
>> > Seeing this patch makes me wonder whether this behavior can be reproduced
>> > with any other HBA than ConnectX-4 Lx? Is this a software or a firmware
>> > bug?
>> >
>> > Thanks,
>> >
>> > Bart.--
>> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> Hello Bart
>>
>> Its on my plate to try reproduce, I was not able to reproduce with my mlx4
>> and IB as I was not in the office to pull cables and I am back-to-back.
>> I also need to try Ethernet.
>>
>> I hope to see if I can reproduce What Robert is seeing later this week as I
>> am fully back in the office tomorrow.
>>
>> If I can, I will try make some sense of this.
>>
>> Thanks
>> Laurence
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Hello Robert
> Are you reproducing again on ISER/IB using the cable pull method.
> Thanks
> Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
