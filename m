From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Tue, 21 Oct 2014 00:09:16 +0300
Message-ID: <CAJ3xEMi9uBB0fFqGj4nUOdYYezLzF135TLH-sswQ0G5hZQvAkA@mail.gmail.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
	<543CD5D6.1020506@mellanox.com>
	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
	<5443DBCA.4000002@dev.mellanox.co.il>
	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
	<CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>
	<eaf7c875-e7e1-43eb-b27a-fbd068aa32f1@CMEXHTCAS1.ad.emulex.com>
	<CAJ3xEMgnmZD8ONJcnor__eioMtfaO6MYMKfd6nbXncaWYXTG+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgnmZD8ONJcnor__eioMtfaO6MYMKfd6nbXncaWYXTG+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 21, 2014 at 12:06 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 20, 2014 at 9:11 PM, Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>>>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>>>> @@ -114,6 +114,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
>>>>         if (IS_ERR(device->pd))
>>>>                 goto pd_err;
>>>>
>>>> +       max_cqe = (dev_attr->max_cqe < ISER_MAX_CQ_LEN) ?
>>>> +                  dev_attr->max_cqe : ISER_MAX_CQ_LEN;
>>>> +
>>
>>>If I was the ocrdma maintainer I would say load and clear: NO, please.
>>>Your current offering supports 32 CQs per device, and this means that on 32 core node you will be able to run only iSER, no other ULP.
>>>Generally, this approach is wrong, causing bad user experience and we will not do that.
>>
>> Hi Or,
>>
>> All 32 CQs will never get used.  Here are the reasons:
>> 1) current #define ISER_MAX_CQ 4
>> 2)  Your proposed TODO "#1. change the number of CQs to be min(num_cpus, 1/2 of what the device can support)"
>>       This would limits the max CQs device supports to 1/2 anyway.
>>
>> If you don't agree, I like to get your suggestions of what I should do in this case for CQs that have 8k of entries each.


So I was wrong, sorry... you were talking on CQEs not CQs. I think
Sagi has some proposal on how to harden the code that deals with
setting the size of CQs, let me talk to him.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
