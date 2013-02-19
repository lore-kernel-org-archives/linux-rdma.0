From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various defines
Date: Tue, 19 Feb 2013 15:05:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F342E49@ORSMSX101.amr.corp.intel.com>
References: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130218153638.2b452d138f0918b945bcdb71-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +#define UMAD_GENERIC_ATTRIBUTE_STR \
> +		case UMAD_ATTR_CLASS_PORT_INFO: \
> +			return "Class Port Info"; \
> +		case UMAD_ATTR_NOTICE: \
> +			return "Notice"; \
> +		case UMAD_ATTR_INFORM_INFO: \
> +			return "Inform Info"

this is .. odd   :P

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
