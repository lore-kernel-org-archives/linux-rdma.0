From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: opensm: switch incorrectly reports IB_PORT_CAP_HAS_MCAST_FDB_TOP
 ?
Date: Fri, 22 Apr 2011 15:58:18 -0400
Message-ID: <4DB1DDDA.8050401@dev.mellanox.co.il>
References: <4DB1C6A0.9000001@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB1C6A0.9000001-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 4/22/2011 2:19 PM, Jim Schutt wrote:
> Hi,
> 
> I've been testing the current opensm development head
> (commit 83b67527d16 from git://git.openfabrics.org/~alexnetes/opensm),
> and I've been getting some messages that are new since version 3.3.7:
> 
> Apr 22 12:08:09 646534 [411CD940] 0x01 -> log_rcv_cb_error: ERR 3111:
> Received MAD with error status = 0x1C
>                         SubnGetResp(SwitchInfo), attr_mod 0x0, TID 0x4802
>                         Initial path: 0,1,1,4 Return path: 0,20,1,7
> 
> I get one of these messages for each switch in my fabric, on every
> heavy sweep.
> 
> It appears these are caused by my switches incorrectly reporting
> the capability IB_PORT_CAP_HAS_MCAST_FDB_TOP; i.e. this patch stops
> the messages:
> 
> diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
> index ea52bfe..63d2968 100644
> --- a/opensm/osm_mcast_mgr.c
> +++ b/opensm/osm_mcast_mgr.c
> @@ -1041,7 +1041,7 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm,
> IN osm_switch_t * p_sw)
>      p_path = osm_physp_get_dr_path_ptr(p_physp);
>      p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
> 
> -    if (p_physp->port_info.capability_mask &
> IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
> +    if (0 && p_physp->port_info.capability_mask &
> IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
>          /*
>             Set the top of the multicast forwarding table.
>           */
> 
> IB_PORT_CAP_HAS_MCAST_FDB_TOP is bit 30 of the port capability mask,
> which in at least IBA v1.2.1 was a reserved bit but apparently is
> not anymore.

Yes, this is in IBTA MgtWG public errata beyond IBA 1.2.1.

> Should I file a bug report with my switch vendor about setting
> a port capability bit for a capability they don't support, or
> is there something else going on that I haven't figured out yet?

I will have a patch shortly which can turn this off even if it is
advertised by the switch (not sure what default should be).

You might also want to contact your switch vendor about fixing this.

> FWIW I think my switches have a base SP0; maybe it's got something
> to do with that?

No; either base or enhanced SP0 can support this; it's orthogonal to that.

-- Hal

> Thanks -- Jim
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
