From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/5] OpenSM: dfsssp - send multicast forwarding tables
 to switches
Date: Mon, 07 Oct 2013 08:42:35 -0400
Message-ID: <5252AC3B.5050805@dev.mellanox.co.il>
References: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/3/2013 11:03 AM, Jens Domke wrote:
> Issue: dfsssp calculates mcast forwarding tables but doesn't
> distribute them to the switches, because is_mc_member/num_of_mcm
> for each switch was reset to 0 in osm_mcast_mgr.c.
> dfsssp relies on this data to figure out with switch is involved
> in the mcast group.
> 
> Fix: recalculate is_mc_member/num_of_mcm similar to the code
> of create_mgrp_switch_map(...) in osm_mcast_mgr.c right before
> the update_mcft function and reset to 0 afterwards.
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
