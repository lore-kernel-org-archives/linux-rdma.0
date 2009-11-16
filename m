From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] complib/cl_fleximap: add cl_fmap_match() function
Date: Mon, 16 Nov 2009 10:30:57 -0500
Message-ID: <f0e08f230911160730r6863783fs1757ac7b4ff248a9@mail.gmail.com>
References: <20091113061948.GJ7192@me> <20091113062104.GK7192@me>
	 <20091113201144.GS7192@me> <20091113203856.GT7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091113203856.GT7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 13, 2009 at 3:38 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> Add cl_fmap_match() function - it is similar for cl_fmap_get() (getti=
ng
> fleximap item by key) with difference that instead of using the map's
> default comparison routine custom compare function can be passed ther=
e
> as a parameter.
>
> This can be useful for matching map item by a key pattern.
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>
> This function is used in IPv6 SNM MGID compression patch.
>
> =C2=A0opensm/complib/cl_map.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0| =C2=A0 14 ++++++++++--
> =C2=A0opensm/complib/libosmcomp.map =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0=
 =C2=A01 +
> =C2=A0opensm/include/complib/cl_fleximap.h | =C2=A0 36 ++++++++++++++=
++++++++++++++++++++
> =C2=A03 files changed, 48 insertions(+), 3 deletions(-)
>
> diff --git a/opensm/complib/cl_map.c b/opensm/complib/cl_map.c
> index d851bf8..f5fb1f3 100644
> --- a/opensm/complib/cl_map.c
> +++ b/opensm/complib/cl_map.c
> @@ -1144,8 +1144,9 @@ void cl_fmap_init(IN cl_fmap_t * const p_map, I=
N cl_pfn_fmap_cmp_t pfn_compare)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_remove_all(p_map);
> =C2=A0}
>
> -cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 IN const void *const p_key)
> +cl_fmap_item_t *cl_fmap_match(IN const cl_fmap_t * const p_map,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const void *const p_key,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN cl_pfn_fmap_cmp_t pfn_compare)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_item_t *p_item;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int cmp;
> @@ -1156,7 +1157,8 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t =
* const p_map,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_item =3D __cl_fmap_root(p_map);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (p_item !=3D &p_map->nil) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cmp =3D p_map->pfn=
_compare(p_key, p_item->p_key);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cmp =3D pfn_compar=
e ? pfn_compare(p_key, p_item->p_key) :
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_map->pfn_compare(p_key, p_item->p_key);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cmp)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break; =C2=A0/* just right */
> @@ -1170,6 +1172,12 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t=
 * const p_map,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return (p_item);
> =C2=A0}
>
> +cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 IN const void *const p_key)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return cl_fmap_match(p_map, p_key, p_map->pfn_=
compare);
> +}
> +
> =C2=A0cl_fmap_item_t *cl_fmap_get_next(IN const cl_fmap_t * const p_m=
ap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const void *const p_key)
> =C2=A0{
> diff --git a/opensm/complib/libosmcomp.map b/opensm/complib/libosmcom=
p.map
> index 788eb2a..52410cc 100644
> --- a/opensm/complib/libosmcomp.map
> +++ b/opensm/complib/libosmcomp.map
> @@ -66,6 +66,7 @@ OSMCOMP_2.3 {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_map_merge;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_map_delta;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_init;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_fmap_match;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_get;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_get_ne=
xt;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_fmap_apply_=
func;
> diff --git a/opensm/include/complib/cl_fleximap.h b/opensm/include/co=
mplib/cl_fleximap.h
> index ec008cf..b74040f 100644
> --- a/opensm/include/complib/cl_fleximap.h
> +++ b/opensm/include/complib/cl_fleximap.h
> @@ -619,6 +619,42 @@ cl_fmap_item_t *cl_fmap_insert(IN cl_fmap_t * co=
nst p_map,
> =C2=A0* =C2=A0 =C2=A0 =C2=A0Flexi Map, cl_fmap_remove, cl_fmap_item_t
> =C2=A0*********/
>
> +/****f* Component Library: Flexi Map/cl_fmap_match
> +* NAME
> +* =C2=A0 =C2=A0 =C2=A0cl_fmap_get

typo: cl_fmap_match

> +*
> +* DESCRIPTION
> +* =C2=A0 =C2=A0 =C2=A0The cl_fmap_match function returns the map ite=
m matching a key.
> +*
> +* SYNOPSIS
> +*/
> +cl_fmap_item_t *cl_fmap_match(IN const cl_fmap_t * const p_map,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const void *const p_key,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN cl_pfn_fmap_cmp_t pfn_compare);
> +/*
> +* PARAMETERS
> +* =C2=A0 =C2=A0 =C2=A0p_map
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to a =
cl_fmap_t structure from which to retrieve the
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0item with the spec=
ified key.
> +*
> +* =C2=A0 =C2=A0 =C2=A0p_key
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to a =
key value used to search for the desired map item.
> +*
> +* =C2=A0 =C2=A0 =C2=A0pfn_compare
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to a =
compare function to invoke to compare the
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0keys of items in t=
he map. Passing NULL here makes such call
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to be equivalent t=
o using cl_fmap_get().
> +*
> +* RETURN VALUES
> +* =C2=A0 =C2=A0 =C2=A0Pointer to the map item matching the desired k=
ey value.
> +*
> +* =C2=A0 =C2=A0 =C2=A0Pointer to the map end if there was no item ma=
tching the desired key
> +* =C2=A0 =C2=A0 =C2=A0value stored in the flexi map.
> +*
> +* SEE ALSO
> +* =C2=A0 =C2=A0 =C2=A0Flexi Map, cl_fmap_remove, cl_fmap_get
> +*********/
> +
> =C2=A0/****f* Component Library: Flexi Map/cl_fmap_get
> =C2=A0* NAME
> =C2=A0* =C2=A0 =C2=A0 =C2=A0cl_fmap_get
> --
> 1.6.5.2
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
