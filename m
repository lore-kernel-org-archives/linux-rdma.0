From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: some dapl assistance
Date: Wed, 7 Jul 2010 10:00:43 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com>
References: <4C344493.2030600@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C344493.2030600-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Itay Berman <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or, 

>What needs to be done such that the dapl debug prints be seen 
>either in the system log or the standard output/error of the mpi rank?

There is limited debug in the non-debug builds. If you 
want full debugging capabilities you can install the
source RPM and configure and make as follow (OFED target example):

./configure --enable-debug --prefix /usr --sysconf=/etc --libdir /usr/lib64 LDFLAGS=-L/usr/lib64 CPPFLAGS="-I/usr/include"
make install

debug logs can be set with environment DAPL_DBG_TYPE (default=1)

typedef enum
{
    DAPL_DBG_TYPE_ERR		= 0x0001,
    DAPL_DBG_TYPE_WARN	  	= 0x0002,
    DAPL_DBG_TYPE_EVD	  	= 0x0004,
    DAPL_DBG_TYPE_CM		= 0x0008,
    DAPL_DBG_TYPE_EP		= 0x0010,
    DAPL_DBG_TYPE_UTIL	  	= 0x0020,
    DAPL_DBG_TYPE_CALLBACK	= 0x0040,
    DAPL_DBG_TYPE_DTO_COMP_ERR = 0x0080,
    DAPL_DBG_TYPE_API	  	= 0x0100,
    DAPL_DBG_TYPE_RTN	  	= 0x0200,
    DAPL_DBG_TYPE_EXCEPTION	= 0x0400,
    DAPL_DBG_TYPE_SRQ		= 0x0800,
    DAPL_DBG_TYPE_CNTR  	= 0x1000,
    DAPL_DBG_TYPE_CM_LIST  	= 0x2000,
    DAPL_DBG_TYPE_THREAD  	= 0x4000

} DAPL_DBG_TYPE;

output location can be set with DAPL_DBG_DEST as follow (default=1):

typedef enum
{
    DAPL_DBG_DEST_STDOUT  	= 0x0001,
    DAPL_DBG_DEST_SYSLOG  	= 0x0002,
} DAPL_DBG_DEST;

log messagea are prefixed with hostname:process_id as follow
and by default will be sent to stdout of mpiexec node:

cstnh-9:4834:  query_hca: mlx4_0 192.168.0.109
cstnh-9:4834:  query_hca: port.link_layer = 0x1
cstnh-9:4834:  query_hca: (b0.0) eps 260032, sz 16351 evds 65408, sz 4194303 mtu 2048 - pkey 0 p_idx 0 sl 1

>
>You can see here that on this node (dodly0), the 
>"OpenIB-mthca0-1" is used, but later when I try it with 
>dapltest (next bullet), I can't get dat to open/work with it.
>
>2. dapltest
>
>> # DAT_DBG_TYPE=0x3 dapltest -T S -D OpenIB-mthca0-1

Intel MPI will pick up the appropriate v1.2 or v2.0 libdat
and libdapl provider libraries depending on your device
selection. However, when using dapltest you have to use 
the appropriate binary that links to the v1.2 library. 

If you are using v1.2 compat library providers (OpenIB-*)
you need to use the compat-dapl tests (dapltest1, dtest1, etc)
that come with the v1.2 package. 

[root@cstnh-10]# rpm -qpl compat-dapl-utils-1.2.16-1.x86_64.rpm
/usr/bin/dapltest1
/usr/bin/dtest1
/usr/share/man/man1/dapltest1.1.gz
/usr/share/man/man1/dtest1.1.gz
/usr/share/man/man5/dat.conf.5.gz

Try the following:

# dapltest1 -T S -D OpenIB-mthca0-1

Sorry for any confusion.

-arlin







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
