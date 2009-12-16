From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] Set HopLimit based on off subnet Re: SRP issues with
	OpenSM 3.3.3
Date: Wed, 16 Dec 2009 08:29:43 -0500
Message-ID: <f0e08f230912160529h64424ba7id5c57dffb770380c@mail.gmail.com>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	 <20091215170317.GV5262@me>
	 <20091215171532.GA8288@obsidianresearch.com>
	 <20091215091819.c217cf36.weiny2@llnl.gov>
	 <f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
	 <20091215185511.3ae458cc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215185511.3ae458cc.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2009 at 9:55 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Tue, 15 Dec 2009 12:59:11 -0500
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Dec 15, 2009 at 12:18 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>
> [snip]
>
>>
>> > The follow on would be that if they specify a
>> > DGID in the PathRecord query and the result is subnet local they m=
ust still
>> > use a GRH even if the packet is going to stay local?
>>
>> No; with subnet local traffic, GRH is optional.
>>
>
> Ok, if the GRH is optional with local traffic then I think the approp=
riate fix
> is:
>
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_s=
a_path_record.c
> index be0cd71..1fa83a1 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -757,6 +757,14 @@ Exit:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return (status);
> =C2=A0}
>
> +static int gid_is_off_subnet(IN osm_sa_t * sa, IN const ib_gid_t * p=
_dgid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return (!ib_gid_is_link_local(p_dgid) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !ib_gid_is_multica=
st(p_dgid) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_gid_get_subnet_=
prefix(p_dgid) !=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa->p_subn->opt.su=
bnet_prefix);
> +}
> +
> =C2=A0/**************************************************************=
********
> =C2=A0***************************************************************=
*******/
> =C2=A0static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port=
_t * p_src_port,
> @@ -770,16 +778,12 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, I=
N const osm_port_t * p_src_port,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const osm_physp_t *p_src_physp;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const osm_physp_t *p_dest_physp;
> - =C2=A0 =C2=A0 =C2=A0 boolean_t is_nonzero_gid =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(sa->p_log);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_src_physp =3D p_src_port->p_physp;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p_dgid)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 is_nonzero_gid =3D=
 ib_gid_is_notzero(p_dgid);
> -
> - =C2=A0 =C2=A0 =C2=A0 if (is_nonzero_gid)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->dgid =3D=
 *p_dgid;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_dest_physp =3D=
 p_dest_port->p_physp;
> @@ -799,7 +803,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN =
const osm_port_t * p_src_port,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->hop_flow_raw &=3D cl_hton32(1 << 31)=
;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Only set HopLimit if going through a ro=
uter */
> - =C2=A0 =C2=A0 =C2=A0 if (is_nonzero_gid)
> + =C2=A0 =C2=A0 =C2=A0 if (gid_is_off_subnet(sa, &p_pr->dgid))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->hop_flow=
_raw |=3D cl_hton32(IB_HOPLIMIT_MAX);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->pkey =3D p_parms->pkey;
> @@ -1248,10 +1252,7 @@ static ib_net16_t pr_rcv_get_end_points(IN osm=
_sa_t * sa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(p_dgid,=
 0, sizeof(*p_dgid));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (comp_mask & IB_PR_COMPMASK_DGID) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ib_gid_is_lin=
k_local(&p_pr->dgid) &&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !ib_=
gid_is_multicast(&p_pr->dgid) &&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_g=
id_get_subnet_prefix(&p_pr->dgid) !=3D
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa->=
p_subn->opt.subnet_prefix) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (gid_is_off_sub=
net(sa, &p_pr->dgid)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0dest_guid =3D find_router(sa, p_pr->dgid.unicast.prefix);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (!dest_guid) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char gid_str[INET6_ADDRSTRLEN=
];
>
>
> This maintains the p_dgid found in pr_rcv_get_end_points but appropri=
ately
> set's the HopLimit when the DGID is off subnet.

Yes, this looks right to me. Would it be better to only determine
gid_is_off_subnet once by saving this in a variable and passing it as
a parameter where needed ?

-- Hal

>
> Ira
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
