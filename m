From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rds: rds_ib_device.refcount overflow
Date: Thu, 30 Jul 2015 13:35:09 +0800
Message-ID: <55B9B78D.5000807@oracle.com>
References: <1436164511-2411-1-git-send-email-wen.gang.wang@oracle.com> <55A31202.1030408@oracle.com> <55B8E4F2.2060700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B8E4F2.2060700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Doug,

No problem. I found the patch picked up.

thanks,
wengang

=E5=9C=A8 2015=E5=B9=B407=E6=9C=8829=E6=97=A5 22:36, Doug Ledford =E5=86=
=99=E9=81=93:
> On 07/12/2015 09:18 PM, Wengang Wang wrote:
>> Hi Doug,
>>
>> How do you think about this patch?
> Sorry, I picked this up already.  I must have missed sending out the
> acknowledgment on this one.
>
>> thanks,
>> wengang
>>
>> =E5=9C=A8 2015=E5=B9=B407=E6=9C=8806=E6=97=A5 14:35, Wengang Wang =E5=
=86=99=E9=81=93:
>>> Fixes: 3e0249f9c05c ("RDS/IB: add refcount tracking to struct
>>> rds_ib_device")
>>>
>>> There lacks a dropping on rds_ib_device.refcount in case rds_ib_all=
oc_fmr
>>> failed(mr pool running out). this lead to the refcount overflow.
>>>
>>> A complain in line 117(see following) is seen. From vmcore:
>>> s_ib_rdma_mr_pool_depleted is 2147485544 and rds_ibdev->refcount is
>>> -2147475448.
>>> That is the evidence the mr pool is used up. so rds_ib_alloc_fmr is
>>> very likely
>>> to return ERR_PTR(-EAGAIN).
>>>
>>> 115 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
>>> 116 {
>>> 117         BUG_ON(atomic_read(&rds_ibdev->refcount) <=3D 0);
>>> 118         if (atomic_dec_and_test(&rds_ibdev->refcount))
>>> 119                 queue_work(rds_wq, &rds_ibdev->free_work);
>>> 120 }
>>>
>>> fix is to drop refcount when rds_ib_alloc_fmr failed.
>>>
>>> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>    net/rds/ib_rdma.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
>>> index 273b8bf..657ba9f 100644
>>> --- a/net/rds/ib_rdma.c
>>> +++ b/net/rds/ib_rdma.c
>>> @@ -759,8 +759,10 @@ void *rds_ib_get_mr(struct scatterlist *sg,
>>> unsigned long nents,
>>>        }
>>>          ibmr =3D rds_ib_alloc_fmr(rds_ibdev);
>>> -    if (IS_ERR(ibmr))
>>> +    if (IS_ERR(ibmr)) {
>>> +        rds_ib_dev_put(rds_ibdev);
>>>            return ibmr;
>>> +    }
>>>          ret =3D rds_ib_map_fmr(rds_ibdev, ibmr, sg, nents);
>>>        if (ret =3D=3D 0)
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
