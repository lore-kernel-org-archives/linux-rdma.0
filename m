Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795692902;
	b=Y6qRnJlyaWLapT5nOcyM+MG0yVIKKnExDzyNNnPSdtjoknXYPwne5WrfR7JJLa7KsVlt
	 t0Pl+eJ9QAhv2AWgJlxyNNYNAQn/tNZtfPMl2pSiDky5m2LKDtGRweeguzxtkICl48LqK
	 JOpM4fCmNoXKbyzaWkLHugt4lda5jI6GmEIZuHee5yun7EkBbCg+T8KG/zWsdm6NY7ZGa
	 mlELySPYKv92fJaQAamCjT+CiuPXAtFlM3CxjYwdGpWSix8ry4UFPCW62EuzE/c18Gm31
	 TjcwOo9OQFQ31lrj6T9ENU8T2+WQByd54RdCzjHxtKAYrTgWJL13qBHTtsd3jzuZ5pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795692902;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=F1ysSIq8P4zmWw07TXTD7UWja5GSxoOEW3aTiOqMAwg=;
	b=Hsmc6CyjhG58UwmdVALzjw4rBFGXqvCxlQF/VpvkF8GxE8aAv2taJ8Kta1Z1G+r3Knx5
	 uc6oAH3ebCdUXa4tND6eUfeNk3hriDXueDlbPVi3ecXCnKT8A+FGOOY6hDJxmVLPtar7x
	 cZDfi6RH6byVF7sEHD79SlJMen/UBdFQmDpkDCa6VBmTH+aWa2U3H7C2Ei317DH9EUNNy
	 L+KUwWYaQvmhdFyF9D4hleKUUMK8eUzQ2O4UcJt+R4hb8p3XghvtPqJ3pvT4Cg/GwKlZk
	 3UmGS6aN80m4GTd5jnKuivm1fWpw9ChBS+F7E6Wcv8fMT8HqTd5+A+Cqba6JrsAzrXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Mqjef4Md;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42853606A31E;
	Thu, 26 Nov 2026 11:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42853606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Mqjef4Md
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795692903; x=1827228903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qZ4auUk8+IHrdvOEBAFF06C3MVQTviD6R5qX6NqXpgQ=;
  b=Mqjef4MdAu0AZN5tYLRjOaB0A6S2C9xN+M5iJFQN/oIDbWSTXzFmqJiJ
   4joe8UUQ7lY9Mv2HFzVPTN9oK72qxBL2M64masUndkGe6Zc7vLUf1F5LU
   E8t28M/avPZzva3wcmkkWLvw6n93KWc3r5VIuiLKiKE/RtnEp1c8UBNNP
   razhJ3T9xFl/JW1ASb448fBxhh+DuvJeJiXEzN6yRVa1Fch/EWZrlIxB6
   UerApqckuqzSvFRRzd60gbRKEA6i1LuTqLz/djaP3VdrdfpKBLAPlX/Nv
   gbrpDKMSUBXrbdq6ryA9z3ONpyEhF/ZGfVPi4f4BjWAO+Wjgh5Em2Bjc1
   w==;
X-CSE-ConnectionGUID: 2JAcOMHYRxCHN8HbnR8OFQ==
X-CSE-MsgGUID: c1uzyWUbSBuNEuPvy/QUug==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4614583"
X-IronPort-AV: E=Sophos;i="6.27,234,1787036400"; 
   d="scan'208";a="4614583"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 03:34:33 -0800
X-CSE-ConnectionGUID: JdG1uh/xRBaOMQe9t8sFcw==
X-CSE-MsgGUID: IgW0FcPpSeKxGYB7k14OjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,234,1787036400"; 
   d="scan'208";a="12198114"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 26 Nov 2026 03:34:26 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWXk7-00000001Tz8-1c75;
	Thu, 26 Nov 2026 11:34:23 +0000
Date: Thu, 26 Nov 2026 19:33:31 +0800
From: kernel test robot <lkp@intel.com>
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>,
	linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Expose SW RoCE monitor matched
 packets counter
Message-ID: <20261126192651.xrb8kANY-lkp@intel.com>
References: <20261125212344.243989-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125212344.243989-1-tariqt@nvidia.com>

Hi Tariq,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 612848d37e68b858e15815175f1c5e609e09d719]

url:    https://github.com/intel-lab-lkp/linux/commits/Tariq-Toukan/net-mlx5-Expose-SW-RoCE-monitor-matched-packets-counter/20261125-232343
base:   612848d37e68b858e15815175f1c5e609e09d719
patch link:    https://lore.kernel.org/r/20261125212344.243989-1-tariqt%40nvidia.com
patch subject: [PATCH net-next] net/mlx5: Expose SW RoCE monitor matched packets counter
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20261126/20261126192651.xrb8kANY-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126192651.xrb8kANY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126192651.xrb8kANY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c: In function 'mlx5_reporter_vnic_diagnose_counters':
>> drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c:133:1: warning: the frame size of 1344 bytes is larger than 1280 bytes [-Wframe-larger-than=]
     133 | }
         | ^


vim +133 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c

b820864335c8b3 Akiva Goldberger 2025-02-09   63  
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   64  void mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
b0bc615df488ab Maher Sanalla    2023-03-21   65  					  struct devlink_fmsg *fmsg,
b0bc615df488ab Maher Sanalla    2023-03-21   66  					  u16 vport_num, bool other_vport)
b0bc615df488ab Maher Sanalla    2023-03-21   67  {
b0bc615df488ab Maher Sanalla    2023-03-21   68  	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
2520766fb420da Moshe Shemesh    2026-11-25   69  	u32 cap_reg[MLX5_ST_SZ_DW(nic_cap_reg)] = {};
b0bc615df488ab Maher Sanalla    2023-03-21   70  	struct mlx5_vnic_diag_stats vnic;
2520766fb420da Moshe Shemesh    2026-11-25   71  	bool cap_reg_valid = false;
b0bc615df488ab Maher Sanalla    2023-03-21   72  
b0bc615df488ab Maher Sanalla    2023-03-21   73  	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
b0bc615df488ab Maher Sanalla    2023-03-21   74  	MLX5_SET(query_vnic_env_in, in, vport_number, vport_num);
b0bc615df488ab Maher Sanalla    2023-03-21   75  	MLX5_SET(query_vnic_env_in, in, other_vport, !!other_vport);
b0bc615df488ab Maher Sanalla    2023-03-21   76  
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   77  	mlx5_cmd_exec_inout(dev, query_vnic_env, in, &vnic.query_vnic_env_out);
b0bc615df488ab Maher Sanalla    2023-03-21   78  
2520766fb420da Moshe Shemesh    2026-11-25   79  	if (MLX5_CAP_GEN(dev, nic_cap_reg))
2520766fb420da Moshe Shemesh    2026-11-25   80  		cap_reg_valid = !mlx5_reporter_vnic_query_nic_cap(dev, cap_reg);
2520766fb420da Moshe Shemesh    2026-11-25   81  
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   82  	devlink_fmsg_pair_nest_start(fmsg, "vNIC env counters");
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   83  	devlink_fmsg_obj_nest_start(fmsg);
b0bc615df488ab Maher Sanalla    2023-03-21   84  
548ee049b19fb9 Lama Kayal       2023-06-11   85  	if (MLX5_CAP_GEN(dev, vnic_env_queue_counters)) {
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   86  		devlink_fmsg_u32_pair_put(fmsg, "total_error_queues",
548ee049b19fb9 Lama Kayal       2023-06-11   87  					  VNIC_ENV_GET(&vnic, total_error_queues));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   88  		devlink_fmsg_u32_pair_put(fmsg, "send_queue_priority_update_flow",
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   89  					  VNIC_ENV_GET(&vnic, send_queue_priority_update_flow));
548ee049b19fb9 Lama Kayal       2023-06-11   90  	}
548ee049b19fb9 Lama Kayal       2023-06-11   91  	if (MLX5_CAP_GEN(dev, eq_overrun_count)) {
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   92  		devlink_fmsg_u32_pair_put(fmsg, "comp_eq_overrun",
548ee049b19fb9 Lama Kayal       2023-06-11   93  					  VNIC_ENV_GET(&vnic, comp_eq_overrun));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   94  		devlink_fmsg_u32_pair_put(fmsg, "async_eq_overrun",
548ee049b19fb9 Lama Kayal       2023-06-11   95  					  VNIC_ENV_GET(&vnic, async_eq_overrun));
548ee049b19fb9 Lama Kayal       2023-06-11   96  	}
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   97  	if (MLX5_CAP_GEN(dev, vnic_env_cq_overrun))
d17f98bf7cc9ed Przemek Kitszel  2023-10-18   98  		devlink_fmsg_u32_pair_put(fmsg, "cq_overrun",
548ee049b19fb9 Lama Kayal       2023-06-11   99  					  VNIC_ENV_GET(&vnic, cq_overrun));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  100  	if (MLX5_CAP_GEN(dev, invalid_command_count))
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  101  		devlink_fmsg_u32_pair_put(fmsg, "invalid_command",
548ee049b19fb9 Lama Kayal       2023-06-11  102  					  VNIC_ENV_GET(&vnic, invalid_command));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  103  	if (MLX5_CAP_GEN(dev, quota_exceeded_count))
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  104  		devlink_fmsg_u32_pair_put(fmsg, "quota_exceeded_command",
548ee049b19fb9 Lama Kayal       2023-06-11  105  					  VNIC_ENV_GET(&vnic, quota_exceeded_command));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  106  	if (MLX5_CAP_GEN(dev, nic_receive_steering_discard))
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  107  		devlink_fmsg_u64_pair_put(fmsg, "nic_receive_steering_discard",
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  108  					  VNIC_ENV_GET64(&vnic, nic_receive_steering_discard));
548ee049b19fb9 Lama Kayal       2023-06-11  109  	if (MLX5_CAP_GEN(dev, vnic_env_cnt_steering_fail)) {
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  110  		devlink_fmsg_u64_pair_put(fmsg, "generated_pkt_steering_fail",
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  111  					  VNIC_ENV_GET64(&vnic, generated_pkt_steering_fail));
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  112  		devlink_fmsg_u64_pair_put(fmsg, "handled_pkt_steering_fail",
a33682e4e78e24 Lama Kayal       2023-06-06  113  					  VNIC_ENV_GET64(&vnic, handled_pkt_steering_fail));
548ee049b19fb9 Lama Kayal       2023-06-11  114  	}
2520766fb420da Moshe Shemesh    2026-11-25  115  	if (cap_reg_valid && MLX5_GET(nic_cap_reg, cap_reg, vhca_icm_ctrl))
b820864335c8b3 Akiva Goldberger 2025-02-09  116  		mlx5_reporter_vnic_diagnose_counter_icm(dev, fmsg, vport_num, other_vport);
e835faaed2f80e Akiva Goldberger 2025-09-25  117  	if (MLX5_CAP_GEN(dev, vnic_env_cnt_bar_uar_access))
e835faaed2f80e Akiva Goldberger 2025-09-25  118  		devlink_fmsg_u32_pair_put(fmsg, "bar_uar_access",
e835faaed2f80e Akiva Goldberger 2025-09-25  119  					  VNIC_ENV_GET(&vnic, bar_uar_access));
e835faaed2f80e Akiva Goldberger 2025-09-25  120  	if (MLX5_CAP_GEN(dev, vnic_env_cnt_odp_page_fault)) {
e835faaed2f80e Akiva Goldberger 2025-09-25  121  		devlink_fmsg_u32_pair_put(fmsg, "odp_local_triggered_page_fault",
e835faaed2f80e Akiva Goldberger 2025-09-25  122  					  VNIC_ENV_GET(&vnic, odp_local_triggered_page_fault));
e835faaed2f80e Akiva Goldberger 2025-09-25  123  		devlink_fmsg_u32_pair_put(fmsg, "odp_remote_triggered_page_fault",
e835faaed2f80e Akiva Goldberger 2025-09-25  124  					  VNIC_ENV_GET(&vnic, odp_remote_triggered_page_fault));
e835faaed2f80e Akiva Goldberger 2025-09-25  125  	}
2520766fb420da Moshe Shemesh    2026-11-25  126  	if (cap_reg_valid &&
2520766fb420da Moshe Shemesh    2026-11-25  127  	    MLX5_GET(nic_cap_reg, cap_reg, sw_roce_monitor_classifier))
2520766fb420da Moshe Shemesh    2026-11-25  128  		devlink_fmsg_u32_pair_put(fmsg, "sw_roce_monitor_matched_packets",
2520766fb420da Moshe Shemesh    2026-11-25  129  					  VNIC_ENV_GET(&vnic, sw_roce_monitor_matched_packets));
a33682e4e78e24 Lama Kayal       2023-06-06  130  
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  131  	devlink_fmsg_obj_nest_end(fmsg);
d17f98bf7cc9ed Przemek Kitszel  2023-10-18  132  	devlink_fmsg_pair_nest_end(fmsg);
b0bc615df488ab Maher Sanalla    2023-03-21 @133  }
b0bc615df488ab Maher Sanalla    2023-03-21  134  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
