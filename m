From: =?ISO-8859-2?Q?S=B3awomir_Skowron?= <szibis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix opensm handover/relinquish corner case
Date: Tue, 14 Feb 2012 18:00:25 +0100
Message-ID: <6985899376444923599@unknownmsgid>
References: <1329178427.4779.1088.camel@auk59.llnl.gov>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329178427.4779.1088.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pozdrawiam

iSS

On 14 lut 2012, at 01:23, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> When in master state and performing light sweeps, openSM ignores
> other subnet managers in master state and fails to perform
> handovers or relinquish control.  Handovers and relinquishing
> master is only performed after a heavy sweep.  This can result
> in two subnet managers being in master state, seeing each other
> SM in master state, but both choose to do nothing about it.
>
> This patch initiates a heavy sweep when another master subnet
> manager is found during a light sweep.  This is sufficient to
> start a handover or relinquish scenario.
>
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
> opensm/osm_sminfo_rcv.c |   18 ++++++++++++++++--
> 1 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
> index 66eb886..d4ae7c9 100644
> --- a/opensm/osm_sminfo_rcv.c
> +++ b/opensm/osm_sminfo_rcv.c
> @@ -385,8 +385,22 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
>                osm_sm_state_mgr_signal_master_is_alive(sm);
>            else {
>                /* This is a response we got while sweeping the subnet.
> -                   We will handle a case of handover needed later on, when the sweep
> -                   is done and all SMs are recongnized. */
> +                 *
> +                 * If this is during a heavy sweep, we will handle a case of
> +                 * handover needed later on, when the sweep is done and all
> +                 * SMs are recognized.
> +                 *
> +                 * If this is during a light sweep, initiate a heavy sweep
> +                 * to initiate handover scenarios.
> +                 *
> +                 * Note that it does not matter if the remote SM is lower
> +                 * or higher priority.  If it is lower priority, we must
> +                 * wait for it HANDOVER.  If it is higher priority, we need
> +                 * to HANDOVER to it.  Both cases are handled after doing
> +                 * a heavy sweep.
> +                 */
> +                if (light_sweep)
> +                    sm->p_subn->force_heavy_sweep = TRUE;
>            }
>            break;
>        case IB_SMINFO_STATE_STANDBY:
> --
> 1.7.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
