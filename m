From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 02/10] IB/core: Add flags parameter for ib_create_cq
Date: Wed, 20 May 2015 19:46:11 +0300
Message-ID: <CAAKD3BA8DKLCA8C2KH+TkgCx1RjoDQMDg2rRFpC9ps8htyLTjA@mail.gmail.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
	<1431869786-6308-3-git-send-email-ogerlitz@mellanox.com>
	<1432135457.5304.33.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432135457.5304.33.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 6:24 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> w=
rote:
> Hi,
>
> Le dimanche 17 mai 2015 =E0 16:36 +0300, Or Gerlitz a =E9crit :
>> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c
>> b/drivers/infiniband/ulp/iser/iser_verbs.c
>> index cc2dd35..922d322 100644
>> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>> @@ -126,11 +126,9 @@ static int iser_create_device_ib_res(struct
>> iser_device *device)
>>                 struct iser_comp *comp =3D &device->comps[i];
>>
>>                 comp->device =3D device;
>> -               comp->cq =3D ib_create_cq(device->ib_device,
>> -                                       iser_cq_callback,
>> -                                       iser_cq_event_callback,
>> -                                       (void *)comp,
>> -                                       max_cqe, i);
>> +               comp->cq =3D ib_create_cq(device->ib_device, iser_cq=
_callback,
>> +                                       iser_cq_event_callback, (voi=
d *)comp,
>> +                                       max_cqe, i, 0);
>
> Don't change indentation needlessly.
>
>
>>                 if (IS_ERR(comp->cq)) {
>>                         comp->cq =3D NULL;
>>                         goto cq_err;
>
>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
>> b/drivers/infiniband/ulp/isert/ib_isert.c
>> index 327529e..f7d9ae0 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -320,11 +320,12 @@ isert_alloc_comps(struct isert_device *device,
>>
>>                 comp->device =3D device;
>>                 INIT_WORK(&comp->work, isert_cq_work);
>> -               comp->cq =3D ib_create_cq(device->ib_device,
>> -                                       isert_cq_callback,
>> +               comp->cq =3D ib_create_cq(device->ib_device, isert_c=
q_callback,
>
> Don't change indentation.
>
>>                                         isert_cq_event_callback,
>>                                         (void *)comp,
>> -                                       max_cqe, i);
>> +                                       max_cqe,
>> +                                       i,
>> +                                       0);
>>                 if (IS_ERR(comp-&gt;cq)) {
>>                         isert_err("Unable to allocate cq\n");
>>                         ret =3D PTR_ERR(comp-&gt;cq);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index ad0e2ea..1bbe4a4 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -173,6 +173,10 @@ struct ib_odp_caps {
>>         } per_transport_caps;
>>  };
>>
>> +enum ib_cq_creation_flags {
>> +       IB_CQ_FLAGS_TIMESTAMP   =3D 1 << 0,
>> +};
>> +
>
> That's must be part of a different patch, otherwise the commit messag=
e
> is not true.
>
>>  struct ib_cq_init_attr {
>>         int cqe;
>>         int comp_vector;
>
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> index 3df8320..cfb5915 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -901,21 +901,16 @@ static struct svc_xprt *svc_rdma_accept(struct
>> svc_xprt *xprt)
>>                 goto errout;
>>         }
>>         newxprt->sc_sq_cq =3D ib_create_cq(newxprt->sc_cm_id->device=
,
>> -                                        sq_comp_handler,
>> -                                        cq_event_handler,
>> -                                        newxprt,
>> -                                        newxprt->sc_sq_depth,
>> -                                        0);
>> +                                        sq_comp_handler, cq_event_h=
andler,
>> +                                        newxprt, newxprt->sc_sq_dep=
th, 0, 0);
>
> Don't change indentation.
>
>>         if (IS_ERR(newxprt->sc_sq_cq)) {
>>                 dprintk("svcrdma: error creating SQ CQ for connect
>> request\n");
>>                 goto errout;
>>         }
>>         newxprt->sc_rq_cq =3D ib_create_cq(newxprt->sc_cm_id->device=
,
>> -                                        rq_comp_handler,
>> -                                        cq_event_handler,
>> -                                        newxprt,
>> -                                        newxprt->sc_max_requests,
>> -                                        0);
>> +                                        rq_comp_handler, cq_event_h=
andler,
>> +                                        newxprt, newxprt->sc_max_re=
quests,
>> +                                        0, 0);
>
> Don't change indentation.
>
>>         if (IS_ERR(newxprt->sc_rq_cq)) {
>>                 dprintk("svcrdma: error creating RQ CQ for connect
>> request\n");
>>                 goto errout;
>

Nice catches, I'll fix that for the next version.

Thanks.

Matan

>
> Regards
>
> --
> Yann Droneaud
> OPTEYA
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
