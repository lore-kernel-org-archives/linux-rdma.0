From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Mon, 23 Jan 2012 16:11:02 +0100
Message-ID: <4F1D7886.6010801@itwm.fraunhofer.de>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain> <1828884A29C6694DAF28B7E6B8A823732DC0C33E@ORSMSX106.amr.corp.intel.com> <4F1992F6.9070103@itwm.fraunhofer.de> <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/20/2012 07:40 PM, Roland Dreier wrote:
> On Fri, Jan 20, 2012 at 8:14 AM, Bernd Schubert
> <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>  wrote:
>> I *guess* the qp allocated by pd->context->ops.create_qp() does not have
>> qp->usecnt initialized (not does it know anything about it). So its random
>> value will fail the destruction later. A simple workaround that would work
>> for us, is to extend the patch I send to
>>
>> diff --git a/drivers/infiniband/core/verbs.c
>> b/drivers/infiniband/core/verbs.c
>> index 602b1bd..fba1675 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -874,7 +874,7 @@ int ib_destroy_qp(struct ib_qp *qp)
>>         struct ib_srq *srq;
>>         int ret;
>>
>> -       if (atomic_read(&qp->usecnt))
>> +       if (qp->qp_type == IB_QPT_XRC_TGT&&  atomic_read(&qp->usecnt))
>>                 return -EBUSY;
>>
>>         if (qp->real_qp != qp)
>
> It looks like this is sufficient and correct without the other patch?
>
>>
>>
>> However, what is is with user space setting type to IB_QPT_XRC_TGT? I guess
>> this could be solved by letting the kernel zero the memory returned by
>> ->ops.create_qp(pd, qp_init_attr).
>> Btw, I didn't figure out yet, how this translates at all in kernel space? Is
>> this op directly going to the device driver?
>>
>> But even if we are properly going to initialize the qp, what is with user
>> space mischievously trying to crash the system by manipulating struct ib_qp
>> *qp?
>
> I don't follow this.  Isn't *qp completely allocated and manipulated
> in the kernel?  How can userspace touch it except by having the
> kernel do something via the uverbs interface?

Sorry, I first didn't see the ib_uverbs_create_qp() interface and 
copy_from/to_user() there.


Cheers,
Bernd

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
