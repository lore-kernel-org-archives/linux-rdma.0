From: Gal Pressman <galpress@amazon.com>
Subject: Re: [RFC v1 10/19] RDMA/irdma: Add connection manager
Date: Sun, 24 Feb 2019 13:21:16 +0200
Message-ID: <0eafe40b-4c54-dc12-6a85-3a821d99d2cd@amazon.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-11-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-11-shiraz.saleem@intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On 15-Feb-19 19:10, Shiraz Saleem wrote:
> +/**
> + * irdma_cm_teardown_connections - teardown QPs
> + * @iwdev: device pointer
> + * @ipaddr: Pointer to IPv4 or IPv6 address
> + * @ipv4: flag indicating IPv4 when true

There is no ipv4 parameter.

> + * @disconnect_all: flag indicating disconnect all QPs
> + * teardown QPs where source or destination addr matches ip addr
> + */
> +void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
> +				   struct irdma_cm_info *nfo,
> +				   bool disconnect_all)
> +{
> +	struct irdma_cm_core *cm_core = &iwdev->cm_core;
> +	struct list_head *list_core_temp;
> +	struct list_head *list_node;
> +	struct irdma_cm_node *cm_node;
> +	struct list_head teardown_list;
> +	struct ib_qp_attr attr;
> +	struct irdma_sc_vsi *vsi = &iwdev->vsi;
> +	struct irdma_sc_qp *sc_qp;
> +	struct irdma_qp *qp;
> +	int i;
> +	unsigned long flags;
> +
> +	INIT_LIST_HEAD(&teardown_list);
> +
> +	spin_lock_irqsave(&cm_core->ht_lock, flags);
> +	list_for_each_safe(list_node, list_core_temp,
> +			   &cm_core->accelerated_list) {
> +		cm_node = container_of(list_node, struct irdma_cm_node, list);
> +		if (disconnect_all ||
> +		    (nfo->vlan_id == cm_node->vlan_id &&
> +		    !memcmp(cm_node->loc_addr, ipaddr, nfo->ipv4 ? 4 : 16))) {
> +			atomic_inc(&cm_node->ref_count);
> +			list_add(&cm_node->teardown_entry, &teardown_list);
> +		}
> +	}
> +	list_for_each_safe(list_node, list_core_temp,
> +			   &cm_core->non_accelerated_list) {
> +		cm_node = container_of(list_node, struct irdma_cm_node, list);
> +		if (disconnect_all ||
> +		    (nfo->vlan_id == cm_node->vlan_id &&
> +		    !memcmp(cm_node->loc_addr, ipaddr, nfo->ipv4 ? 4 : 16))) {
> +			atomic_inc(&cm_node->ref_count);
> +			list_add(&cm_node->teardown_entry, &teardown_list);
> +		}
> +	}
> +	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
> +
> +	list_for_each_safe(list_node, list_core_temp, &teardown_list) {
> +		cm_node = container_of(list_node, struct irdma_cm_node,
> +				       teardown_entry);
> +		attr.qp_state = IB_QPS_ERR;
> +		irdma_modify_qp(&cm_node->iwqp->ibqp, &attr, IB_QP_STATE, NULL);
> +		if (iwdev->reset)
> +			irdma_cm_disconn(cm_node->iwqp);
> +		irdma_rem_ref_cm_node(cm_node);
> +	}
> +	if (!iwdev->roce_mode)
> +		return;
> +
> +	INIT_LIST_HEAD(&teardown_list);
> +	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
> +		spin_lock_irqsave(&vsi->qos[i].lock, flags);
> +		list_for_each_safe(list_node, list_core_temp, &vsi->qos[i].qplist) {
> +			u32 qp_ip[4];
> +
> +			sc_qp = container_of(list_node, struct irdma_sc_qp, list);
> +			if (sc_qp->qp_type != IRDMA_QP_TYPE_ROCE_RC)
> +				continue;
> +
> +			qp = sc_qp->back_qp;
> +			if (!disconnect_all) {
> +				if (nfo->ipv4)
> +					qp_ip[0] = qp->udp_info.local_ipaddr3;
> +				else
> +					memcpy(qp_ip,
> +					       &qp->udp_info.local_ipaddr0,
> +					       sizeof(qp_ip));
> +			}
> +
> +			if (disconnect_all ||
> +			    (nfo->vlan_id == qp->udp_info.vlan_tag &&
> +			    !memcmp(qp_ip, ipaddr, nfo->ipv4 ? 4 : 16))) {
> +				spin_lock_irqsave(&iwdev->rf->qptable_lock, flags);

You should use different 'flags' here.

> +				if (iwdev->rf->qp_table[sc_qp->qp_uk.qp_id]) {
> +					irdma_add_ref(&qp->ibqp);
> +					list_add(&qp->teardown_entry, &teardown_list);
> +				}
> +				spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
> +			}
> +		}
> +		spin_unlock_irqrestore(&vsi->qos[i].lock, flags);
> +	}
> +
> +	list_for_each_safe(list_node, list_core_temp, &teardown_list) {
> +		qp = container_of(list_node, struct irdma_qp, teardown_entry);
> +		attr.qp_state = IB_QPS_ERR;
> +		irdma_modify_qp_roce(&qp->ibqp, &attr, IB_QP_STATE, NULL);
> +		irdma_rem_ref(&qp->ibqp);
> +	}
> +}
