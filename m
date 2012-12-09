From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/3] Fix -Wtautological-compare warnings with clang
Date: Sun, 9 Dec 2012 17:09:02 +0000
Message-ID: <75EE638CB68A864F90627D3D06A189A8593506EE@MTRDAG01.mtl.com>
References: <alpine.BSF.2.00.1212090303280.64779@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.1212090303280.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Garrett,

> These branch conditions are always > 0 (or false) and hence not executed as
> designed.
> 
> Also, enum by definition is always > 0, so the error condition isn't triggered
> ever.
> 
> Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>   libvendor/osm_vendor_ibumad.c | 5 +----
>   opensm/osm_qos_parser_y.y     | 6 ++----
>   opensm/st.c                   | 2 --
>   3 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/libvendor/osm_vendor_ibumad.c
> b/libvendor/osm_vendor_ibumad.c index ca320a6..cdb18e9 100644
> --- a/libvendor/osm_vendor_ibumad.c
> +++ b/libvendor/osm_vendor_ibumad.c
> @@ -574,10 +574,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t *
> const p_log,
> 
>   	memset(p_vend, 0, sizeof(*p_vend));
> 
> -	if (osm_vendor_init(p_vend, p_log, timeout) < 0) {
> -		free(p_vend);
> -		p_vend = NULL;
> -	}
> +	osm_vendor_init(p_vend, p_log, timeout);

I guess it's better to write:

If (osm_vendor_init(p_vend, p_log, timeout) != IB_SUCCESS) { 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
