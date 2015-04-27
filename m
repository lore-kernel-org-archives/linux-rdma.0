From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Mon, 27 Apr 2015 11:25:56 +0300
Message-ID: <553DF294.4070507@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
	<9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/26/2015 11:10 PM, Or Gerlitz wrote:
> On Thu, Mar 26, 2015 at 12:19 AM, Somnath Kotur
> <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Previously. we used device_mutex lock in order to protect
>> the device's list. That means that in order to guarantee a
>> device isn't freed while we use it, we had to lock all
>> devices.
>
> Matan, looking on the cover letter, it says: "[...] Patch 0002 adds a
> reference count mechanism to IB devices. This mechanism is similar to
> dev_hold and dev_put available for net devices. This is mandatory for
> later patches [...]"
>
> So in that respect, saying here "Previously. we used device_mutex
> lock" is a bit cryptic, @ least one typo must exist in this sentence,
> right? did you want to say "Currently we use device_mutex lock for XXX
> [...] and this should be replaced as of a YYY change which is to be
> introduced [...]" please clarify

Correct, I'll change that into:

Currently we use device_mutex lock for protecting the device's list. In 
the current approach, in order to guarantee a device isn't freed we have 
to lock all devices.

Adding a kref per IB device. Before an IB device is unregistered, we 
wait until it's not held anymore.

>
>> Adding a kref per IB device. Before an IB device
>> is unregistered, we wait before its not held anymore.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
