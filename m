From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 17/19] IB/mad: Implement support for Intel Omni-Path
 Architecture base version MADs in ib_create_send_mad
Date: Fri, 3 Apr 2015 23:40:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBD722@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-18-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-18-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -937,20 +937,31 @@ struct ib_mad_send_buf * ib_create_send_mad(struct
> ib_mad_agent *mad_agent,
>  	struct ib_mad_send_wr_private *mad_send_wr;
>  	int pad, message_size, ret, size;
>  	void *buf;
> +	size_t mad_size;
> +	int opa;
> 
>  	mad_agent_priv = container_of(mad_agent, struct
> ib_mad_agent_private,
>  				      agent);
> -	pad = get_pad_size(hdr_len, data_len);
> +
> +	opa = mad_agent_priv->agent.device-
> >cached_dev_attrs.device_cap_flags2 &
> +	      IB_DEVICE_OPA_MAD_SUPPORT;
> +
> +	if (opa && base_version == OPA_MGMT_BASE_VERSION)
> +		mad_size = sizeof(struct jumbo_mad);
> +	else
> +		mad_size = sizeof(struct ib_mad);

Didn't an earlier patch make is possible to read the mad_size directly from the device?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
