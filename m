From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm 1.0.12
Date: Sun, 23 May 2010 18:23:25 +0300
Message-ID: <4BF9486D.5000402@dev.mellanox.co.il>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com> <A04A50C5C9294B538ECAB7C44CEBE56D@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A04A50C5C9294B538ECAB7C44CEBE56D-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> I've pushed out release 1.0.12 of librdmacm.
> 
> Uhm... the release is at:
> 
> http://www.openfabrics.org/downloads/rdmacm/librdmacm-1.0.12.tar.gz
> 
> - Sean
> 

Hi Sean,
After updating librdmacm. compat-dapl compilation fails:

  gcc -DHAVE_CONFIG_H -I. -I. -I. -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic -I/usr/local/include -g -Wall -D_GNU_SOURCE 
-DDAT_CONF=\"/etc/dat.conf\" -D_GNU_SOURCE -DOS_RELEASE=131078 -DREDHAT_EL5 -DOPENIB -DCQ_WAIT_OBJECT -I./dat/include/ -I./dapl/include/ -I./dapl/common -I./dapl/udapl/linux -I./dapl/openib_cma -O2 -g 
-pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic -I/usr/local/include -MT dapl_udapl_libdaplcma_la-dapl_evd_create.lo -MD -MP -MF 
.deps/dapl_udapl_libdaplcma_la-dapl_evd_create.Tpo -c dapl/udapl/dapl_evd_create.c  -fPIC -DPIC -o .libs/dapl_udapl_libdaplcma_la-dapl_evd_create.o
In file included from ./dapl/include/dapl.h:246In file included from ./dapl/include/dapl.h:246,
                  from dapl/udapl/dapl_init.c:39:
./dapl/openib_cma/dapl_ib_util.h:54:27: error: rdma/rdma_cma.h: No such file or directory
,
                  from dapl/udapl/dapl_cno_create.c:39:

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
