From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_helper.c: fix compiler warning
Date: Thu, 1 Oct 2009 10:37:23 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E873B@orsmsx501.amr.corp.intel.com>
References: <D8E83C9B6A164D48B1F37DFB606CB25A@amr.corp.intel.com>
 <20091001171700.GU17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001171700.GU17846@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Eliminate compiler warning:
>
> osm_helper.c:551: warning: missing braces around initializer
> osm_helper.c:551: warning: (near initialization for 'ib_zero_gid.raw')
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/opensm/osm_helper.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
> index 35da131..ea9e21f 100644
> --- a/opensm/opensm/osm_helper.c
> +++ b/opensm/opensm/osm_helper.c
> @@ -548,7 +548,7 @@ const char *ib_get_trap_str(ib_net16_t trap_num)
>       return "Unknown";
>  }
>
> -const ib_gid_t ib_zero_gid = { 0 };
> +const ib_gid_t ib_zero_gid = { { 0 } };
>
>  /**********************************************************************
>
> **********************************************************************/

OK.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
