From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v1 0/5] adding support for FDR/FDR-10 link speed
Date: Mon, 3 Oct 2011 18:54:28 +0300
Message-ID: <201110031754.28833.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  The purpose of the RFC is to introduce FDR/FDR-10:
   =A0- FDR10 is a proprietary link speed which is 10.3125 Gbps at 64/6=
6 encoding rather than 8b10b encoding. - FDR represents the IBA extende=
d speed: 14.0625 Gbps
   =A0- EDR represents the IBA extended speed: 25.78125 Gbps (EDR)

   The aim is to show correct speeds and link encoding in:
   =A0 - Ibstat
   =A0 - Ibv_devinfo
   =A0 - /sys/class/infiniband/mlx4_0/ports/1/rate
   =A0 - Other user space modules

   Port Info's active speed field has values for the enhanced speeds:
   8 =A0 - FDR10
   16 - FDR
   32 - EDR

   [PATCH 1/5] ib/core: Add enhanced link speeds
   Extended speeds are introduced and a new formula is used for speed c=
omputation (because of different encoding)

   [PATCH 2/5] ib/ipoib: Modified rate computation
   Modified the way the speed rate is computed because of the new IBA e=
xtended speeds that are no longer multiple of 2.5 Gbps.

   [PATCH 3/5] ib/mlx4: Add extended port capabilities support
   An Extended Port Info packet is used to query the extended port capa=
bilities

   [PATCH 4/5] ib/mlx4: Configure IBA extended active speeds
   Set the IBA extended active speeds based on hardware configuration

   [PATCH 5/5] libibverbs: Add support for extended speeds
   Add support for the new speeds in ibv_devinfo

 --
 Changes from v0
 Summary - instead of adding two new fields (ext_active_speed and link_=
encoding), the new speed values are added to existing active_speed fiel=
d.

  -Patch 1/4 was splitted into ib/core and ib/ipoib parts
  -Patch 5 was added to handle new speeds for libibverbs

 [Patch RFC 1/4]
  - ext _active_speed field is no longer required; the IBA extended spe=
eds are added to active_speed field (values 16 and 32)=20
 [Patch RFC 2/4]
  - link_encoding field is no longer required: FDR-10 link speed is add=
ed to active_speed field (value 8) [Patch RFC 3/4 and 4/4]
  - Reorganized
     - 3/4 only adds extended port capabilities support
     - 4/4 configures the actual speed based on hw configuration

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
