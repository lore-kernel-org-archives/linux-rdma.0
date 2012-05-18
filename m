From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: watchdog timer
Date: Fri, 18 May 2012 09:07:50 -0400
Message-ID: <4FB649A6.2060602@dev.mellanox.co.il>
References: <4FB5E69A.7010602@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB5E69A.7010602-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/18/2012 2:05 AM, Bob Ciotti wrote:
> 
> 
> I'm seeing lots of these messages in SM log:
> 
> May 17 22:36:04 947774 [DA234710] 0x01 -> log_trap_info: Received
> Generic Notice type:1 num:131 (Flow Control Update watchdog timer
> expired) Producer:2 (Switch) from LID:444 Port 5 TID:0x0000000000000025
> 
> the referenced port is a switch to HCA link.
> 
> I've seen this in cases where there was bad hardware. Spec says failure
> in flow control machine on other end. But lets assume hardware was good.
> When could this occur?

Do OperationalVLs match on both sides of the link ? Are you
using/configuring QoS ?

> Only in the case of FW bug?

I don't think flow control is performed by FW.

> Any tunable's that might impact this?

No IBA standard ones AFAIK. Who's the HCA vendor ?

-- Hal

> bob
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
