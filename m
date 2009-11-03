From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/: Removed empty comments
Date: Tue, 3 Nov 2009 04:11:30 +0200
Message-ID: <20091103021130.GC17404@me>
References: <829ded920910282352u5105f2an4835d3685bf64a93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <829ded920910282352u5105f2an4835d3685bf64a93-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:22 Thu 29 Oct     , Keshetti Mahesh wrote:
> Signed-off-by: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The patch was broken (whitespaces were fine, but long line were
wrapped).

Applied after hand-fixing. Thanks.

Sasha

> ---
>  opensm/complib/cl_dispatcher.c              |   14 ---
>  opensm/libvendor/osm_pkt_randomizer.c       |    6 -
>  opensm/libvendor/osm_vendor_al.c            |   50 ----------
>  opensm/libvendor/osm_vendor_ibumad.c        |   28 ------
>  opensm/libvendor/osm_vendor_ibumad_sa.c     |   17 ----
>  opensm/libvendor/osm_vendor_mlx.c           |    2 -
>  opensm/libvendor/osm_vendor_mlx_anafa.c     |    2 -
>  opensm/libvendor/osm_vendor_mlx_hca.c       |    2 -
>  opensm/libvendor/osm_vendor_mlx_hca_anafa.c |    2 -
>  opensm/libvendor/osm_vendor_mlx_hca_pfs.c   |    2 -
>  opensm/libvendor/osm_vendor_mlx_hca_sim.c   |    2 -
>  opensm/libvendor/osm_vendor_mlx_sa.c        |   20 ----
>  opensm/libvendor/osm_vendor_mtl.c           |    6 -
>  opensm/libvendor/osm_vendor_mtl_hca_guid.c  |    4 -
>  opensm/libvendor/osm_vendor_test.c          |   24 -----
>  opensm/libvendor/osm_vendor_ts.c            |    6 -
>  opensm/libvendor/osm_vendor_umadt.c         |   10 --
>  opensm/opensm/main.c                        |   12 ---
>  opensm/opensm/osm_db_files.c                |   24 -----
>  opensm/opensm/osm_drop_mgr.c                |   14 ---
>  opensm/opensm/osm_dump.c                    |    4 -
>  opensm/opensm/osm_helper.c                  |   84 -----------------
>  opensm/opensm/osm_inform.c                  |   12 ---
>  opensm/opensm/osm_lid_mgr.c                 |   12 ---
>  opensm/opensm/osm_lin_fwd_rcv.c             |    2 -
>  opensm/opensm/osm_link_mgr.c                |    8 --
>  opensm/opensm/osm_mad_pool.c                |   14 ---
>  opensm/opensm/osm_mcast_fwd_rcv.c           |    2 -
>  opensm/opensm/osm_mcast_mgr.c               |   24 -----
>  opensm/opensm/osm_mcast_tbl.c               |   16 ---
>  opensm/opensm/osm_mcm_port.c                |    4 -
>  opensm/opensm/osm_mtree.c                   |    2 -
>  opensm/opensm/osm_multicast.c               |   10 --
>  opensm/opensm/osm_node.c                    |   20 ----
>  opensm/opensm/osm_node_desc_rcv.c           |    4 -
>  opensm/opensm/osm_node_info_rcv.c           |    6 -
>  opensm/opensm/osm_opensm.c                  |   18 ----
>  opensm/opensm/osm_perfmgr.c                 |    4 -
>  opensm/opensm/osm_perfmgr_db.c              |    4 -
>  opensm/opensm/osm_pkey.c                    |   30 ------
>  opensm/opensm/osm_pkey_mgr.c                |   16 ---
>  opensm/opensm/osm_pkey_rcv.c                |    2 -
>  opensm/opensm/osm_port.c                    |   24 -----
>  opensm/opensm/osm_port_info_rcv.c           |   14 ---
>  opensm/opensm/osm_remote_sm.c               |    6 -
>  opensm/opensm/osm_resp.c                    |    4 -
>  opensm/opensm/osm_router.c                  |    4 -
>  opensm/opensm/osm_sa.c                      |   12 ---
>  opensm/opensm/osm_sa_class_port_info.c      |    2 -
>  opensm/opensm/osm_sa_guidinfo_record.c      |    8 --
>  opensm/opensm/osm_sa_informinfo.c           |   10 --
>  opensm/opensm/osm_sa_lft_record.c           |    6 -
>  opensm/opensm/osm_sa_link_record.c          |   10 --
>  opensm/opensm/osm_sa_mad_ctrl.c             |   10 --
>  opensm/opensm/osm_sa_mcmember_record.c      |   12 ---
>  opensm/opensm/osm_sa_mft_record.c           |    6 -
>  opensm/opensm/osm_sa_multipath_record.c     |   24 -----
>  opensm/opensm/osm_sa_node_record.c          |    8 --
>  opensm/opensm/osm_sa_path_record.c          |   28 ------
>  opensm/opensm/osm_sa_pkey_record.c          |   10 --
>  opensm/opensm/osm_sa_portinfo_record.c      |   12 ---
>  opensm/opensm/osm_sa_service_record.c       |   20 ----
>  opensm/opensm/osm_sa_slvl_record.c          |    8 --
>  opensm/opensm/osm_sa_sminfo_record.c        |    6 -
>  opensm/opensm/osm_sa_sw_info_record.c       |    8 --
>  opensm/opensm/osm_sa_vlarb_record.c         |   10 --
>  opensm/opensm/osm_service.c                 |   12 ---
>  opensm/opensm/osm_slvl_map_rcv.c            |    2 -
>  opensm/opensm/osm_sm.c                      |   18 ----
>  opensm/opensm/osm_sm_mad_ctrl.c             |    8 --
>  opensm/opensm/osm_sm_state_mgr.c            |   16 ---
>  opensm/opensm/osm_sminfo_rcv.c              |   12 ---
>  opensm/opensm/osm_state_mgr.c               |   12 ---
>  opensm/opensm/osm_subnet.c                  |   32 -------
>  opensm/opensm/osm_sw_info_rcv.c             |    2 -
>  opensm/opensm/osm_switch.c                  |   22 -----
>  opensm/opensm/osm_trap_rcv.c                |   15 ---
>  opensm/opensm/osm_ucast_cache.c             |   56 -----------
>  opensm/opensm/osm_ucast_mgr.c               |   26 -----
>  opensm/opensm/osm_ucast_updn.c              |   18 ----
>  opensm/opensm/osm_vl15intf.c                |   13 ---
>  opensm/opensm/osm_vl_arb_rcv.c              |    2 -
>  opensm/osmtest/main.c                       |   10 --
>  opensm/osmtest/osmt_multicast.c             |   15 ---
>  opensm/osmtest/osmt_service.c               |   29 ------
>  opensm/osmtest/osmt_slvl_vl_arb.c           |    2 -
>  opensm/osmtest/osmtest.c                    |  134 ---------------------------
>  87 files changed, 0 insertions(+), 1263 deletions(-)
> 
> diff --git a/opensm/complib/cl_dispatcher.c b/opensm/complib/cl_dispatcher.c
> index 971d8d3..6736d67 100644
> --- a/opensm/complib/cl_dispatcher.c
> +++ b/opensm/complib/cl_dispatcher.c
> @@ -118,8 +118,6 @@ void __cl_disp_worker(IN void *context)
>  	cl_spinlock_release(&p_disp->lock);
>  }
> 
> -/********************************************************************
> - ********************************************************************/
>  void cl_disp_construct(IN cl_dispatcher_t * const p_disp)
>  {
>  	CL_ASSERT(p_disp);
> @@ -131,8 +129,6 @@ void cl_disp_construct(IN cl_dispatcher_t * const p_disp)
>  	cl_qpool_construct(&p_disp->msg_pool);
>  }

[snip]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
