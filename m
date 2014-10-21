From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] send client reregistration in case of SM LID change
Date: Tue, 21 Oct 2014 08:07:26 -0400
Message-ID: <54464C7E.6000702@dev.mellanox.co.il>
References: <1413879962-15383-1-git-send-email-vladimirk@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413879962-15383-1-git-send-email-vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/21/2014 4:26 AM, Vladimir Koushnir wrote:
> if for some reason SM LID recorded in PortInfo of the node is different
> from our SM LID, it is safer to send client reregister notification to this node
> to trigger reregistration of the node in Master SM.
> 
> This scenario may occur when Standby SM loses connectivity to the Master SM and becomes
> Master SM for some time period. If the connectivity is re-established but Handover sent by
> Standby SM is lost. the only indication about SM handovers in the fabric is SM LID mis-configuration
> in some nodes.
> 
> It is important to note that this is a workaround.
> Some applications/ULPs only look at client reregistration and not at SM LID change.
> Most IB device drivers are not currently issuing SM LID change local event.
> 
> The fix forces opensm to set client reregister bit in PortInfo(Set) in the scenario above.
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
