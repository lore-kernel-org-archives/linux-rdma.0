From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/5] opensm: Better handle topology changes in the fabric
Date: Mon, 03 Feb 2014 14:42:45 -0500
Message-ID: <52EFF135.7030603@dev.mellanox.co.il>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com> <1391425516-14462-3-git-send-email-alexne@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-3-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/3/2014 6:05 AM, Alex Netes wrote:
> The patch tries to solve the following problem:
> When newly discovered switch is rebooted during the configuration cycle,
> SM end-up setting all Initialized ports to Active, but the configuration
> on the switch such as Pkey tables, QoS, etc' might be incorrect.
> 
> The fix is solves this in two steps. First, turn need_update flag when
> switch's StateChange bit is detected ON or CA's neighbor switch has
> StateChange bit ON. Second, clear StateChange bit on the switches, before
> any configuration is done. This assures that we don't miss changes in
> the fabric. If a switch was rebooted during a sweep, we will detect it
> in a sequential sweep and configure all its' neighbors from scratch.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
