From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-git:wip/jgg-zero-day 5/12] htmldocs:
 drivers/infiniband/ulp/iser/iscsi_iser.h:273: warning: Excess struct member
 'dam_addr' description in 'iser_tx_desc'
Date: Wed, 10 Jan 2018 21:59:39 -0700
Message-ID: <20180111045939.GZ4776@mellanox.com>
References: <201801111232.BXstLm4n%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201801111232.BXstLm4n%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Randy:

What do you want me to do with this?

We can still discard the 'infiniband: add a Documentation driver-api
chapter for Infiniband', or replace it with something else.

I assume the two patches I dropped silence these warnings?

Thanks,
Jason

On Thu, Jan 11, 2018 at 12:43:38PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma wip/jgg-zero-day
> head:   b9082bcde398b3c0fbe64710c043b8360b223b43
> commit: 9a2939223aa91e1cb5d0ccda478583bf4eb2fe92 [5/12] infiniband: add a Documentation driver-api chapter for Infiniband
> reproduce: make htmldocs
> 
> All warnings (new ones prefixed by >>):
> 
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>    kernel/sched/core.c:5113: warning: No description found for parameter 't'
>    kernel/sched/core.c:5113: warning: Excess function parameter 'interval' description in 'sched_rr_get_interval'
>    drivers/gpio/gpiolib.c:601: warning: No description found for parameter '16'
>    drivers/gpio/gpiolib.c:601: warning: Excess struct member 'events' description in 'lineevent_state'
>    include/linux/iio/iio.h:610: warning: No description found for parameter 'iio_dev'
>    include/linux/iio/iio.h:610: warning: Excess function parameter 'indio_dev' description in 'iio_device_register'
>    include/linux/iio/trigger.h:79: warning: No description found for parameter 'owner'
>    drivers/infiniband/core/iwpm_util.h:218: warning: No description found for parameter 'a_sockaddr'
>    drivers/infiniband/core/iwpm_util.h:218: warning: No description found for parameter 'b_sockaddr'
>    drivers/infiniband/core/device.c:460: warning: No description found for parameter 'port_callback'
>    drivers/infiniband/core/device.c:960: warning: No description found for parameter 'nldev_cb'
>    drivers/infiniband/core/device.c:960: warning: No description found for parameter 'skb'
>    drivers/infiniband/core/verbs.c:243: warning: No description found for parameter 'flags'
>    drivers/infiniband/core/verbs.c:243: warning: No description found for parameter 'caller'
>    drivers/infiniband/core/sa_query.c:1514: warning: No description found for parameter 'client'
>    drivers/infiniband/core/sa_query.c:1514: warning: No description found for parameter 'device'
>    drivers/infiniband/core/sa_query.c:1514: warning: No description found for parameter 'port_num'
>    drivers/infiniband/core/sa_query.c:1514: warning: No description found for parameter 'rec'
>    drivers/infiniband/sw/rdmavt/mr.c:382: warning: No description found for parameter 'virt_addr'
>    drivers/infiniband/sw/rdmavt/mr.c:454: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/mr.c:454: warning: No description found for parameter 'v'
>    drivers/infiniband/sw/rdmavt/mr.c:471: warning: No description found for parameter 'mr'
>    drivers/infiniband/sw/rdmavt/mr.c:489: warning: No description found for parameter 'mr'
>    drivers/infiniband/sw/rdmavt/mr.c:489: warning: No description found for parameter 't'
>    drivers/infiniband/sw/rdmavt/mr.c:516: warning: No description found for parameter 'mr'
>    drivers/infiniband/sw/rdmavt/mr.c:516: warning: No description found for parameter 'lkey'
>    drivers/infiniband/sw/rdmavt/mr.c:529: warning: No description found for parameter 'ss'
>    drivers/infiniband/sw/rdmavt/mr.c:529: warning: No description found for parameter 'lkey'
>    drivers/infiniband/sw/rdmavt/vt.c:321: warning: No description found for parameter 'context'
>    drivers/infiniband/sw/rdmavt/vt.c:892: warning: No description found for parameter 'pkey_table'
>    drivers/infiniband/sw/rdmavt/cq.c:355: warning: No description found for parameter 'cqe'
>    drivers/infiniband/sw/rdmavt/cq.c:355: warning: No description found for parameter 'udata'
>    drivers/infiniband/sw/rdmavt/qp.c:144: warning: No description found for parameter 'rdi'
>    drivers/infiniband/sw/rdmavt/qp.c:347: warning: No description found for parameter 'type'
>    drivers/infiniband/sw/rdmavt/qp.c:480: warning: No description found for parameter 'wqe'
>    drivers/infiniband/sw/rdmavt/qp.c:480: warning: No description found for parameter 'lkey'
>    drivers/infiniband/sw/rdmavt/qp.c:498: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:498: warning: No description found for parameter 'lkey'
>    drivers/infiniband/sw/rdmavt/qp.c:522: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:522: warning: No description found for parameter 'lkey'
>    drivers/infiniband/sw/rdmavt/qp.c:641: warning: No description found for parameter 'rdi'
>    drivers/infiniband/sw/rdmavt/qp.c:698: warning: No description found for parameter 'rdi'
>    drivers/infiniband/sw/rdmavt/qp.c:1623: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:1623: warning: No description found for parameter 'post_parms'
>    drivers/infiniband/sw/rdmavt/qp.c:1623: warning: No description found for parameter 'wr'
>    drivers/infiniband/sw/rdmavt/qp.c:1722: warning: No description found for parameter 'call_send'
>    drivers/infiniband/sw/rdmavt/qp.c:2073: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:2073: warning: No description found for parameter 'aeth'
>    drivers/infiniband/sw/rdmavt/qp.c:2091: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:2110: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:2124: warning: No description found for parameter 'qp'
>    drivers/infiniband/sw/rdmavt/qp.c:2134: warning: No description found for parameter 't'
>    drivers/infiniband/sw/rdmavt/qp.c:2197: warning: No description found for parameter 'cb'
>    drivers/infiniband/sw/rdmavt/qp.c:2228: warning: No description found for parameter 'iter'
>    drivers/infiniband/sw/rdmavt/qp.c:2296: warning: No description found for parameter 'rdi'
>    drivers/infiniband/sw/rdmavt/qp.c:2296: warning: No description found for parameter 'v'
>    drivers/infiniband/sw/rdmavt/qp.c:2296: warning: No description found for parameter 'cb'
>    drivers/infiniband/sw/rdmavt/mcast.c:196: warning: No description found for parameter 'rdi'
>    drivers/infiniband/sw/rdmavt/mcast.c:196: warning: No description found for parameter 'ibp'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:273: warning: No description found for parameter 'dma_addr'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:273: warning: No description found for parameter 'cqe'
> >> drivers/infiniband/ulp/iser/iscsi_iser.h:273: warning: Excess struct member 'dam_addr' description in 'iser_tx_desc'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:296: warning: No description found for parameter 'cqe'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:315: warning: No description found for parameter 'rsp'
> >> drivers/infiniband/ulp/iser/iscsi_iser.h:315: warning: Excess struct member 'resp' description in 'iser_login_desc'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:358: warning: No description found for parameter 'reg_mem'
> >> drivers/infiniband/ulp/iser/iscsi_iser.h:358: warning: Excess struct member 'fast_reg_mem' description in 'iser_reg_ops'
> >> drivers/infiniband/ulp/iser/iscsi_iser.h:385: warning: Excess struct member 'mr' description in 'iser_device'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:435: warning: No description found for parameter 'all_list'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:449: warning: No description found for parameter 'all_list'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:475: warning: No description found for parameter 'reg_cqe'
>    drivers/infiniband/ulp/iser/iscsi_iser.h:525: warning: No description found for parameter 'snd_w_inv'
>    drivers/infiniband/ulp/iser/iscsi_iser.c:815: warning: No description found for parameter 'non_blocking'
>    drivers/infiniband/ulp/iser/iser_initiator.c:365: warning: No description found for parameter 'conn'
>    drivers/infiniband/ulp/iser/iser_initiator.c:365: warning: No description found for parameter 'task'
>    drivers/infiniband/ulp/iser/iser_initiator.c:437: warning: No description found for parameter 'conn'
>    drivers/infiniband/ulp/iser/iser_initiator.c:437: warning: No description found for parameter 'task'
>    drivers/infiniband/ulp/iser/iser_initiator.c:437: warning: No description found for parameter 'hdr'
>    drivers/infiniband/ulp/iser/iser_verbs.c:70: warning: No description found for parameter 'device'
>    drivers/infiniband/ulp/iser/iser_verbs.c:133: warning: No description found for parameter 'device'
>    drivers/infiniband/ulp/iser/iser_verbs.c:159: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:159: warning: No description found for parameter 'cmds_max'
>    drivers/infiniband/ulp/iser/iser_verbs.c:159: warning: No description found for parameter 'size'
>    drivers/infiniband/ulp/iser/iser_verbs.c:221: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:357: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:357: warning: No description found for parameter 'cmds_max'
>    drivers/infiniband/ulp/iser/iser_verbs.c:357: warning: No description found for parameter 'size'
>    drivers/infiniband/ulp/iser/iser_verbs.c:391: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:421: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:501: warning: No description found for parameter 'cma_id'
>    drivers/infiniband/ulp/iser/iser_verbs.c:552: warning: No description found for parameter 'iser_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:552: warning: No description found for parameter 'comp'
>    drivers/infiniband/ulp/iser/iser_verbs.c:552: warning: No description found for parameter 'exch'
>    drivers/infiniband/ulp/iser/iser_verbs.c:623: warning: No description found for parameter 'iser_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:658: warning: No description found for parameter 'iser_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:695: warning: No description found for parameter 'cma_id'
>    drivers/infiniband/ulp/iser/iser_verbs.c:726: warning: No description found for parameter 'cma_id'
>    drivers/infiniband/ulp/iser/iser_verbs.c:774: warning: No description found for parameter 'cma_id'
>    drivers/infiniband/ulp/iser/iser_verbs.c:1074: warning: No description found for parameter 'ib_conn'
>    drivers/infiniband/ulp/iser/iser_verbs.c:1074: warning: No description found for parameter 'tx_desc'
>    drivers/infiniband/ulp/iser/iser_verbs.c:1074: warning: No description found for parameter 'signal'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'fabric_id'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'vesw_id'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rsvd0'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'def_port_mask'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rsvd1'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'pkey'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rsvd2'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'u_mcast_dlid'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'u_ucast_dlid'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rsvd3'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'eth_mtu'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:98: warning: No description found for parameter 'rsvd4'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'port_num'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'eth_link_status'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'rsvd0'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'base_mac_addr'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'config_state'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'oper_state'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'max_mac_tbl_ent'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'max_smac_ent'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'mac_tbl_digest'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'rsvd1'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'encap_slid'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'pcp_to_sc_uc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'pcp_to_vl_uc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'pcp_to_sc_mc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'pcp_to_vl_mc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'non_vlan_sc_uc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'non_vlan_vl_uc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'non_vlan_sc_mc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'non_vlan_vl_mc'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'rsvd2'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'uc_macs_gen_count'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'mc_macs_gen_count'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:138: warning: No description found for parameter 'rsvd3'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:148: warning: No description found for parameter 'vesw'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:148: warning: No description found for parameter 'vport'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'fabric_id'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'veswid'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'veswportnum'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'opaportnum'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'veswportindex'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'opcode'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h:163: warning: No description found for parameter 'reserved'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: No description found for parameter 'rsvd0'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: No description found for parameter 'rsvd1'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: No description found for parameter 'rsvd2'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: No description found for parameter 'rsvd3'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:148: warning: No description found for parameter 'rsvd4'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: No description found for parameter 'rsvd0'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: No description found for parameter 'rsvd1'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: No description found for parameter 'rsvd2'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:205: warning: No description found for parameter 'rsvd3'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:263: warning: No description found for parameter 'tbl_entries'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:342: warning: No description found for parameter 'reserved'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd0'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd1'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd2'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd3'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd4'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd5'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd6'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd7'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd8'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:394: warning: No description found for parameter 'rsvd9'
>    drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:460: warning: No description found for parameter 'reserved'
> 
> vim +273 drivers/infiniband/ulp/iser/iscsi_iser.h
> 
> 49cd5382f Or Gerlitz        2006-05-11 @273  
> bcc60c381 Or Gerlitz        2010-02-08  274  #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
> cfeb91b37 Christoph Hellwig 2015-12-11  275  				 sizeof(u64) + sizeof(struct ib_sge) + \
> cfeb91b37 Christoph Hellwig 2015-12-11  276  				 sizeof(struct ib_cqe)))
> cd88621a9 Sagi Grimberg     2014-10-01  277  /**
> cfeb91b37 Christoph Hellwig 2015-12-11  278   * struct iser_rx_desc - iSER RX descriptor
> cd88621a9 Sagi Grimberg     2014-10-01  279   *
> cd88621a9 Sagi Grimberg     2014-10-01  280   * @iser_header:   iser header
> cd88621a9 Sagi Grimberg     2014-10-01  281   * @iscsi_header:  iscsi header
> cd88621a9 Sagi Grimberg     2014-10-01  282   * @data:          received data segment
> cd88621a9 Sagi Grimberg     2014-10-01  283   * @dma_addr:      receive buffer dma address
> cd88621a9 Sagi Grimberg     2014-10-01  284   * @rx_sg:         ib_sge of receive buffer
> cd88621a9 Sagi Grimberg     2014-10-01  285   * @pad:           for sense data TODO: Modify to maximum sense length supported
> cd88621a9 Sagi Grimberg     2014-10-01  286   */
> bcc60c381 Or Gerlitz        2010-02-08  287  struct iser_rx_desc {
> d3cf81f9c Sagi Grimberg     2015-12-09  288  	struct iser_ctrl             iser_header;
> bcc60c381 Or Gerlitz        2010-02-08  289  	struct iscsi_hdr             iscsi_header;
> bcc60c381 Or Gerlitz        2010-02-08  290  	char		             data[ISER_RECV_DATA_SEG_LEN];
> bcc60c381 Or Gerlitz        2010-02-08  291  	u64		             dma_addr;
> bcc60c381 Or Gerlitz        2010-02-08  292  	struct ib_sge		     rx_sg;
> cfeb91b37 Christoph Hellwig 2015-12-11  293  	struct ib_cqe		     cqe;
> bcc60c381 Or Gerlitz        2010-02-08  294  	char		             pad[ISER_RX_PAD_SIZE];
> cfeb91b37 Christoph Hellwig 2015-12-11  295  } __packed;
> 0f512b34c Sagi Grimberg     2015-11-04  296  
> 0f512b34c Sagi Grimberg     2015-11-04  297  /**
> 0f512b34c Sagi Grimberg     2015-11-04  298   * struct iser_login_desc - iSER login descriptor
> 0f512b34c Sagi Grimberg     2015-11-04  299   *
> 0f512b34c Sagi Grimberg     2015-11-04  300   * @req:           pointer to login request buffer
> 0f512b34c Sagi Grimberg     2015-11-04  301   * @resp:          pointer to login response buffer
> 0f512b34c Sagi Grimberg     2015-11-04  302   * @req_dma:       DMA address of login request buffer
> 0f512b34c Sagi Grimberg     2015-11-04  303   * @rsp_dma:      DMA address of login response buffer
> 0f512b34c Sagi Grimberg     2015-11-04  304   * @sge:           IB sge for login post recv
> cfeb91b37 Christoph Hellwig 2015-12-11  305   * @cqe:           completion handler
> 0f512b34c Sagi Grimberg     2015-11-04  306   */
> 0f512b34c Sagi Grimberg     2015-11-04  307  struct iser_login_desc {
> 0f512b34c Sagi Grimberg     2015-11-04  308  	void                         *req;
> 0f512b34c Sagi Grimberg     2015-11-04  309  	void                         *rsp;
> 0f512b34c Sagi Grimberg     2015-11-04  310  	u64                          req_dma;
> 0f512b34c Sagi Grimberg     2015-11-04  311  	u64                          rsp_dma;
> 0f512b34c Sagi Grimberg     2015-11-04  312  	struct ib_sge                sge;
> cfeb91b37 Christoph Hellwig 2015-12-11  313  	struct ib_cqe		     cqe;
> bcc60c381 Or Gerlitz        2010-02-08  314  } __attribute__((packed));
> bcc60c381 Or Gerlitz        2010-02-08 @315  
> b4e155ffb Sagi Grimberg     2013-07-28  316  struct iser_conn;
> a4ee3539f Sagi Grimberg     2014-10-01  317  struct ib_conn;
> b4e155ffb Sagi Grimberg     2013-07-28  318  struct iscsi_iser_task;
> b4e155ffb Sagi Grimberg     2013-07-28  319  
> bf1755403 Sagi Grimberg     2014-10-01  320  /**
> bf1755403 Sagi Grimberg     2014-10-01  321   * struct iser_comp - iSER completion context
> bf1755403 Sagi Grimberg     2014-10-01  322   *
> 6aabfa76f Sagi Grimberg     2014-10-01  323   * @cq:         completion queue
> bf1755403 Sagi Grimberg     2014-10-01  324   * @active_qps: Number of active QPs attached
> bf1755403 Sagi Grimberg     2014-10-01  325   *              to completion context
> bf1755403 Sagi Grimberg     2014-10-01  326   */
> bf1755403 Sagi Grimberg     2014-10-01  327  struct iser_comp {
> 6aabfa76f Sagi Grimberg     2014-10-01  328  	struct ib_cq		*cq;
> bf1755403 Sagi Grimberg     2014-10-01  329  	int                      active_qps;
> bf1755403 Sagi Grimberg     2014-10-01  330  };
> bf1755403 Sagi Grimberg     2014-10-01  331  
> cd88621a9 Sagi Grimberg     2014-10-01  332  /**
> 48afbff67 Sagi Grimberg     2015-08-06  333   * struct iser_device - Memory registration operations
> 48afbff67 Sagi Grimberg     2015-08-06  334   *     per-device registration schemes
> 48afbff67 Sagi Grimberg     2015-08-06  335   *
> 48afbff67 Sagi Grimberg     2015-08-06  336   * @alloc_reg_res:     Allocate registration resources
> 48afbff67 Sagi Grimberg     2015-08-06  337   * @free_reg_res:      Free registration resources
> 32467c420 Sagi Grimberg     2015-08-06  338   * @fast_reg_mem:      Register memory buffers
> 32467c420 Sagi Grimberg     2015-08-06  339   * @unreg_mem:         Un-register memory buffers
> 81722909c Sagi Grimberg     2015-08-06  340   * @reg_desc_get:      Get a registration descriptor for pool
> 81722909c Sagi Grimberg     2015-08-06  341   * @reg_desc_put:      Get a registration descriptor to pool
> 48afbff67 Sagi Grimberg     2015-08-06  342   */
> 48afbff67 Sagi Grimberg     2015-08-06  343  struct iser_reg_ops {
> 48afbff67 Sagi Grimberg     2015-08-06  344  	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
> f8db651da Sagi Grimberg     2015-08-06  345  					unsigned cmds_max,
> f8db651da Sagi Grimberg     2015-08-06  346  					unsigned int size);
> 48afbff67 Sagi Grimberg     2015-08-06  347  	void           (*free_reg_res)(struct ib_conn *ib_conn);
> 32467c420 Sagi Grimberg     2015-08-06  348  	int            (*reg_mem)(struct iscsi_iser_task *iser_task,
> 32467c420 Sagi Grimberg     2015-08-06  349  				  struct iser_data_buf *mem,
> 32467c420 Sagi Grimberg     2015-08-06  350  				  struct iser_reg_resources *rsc,
> 32467c420 Sagi Grimberg     2015-08-06  351  				  struct iser_mem_reg *reg);
> 32467c420 Sagi Grimberg     2015-08-06  352  	void           (*unreg_mem)(struct iscsi_iser_task *iser_task,
> 48afbff67 Sagi Grimberg     2015-08-06  353  				    enum iser_data_dir cmd_dir);
> 81722909c Sagi Grimberg     2015-08-06  354  	struct iser_fr_desc * (*reg_desc_get)(struct ib_conn *ib_conn);
> 81722909c Sagi Grimberg     2015-08-06  355  	void           (*reg_desc_put)(struct ib_conn *ib_conn,
> 81722909c Sagi Grimberg     2015-08-06  356  				       struct iser_fr_desc *desc);
> 48afbff67 Sagi Grimberg     2015-08-06  357  };
> 48afbff67 Sagi Grimberg     2015-08-06 @358  
> 48afbff67 Sagi Grimberg     2015-08-06  359  /**
> cd88621a9 Sagi Grimberg     2014-10-01  360   * struct iser_device - iSER device handle
> cd88621a9 Sagi Grimberg     2014-10-01  361   *
> cd88621a9 Sagi Grimberg     2014-10-01  362   * @ib_device:     RDMA device
> cd88621a9 Sagi Grimberg     2014-10-01  363   * @pd:            Protection Domain for this device
> cd88621a9 Sagi Grimberg     2014-10-01  364   * @mr:            Global DMA memory region
> cd88621a9 Sagi Grimberg     2014-10-01  365   * @event_handler: IB events handle routine
> cd88621a9 Sagi Grimberg     2014-10-01  366   * @ig_list:	   entry in devices list
> cd88621a9 Sagi Grimberg     2014-10-01  367   * @refcount:      Reference counter, dominated by open iser connections
> cd88621a9 Sagi Grimberg     2014-10-01  368   * @comps_used:    Number of completion contexts used, Min between online
> cd88621a9 Sagi Grimberg     2014-10-01  369   *                 cpus and device max completion vectors
> cd88621a9 Sagi Grimberg     2014-10-01  370   * @comps:         Dinamically allocated array of completion handlers
> 48afbff67 Sagi Grimberg     2015-08-06  371   * @reg_ops:       Registration ops
> 59caaed7a Jenny Derzhavetz  2015-12-24  372   * @remote_inv_sup: Remote invalidate is supported on this device
> cd88621a9 Sagi Grimberg     2014-10-01  373   */
> 49cd5382f Or Gerlitz        2006-05-11  374  struct iser_device {
> 49cd5382f Or Gerlitz        2006-05-11  375  	struct ib_device             *ib_device;
> 49cd5382f Or Gerlitz        2006-05-11  376  	struct ib_pd	             *pd;
> 2110f9bf3 Or Gerlitz        2010-05-05  377  	struct ib_event_handler      event_handler;
> cd88621a9 Sagi Grimberg     2014-10-01  378  	struct list_head             ig_list;
> 49cd5382f Or Gerlitz        2006-05-11  379  	int                          refcount;
> bf1755403 Sagi Grimberg     2014-10-01  380  	int			     comps_used;
> da64bdb25 Sagi Grimberg     2014-12-07  381  	struct iser_comp	     *comps;
> 2392a4cdc Julia Lawall      2015-11-28  382  	const struct iser_reg_ops    *reg_ops;
> 59caaed7a Jenny Derzhavetz  2015-12-24  383  	bool                         remote_inv_sup;
> 49cd5382f Or Gerlitz        2006-05-11  384  };
> 49cd5382f Or Gerlitz        2006-05-11 @385  
> 
> :::::: The code at line 273 was first introduced by commit
> :::::: 49cd5382f629bde2aee9f817cefb271106dc47ee IB/iser: iSCSI iSER transport provider header file
> 
> :::::: TO: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> :::::: CC: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> 
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
