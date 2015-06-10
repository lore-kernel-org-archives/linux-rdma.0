From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 13:54:23 -0400
Message-ID: <20150610175423.GB13497@phlsvsds.ph.intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com> <1433615915-24591-15-git-send-email-ira.weiny@intel.com> <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 06:30:58AM +0000, Liran Liss wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Hi Ira,
> 
> OPA cannot impersonate IB; OPA node and link types have to be designated as such.

This was discussed at length and we agreed that the kernel would have explicit
capabilities communicated between the drivers and the core layers rather than
using link layer to determine what core support was needed.

For Node Type, OPA is its own "namespace" and as such we use the same values
for "CA" and "Switch".  The code you reference below is explicitly executed
only on OPA devices so I don't see why this is in conflict with IB.

> In terms of MAD processing flows, both explicit (as in the handle_opa_smi() call below) and implicit code paths (which share IB flows - there are several cases) must make this distinction.
> 

I agreed and all OPA differences are limited to device/ports which explicitly
indicate they are OPA ports.

For example:

        opa = rdma_cap_opa_mad(qp_info->port_priv->device,
                               qp_info->port_priv->port_num);

...

        if (opa && ((struct ib_mad_hdr *)(recv->mad))->base_version == OPA_MGMT_BASE_VERSION) {
                recv->header.recv_wc.mad_len = wc->byte_len - sizeof(struct ib_grh);
                recv->header.recv_wc.mad_seg_size = sizeof(struct opa_mad);
        } else {
                recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
                recv->header.recv_wc.mad_seg_size = sizeof(struct ib_mad);
        }


If I missed a place where this is not the case please let me know but I made
this change many months back and I'm pretty sure I caught them all.

Thanks,
Ira


> > +static enum smi_action
> > +handle_opa_smi(struct ib_mad_port_private *port_priv,
> > +	       struct ib_mad_qp_info *qp_info,
> > +	       struct ib_wc *wc,
> > +	       int port_num,
> > +	       struct ib_mad_private *recv,
> > +	       struct ib_mad_private *response)
> > +{
> ...
> > +	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH)  <----
> 
> --Liran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
