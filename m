From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-next v1 13/22] RDMA/hns: Remove empty functions
Date: Mon, 21 Aug 2017 10:09:10 +0530
Message-ID: <CA+sbYW3LHT3CHX-UmQ_up3VexxoHdaa_Gs3ukanDnApEwPk4Fg@mail.gmail.com>
References: <20170813101816.3120-1-leon@kernel.org> <20170813101816.3120-14-leon@kernel.org>
 <CA+sbYW2ZJj2SdchU8M4dZz-KOGSxw2EPX-9oGJhMf3LSzMtA2A@mail.gmail.com> <20170818154045.GL23648@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170818154045.GL23648-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 18, 2017 at 9:10 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

>>
>> The following patch helps. But it is like a workaround to solve the problem.
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index d5ca101..59911dd 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -4189,7 +4189,7 @@ static void cm_add_one(struct ib_device *ib_device)
>>                         goto error2;
>>
>>                 ret = ib_modify_port(ib_device, i, 0, &port_modify);
>> -               if (ret)
>> +               if (ret && ret != -ENOSYS)
>>                         goto error3;
>>
>>                 count++;
>>
>> Or should we have the modify_port hook with some basic checks?
>
> I think that your proposal is right thing to do. The driver should
> properly return the status of its callbacks (-ENOSYS) and it is
> responsibility of the caller to decide what to do in such case.
>

> The dummy function (return 0) hides the fact that modify_port do
> nothing and it can be wrong for some callers.
>
I am bit confused. You support the proposal to have a modify_port with
some basic check.. right?
> Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
