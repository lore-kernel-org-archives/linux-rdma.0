From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv4] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Fri, 16 Oct 2009 16:17:54 -0400
Message-ID: <f0e08f230910161317o2769393bu5d171e9572bb429d@mail.gmail.com>
References: <20091015223052.GA6843@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015223052.GA6843-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha,

On Thu, Oct 15, 2009 at 6:30 PM, Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org> wr=
ote:
>
> Heap memory consumption by the unicast and multicast routing tables c=
an be
> reduced.
>
> This patch is analagous to the previous patch doing this for the unic=
ast
> routing tables (LFTs).
>
> Using valgrind --tool=3Dmassif (for heap profiling), there are couple=
 of place
> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:9=
6)
>
> osm_mcast_tbl_init (osm_mcast_tbl.c:96):
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->p_mask_tbl =3D malloc(p_tbl->num_en=
tries *
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (IB_MCAST_POSITION_MA=
X +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01) * IB_MCAST_M=
ASK_SIZE / 8);
>
> num_entries above is set based on the switch's MulticastFDBCap
> (indicated in it's SM class SwitchInfo attribute).
>
> MFTs are only be increased in size and are never reduced in size. If =
a realloc
> for MFT fails, it is treated as a fatal error and OpenSM is exited.
>
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v3:
> Renamed mft_size to mft_depth and added description in osm_mcast_tbl.=
h
> Removed vestigial realloc mask tbl call in osm_dump.c
> Simplified max_mlid determination in alloc_mfts
> Added return value to osm_mcast_tbl_realloc_mask_tbl
> Added return value to alloc_mfts
> Handle alloc_mfts failure in osm_mcast_mgr_process/process_mgroups
> Renamed osm_mcast_tbl_realloc_mask_tbl to osm_mcast_tbl_realloc
> In osm_mcast_tbl_realloc, simplified mft_depth calculation
>
> Changes since v2:
> MFT allocation during routing preparation rather than on table access
>
> Changes since v1:
> MFT allocation based on actual MLID requests
>

Please ignore this. I'll resubmit once we get past the mcast tbl
change for max LID host order.

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
