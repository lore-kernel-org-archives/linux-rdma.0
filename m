From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma_cm.h: Fix SCTP protocol ID
Date: Wed, 13 Jan 2010 13:38:18 -0800
Message-ID: <CD178F65B7CB4A7DB06398EEE0C05316@amr.corp.intel.com>
References: <20100113192454.GA17655@comcast.net>	<adaska9n2d3.fsf@roland-alpha.cisco.com>	<7E10F17E68C24836BE68F8F22B64862B@amr.corp.intel.com> <adak4vln1ks.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4vln1ks.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Wouldn't trying to use RDMA_PS_SCTP hit the
>
>	default:
>		return -EPROTONOSUPPORT;
>
>case in cma_get_port()?  So one couldn't actually do anything with
>RDMA_PS_SCTP?  Or is there some way to avoid binding?

You're right.  There isn't any way to actually do anything with it.  All code
paths go through rdma_bind_addr.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
