From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] opensm: Fixed pointer validity check in
 report_torus_changes()
Date: Mon, 7 Mar 2011 08:46:58 -0700
Message-ID: <1299512818.4750.237.camel@sale659.sandia.gov>
References: <20110307095930.GH5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110307095930.GH5577-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi Alex,

On Mon, 2011-03-07 at 02:59 -0700, Alex Netes wrote:
> struct torus *nt should be checked for validity before getting assignments.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/osm_torus.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
> index add3cf9..7a2c252 100644
> --- a/opensm/osm_torus.c
> +++ b/opensm/osm_torus.c
> @@ -7423,13 +7423,17 @@ void report_torus_changes(struct torus *nt, struct torus *ot)
>  {
>  	unsigned cnt = 0;
>  	unsigned i, j, k;
> -	unsigned x_sz = nt->x_sz;
> -	unsigned y_sz = nt->y_sz;
> -	unsigned z_sz = nt->z_sz;
> +	unsigned x_sz;
> +	unsigned y_sz;
> +	unsigned z_sz;

Actually, nt is guaranteed to be non-NULL; check the
only caller (torus_build_lfts()).

>  
>  	if (!(nt && ot))
>  		return;

This check for nt is redundant, I think.  Only ot has 
any possibility of being NULL.

-- Jim

>  
> +	x_sz = nt->x_sz;
> +	y_sz = nt->y_sz;
> +	z_sz = nt->z_sz;
> +
>  	if (x_sz != ot->x_sz) {
>  		cnt++;
>  		OSM_LOG(&nt->osm->log, OSM_LOG_INFO,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
