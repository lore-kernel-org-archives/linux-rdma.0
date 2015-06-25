From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Do not queue a work when the device is going to
 be removed
Date: Thu, 25 Jun 2015 08:51:43 -0700
Message-ID: <558C238F.1030702@sandisk.com>
References: <1435241602-12104-1-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435241602-12104-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/25/2015 07:13 AM, Erez Shitrit wrote:
> @@ -3864,14 +3904,23 @@ static void cm_remove_one(struct ib_device *ib_device)
>   	list_del(&cm_dev->list);
>   	write_unlock_irqrestore(&cm.device_lock, flags);
>
> +	spin_lock_irq(&cm.lock);
> +	cm_dev->going_down = 1;
> +	spin_unlock_irq(&cm.lock);
> +
>   	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
>   		if (!rdma_cap_ib_cm(ib_device, i))
>   			continue;
>
>   		port = cm_dev->port[i-1];
>   		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
> -		ib_unregister_mad_agent(port->mad_agent);
> +		/*
> +		 * We flush the queue here after the going_down set, this
> +		 * verify that no new works will be queued in the recv handler,
> +		 * after that we can call the unregister_mad_agent
> +		 */
>   		flush_workqueue(cm.wq);
> +		ib_unregister_mad_agent(port->mad_agent);
>   		cm_remove_port_fs(port);
>   	}
>   	device_unregister(cm_dev->device);

Hello Erez,

How about splitting unregister_mad_agent() into two functions, one that 
stops the invocation of the receive callbacks and another one that 
cancels all sends ? If the new function that stops the receive callbacks 
would be invoked before flush_workqueue(), would that be safe ? Would 
that allow to drop the new flag "going_down" since the workqueue 
implementation already sets __WQ_DRAINING ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
