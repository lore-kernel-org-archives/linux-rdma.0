From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] uDAPL v2.0 Windows patch to fix IB_INVLAID_HANDLE name collision.
Date: Fri, 19 Feb 2010 14:59:41 -0800
Message-ID: <E676323021AD42D6BAC461C33A88DE9F@amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C983B57CCDCB@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983B57CCDCB-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>diff U3 a/dapl/dapl/ibal/dapl_ibal_cm.c b/dapl/ibal/dapl_ibal_cm.c
>--- a/dapl/ibal/dapl_ibal_cm.c	Fri Feb 19 14:03:58 2010
>+++ b/dapl/ibal/dapl_ibal_cm.c	Fri Feb 19 14:15:22 2010
>@@ -37,6 +37,12 @@
> #define  DAPL_ATS_NAME              ATS_NAME
> #define  HCA_IPV6_ADDRESS_LENGTH    16
>
>+/* until dapl_ibal_util.h define of IB_INVALID_HANDLE which overlaps the
>+ * Windows ib_types.h typedef enu ib_api_status_t IB_INVALID_HANDLE is fixed.
>+ */
>+#undef IB_INVALID_HANDLE
>+#define DAPL_IB_INVALID_HANDLE NULL

How about just using NULL directly?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
