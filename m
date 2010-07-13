From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: some dapl assistance
Date: Tue, 13 Jul 2010 14:41:00 +0300
Message-ID: <4C3C50CC.7000508@Voltaire.com>
References: <4C344493.2030600@Voltaire.com> <E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983010435A1A8-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Itay Berman <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Davis, Arlin R wrote:
> There is limited debug in the non-debug builds. If you want full debugging capabilities
> you can install the source RPM and configure and make as follows [..] (OFED target example):

okay, got that, once I built the sources by hand as you suggested I could see debug prints
but things didn't really work, so I stepped back and installed the latest rpms - dapl-2.0.29-1
and compat-dapl-1.2.18-1, now I couldn't get intel-mpi to run:

> [root@dodly0 ~]# rpm -qav | grep dapl
> dapl-utils-2.0.29-1
> dapl-2.0.29-1
> compat-dapl-1.2.18-1

> [root@dodly0 ~]# ldconfig -p | grep libdat
>         libdat2.so.2 (libc6,x86-64) => /usr/lib64/libdat2.so.2
>         libdat.so.1 (libc6,x86-64) => /usr/lib64/libdat.so.1

> [root@dodly0 ~]# rpm -qf /usr/lib64/libdat.so.1
> compat-dapl-1.2.18-1
> [root@dodly0 ~]# rpm -qf /usr/lib64/libdat2.so.2
> dapl-2.0.29-1

> [root@dodly0 ~]# /opt/intel/impi/4.0.0.027/intel64/bin/mpiexec -ppn 1 -n 2  -env DAPL_IB_PKEY 0x8002 -env DAPL_DBG_TYPE 0xff -env DAPL_DBG_DEST 0x3  -env I_MPI_DEBUG 3 -env I_MPI_CHECK_DAPL_PROVIDER_MISMATCH none -env I_MPI_FABRICS dapl:dapl /tmp/osu
> [0] MPI startup(): cannot open dynamic library libdat.so
> [1] MPI startup(): cannot open dynamic library libdat.so
> [0] MPI startup(): cannot open dynamic library libdat2.so
> [0] dapl fabric is not available and fallback fabric is not enabled
> [1] MPI startup(): cannot open dynamic library libdat2.so
> [1] dapl fabric is not available and fallback fabric is not enabled
> rank 1 in job 5  dodly0_54941   caused collective abort of all ranks
>   exit status of rank 1: return code 254
> rank 0 in job 5  dodly0_54941   caused collective abort of all ranks
>   exit status of rank 0: return code 254

Any idea what we're doing wrong?

BTW - before things stopped to work, exporting LD_DEBUG=libs to the MPI rank, 
I noticed that it used the compat-1.2 rpm ...

Now, I can run dapltest fine,
> [root@dodly0 ~]# dapltest -T S -D ofa-v2-mthca0-1
> Dapltest: Service Point Ready - ofa-v2-mthca0-1
> Dapltest: Service Point Ready - ofa-v2-mthca0-1
> Server: Transaction Test Finished for this client

> [root@dodly4 ~]# dapltest -T T -D ofa-v2-mlx4_0-1 -s dodly0 -i 1000 server SR 65536 4 client SR 65536 4
> Server Name: dodly0
> Server Net Address: 172.30.3.230
> DT_cs_Client: Starting Test ...
> ----- Stats ---- : 1 threads, 1 EPs
> Total WQE        :    2919.70 WQE/Sec
> Total Time       :       0.68 sec
> Total Send       :     262.14 MB -     382.69 MB/Sec
> Total Recv       :     262.14 MB -     382.69 MB/Sec
> Total RDMA Read  :       0.00 MB -       0.00 MB/Sec
> Total RDMA Write :       0.00 MB -       0.00 MB/Sec
> DT_cs_Client: ========== End of Work -- Client Exiting

I also noted that the dapl-utils and the compat-dapl-utils are mutual exclusive as both 
attempt to install the same man page for dat.conf
> # rpm -Uvh /usr/src/redhat/RPMS/x86_64/compat-dapl-utils-1.2.18-1.x86_64.rpm
> Preparing...                ########################################### [100%]
>         file /usr/share/man/man5/dat.conf.5.gz from install of compat-dapl-utils-1.2.18-1.x86_64 conflicts with file from package dapl-utils-2.0.29-1.x86_64

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
