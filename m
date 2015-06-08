From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 10/14] IB/mad: Add support for additional MAD info
 to/from drivers
Date: Mon, 8 Jun 2015 18:50:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE5BD4@ORSMSX109.amr.corp.intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
 <1433615915-24591-11-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-11-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -1693,8 +1693,11 @@ struct ib_device {
>  						  u8 port_num,
>  						  const struct ib_wc *in_wc,
>  						  const struct ib_grh *in_grh,
> -						  const struct ib_mad *in_mad,
> -						  struct ib_mad *out_mad);
> +						  const struct ib_mad_hdr *in_mad,
> +						  size_t in_mad_size,
> +						  struct ib_mad_hdr *out_mad,
> +						  size_t *out_mad_size,
> +						  u16 *out_mad_pkey_index);

I don't have an alternate suggestion at the moment, but this call is getting to be a little much.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
