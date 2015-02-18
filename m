From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Enhance device capabilities flags debug
 printouts
Date: Wed, 18 Feb 2015 09:12:51 +0200
Message-ID: <20150218071250.GA2738@yuval-lab>
References: <1422282623-3744-1-git-send-email-yuval.shaia@oracle.com>
 <20150216173246.GA3284@yuval-lab>
 <54E33847.5090001@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54E33847.5090001-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 17, 2015 at 02:47:03PM +0200, Matan Barak wrote:
> 
> 
> On 2/16/2015 7:32 PM, Yuval Shaia wrote:
> >ping
> >
> >On Mon, Jan 26, 2015 at 06:30:23AM -0800, Yuval Shaia wrote:
> >>1. Add descriptions of all features.
> >>2. Add indication whether feature is supported or not.
> >>With this enhancement all device features will be printed along with flags that shows if feature is supported by FW, Driver or both.
> >>
> >>Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>---
> >>  drivers/net/ethernet/mellanox/mlx4/fw.c | 54 +++++++++++++++++++++++++++------
> >>  include/linux/mlx4/device.h             | 52 +++++++++++++++++++++++++++++++
> >>  2 files changed, 96 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
> >>index 982861d..34a7ab3 100644
> >>--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
> >>+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
> >>@@ -77,6 +77,19 @@ MODULE_PARM_DESC(enable_qos, "Enable Quality of Service support in the HCA (defa
> >>  		}						      \
> >>  	} while (0)
> >>
> >>+void dump_cap_flags(struct mlx4_dev *dev, u64 fw_flags, u64 drv_flags,
> >>+		    const char** fname, int fname_sz)
> >>+{
> >>+	int i;
> >>+	for (i = 0; i < fname_sz; ++i) {
> >>+		if (fname[i])
> >>+			mlx4_dbg(dev, "\t(%c%c) %s\n",
> >>+				 (fw_flags & (1LL << i)) ? '+' : '-',
> >>+				 (drv_flags & (1LL << i)) ? '+' : '-',
> >>+				 fname[i]);
> >>+	}
> >>+}
> >>+
> 
> I think using + and - for both the driver and FW is a bit confusing.
> Maybe F/X, D/X for supported/unsupported?
Agree.
It will be much more readable for one that unfamiliar with the code.
> 
> >>  static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >>  {
> >>  	static const char *fname[] = {
> >>@@ -91,7 +104,10 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >>  		[ 8] = "P_Key violation counter",
> >>  		[ 9] = "Q_Key violation counter",
> >>  		[10] = "VMM",
> >>+		[11] = "Fibre Channel Protocol On Ethernet Ports support",
> >>  		[12] = "Dual Port Different Protocol (DPDP) support",
> >>+		[13] = "Raw Ethertype support",
> >>+		[14] = "Raw IPv6 support",
> >>  		[15] = "Big LSO headers",
> >>  		[16] = "MW support",
> >>  		[17] = "APM support",
> >>@@ -99,33 +115,53 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >>  		[19] = "Raw multicast support",
> >>  		[20] = "Address vector port checking support",
> >>  		[21] = "UD multicast support",
> >>+		[22] = "UD IPv4 Multicast support",
> >>  		[24] = "Demand paging support",
> >>  		[25] = "Router support",
> >>+		[26] = "L2 Ethernet Multicast support",
> >>+		[28] = "Software parsing support for UD transport",
> >>+		[29] = "TCP checksum off-load support (ipv6)",
> >>  		[30] = "IBoE support",
> >>+		[31] = "FCoE T11 frame format support",
> >>  		[32] = "Unicast loopback support",
> >>+		[32] = "Multicast loopback support",
> >>  		[34] = "FCS header control",
> >>-		[38] = "Wake On LAN support",
> >>+		[35] = "Address Path ud_force_mgid support",
> >>+		[36] = "Header-Data Split support",
> >>+		[37] = "Wake On LAN support on port 1",
> >>+		[38] = "Wake On LAN support on port 2",
> >>+		[39] = "Fatal Warning Event upon a thermal warning condition",
> >>  		[40] = "UDP RSS support",
> >>  		[41] = "Unicast VEP steering support",
> >>  		[42] = "Multicast VEP steering support",
> >>+		[43] = "VLAN Steering mechanism support",
> >>+		[44] = "Steering according to EtherType support",
> >>+		[45] = "WQE format version 1 support",
> >>+		[46] = "Keep Alive Validiation support",
> >>+		[47] = "PTP1588 support",
> >>  		[48] = "Counters support",
> >>+		[49] = "Advanced Counters support",
> >>+		[50] = "Force Ethernet user priority from QPC support",
> >>+		[51] = "RX Port Num check disabled",
> >>+		[52] = "RSS on fragmented IP datagram support",
> >>  		[53] = "Port ETS Scheduler support",
> >>  		[55] = "Port link type sensing support",
> >>+		[56] = "Reliable Multicast support",
> >>+		[57] = "Fast Drop support",
> >>+		[58] = "Protected FMR support",
> >>  		[59] = "Port management change event support",
> >>  		[61] = "64 byte EQE support",
> >>  		[62] = "64 byte CQE support",
> >>  	};
> >>-	int i;
> >>
> >>  	mlx4_dbg(dev, "DEV_CAP flags:\n");
> >>-	for (i = 0; i < ARRAY_SIZE(fname); ++i)
> >>-		if (fname[i] && (flags & (1LL << i)))
> >>-			mlx4_dbg(dev, "    %s\n", fname[i]);
> >>+	dump_cap_flags(dev, flags, MLX4_DEV_CAP_FLAG_ALL, fname,
> >>+		       ARRAY_SIZE(fname));
> >>  }
> >>
> >>  static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> >>  {
> >>-	static const char * const fname[] = {
> >>+	static const char *fname[] = {
> >>  		[0] = "RSS support",
> >>  		[1] = "RSS Toeplitz Hash Function support",
> >>  		[2] = "RSS XOR Hash Function support",
> >>@@ -147,11 +183,9 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> >>  		[18] = "More than 80 VFs support",
> >>  		[19] = "Performance optimized for limited rule configuration flow steering support"
> >>  	};
> >>-	int i;
> >>
> >>-	for (i = 0; i < ARRAY_SIZE(fname); ++i)
> >>-		if (fname[i] && (flags & (1LL << i)))
> >>-			mlx4_dbg(dev, "    %s\n", fname[i]);
> >>+	dump_cap_flags(dev, flags, MLX4_DEV_CAP_FLAG2_ALL, fname,
> >>+		       ARRAY_SIZE(fname));
> >>  }
> >>
> >>  int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg)
> >>diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> >>index 25c791e..e84badc 100644
> >>--- a/include/linux/mlx4/device.h
> >>+++ b/include/linux/mlx4/device.h
> >>@@ -180,6 +180,37 @@ enum {
> >>  	MLX4_DEV_CAP_FLAG_64B_CQE	= 1LL << 62
> >>  };
> >>
> >>+#define MLX4_DEV_CAP_FLAG_ALL	MLX4_DEV_CAP_FLAG_RC | \
> >>+				MLX4_DEV_CAP_FLAG_UC | \
> >>+				MLX4_DEV_CAP_FLAG_UD | \
> >>+				MLX4_DEV_CAP_FLAG_XRC | \
> >>+				MLX4_DEV_CAP_FLAG_SRQ | \
> >>+				MLX4_DEV_CAP_FLAG_IPOIB_CSUM | \
> >>+				MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	 | \
> >>+				MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR	 | \
> >>+				MLX4_DEV_CAP_FLAG_DPDP | \
> >>+				MLX4_DEV_CAP_FLAG_BLH | \
> >>+				MLX4_DEV_CAP_FLAG_MEM_WINDOW | \
> >>+				MLX4_DEV_CAP_FLAG_APM | \
> >>+				MLX4_DEV_CAP_FLAG_ATOMIC | \
> >>+				MLX4_DEV_CAP_FLAG_RAW_MCAST | \
> >>+				MLX4_DEV_CAP_FLAG_UD_AV_PORT | \
> >>+				MLX4_DEV_CAP_FLAG_UD_MCAST | \
> >>+				MLX4_DEV_CAP_FLAG_IBOE | \
> >>+				MLX4_DEV_CAP_FLAG_UC_LOOPBACK | \
> >>+				MLX4_DEV_CAP_FLAG_FCS_KEEP | \
> >>+				MLX4_DEV_CAP_FLAG_WOL_PORT1 | \
> >>+				MLX4_DEV_CAP_FLAG_WOL_PORT2 | \
> >>+				MLX4_DEV_CAP_FLAG_UDP_RSS | \
> >>+				MLX4_DEV_CAP_FLAG_VEP_UC_STEER | \
> >>+				MLX4_DEV_CAP_FLAG_VEP_MC_STEER | \
> >>+				MLX4_DEV_CAP_FLAG_COUNTERS | \
> >>+				MLX4_DEV_CAP_FLAG_SET_ETH_SCHED  | \
> >>+				MLX4_DEV_CAP_FLAG_SENSE_SUPPORT	 | \
> >>+				MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV  | \
> >>+				MLX4_DEV_CAP_FLAG_64B_EQE | \
> >>+				MLX4_DEV_CAP_FLAG_64B_CQE
> >>+
> 
> I don't really like the idea that adding a flag is done both here
> and both in the enum. However, I don't see other option right now.
Same with me, no other choice.
Other ideas are welcome.
> 
> >>  enum {
> >>  	MLX4_DEV_CAP_FLAG2_RSS			= 1LL <<  0,
> >>  	MLX4_DEV_CAP_FLAG2_RSS_TOP		= 1LL <<  1,
> >>@@ -203,6 +234,27 @@ enum {
> >>  	MLX4_DEV_CAP_FLAG2_FS_A0		= 1LL <<  19
> >>  };
> >>
> >>+#define MLX4_DEV_CAP_FLAG2_ALL	MLX4_DEV_CAP_FLAG2_RSS | \
> >>+				MLX4_DEV_CAP_FLAG2_RSS_TOP | \
> >>+				MLX4_DEV_CAP_FLAG2_RSS_XOR | \
> >>+				MLX4_DEV_CAP_FLAG2_FS_EN | \
> >>+				MLX4_DEV_CAP_FLAG2_REASSIGN_MAC_EN | \
> >>+				MLX4_DEV_CAP_FLAG2_TS | \
> >>+				MLX4_DEV_CAP_FLAG2_VLAN_CONTROL | \
> >>+				MLX4_DEV_CAP_FLAG2_FSM | \
> >>+				MLX4_DEV_CAP_FLAG2_UPDATE_QP | \
> >>+				MLX4_DEV_CAP_FLAG2_DMFS_IPOIB | \
> >>+				MLX4_DEV_CAP_FLAG2_VXLAN_OFFLOADS | \
> >>+				MLX4_DEV_CAP_FLAG2_MAD_DEMUX | \
> >>+				MLX4_DEV_CAP_FLAG2_CQE_STRIDE | \
> >>+				MLX4_DEV_CAP_FLAG2_EQE_STRIDE | \
> >>+				MLX4_DEV_CAP_FLAG2_ETH_PROT_CTRL | \
> >>+				MLX4_DEV_CAP_FLAG2_ETH_BACKPL_AN_REP | \
> >>+				MLX4_DEV_CAP_FLAG2_CONFIG_DEV | \
> >>+				MLX4_DEV_CAP_FLAG2_SYS_EQS | \
> >>+				MLX4_DEV_CAP_FLAG2_80_VFS | \
> >>+				MLX4_DEV_CAP_FLAG2_FS_A0
> >>+
> >>  enum {
> >>  	MLX4_QUERY_FUNC_FLAGS_BF_RES_QP		= 1LL << 0,
> >>  	MLX4_QUERY_FUNC_FLAGS_A0_RES_QP		= 1LL << 1
> >>--
> >>1.9.1
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
