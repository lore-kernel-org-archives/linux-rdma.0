From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 10:01:49 -0500
Message-ID: <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
 <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2a2aa84-71ce-36f0-91af-0854b24d4a6a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2017 7:49 AM, Hal Rosenstock wrote:
> On 10/31/2017 12:24 AM, Jason Gunthorpe wrote:
>> On Tue, Oct 31, 2017 at 03:16:42AM +0000, Parav Pandit wrote:
>>
>>> I am yet to review my below patch with Dan as he did most security
>>> dev, but I suspect this might be the cause where rmpp list is not
>>> initialized and mad processing is continued when security check
>>> fails.
>> This patch sure looks needed to me, ib_free_recv_mad touches
>> rmpp_list, so if it needs initializion then it certainly has to be
>> done earlier..
> Agreed.
>
>> Adding the new return sure makes alot of sense as well..
>>
>> Hal, Ira, would you check this routine too? kernel oops's are bad..
> Patch looks needed for just the point that Parav made above (that if
> security check fails, then ib_free_recv_mad will cause the
> mad_recv_wc->rmpp_list to be accessed so it needs to be initialized
> before security is enforced).

Agree the patch is needed regardless.

>
> I don't have mthca to try this. Maybe Chris can try this patch (with
> CONFIG_SECURITY_INFINIBAND=y).

Chris, are you running with SELinux enabled? If this addresses your issue it means permission is denied, so once the crash is resolved additional policy will be required in order for it to work as expected.

> -- Hal
>
>>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
>>> index f8f53bb..cb91245 100644
>>> +++ b/drivers/infiniband/core/mad.c
>>> @@ -1974,14 +1974,15 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>>>         unsigned long flags;
>>>         int ret;
>>>
>>> +       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
>>>         ret = ib_mad_enforce_security(mad_agent_priv,
>>>                                       mad_recv_wc->wc->pkey_index);
>>>         if (ret) {
>>>                 ib_free_recv_mad(mad_recv_wc);
>>>                 deref_mad_agent(mad_agent_priv);
>>> +               return;
>>>         }
>>>
>>> -       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
>>>         list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  https://emea01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.kernel.org%2Fmajordomo-info.html&data=02%7C01%7Cdanielj%40mellanox.com%7C0c1d5cc98d224d5f21ca08d5205dceb0%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636450509634819485&sdata=RANgNBE48saDXft%2BfCIIS3qWZT8PK5imlXnoCKnWdkU%3D&reserved=0
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
