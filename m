From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 19 Nov 2014 16:49:19 +0200
Message-ID: <546CADEF.6070905@mellanox.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com> <1416312682-7899-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416312682-7899-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 2:11 PM, Yishai Hadas wrote:
> @@ -533,6 +552,12 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
>   	struct ib_uverbs_file *file =
>   		container_of(handler, struct ib_uverbs_file, event_handler);
>   
> +	if (event->event == IB_EVENT_DEVICE_FATAL) {
> +		if (file->fatal_event_raised)
> +			return;
> +		file->fatal_event_raised = 1;
> +	}
> +

can we avoid the fatal_event_raised flag?

In a similar manner to what defined for rdma-cm consumers, let's add 
IB_EVENT_DEVICE_REMOVAL event and generate both events from  here 
towards the uberbs consumer (the fatal for legacy apps and the device 
removal for newer apps that maybe want to distinguish between the
two)

>   	ib_uverbs_async_handler(file, event->element.port_num, event->event,
>   				NULL, NULL);
>   }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
