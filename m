From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_torus.c: Increase PORTGRP_MAX_PORTS define
Date: Wed, 17 Dec 2014 05:46:40 -0500
Message-ID: <54915F10.4000205@dev.mellanox.co.il>
References: <1418808490-27687-1-git-send-email-alexne@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418808490-27687-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/17/2014 4:28 AM, Alex Netes wrote:
> Torus-2QoS fails to configure fabric with more than 16 HCAs.
> This patch extends PORTGRP_MAX_PORTS to be 34. Maximal practical ports
> per switch - 2 reserved ports (minimal of needed ports for switch to
> switch connections in 2D Torus).
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/osm_torus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
> index 330f55d..b01f69f 100644
> --- a/opensm/osm_torus.c
> +++ b/opensm/osm_torus.c
> @@ -59,7 +59,7 @@
>  #include <opensm/osm_opensm.h>
>  
>  #define TORUS_MAX_DIM        3
> -#define PORTGRP_MAX_PORTS    16
> +#define PORTGRP_MAX_PORTS    34
>  #define SWITCH_MAX_PORTGRPS  (1 + 2 * TORUS_MAX_DIM)
>  #define DEFAULT_MAX_CHANGES  32
>  

There is portgroup_max_ports configuration parameter for torus to change this if needed.

man torus-2QoS.conf states:
       portgroup_max_ports max_ports
              This keyword specifies the maximum  number  of  parallel  inter-
              switch  links,  and  also  the  maximum number of host ports per
              switch, that torus-2QoS can accommodate.  The default  value  is
              16.   Torus-2QoS  will log an error message during topology dis-
              covery if this parameter needs to be increased.  If this keyword
              appears multiple times, the last instance prevails.

              Note  that  the  switch management port (switch port 0) gets put
              into the same port group with the host ports, so if you have  16
              host  ports  per switch, portgroup_max_ports would need to be at
              least 17.

Is there really a need to change the default for this ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
