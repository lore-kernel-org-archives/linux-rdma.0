From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Tue, 7 Sep 2010 18:18:35 +0300
Message-ID: <20100907151834.GA12837@mtldesk30>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
 <20100827054256.GA9755@mtldesk30>
 <adavd6w37lp.fsf@cisco.com>
 <20100829143914.GA14370@mtldesk30>
 <adaeidcnin1.fsf@cisco.com>
 <20100902192745.GA22039@mtldesk30>
 <aday6bjnbyu.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aday6bjnbyu.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 02, 2010 at 01:10:17PM -0700, Roland Dreier wrote:
> Please just resend this, thanks.

Here's the new code. I added a function that tries to find a match for
a given port, istead of ib_find_cached_gid() which searches all the
ports.
I tested this on a machine with two cards with different
configurations and it works fine.

static int find_gid_port(struct ib_device *device, union ib_gid	*gid, u8 port_num)
{
	int i;
	int err;
	struct ib_port_attr props;
	union ib_gid tmp;

	err = ib_query_port(device, port_num, &props);
	if (err)
		return 1;

	for (i = 0; i < props.gid_tbl_len; ++i) {
		err = ib_query_gid(device, port_num, i, &tmp);
		if (err)
			return 1;
		if (!memcmp(&tmp, gid, sizeof tmp))
			return 0;
	}

	return -EAGAIN;
}

static int cma_acquire_dev(struct rdma_id_private *id_priv)
{
	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
	struct cma_device *cma_dev;
	union ib_gid gid, iboe_gid;
	int ret = -ENODEV;
	u8 port;
	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;

	iboe_addr_get_sgid(dev_addr, &iboe_gid);
	memcpy(&gid, dev_addr->src_dev_addr +
	       rdma_addr_gid_offset(dev_addr), sizeof gid);
	list_for_each_entry(cma_dev, &dev_list, list) {
		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port) {
			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
					ret = find_gid_port(cma_dev->device, &iboe_gid, port);
				else
					ret = find_gid_port(cma_dev->device, &gid, port);

				if (!ret) {
					id_priv->id.port_num = port;
					goto out;
				} else if (ret == 1)
					break;
			}
		}
	}

out:
	if (!ret)
		cma_attach_to_dev(id_priv, cma_dev);

	return ret;
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
