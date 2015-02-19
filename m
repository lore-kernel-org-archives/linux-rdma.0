From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 02/30] IB/core: Add kref to IB devices
Date: Thu, 19 Feb 2015 14:34:57 +0200
Message-ID: <CAAKD3BC75hott0T2BgeOLYjh+hGEry1+oGkhow9rFyUiUMDF4g@mail.gmail.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
	<1b381c86-9f29-49a6-b7c5-9571d4490f5c@CMEXHTCAS2.ad.emulex.com>
	<54E5C1AF.4010400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E5C1AF.4010400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 19, 2015 at 12:57 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 20/02/2015 00:02, Somnath Kotur wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Previously. we used device_mutex lock in order to protect
>> the device's list. That means that in order to guarantee a
>> device isn't freed while we use it, we had to lock all
>> devices.
>>
>> Adding a kref per IB device. Before an IB device
>> is unregistered, we wait before its not held anymore.
>
> Maybe I'm missing something, but IB device already has a struct device
> embedded in it, which has a kobject with a kref. Wouldn't it be better
> to simply move the operations that need to wait to the ib_device_release
> function?

You're correct, but in ib_unregister_device we delete all client's related data.
We would like to ensure that all references were released before this
data is being deleted and the device is still functioning rather than
when the IB device's
memory is freed.
ib_device_get and ib_device_hold are APIs for the clients, similar to
dev_hold and dev_put.

Regards,
Matan

>
> Regards,
> Haggai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
