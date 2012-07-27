From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: include release in osm_version.h
Date: Thu, 26 Jul 2012 18:07:11 -0700
Message-ID: <20120726180711.6a560a19be9f17192b5c6591@llnl.gov>
References: <20120726174251.fe779972e664028e01b9fa8b@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120726174251.fe779972e664028e01b9fa8b-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Disregard this for now...  I see there is more crazyness with OpenSM's gen_ver.sh script...

:-(

Ira

On Thu, 26 Jul 2012 17:42:51 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> 
> This ensures plugin compatibility.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/opensm/osm_version.h.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/opensm/osm_version.h.in b/include/opensm/osm_version.h.in
> index d783245..7a29b77 100644
> --- a/include/opensm/osm_version.h.in
> +++ b/include/opensm/osm_version.h.in
> @@ -45,7 +45,7 @@
>  *
>  * SYNOPSIS
>  */
> -#define OSM_VERSION "OpenSM @VERSION@"
> +#define OSM_VERSION "OpenSM @VERSION@-@RELEASE@"
>  /********/
>  
>  #endif				/* _OSM_VERSION_H_ */
> -- 
> 1.7.1
> 


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
