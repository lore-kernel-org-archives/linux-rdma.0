From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port,
 better last block handling
Date: Thu, 7 Apr 2011 19:46:42 +0300
Message-ID: <20110407164642.GD21920@calypso.voltaire.com>
References: <4D9B59D1.9010209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D9B59D1.9010209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:05 Tue 05 Apr     , Hal Rosenstock wrote:
> 
> PKey table capacities are not required to be multiples of the PKey table block
> size (32 entries of 16 pkeys).
> 
> Current code could enable partition enforcement on the peer switch port
> even if the last partition table block were truncated. In this case, it's
> better to disable partition enforcement on those ports.
> 

What is the motivation for this patch?
In case where there are more pkeys than sw->switch_info.enforce_cap I guess
enforcement won't be applied on pkeys > sw->switch_info.enforce_cap. This is a
user configuration issue. Why issue a warning message to a log isn't enough?

--Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
