From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Mon, 20 Oct 2014 19:14:19 +0300
Message-ID: <544534DB.4070908@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>	<543CD5D6.1020506@mellanox.com>	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>	<5443DBCA.4000002@dev.mellanox.co.il>	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com> <CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/20/2014 11:01 AM, Or Gerlitz wrote:
> On Mon, Oct 20, 2014 at 8:36 AM, Minh Duc Tran
> <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> > ---
> a/drivers/infiniband/ulp/iser/iser_verbs.c
>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>> @@ -114,6 +114,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
>>          if (IS_ERR(device->pd))
>>                  goto pd_err;
>>
>> +       max_cqe = (dev_attr->max_cqe < ISER_MAX_CQ_LEN) ?
>> +                  dev_attr->max_cqe : ISER_MAX_CQ_LEN;
>> +
>
> If I was the ocrdma maintainer I would say load and clear: NO, please.
>
> Your current offering supports 32 CQs per device, and this means that
> on 32 core node you will be able to run only iSER, no other ULP.

This is max CQ entries, are you referring to max_cq? or am I missing
something?

I tend to agree that if the device supports smaller CQs we should not
just fail everything, but adjust accordingly.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
