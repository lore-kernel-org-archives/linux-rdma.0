From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Fri, 20 Jan 2012 10:43:51 -0800
Message-ID: <CAL1RGDW=XfCd3aCmB0mE1WcOUeDj=17=s2K0A3zpFmBF6Rg_Rg@mail.gmail.com>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain>
 <1828884A29C6694DAF28B7E6B8A823732DC0C33E@ORSMSX106.amr.corp.intel.com>
 <4F1992F6.9070103@itwm.fraunhofer.de> <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2012 at 10:40 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> On Fri, Jan 20, 2012 at 8:14 AM, Bernd Schubert
> <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org> wrote:
>> I *guess* the qp allocated by pd->context->ops.create_qp() does not =
have
>> qp->usecnt initialized (not does it know anything about it). So its =
random
>> value will fail the destruction later. A simple workaround that woul=
d work
>> for us, is to extend the patch I send to
>>
>> diff --git a/drivers/infiniband/core/verbs.c
>> b/drivers/infiniband/core/verbs.c
>> index 602b1bd..fba1675 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -874,7 +874,7 @@ int ib_destroy_qp(struct ib_qp *qp)
>> =A0 =A0 =A0 =A0struct ib_srq *srq;
>> =A0 =A0 =A0 =A0int ret;
>>
>> - =A0 =A0 =A0 if (atomic_read(&qp->usecnt))
>> + =A0 =A0 =A0 if (qp->qp_type =3D=3D IB_QPT_XRC_TGT && atomic_read(&=
qp->usecnt))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EBUSY;
>>
>> =A0 =A0 =A0 =A0if (qp->real_qp !=3D qp)
>
> It looks like this is sufficient and correct without the other patch?

But maybe it's cleaner to initialize qp->usecnt in
both ib_create_qp() and ib_uverbs_create_qp().

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
