From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: fix some obvious -Wsign-compare warnings
Date: Fri, 2 Oct 2009 13:41:14 -0400
Message-ID: <f0e08f230910021041p28307726j6bb280220abd1eae@mail.gmail.com>
References: <20091001192536.GY17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001192536.GY17846@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

On Thu, Oct 1, 2009 at 3:25 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
>
> Fix some obvious (not all) compile warnings generated when
> -Wsign-compare flag is used.
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---

<snip...>

> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_=
mgr.c
> index 6f51404..aaab91a 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -1004,7 +1004,7 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm=
)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_switch_t *p_sw;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_mcast_tbl_t *p_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int block_notdone, ret =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 int16_t block_num, max_block =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t block_num, max_block =3D -1;

Doesn't this change break the loop which uses block_num/max_block like:

for (block_num =3D 0; block_num <=3D max_block; block_num++) {
=2E..

so should a max_block check be inserted before that loop ?

-- Hal

> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_sw =3D (osm_switch_t *) cl_qmap_head(p_s=
w_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (p_sw !=3D (osm_switch_t *) cl_qmap_=
end(p_sw_tbl)) {

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
