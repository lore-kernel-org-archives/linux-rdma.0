From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 18 Nov 2014 18:24:01 +0200
Message-ID: <546B72A1.2080403@dev.mellanox.co.il>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com> <1416312682-7899-2-git-send-email-yishaih@mellanox.com> <546B59E2.2050707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546B59E2.2050707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 4:38 PM, Or Gerlitz wrote:
> On 11/18/2014 2:11 PM, Yishai Hadas wrote:
>> @@ -923,6 +1062,7 @@ static void ib_uverbs_add_one(struct ib_device
>> *device)
>>       if (device_create_file(uverbs_dev->dev, &dev_attr_abi_version))
>>           goto err_class;
>> +    uverbs_dev->disassociated_supported =
>> device->disassociate_ucontext ? 1 : 0;
>>       ib_set_client_data(device, &uverbs_client, uverbs_dev);
>>       return;
>
> please no, for object->yyy_supported flags (here and elsewhere too).
>
> You can add IB device capability (say, named IB_DEVICE_DISASSOCIATE) and
> just look it up directly from uverbs throug the IB device pointer
> existing in the uverbs device object in the spots you need this (remove
> uverbs_dev->disassociated_supported field).
>

The IB device pointer is not valid at all spots, for example after the 
HW Device was removed, that's why we set this information on the uverbs 
device.

> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
