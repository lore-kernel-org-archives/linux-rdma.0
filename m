From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 06:30:58 +0000
Message-ID: <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-15-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Ira,

OPA cannot impersonate IB; OPA node and link types have to be designated as such.
In terms of MAD processing flows, both explicit (as in the handle_opa_smi() call below) and implicit code paths (which share IB flows - there are several cases) must make this distinction.

> +static enum smi_action
> +handle_opa_smi(struct ib_mad_port_private *port_priv,
> +	       struct ib_mad_qp_info *qp_info,
> +	       struct ib_wc *wc,
> +	       int port_num,
> +	       struct ib_mad_private *recv,
> +	       struct ib_mad_private *response)
> +{
...
> +	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH)  <----

--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
