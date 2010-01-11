From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] uDAPL v2 - dapl-2.0.26 release
Date: Mon, 11 Jan 2010 11:58:07 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983ADFC3AD6@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 

New release for uDAPL 2.0 available on the OFA download page and in my git tree.

Bug fixes for RDMAoE.

md5sum: 32924de6b4f1fa351aa1468b19501981 dapl-2.0.26.tar.gz 

Summary of changes since last release: 

Release 2.0.26 fixes (tested on OFED-RDMAoE-rc6, Mellanox MHJH29-XTC, v2.7.0): 

v2 - openib_common: add check for both gid and global routing in RTR 
v2 - openib_common: remote memory read priviledge set multiple times 
v2 - scm, ucm: DAPL_GLOBAL_ROUTING enable setting to use GID's, causes segv 

Vlad, please pull new package into latest OFED 1.5 RDMAoE build and install the following:
 
dapl-2.0.26-1 
dapl-utils-2.0.26-1 
dapl-devel-2.0.26-1 
dapl-debuginfo-2.0.26-1 
compat-dapl-1.2.15-1 
compat-dapl-devel-1.2.15-1 

See http://www.openfabrics.org/downloads/dapl/ more details.

Thanks,

-arlin



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
