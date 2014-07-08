From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] opensm/osm_perfmgr.c: Fix perfmgr sweep_state race
Date: Tue, 08 Jul 2014 15:11:12 -0400
Message-ID: <53BC4250.3040601@dev.mellanox.co.il>
References: <1403891774.30332.421.camel@auk59.llnl.gov>  <53ADE3CE.3090606@dev.mellanox.co.il>  <1404147950.3976.13.camel@crazyclimber.llnl.gov> <1404240219.30332.436.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404240219.30332.436.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/1/2014 2:43 PM, Albert Chu wrote:
> Introduce new sweep state PERFMGR_SWEEP_POST_PROCESSING to fix
> race in perfmgr.
> 
> Race occurs as follows:
> 
> Under typical conditions, osm_perfmgr_process() is entered
> with sweep_state set to PERFMGR_SWEEP_SLEEP.  osm_perfmgr_process()
> sets sweep_state to PERFMGR_SWEEP_ACTIVE when it begins to sweep.
> 
> osm_perfmgr_process() will eventually call perfmgr_send_mad() by
> way of perfmgr_query_counters() and several other functions.
> 
> Responses to performance counter MADs may initiate the sending
> of more MADs via perfmgr_send_mad(), such as through redirection
> or the desire to clear counters.
> 
> If too many MADs have been put on the wire, perfmgr_send_mad()
> will throttle sending out MADS and temporarily change sweep_state
> between PERFMGR_SWEEP_SUSPENDED and PERFMGR_SWEEP_ACTIVE as it
> throttles.  The sweep_state is set to PERFMGR_SWEEP_ACTIVE
> when all performance counter MADs have been sent out by the sweeper.
> 
> osm_perfmgr_process() eventually completes its sweep and puts
> sweep_state back into PERFMGR_SWEEP_SLEEP.
> 
> At this point, some MADs may still be on the wire.  New MADs may be
> put back on the wire if responses necessitate it (redirection or
> clearing counters).  If enough MADs are put back onto the wire,
> perfmgr_send_mad() will throttle as normal, temporarily moving
> between PERFMGR_SWEEP_SUSPENDED and PERFMGR_SWEEP_ACTIVE.  After
> the throttling is complete, sweep_state is put into
> PERFMGR_SWEEP_ACTIVE state.
> 
> This is the key problem, the sweep_state is changed from
> PERFMGR_SWEEP_SLEEP to PERFMGR_SWEEP_ACTIVE outside of
> osm_perfmgr_process().
> 
> Now that the perfmgr is in ACTIVE state, any future sweep call to
> osm_perfmgr_process() will not sweep b/c the sweep_state is set
> to PERFMGR_SWEEP_ACTIVE.
> 
> The introduction of a new sweep_state PERFMGR_SWEEP_POST_PROCESSING
> fixes this problem.
> 
> If perfmgr_send_mad() throttles mads while in PERFMGR_SWEEP_SLEEP.
> sweep_state will be moved into the PERFMGR_SWEEP_POST_PROCESSING
> state instead of PERFMGR_SWEEP_SUSPENDED/PERFMGR_SWEEP_ACTIVE.
> 
> When all post-SLEEP state MAD processing is complete, the sweep_state
> will move from PERFMGR_SWEEP_POST_PROCESSING back to PERFMGR_SWEEP_SLEEP,
> so that future sweeps can operate as normal.
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks. Series applied (with minor cosmetic change).

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
