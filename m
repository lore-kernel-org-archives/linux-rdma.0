From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 5/5] IB/mlx5: Report Scatter FCS device capability when supported
Date: Wed, 20 Apr 2016 21:24:43 -0400
Message-ID: <20160421012442.GA30527@phlsvsds.ph.intel.com>
References: <1460902778-5977-6-git-send-email-matanb@mellanox.com> <201604172352.60qppaot%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201604172352.60qppaot%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I will do my best to review this.  But to save time I'll wait for the kbuilds
to be fixed.

Thanks,
Ira


On Sun, Apr 17, 2016 at 11:44:43PM +0800, kbuild test robot wrote:
> Hi Majd,
> 
> [auto build test WARNING on rdma/master]
> [also build test WARNING on v4.6-rc3 next-20160415]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Matan-Barak/Add-scatter-FCS-support/20160417-222225
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma master
> config: xtensa-allmodconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/byteorder/big_endian.h:4:0,
>                     from arch/xtensa/include/uapi/asm/byteorder.h:7,
>                     from arch/xtensa/include/asm/bitops.h:23,
>                     from include/linux/bitops.h:36,
>                     from include/linux/kernel.h:10,
>                     from include/linux/list.h:8,
>                     from include/linux/wait.h:6,
>                     from include/linux/fs.h:5,
>                     from include/linux/highmem.h:4,
>                     from drivers/infiniband/hw/mlx5/main.c:33:
>    drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
>    include/linux/mlx5/device.h:51:80: error: 'struct mlx5_ifc_per_protocol_networking_offload_caps_bits' has no member named 'scatter_fcs'
>     #define __mlx5_bit_off(typ, fld) ((unsigned)(unsigned long)(&(__mlx5_nullp(typ)->fld)))
>                                                                                    ^
>    include/uapi/linux/byteorder/big_endian.h:39:51: note: in definition of macro '__be32_to_cpu'
>     #define __be32_to_cpu(x) ((__force __u32)(__be32)(x))
>                                                       ^
>    include/linux/mlx5/device.h:52:34: note: in expansion of macro '__mlx5_bit_off'
>     #define __mlx5_dw_off(typ, fld) (__mlx5_bit_off(typ, fld) / 32)
>                                      ^
>    include/linux/mlx5/device.h:85:1: note: in expansion of macro '__mlx5_dw_off'
>     __mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
>     ^
>    include/linux/mlx5/device.h:1253:2: note: in expansion of macro 'MLX5_GET'
>      MLX5_GET(per_protocol_networking_offload_caps,\
>      ^
> >> drivers/infiniband/hw/mlx5/main.c:521:6: note: in expansion of macro 'MLX5_CAP_ETH'
>          MLX5_CAP_ETH(dev->mdev, scatter_fcs))
>          ^
>    In file included from include/linux/mlx5/driver.h:45:0,
>                     from include/linux/mlx5/port.h:36,
>                     from drivers/infiniband/hw/mlx5/main.c:45:
>    include/linux/mlx5/device.h:50:57: error: 'struct mlx5_ifc_per_protocol_networking_offload_caps_bits' has no member named 'scatter_fcs'
>     #define __mlx5_bit_sz(typ, fld) sizeof(__mlx5_nullp(typ)->fld)
>                                                             ^
>    include/linux/mlx5/device.h:54:43: note: in expansion of macro '__mlx5_bit_sz'
>     #define __mlx5_dw_bit_off(typ, fld) (32 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0x1f))
>                                               ^
>    include/linux/mlx5/device.h:85:30: note: in expansion of macro '__mlx5_dw_bit_off'
>     __mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
>                                  ^
>    include/linux/mlx5/device.h:1253:2: note: in expansion of macro 'MLX5_GET'
>      MLX5_GET(per_protocol_networking_offload_caps,\
>      ^
> >> drivers/infiniband/hw/mlx5/main.c:521:6: note: in expansion of macro 'MLX5_CAP_ETH'
>          MLX5_CAP_ETH(dev->mdev, scatter_fcs))
>          ^
>    include/linux/mlx5/device.h:51:80: error: 'struct mlx5_ifc_per_protocol_networking_offload_caps_bits' has no member named 'scatter_fcs'
>     #define __mlx5_bit_off(typ, fld) ((unsigned)(unsigned long)(&(__mlx5_nullp(typ)->fld)))
>                                                                                    ^
>    include/linux/mlx5/device.h:54:70: note: in expansion of macro '__mlx5_bit_off'
>     #define __mlx5_dw_bit_off(typ, fld) (32 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0x1f))
>                                                                          ^
>    include/linux/mlx5/device.h:85:30: note: in expansion of macro '__mlx5_dw_bit_off'
>     __mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
>                                  ^
>    include/linux/mlx5/device.h:1253:2: note: in expansion of macro 'MLX5_GET'
>      MLX5_GET(per_protocol_networking_offload_caps,\
>      ^
> >> drivers/infiniband/hw/mlx5/main.c:521:6: note: in expansion of macro 'MLX5_CAP_ETH'
>          MLX5_CAP_ETH(dev->mdev, scatter_fcs))
>          ^
>    include/linux/mlx5/device.h:50:57: error: 'struct mlx5_ifc_per_protocol_networking_offload_caps_bits' has no member named 'scatter_fcs'
>     #define __mlx5_bit_sz(typ, fld) sizeof(__mlx5_nullp(typ)->fld)
>                                                             ^
>    include/linux/mlx5/device.h:55:47: note: in expansion of macro '__mlx5_bit_sz'
>     #define __mlx5_mask(typ, fld) ((u32)((1ull << __mlx5_bit_sz(typ, fld)) - 1))
>                                                   ^
>    include/linux/mlx5/device.h:86:1: note: in expansion of macro '__mlx5_mask'
>     __mlx5_mask(typ, fld))
>     ^
>    include/linux/mlx5/device.h:1253:2: note: in expansion of macro 'MLX5_GET'
>      MLX5_GET(per_protocol_networking_offload_caps,\
>      ^
> >> drivers/infiniband/hw/mlx5/main.c:521:6: note: in expansion of macro 'MLX5_CAP_ETH'
>          MLX5_CAP_ETH(dev->mdev, scatter_fcs))
>          ^
> 
> vim +/MLX5_CAP_ETH +521 drivers/infiniband/hw/mlx5/main.c
> 
>    505			props->sig_guard_cap = IB_GUARD_T10DIF_CRC |
>    506					       IB_GUARD_T10DIF_CSUM;
>    507		}
>    508		if (MLX5_CAP_GEN(mdev, block_lb_mc))
>    509			props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
>    510	
>    511		if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
>    512		    (MLX5_CAP_ETH(dev->mdev, csum_cap)))
>    513				props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
>    514	
>    515		if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
>    516			props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
>    517			props->device_cap_flags |= IB_DEVICE_UD_TSO;
>    518		}
>    519	
>    520		if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
>  > 521		    MLX5_CAP_ETH(dev->mdev, scatter_fcs))
>    522			props->device_cap_flags |= IB_DEVICE_RAW_SCATTER_FCS;
>    523	
>    524		props->vendor_part_id	   = mdev->pdev->device;
>    525		props->hw_ver		   = mdev->pdev->revision;
>    526	
>    527		props->max_mr_size	   = ~0ull;
>    528		props->page_size_cap	   = ~(min_page_size - 1);
>    529		props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
