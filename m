From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] use macro for tmp file path
Date: Tue, 25 May 2010 14:02:06 +0300
Message-ID: <20100525110206.GO28549@me>
References: <3F6F638B8D880340AB536D29CD4C1E192562EBBB00@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E192562EBBB00-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:51 Fri 21 May     , Smith, Stan wrote:
> 
> Use defined macro for tmp file path
> 
> signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 

The patch is whitespece-mangled.

> diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
> index ea76038..2d39117 100644
> --- a/opensm/opensm/st.c
> +++ b/opensm/opensm/st.c
> @@ -174,7 +174,7 @@ static int init_st = 0;
> 
>  static void stat_col()
>  {
> -       FILE *f = fopen("/var/log/osm_st_col", "w");
> +       FILE *f = fopen( OSM_DEFAULT_TMP_DIR "osm_st_col", "w");

I think it was discussed somehow in the past.

Shouldn't this be:

	OSM_DEFAULT_TMP_DIR "/osm_st_col"

, so that trailing '/' will not be mandatory in directory define?

Sasha

>         fprintf(f, "collision: %d\n", collision);
>         fclose(f);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
