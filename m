From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 20:10:31 +0100
Message-ID: <AANLkTinxZ=x9uQH-r1TN003HT1aKu_KjgF8-aXDkKzTm@mail.gmail.com>
References: <adalj2q587i.fsf@cisco.com> <1294854748.15826.26.camel@lap75545.ornl.gov>
 <ada8vyq57bq.fsf@cisco.com> <1294861341.15826.38.camel@lap75545.ornl.gov>
 <adaoc7l52hy.fsf@cisco.com> <adak4i952bk.fsf@cisco.com> <1294866460.15826.41.camel@lap75545.ornl.gov>
 <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ@mail.gmail.com> <1294932071.3667.5.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294932071.3667.5.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 13, 2011 at 4:21 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Thu, 2011-01-13 at 06:19 -0500, Bart Van Assche wrote:
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>> b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 4b62105..3164c4d 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -1132,16 +1132,12 @@ static int srp_queuecommand(struct Scsi_Host
>> *shost, struct scsi_cmnd *scmnd)
>>
>> =A0 =A0 =A0 spin_lock_irqsave(&target->lock, flags);
>> =A0 =A0 =A0 iu =3D __srp_get_tx_iu(target, SRP_IU_CMD);
>> - =A0 =A0 if (iu) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 req =3D list_first_entry(&target->free_req=
s, struct srp_request,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 list);
>> - =A0 =A0 =A0 =A0 =A0 =A0 list_del(&req->list);
>> - =A0 =A0 }
>> + =A0 =A0 if (unlikely(!iu))
>
> Please drop the unlikely -- it isn't at all unlikely on the hardware =
and
> loads I run.

OK, I have dropped "unlikely()" in the patch I have just posted - the
branch prediction circuitry in a CPU should be perfectly capable of
detecting in which direction that branch is taken.

But it surprises me that on the hardware and loads you run it
regularly happens that iu =3D=3D NULL -- a recent patch had the exact
purpose to avoid that ("IB/srp: Reduce number of BUSY conditions").
With that patch it should only occur that iu =3D=3D NULL if the target
violates the SRP spec by sending target-initiated information units so
fast that there is more than one unanswered request.

>> + =A0 =A0 =A0 =A0 =A0 =A0 goto err_unlock;
>> + =A0 =A0 req =3D list_first_entry(&target->free_reqs, struct srp_re=
quest, list);
>> + =A0 =A0 list_del(&req->list);
>> =A0 =A0 =A0 spin_unlock_irqrestore(&target->lock, flags);
>>
>> - =A0 =A0 if (!iu)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto err;
>> -
>> =A0 =A0 =A0 dev =3D target->srp_host->srp_dev->dev;
>> =A0 =A0 =A0 ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0D=
MA_TO_DEVICE);
>> @@ -1185,6 +1181,7 @@ err_iu:
>>
>> =A0 =A0 =A0 spin_lock_irqsave(&target->lock, flags);
>> =A0 =A0 =A0 list_add(&req->list, &target->free_reqs);
>> +err_unlock:
>
> Please add a line before the label.

OK, done.

> If Roland would like to rebase his tree and substitute your patch for=
 my
> quickie, then I'm fine with that and you can have my Acked-by with th=
e
> above changes. If not, then make it relative to the uninit var change
> and I'll be happy to put it in my pull request once the workqueue stu=
ff
> is sorted.

The patch I have sent is relative to Linus' linux-2.6.git tree, so
removing the uninit var change is a separate step. Roland, I assume
that it's not necessary to post a separate patch for reverting that
change ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
