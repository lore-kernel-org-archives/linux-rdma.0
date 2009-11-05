From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] contain pthreads defs with ifdef  HAVE_LIBPTHREAD
Date: Thu, 5 Nov 2009 09:07:45 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C8E0D221@orsmsx501.amr.corp.intel.com>
References: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Stan C. Smith wrote:
> Contain pthread definitions with ifdef HAVE_LIBPTHREAD
>
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> diff --git a/opensm/include/vendor/osm_vendor_ibumad.h
> b/opensm/include/vendor/osm_vendor_ibumad.h index 0a4692d..d523412
> 100644 --- a/opensm/include/vendor/osm_vendor_ibumad.h
> +++ b/opensm/include/vendor/osm_vendor_ibumad.h
> @@ -160,8 +160,13 @@ typedef struct _osm_vendor {
>       char ca_names[OSM_UMAD_MAX_CAS][UMAD_CA_NAME_LEN];
>       vendor_match_tbl_t mtbl;
>       umad_port_t umad_port;
> +#ifdef HAVE_LIBPTHREAD
>       pthread_mutex_t cb_mutex;
>       pthread_mutex_t match_tbl_mutex;
> +#else
> +     cl_mutex_t cb_mutex;
> +     cl_mutex_t match_tbl_mutex;
> +#endif
>       int umad_port_id;
>       void *receiver;
>       int issmfd;

The use of ifdef HAVE_LIBPTHREAD was based on existing HAVE_LIBPTHREAD usage in opensm/include/opensm/osm_stats.h @ line 97.
If the community prefers the use of macros then these two patches can be skipped.
Please advise on path to travel.

Stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
