From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Initiate heavy sweep in MFTSubnSet fails during idle
 time process
Date: Sat, 14 May 2011 10:43:24 -0400
Message-ID: <4DCE950C.60303@dev.mellanox.co.il>
References: <20110512161443.GC22389@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110512161443.GC22389-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 5/12/2011 12:14 PM, Alex Netes wrote:
> MFTSubnSet failed MADs may leave temporary MC loops in the fabric.
> In order to eliminate this faulty state as quick as possible it's a good
> thing to initiate a heavy sweep immediately and to wait for the next light
> sweep.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/osm_state_mgr.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
> index dd308f2..aa71b03 100644
> --- a/opensm/osm_state_mgr.c
> +++ b/opensm/osm_state_mgr.c
> @@ -1434,6 +1434,13 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
>  		osm_mcast_mgr_process(sm);
>  		wait_for_pending_transactions(&sm->p_subn->p_osm->stats);
>  	}
> +
> +	/* if one or more MFTSubnSet MADs fails
> +	 * during idle process time initiate heavy sweep */
> +	if (sm->p_subn->force_heavy_sweep
> +	    || sm->p_subn->subnet_initialization_error)
> +		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);

subnet_initialization_error is more than just set MFT failures. Should
it be narrowed down to just those failures ?

Also, while this looks like it would fix the scenario you mention,
couldn't this change cause a continual heavy sweep ?

-- Hal

> +
>  }
>  
>  void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
