From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] opensm/osm_node_info_rcv.c: Fix multiple switch discovery
 during a sweep
Date: Wed, 05 Feb 2014 09:43:31 -0500
Message-ID: <52F24E13.7060903@dev.mellanox.co.il>
References: <1391594898-18129-1-git-send-email-alexne@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391594898-18129-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/5/2014 5:08 AM, Alex Netes wrote:
> Because of the race between Get(SwitchInfo) and Get(NodeInfo) to the
> same switch, SM will send additional Get(SwitchInfo) before it get a
> first reply. In a sequence SM will send many redundant MADs and slow
> down the discovery process significantly.
> With this fix, when a switch doesn't respond to Get(SwitchInfo) once
> during the sweep it will be dropped.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
