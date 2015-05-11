From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 1/2] IB/core, cma: Nice log-friendly string helpers
Date: Mon, 11 May 2015 13:24:38 +0200
Message-ID: <55509176.70100@sandisk.com>
References: <1431338443-13216-1-git-send-email-sagig@mellanox.com>
 <1431338443-13216-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431338443-13216-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/15 12:00, Sagi Grimberg wrote:
> +__attribute_const__ const char *cma_event_msg(enum rdma_cm_event_type event)
> +{
> +	return event < ARRAY_SIZE(cma_events) ?
> +			cma_events[event] : "UNRECOGNIZED_EVENT";
> +}

Please cast "event" to an unsigned type before comparing it with the 
array size such that passing a negative value to this function or any 
similar function doesn't cause havoc.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
