From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Wed, 25 Mar 2015 16:46:05 -0700
Message-ID: <551348BD.9080200@sandisk.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/25/2015 02:19 PM, Somnath Kotur wrote:
> +static void ib_device_complete_cb(struct kref *kref)
> +{
> +	struct ib_device *device = container_of(kref, struct ib_device,
> +						refcount);
> +
> +	if (device->reg_state >= IB_DEV_UNREGISTERING)
> +		complete(&device->free);
> +}

> @@ -355,6 +393,9 @@ void ib_unregister_device(struct ib_device *device)
>
>   	ib_device_unregister_sysfs(device);
>
> +	ib_device_put(device);
> +	wait_for_completion(&device->free);

Why is it necessary here to wait until the last reference is gone ? Why 
doesn't ib_device_complete_cb() free any memory ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
