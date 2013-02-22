From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 13:27:10 -0500
Message-ID: <5127B87E.5020907@dev.mellanox.co.il>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222091333.57b91bbb5957928eeb0e62a7-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/22/2013 12:13 PM, Ira Weiny wrote:
> 
> Some of this code was originally proposed by Sean in 2010 as part of user space
> madeye: http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg06185.html
> 
> Changes from V1:
> 	Move functions into library calls
> 	remove funky marco obfuscation
> 	remove public access to umad_[sm|sa|cm]_attr_str functions
> Changes from V2:
> 	Added mgmt_class to umad_method_str call (with man page update)
> 	remove "inline" from man page
> 	Use UMAD_STATUS_x values in umad_mad_status_str decode.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Just a couple of nits below

> ---
>  Makefile.am                     |   12 +-
>  include/infiniband/umad_sm.h    |   31 ++--
>  include/infiniband/umad_str.h   |   55 +++++++
>  include/infiniband/umad_types.h |    4 +-
>  man/umad_attribute_str.3        |    3 +
>  man/umad_class_str.3            |   38 +++++
>  man/umad_mad_status_str.3       |    3 +
>  man/umad_method_str.3           |    3 +
>  src/libibumad.map               |    4 +
>  src/umad_str.c                  |  335 +++++++++++++++++++++++++++++++++++++++
>  10 files changed, 469 insertions(+), 19 deletions(-)
>  create mode 100644 include/infiniband/umad_str.h
>  create mode 100644 man/umad_attribute_str.3
>  create mode 100644 man/umad_class_str.3
>  create mode 100644 man/umad_mad_status_str.3
>  create mode 100644 man/umad_method_str.3
>  create mode 100644 src/umad_str.c
> 
> diff --git a/Makefile.am b/Makefile.am
> index 14e2389..dc34c3d 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -15,7 +15,12 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
>  	   man/umad_get_pkey.3 \
>  	   man/umad_register.3 man/umad_register_oui.3 man/umad_unregister.3 \
>  	   man/umad_send.3 man/umad_recv.3 man/umad_poll.3 \
> -	   man/umad_get_issm_path.3
> +	   man/umad_get_issm_path.3 \
> +	   man/umad_attribute_str.3 \
> +	   man/umad_class_str.3 \
> +	   man/umad_mad_status_str.3 \
> +	   man/umad_method_str.3
> +
>  
>  lib_LTLIBRARIES = libibumad.la
>  
> @@ -27,7 +32,7 @@ else
>  libibumad_version_script =
>  endif
>  
> -libibumad_la_SOURCES = src/umad.c src/sysfs.c
> +libibumad_la_SOURCES = src/umad.c src/sysfs.c src/umad_str.c
>  libibumad_la_LDFLAGS = -version-info $(ibumad_api_version) \
>      -export-dynamic $(libibumad_version_script)
>  libibumad_la_DEPENDENCIES = $(srcdir)/src/libibumad.map
> @@ -38,7 +43,8 @@ libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h \
>  	$(srcdir)/include/infiniband/umad_types.h \
>  	$(srcdir)/include/infiniband/umad_sa.h \
>  	$(srcdir)/include/infiniband/umad_sm.h \
> -	$(srcdir)/include/infiniband/umad_cm.h
> +	$(srcdir)/include/infiniband/umad_cm.h \
> +	$(srcdir)/include/infiniband/umad_str.h
>  
>  EXTRA_DIST = $(srcdir)/include/infiniband/umad.h \
>  	libibumad.spec.in libibumad.spec \
> diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
> index 10348d4..f6ee171 100644
> --- a/include/infiniband/umad_sm.h
> +++ b/include/infiniband/umad_sm.h
> @@ -55,21 +55,22 @@ enum {
>  
>  /* Subnet management attributes */
>  enum {
> -	UMAD_SMP_ATTR_NODE_DESC		= 0x0010,
> -	UMAD_SMP_ATTR_NODE_INFO		= 0x0011,
> -	UMAD_SMP_ATTR_SWITCH_INFO	= 0x0012,
> -	UMAD_SMP_ATTR_GUID_INFO		= 0x0014,
> -	UMAD_SMP_ATTR_PORT_INFO		= 0x0015,
> -	UMAD_SMP_ATTR_PKEY_TABLE	= 0x0016,
> -	UMAD_SMP_ATTR_SLVL_TABLE	= 0x0017,
> -	UMAD_SMP_ATTR_VL_ARB_TABLE	= 0x0018,
> -	UMAD_SMP_ATTR_LINEAR_FT		= 0x0019,
> -	UMAD_SMP_ATTR_RANDOM_FT		= 0x001A,
> -	UMAD_SMP_ATTR_MCAST_FT		= 0x001B,
> -	UMAD_SMP_ATTR_SM_INFO		= 0x0020,
> -	UMAD_SMP_ATTR_VENDOR_DIAG	= 0x0030,
> -	UMAD_SMP_ATTR_LED_INFO		= 0x0031,
> -	UMAD_SMP_ATTR_VENDOR_MASK	= 0xFF00
> +	UMAD_SMP_ATTR_NODE_DESC			= 0x0010,
> +	UMAD_SMP_ATTR_NODE_INFO			= 0x0011,
> +	UMAD_SMP_ATTR_SWITCH_INFO		= 0x0012,
> +	UMAD_SMP_ATTR_GUID_INFO			= 0x0014,
> +	UMAD_SMP_ATTR_PORT_INFO			= 0x0015,
> +	UMAD_SMP_ATTR_PKEY_TABLE		= 0x0016,
> +	UMAD_SMP_ATTR_SLVL_TABLE		= 0x0017,
> +	UMAD_SMP_ATTR_VL_ARB_TABLE		= 0x0018,
> +	UMAD_SMP_ATTR_LINEAR_FT			= 0x0019,
> +	UMAD_SMP_ATTR_RANDOM_FT			= 0x001A,
> +	UMAD_SMP_ATTR_MCAST_FT			= 0x001B,
> +	UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE	= 0x001C,
> +	UMAD_SMP_ATTR_SM_INFO			= 0x0020,
> +	UMAD_SMP_ATTR_VENDOR_DIAG		= 0x0030,
> +	UMAD_SMP_ATTR_LED_INFO			= 0x0031,
> +	UMAD_SMP_ATTR_VENDOR_MASK		= 0xFF00
>  };
>  
>  enum {
> diff --git a/include/infiniband/umad_str.h b/include/infiniband/umad_str.h
> new file mode 100644
> index 0000000..8c00a83
> --- /dev/null
> +++ b/include/infiniband/umad_str.h
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright (c) 2004, 2005, 2010 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2013 Lawrence Livermore National Security. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +#ifndef _UMAD_STR_H
> +#define _UMAD_STR_H
> +
> +#include <infiniband/umad.h>
> +
> +#ifdef __cplusplus
> +#  define BEGIN_C_DECLS extern "C" {
> +#  define END_C_DECLS   }
> +#else				/* !__cplusplus */
> +#  define BEGIN_C_DECLS
> +#  define END_C_DECLS
> +#endif				/* __cplusplus */
> +
> +BEGIN_C_DECLS
> +
> +char * umad_class_str(uint8_t mgmt_class);
> +char * umad_method_str(uint8_t mgmt_class, uint8_t method);
> +char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id);
> +char * umad_mad_status_str(be16_t status, char * buf, size_t len);
> +
> +END_C_DECLS
> +#endif /* _UMAD_STR_H */
> diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
> index a722b8c..db13438 100644
> --- a/include/infiniband/umad_types.h
> +++ b/include/infiniband/umad_types.h
> @@ -64,10 +64,12 @@ enum {
>  	UMAD_CLASS_SNMP			= 0x08,
>  	UMAD_CLASS_VENDOR_RANGE1_START	= 0x09,
>  	UMAD_CLASS_VENDOR_RANGE1_END	= 0x0F,
> -	UMAD_CLASS_DEVICE_ADM		= 0x10,
> +	UMAD_CLASS_APPLICATION_START	= 0x10,
> +	UMAD_CLASS_DEVICE_ADM		= UMAD_CLASS_APPLICATION_START,
>  	UMAD_CLASS_BOOT_MGMT		= 0x11,
>  	UMAD_CLASS_BIS			= 0x12,
>  	UMAD_CLASS_CONG_MGMT		= 0x21,
> +	UMAD_CLASS_APPLICATION_END	= 0x2F,
>  	UMAD_CLASS_VENDOR_RANGE2_START	= 0x30,
>  	UMAD_CLASS_VENDOR_RANGE2_END	= 0x4F
>  };
> diff --git a/man/umad_attribute_str.3 b/man/umad_attribute_str.3
> new file mode 100644
> index 0000000..f5e6b02
> --- /dev/null
> +++ b/man/umad_attribute_str.3
> @@ -0,0 +1,3 @@
> +.\" -*- nroff -*-
> +.\"
> +.so man3/umad_class_str.3
> diff --git a/man/umad_class_str.3 b/man/umad_class_str.3
> new file mode 100644
> index 0000000..1d7552b
> --- /dev/null
> +++ b/man/umad_class_str.3
> @@ -0,0 +1,38 @@
> +.\" -*- nroff -*-
> +.\"
> +.TH UMAD_CLASS_STR 3  "Feb 15, 2013" "OpenIB" "OpenIB Programmer\'s Manual"
> +.SH "NAME"
> +umad_*_str \- class of functions to return string representations of enums
> +
> +.SH "SYNOPSIS"
> +.nf
> +.B #include <infiniband/umad_str.h>
> +.sp
> +.BI "char * umad_class_str(uint8_t mgmt_class)"
> +.BI "char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
> +.BI "char * umad_mad_status_str(be16_t status, char * buf, size_t len)"
> +.BI "char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
> +
> +.SH "DESCRIPTION"
> +
> +.B "char * umad_class_str(uint8_t mgmt_class)"
> +Return string value of management class enum
> +
> +.B "char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
> +Return string value of method enum

Should this now be:
Return string value of method for mgmt_class specified

> +
> +.B "char * umad_mad_status_str(be16_t status, char * buf, size_t len)"
> +Print MAD status into buf and return buf
> +
> +.B "char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
> +Return string value of attribute specified in attr_id based on mgmt_class specified.
> +
> +Currently SM, SA, and CM classes are supported.
> +
> +.SH "RETURN VALUE"
> +
> +Returns a string representations of the fields specified.
> +
> +.SH "AUTHOR"
> +.TP
> +Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> diff --git a/man/umad_mad_status_str.3 b/man/umad_mad_status_str.3
> new file mode 100644
> index 0000000..f5e6b02
> --- /dev/null
> +++ b/man/umad_mad_status_str.3
> @@ -0,0 +1,3 @@
> +.\" -*- nroff -*-
> +.\"
> +.so man3/umad_class_str.3
> diff --git a/man/umad_method_str.3 b/man/umad_method_str.3
> new file mode 100644
> index 0000000..f5e6b02
> --- /dev/null
> +++ b/man/umad_method_str.3
> @@ -0,0 +1,3 @@
> +.\" -*- nroff -*-
> +.\"
> +.so man3/umad_class_str.3
> diff --git a/src/libibumad.map b/src/libibumad.map
> index 0154b7f..af68d11 100644
> --- a/src/libibumad.map
> +++ b/src/libibumad.map
> @@ -30,5 +30,9 @@ IBUMAD_1.0 {
>  		umad_debug;
>  		umad_addr_dump;
>  		umad_dump;
> +		umad_class_str;
> +		umad_method_str;
> +		umad_mad_status_str;
> +		umad_attribute_str;
>  	local: *;
>  };
> diff --git a/src/umad_str.c b/src/umad_str.c
> new file mode 100644
> index 0000000..c77f00b
> --- /dev/null
> +++ b/src/umad_str.c
> @@ -0,0 +1,335 @@
> +/*
> + * Copyright (c) 2004, 2005, 2010 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2013 Lawrence Livermore National Security. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#include <stdio.h>
> +#include <arpa/inet.h>
> +#include <infiniband/umad.h>
> +#include <infiniband/umad_types.h>
> +#include <infiniband/umad_sm.h>
> +#include <infiniband/umad_sa.h>
> +#include <infiniband/umad_cm.h>
> +
> +char * umad_class_str(uint8_t mgmt_class)
> +{
> +	switch (mgmt_class) {
> +		case UMAD_CLASS_SUBN_LID_ROUTED:
> +		case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
> +			return("Subn");
> +		case UMAD_CLASS_SUBN_ADM:
> +			return("SubnAdm");
> +		case UMAD_CLASS_PERF_MGMT:
> +			return("Perf");
> +		case UMAD_CLASS_BM:
> +			return("BM");
> +		case UMAD_CLASS_DEVICE_MGMT:
> +			return("DevMgt");
> +		case UMAD_CLASS_CM:
> +			return("ComMgt");
> +		case UMAD_CLASS_SNMP:
> +			return("SNMP");
> +		case UMAD_CLASS_DEVICE_ADM:
> +			return("DevAdm");
> +		case UMAD_CLASS_BOOT_MGMT:
> +			return("BootMgt");
> +		case UMAD_CLASS_BIS:
> +			return("BIS");
> +		case UMAD_CLASS_CONG_MGMT:
> +			return("CongestionManagment");
> +		default:
> +			break;
> +	}
> +
> +	if ((UMAD_CLASS_VENDOR_RANGE1_START <= mgmt_class
> +		&& mgmt_class <= UMAD_CLASS_VENDOR_RANGE1_END)
> +	    || (UMAD_CLASS_VENDOR_RANGE2_START <= mgmt_class
> +		&& mgmt_class <= UMAD_CLASS_VENDOR_RANGE2_END))
> +		return("Vendor");
> +
> +	if (UMAD_CLASS_APPLICATION_START <= mgmt_class
> +	    && mgmt_class <= UMAD_CLASS_APPLICATION_END) {
> +		return("Application");
> +	}
> +	return ("<unknown>");
> +}
> +
> +static char * umad_common_method_str(uint8_t method)
> +{
> +	switch(method) {
> +		case UMAD_METHOD_GET:
> +			return ("Get");
> +		case UMAD_METHOD_SET:
> +			return ("Set");
> +		case UMAD_METHOD_GET_RESP:
> +			return ("GetResp");
> +		case UMAD_METHOD_SEND:
> +			return ("Send");
> +		case UMAD_METHOD_TRAP:
> +			return ("Trap");
> +		case UMAD_METHOD_REPORT:
> +			return ("Report");
> +		case UMAD_METHOD_REPORT_RESP:
> +			return ("ReportResp");
> +		case UMAD_METHOD_TRAP_REPRESS:
> +			return ("TrapRepress");
> +		case UMAD_METHOD_RESP:
> +			return ("Resp");

There's no RESP method, right ? So shouldn't UMAD_METHOD_RESP case be
removed ?

-- Hal

> +		default:
> +			return ("<unknown");
> +	}
> +}
> +

<snip...>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
