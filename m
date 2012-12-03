From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_torus.c: Fix crash in
 torus_update_osm_vlarb
Date: Mon, 3 Dec 2012 14:09:50 -0700
Message-ID: <50BD151E.40205@sandia.gov>
References: <50BCC497.2030207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BCC497.2030207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/03/2012 08:26 AM, Hal Rosenstock wrote:
>
> Signed-off-by: Alex Netes<alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock<hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   opensm/osm_torus.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
> index c06f8d4..075f84a 100644
> --- a/opensm/osm_torus.c
> +++ b/opensm/osm_torus.c
> @@ -8089,7 +8089,7 @@ void torus_update_osm_vlarb(void *context, osm_physp_t *osm_phys_port,
>   	 * So, leave VL 0 alone, remap VL 4 to VL 1, zero out the rest,
>   	 * and compress out the zero entries to the end.
>   	 */
> -	if (!sw || !port_num ||
> +	if (!sw || !port_num || sw->port[port_num] ||
>   	    sw->port[port_num]->pgrp->port_grp != 2 * TORUS_MAX_DIM)
>   		return;
>

With the patch as-is, if torus_update_osm_vlarb() returns early
for any non-NULL switch port, it will never do any updates.

If the crash was that sw->port[port_num] was NULL,
shouldn't the check be !sw->port[port_num] ?

Can you tell me more about the test case that leads to the crash?

Is it that there's a switch with a port that's not connected
to anything, and torus_update_osm_vlarb() was called for it?

Testing for a non-NULL sw->port[port_num] is definitely the right
thing to do to handle that case, and I'm sorry I missed it earlier.

If not, then something else is likely broken, and we need to find
and fix that.

-- Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
