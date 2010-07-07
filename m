From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: some dapl assistance
Date: Wed, 07 Jul 2010 12:10:43 +0300
Message-ID: <4C344493.2030600@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Itay Berman <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Itay Berman wrote:
> Intel MPI forum admin says that we used the proper way to invoke the dapl debug.
> He suggested that there might be something wrong with the dapl built (though I tried
> running dapltest on other servers with other dapl version and got the same error).

hi Arlin,

While assisting a colleague who is working with Intel MPI / uDAPL, using dapl-2.0.29-1 
and Intel mpi 4.0.0p-027, I couldn't get either of 

1. seeing dapl debug prints when running under Intel MPI
2. any basic dapltest 

to work ... could you help here? see more details below,

Or.

1. dapl prints under mpi

> # /opt/intel/impi/4.0.0.027/intel64/bin/mpiexec -ppn 1 -n 2 -env DAPL_DBG_TYPE 0xff -env DAPL_DBG_DEST 0x3  -env I_MPI_DEBUG 3 -env I_MPI_CHECK_DAPL_PROVIDER_MISMATCH none -env I_MPI_FABRICS dapl:dapl /tmp/osu
> dodly4:10887: dapl_init: dbg_type=0xff,dbg_dest=0x3
> dodly4:10887:  open_hca: device mthca0 not found
> dodly4:10887:  open_hca: device mthca0 not found
> dodly0:11583: dapl_init: dbg_type=0xff,dbg_dest=0x3
> [1] MPI startup(): DAPL provider OpenIB-mlx4_0-1
> [1] MPI startup(): dapl data transfer mode
> [0] MPI startup(): DAPL provider OpenIB-mthca0-1
> [0] MPI startup(): dapl data transfer mode
> [0] MPI startup(): static connections storm algo
> [0] Rank    Pid      Node name
> [0] 0       11583    dodly0
> [0] 1       10887    dodly4
> # OSU MPI Bandwidth Test v3.1.1
> # Size        Bandwidth (MB/s)
> 1                         0.42
> 2                         0.85

What needs to be done such that the dapl debug prints be seen either in the system log or the standard output/error of the mpi rank?


You can see here that on this node (dodly0), the "OpenIB-mthca0-1" is used, but later when I try it with dapltest (next bullet), I can't get dat to open/work with it.

2. dapltest

> # DAT_DBG_TYPE=0x3 dapltest -T S -D OpenIB-mthca0-1
> DAT Registry: Started (dat_init)
> DAT Registry: using config file /etc/dat.conf
> DT_cs_Server: Could not open OpenIB-mthca0-1 (DAT_PROVIDER_NOT_FOUND DAT_NAME_NOT_REGISTERED)
> DT_cs_Server (OpenIB-mthca0-1):  Exiting.
> DAT Registry: Stopped (dat_fini)
> # DAT_DBG_TYPE=0x3 dapltest -T S -D OpenIB-mthca0-1u
> DAT Registry: Started (dat_init)
> DAT Registry: using config file /etc/dat.conf
> DT_cs_Server: Could not open OpenIB-mthca0-1u (DAT_PROVIDER_NOT_FOUND DAT_NAME_NOT_REGISTERED)
> DT_cs_Server (OpenIB-mthca0-1u):  Exiting.
> DAT Registry: Stopped (dat_fini)
> # ibv_devinfo
> hca_id: mthca0
>         transport:                      InfiniBand (0)
>         fw_ver:                         5.0.1
>         node_guid:                      0002:c902:0020:13d0
>         sys_image_guid:                 0002:c902:0020:13d3
>         vendor_id:                      0x02c9
>         vendor_part_id:                 25218
>         hw_ver:                         0xA0
>         board_id:                       MT_0150000001
>         phys_port_cnt:                  2
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                2048 (4)
[...]

> # rpm -qav | grep -E "intel-mpi|dapl"
> intel-mpi-rt-em64t-4.0.0p-027
> dapl-utils-2.0.29-1
> intel-mpi-em64t-4.0.0p-027
> dapl-devel-2.0.29-1
> compat-dapl-devel-1.2.15-1
> compat-dapl-1.2.15-1
> dapl-debuginfo-2.0.29-1
> dapl-2.0.29-1


I don't think the problem is with the compat-dapl package, as it doesn't have any dat.conf file
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
