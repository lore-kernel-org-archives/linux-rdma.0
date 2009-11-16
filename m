From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single MLID
Date: Mon, 16 Nov 2009 10:35:54 -0500
Message-ID: <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
References: <20091113061948.GJ7192@me> <20091113062104.GK7192@me>
	 <20091113201144.GS7192@me> <20091113203856.GT7192@me>
	 <20091113204041.GU7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091113204041.GU7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 13, 2009 at 3:40 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> This is rework of previously used IPv6 SNM groups compression workaro=
und
> using newly proposed "many MGID to single MLID" mapping infrastructur=
e.
>
> Unlike previous solution where all IPv6 Solicited node multicast (SNM=
)
> requests were collapsed into a single multicast group in OpenSM, now
> each IPv6 SNM group is represented as a separate multicast group and
> all groups sharing same P_Key and scope values use a same MLID value.

Shouldn't this also ensure groups sharing MLIDs have the same MTU,
rate, and packet lifetime ?

> The compression method itself should be faster now because MLID shari=
ng
> criteria (matching IPv6 SNM MGID signature) is performed only once wh=
en
> multicast group is created (and not each time when get MC group by MG=
ID
> lookup was performed).
>
> This solution should be fully IBA complaint.

Why the should qualification ?

Shouldn't the IBA compliant issues fixed be documented here ?

-- Hal

> As before this feature is switched on by using 'consolidate_ipv6_snm_=
req'
> command line or/and configuration option.
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_sa_mcmember_record.c | =C2=A0 68 ++++++++++++=
++++++-------------
> =C2=A01 files changed, 39 insertions(+), 29 deletions(-)
>
> diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/o=
sm_sa_mcmember_record.c
> index 27675b6..58c5736 100644
> --- a/opensm/opensm/osm_sa_mcmember_record.c
> +++ b/opensm/opensm/osm_sa_mcmember_record.c
> @@ -114,6 +114,35 @@ static void free_mlid(IN osm_sa_t * sa, IN uint1=
6_t mlid)
> =C2=A0/**************************************************************=
*******
> =C2=A0Get a new unused mlid by scanning all the used ones in the subn=
et.
> =C2=A0***************************************************************=
*******/
> +/* Special Case IPv6 Solicited Node Multicast (SNM) addresses */
> +/* 0xff1Z601bXXXX0000 : 0x00000001ffYYYYYY */
> +/* Where Z is the scope, XXXX is the P_Key, and
> + * YYYYYY is the last 24 bits of the port guid */
> +#define PREFIX_MASK CL_HTON64(0xff10ffff0000ffffULL)
> +#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
> +#define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
> +#define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
> +
> +static int compare_ipv6_snm_mgids(const void *m1, const void *m2)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return memcmp(m1, m2, sizeof(ib_gid_t) - 6);
> +}
> +
> +static ib_net16_t find_ipv6_snm_mlid(osm_subn_t *subn, ib_gid_t *mgi=
d)
> +{
> + =C2=A0 =C2=A0 =C2=A0 osm_mgrp_t *m =3D (osm_mgrp_t *)cl_fmap_match(=
&subn->mgrp_mgid_tbl, mgid,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 compare_ipv6_snm_mgids);
> + =C2=A0 =C2=A0 =C2=A0 if (m !=3D (osm_mgrp_t *)cl_fmap_end(&subn->mg=
rp_mgid_tbl))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return m->mlid;
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static unsigned match_ipv6_snm_mgid(ib_gid_t * mgid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ((mgid->unicast.prefix & PREFIX_MASK) =3D=
=3D PREFIX_SIGNATURE &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mgid->unicast.int=
erface_id & INT_ID_MASK) =3D=3D INT_ID_SIGNATURE);
> +}
> +
> =C2=A0static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_member_rec_t *=
 mcmr)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_subn_t *p_subn =3D sa->p_subn;
> @@ -125,6 +154,16 @@ static ib_net16_t get_new_mlid(osm_sa_t * sa, ib=
_member_rec_t * mcmr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& !osm_get_mbox_by_mlid(p_s=
ubn, requested_mlid))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return request=
ed_mlid;
>
> + =C2=A0 =C2=A0 =C2=A0 if (sa->p_subn->opt.consolidate_ipv6_snm_req
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && match_ipv6_snm_mgid(&mcmr->mg=
id)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && (requested_mlid =3D find_ipv6=
_snm_mlid(sa->p_subn, &mcmr->mgid))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char str[INET6_ADD=
RSTRLEN];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sa->p_log,=
 OSM_LOG_DEBUG,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Special Case Solicited Node Mcast Join for MGID %s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 inet_ntop(AF_INET6, mcmr->mgid.raw, str, sizeof(str)));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return requested_m=
lid;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0max =3D p_subn->max_mcast_lid_ho - IB_LID_=
MCAST_START_HO + 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < max; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!sa->p_sub=
n->mboxes[i])
> @@ -829,39 +868,10 @@ Exit:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return status;
> =C2=A0}
>
> -#define PREFIX_MASK CL_HTON64(0xff10ffff0000ffffULL)
> -#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
> -#define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
> -#define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
> -
> -/* Special Case IPv6 Solicited Node Multicast (SNM) addresses */
> -/* 0xff1Z601bXXXX0000 : 0x00000001ffYYYYYY */
> -/* Where Z is the scope, XXXX is the P_Key, and
> - * YYYYYY is the last 24 bits of the port guid */
> -static unsigned match_and_update_ipv6_snm_mgid(ib_gid_t * mgid)
> -{
> - =C2=A0 =C2=A0 =C2=A0 if ((mgid->unicast.prefix & PREFIX_MASK) =3D=3D=
 PREFIX_SIGNATURE &&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mgid->unicast.interface_id & IN=
T_ID_MASK) =3D=3D INT_ID_SIGNATURE) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mgid->unicast.pref=
ix &=3D PREFIX_MASK;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mgid->unicast.inte=
rface_id &=3D INT_ID_MASK;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> - =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> -}
> -
> =C2=A0osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_sa_t * sa, IN ib_gid_t =
* p_mgid)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_mgrp_t *mg;
>
> - =C2=A0 =C2=A0 =C2=A0 if (sa->p_subn->opt.consolidate_ipv6_snm_req &=
&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 match_and_update_ipv6_snm_mgid(p=
_mgid)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char gid_str[INET6=
_ADDRSTRLEN];
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sa->p_log,=
 OSM_LOG_DEBUG,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Special Case Solicited Node Mcast Join for MGID %s\n",
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 inet_ntop(AF_INET6, p_mgid->raw, gid_str,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof gid_str));
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mg =3D (osm_mgrp_t *)cl_fmap_get(&sa->p_su=
bn->mgrp_mgid_tbl, p_mgid);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mg !=3D (osm_mgrp_t *)cl_fmap_end(&sa-=
>p_subn->mgrp_mgid_tbl))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return mg;
> --
> 1.6.5.2
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
