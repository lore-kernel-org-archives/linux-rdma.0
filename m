From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Tue, 14 Apr 2015 16:27:18 +0300
Message-ID: <552D15B6.10307@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <551348BD.9080200@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551348BD.9080200-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 3/26/2015 1:46 AM, Bart Van Assche wrote:
> On 03/25/2015 02:19 PM, Somnath Kotur wrote:
>> +static void ib_device_complete_cb(struct kref *kref)
>> +{
>> +    struct ib_device *device = container_of(kref, struct ib_device,
>> +                        refcount);
>> +
>> +    if (device->reg_state >= IB_DEV_UNREGISTERING)
>> +        complete(&device->free);
>> +}
>
>> @@ -355,6 +393,9 @@ void ib_unregister_device(struct ib_device *device)
>>
>>       ib_device_unregister_sysfs(device);
>>
>> +    ib_device_put(device);
>> +    wait_for_completion(&device->free);
>
> Why is it necessary here to wait until the last reference is gone ? Why
> doesn't ib_device_complete_cb() free any memory ?
>

IMHO, ib_unregister_device should be a blocking call. The caller would 
like to be certain that any usage of the IB device is completed before 
it frees other resources/memory it allocated.

> Bart.
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
