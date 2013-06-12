From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] libibnetdisc/Makefile.am: Add missing
 makefile dependency
Date: Wed, 12 Jun 2013 18:25:43 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0207CCEF@CRSMSX101.amr.corp.intel.com>
References: <51B855AF.1070607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B855AF.1070607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

What is the error which this fixed?

I would think that the test_testleaks_LDFLAGS would take care of this?

Ira

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Wednesday, June 12, 2013 4:04 AM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Doron Tsur
> Subject: [PATCH infiniband-diags] libibnetdisc/Makefile.am: Add missing
> makefile dependency
> 
> 
> Found-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am index
> d05604f..2cfcc33 100644
> --- a/libibnetdisc/Makefile.am
> +++ b/libibnetdisc/Makefile.am
> @@ -35,6 +35,7 @@ libibnetdiscincludedir = $(includedir)/infiniband
> test_testleaks_SOURCES = test/testleaks.c  test_testleaks_CFLAGS = -Wall
> $(DBGFLAGS)  test_testleaks_LDFLAGS = -libnetdisc
> +test_testleaks_DEPENDENCIES = libibnetdisc.la
> 
>  libibnetdiscinclude_HEADERS = $(srcdir)/include/infiniband/ibnetdisc.h \
>  				$(srcdir)/include/infiniband/ibnetdisc_osd.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
