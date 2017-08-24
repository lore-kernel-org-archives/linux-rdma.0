From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 REPOST 00/10] Hardware tag matching
 support
Date: Thu, 24 Aug 2017 15:56:35 -0400
Message-ID: <1503604595.78641.39.camel@redhat.com>
References: <20170817125212.3173-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125212.3173-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:52 +0300, Leon Romanovsky wrote:
> This patch series adds to Mellanox ConnectX HCA driver support of
> tag matching. It introduces new hardware object eXtended shared
> Receive
> Queue (XRQ), which follows SRQ semantics with addition of extended
> receive buffers topologies and offloads.
> 
> This series adds tag matching topology and rendezvouz offload.
> 
> Changelog:
> v0->v1:
>  * Rebased version, no change
> RFC->v0:
>  * Followed after RFC posted on the ML and OFVWG discussions
>  * Implements agreed verbs interface
>  * Rebased on top of latest version
>  * Adding feature description under Documentaion/infiniband
>  * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
>  * Added max size of the information passed after the RNDV header
>  * Added hca_sq_owner HW flag for RNDV QPs
> 
> Thanks

I know in the previous thread on this submission that you thought it
didn't need the shared pull request, but I'm seeing this when I try to
build after pulling this patch series in:
In file included from ./include/linux/mlx5/driver.h:49:0,
                 from ./include/linux/mlx5/fs.h:36,
                 from drivers/infiniband/hw/mlx5/qp.c:37:
drivers/infiniband/hw/mlx5/qp.c: In function ‘create_qp_common’:
drivers/infiniband/hw/mlx5/qp.c:1734:6: error:
‘MLX5_QPC_OFFLOAD_TYPE_RNDV’ undeclared (first use in this function);
did you mean ‘MLX5_XRQC_OFFLOAD_RNDV’?
      MLX5_QPC_OFFLOAD_TYPE_RNDV);
      ^
./include/linux/mlx5/device.h:70:11: note: in definition of macro
‘MLX5_SET’
  u32 _v = v; \
           ^
drivers/infiniband/hw/mlx5/qp.c:1734:6: note: each undeclared
identifier is reported only once for each function it appears in
      MLX5_QPC_OFFLOAD_TYPE_RNDV);
      ^
./include/linux/mlx5/device.h:70:11: note: in definition of macro
‘MLX5_SET’
  u32 _v = v; \
           ^
./include/linux/mlx5/device.h:51:80: error: ‘struct mlx5_ifc_qpc_bits’
has no member named ‘offload_type’
 #define __mlx5_bit_off(typ, fld) ((unsigned)(unsigned
long)(&(__mlx5_nullp(typ)->fld)))
                                                                       
         ^
./include/linux/mlx5/device.h:52:34: note: in expansion of macro
‘__mlx5_bit_off’
 #define __mlx5_dw_off(typ, fld) (__mlx5_bit_off(typ, fld) / 32)
                                  ^~~~~~~~~~~~~~
./include/linux/mlx5/device.h:72:20: note: in expansion of macro
‘__mlx5_dw_off’
  *((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
                    ^~~~~~~~~~~~~
drivers/infiniband/hw/mlx5/qp.c:1733:4: note: in expansion of macro
‘MLX5_SET’
    MLX5_SET(qpc, qpc, offload_type,
    ^~~~~~~~
In file included from ./include/linux/swab.h:4:0,
                 from
./include/uapi/linux/byteorder/little_endian.h:12,
                 from ./include/linux/byteorder/little_endian.h:4,
                 from ./arch/x86/include/uapi/asm/byteorder.h:4,
                 from ./include/asm-generic/bitops/le.h:5,
                 from ./arch/x86/include/asm/bitops.h:517,
                 from ./include/linux/bitops.h:36,
                 from ./include/linux/kernel.h:10,
                 from ./include/linux/list.h:8,
                 from ./include/linux/module.h:9,
                 from drivers/infiniband/hw/mlx5/qp.c:33:
./include/linux/mlx5/device.h:51:80: error: ‘struct mlx5_ifc_qpc_bits’
has no member named ‘offload_type’
 #define __mlx5_bit_off(typ, fld) ((unsigned)(unsigned
long)(&(__mlx5_nullp(typ)->fld)))

plus a lot more garbage after that.  I'm thinking it does require the
definition updates in the shared pull request.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
