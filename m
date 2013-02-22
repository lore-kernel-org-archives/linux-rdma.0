From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 18:47:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F352A97@ORSMSX101.amr.corp.intel.com>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222091333.57b91bbb5957928eeb0e62a7-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +char * umad_class_str(uint8_t mgmt_class);
> +char * umad_method_str(uint8_t mgmt_class, uint8_t method);
> +char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id);
> +char * umad_mad_status_str(be16_t status, char * buf, size_t len);

Why is umad_mad_status_str() different?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
