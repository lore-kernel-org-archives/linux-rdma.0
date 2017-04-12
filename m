From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
 rdma_ah_attr types
Date: Tue, 11 Apr 2017 18:36:12 -0700
Message-ID: <9873c7bd-5fe7-7b9a-c28f-e11ffa5d53e9@intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1491932545-60894-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB3008F933EA086C3A47C025B3D1000@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008F933EA086C3A47C025B3D1000-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/11/2017 4:09 PM, Parav Pandit wrote:
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dasaratharaman Chandramouli
>> Sent: Tuesday, April 11, 2017 12:42 PM
>> To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Hefty, Sean
>> <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Subject: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth' rdma_ah_attr
>> types
>>
>> rdma_ah_attr can now be either ib or eth allowing core components to use
>> one type or the other and also to define attributes unique to a specific type.
>> struct ib_ah also initialized with the type when its first created. This ensures
>> that calls such as modify_ah dont modify the type of the address handle
>> attribute.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dasaratharaman Chandramouli
>> <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cm.c                    |  4 +-
>>  drivers/infiniband/core/multicast.c             |  1 +
>>  drivers/infiniband/core/sa_query.c              |  5 +-
>>  drivers/infiniband/core/user_mad.c              |  2 +
>>  drivers/infiniband/core/uverbs_cmd.c            |  5 ++
>>  drivers/infiniband/core/verbs.c                 | 14 +++-
>>  drivers/infiniband/hw/bnxt_re/ib_verbs.c        | 13 ++--
>>  drivers/infiniband/hw/hfi1/verbs.c              |  4 +
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c      |  2 +-
>>  drivers/infiniband/hw/mlx4/ah.c                 | 25 +++----
>>  drivers/infiniband/hw/mlx4/mad.c                |  2 +
>>  drivers/infiniband/hw/mlx4/qp.c                 | 16 ++--
>>  drivers/infiniband/hw/mlx5/ah.c                 | 22 +++---
>>  drivers/infiniband/hw/mlx5/qp.c                 |  9 ++-
>>  drivers/infiniband/hw/mthca/mthca_av.c          |  1 +
>>  drivers/infiniband/hw/mthca/mthca_mad.c         |  1 +
>>  drivers/infiniband/hw/mthca/mthca_qp.c          |  1 +
>>  drivers/infiniband/hw/ocrdma/ocrdma.h           |  2 +-
>>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  6 +-
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |  1 +
>>  drivers/infiniband/hw/qedr/qedr_cm.c            |  2 +-
>>  drivers/infiniband/hw/qedr/verbs.c              |  1 +
>>  drivers/infiniband/hw/qib/qib_verbs.c           |  2 +
>>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c  |  5 +-
>> drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  9 +--
>>  drivers/infiniband/sw/rxe/rxe_av.c              |  1 +
>>  drivers/infiniband/sw/rxe/rxe_verbs.c           |  1 +
>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c  |  1 +
>>  include/rdma/ib_verbs.h                         | 99 +++++++++++++++++++++----
>>  net/smc/smc_ib.c                                |  3 +-
>>  30 files changed, 178 insertions(+), 82 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index 2cfc365..13c9f64 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -1761,7 +1761,9 @@ static int cm_req_handler(struct cm_work *work)
>>  	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
>>  	cm_format_paths_from_req(req_msg, &work->path[0], &work-
>>> path[1]);
>>
>> -	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac,
>> ETH_ALEN);
>> +	if (cm_id_priv->av.ah_attr.type == RDMA_AH_ATTR_TYPE_ETH)
>> +		memcpy(work->path[0].dmac, cm_id_priv-
>>> av.ah_attr.eth.dmac,
>> +		       ETH_ALEN);
>>  	grh = rdma_ah_read_grh(&cm_id_priv->av.ah_attr);
>>  	work->path[0].hop_limit = grh->hop_limit;
>>  	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
>> diff --git a/drivers/infiniband/core/multicast.c
>> b/drivers/infiniband/core/multicast.c
>> index 16eec04..45f2f09 100644
>> --- a/drivers/infiniband/core/multicast.c
>> +++ b/drivers/infiniband/core/multicast.c
>> @@ -743,6 +743,7 @@ int ib_init_ah_from_mcmember(struct ib_device
>> *device, u8 port_num,
>>  		return ret;
>>
>>  	memset(ah_attr, 0, sizeof *ah_attr);
>> +	ah_attr->type = rdma_ah_find_type(device, port_num);
>>
>>  	rdma_ah_set_dlid(ah_attr, be16_to_cpu(rec->mlid));
>>  	rdma_ah_set_sl(ah_attr, rec->sl);
>> diff --git a/drivers/infiniband/core/sa_query.c
>> b/drivers/infiniband/core/sa_query.c
>> index 6a71b21..7fe0fe5 100644
>> --- a/drivers/infiniband/core/sa_query.c
>> +++ b/drivers/infiniband/core/sa_query.c
>> @@ -1108,6 +1108,7 @@ int ib_init_ah_from_path(struct ib_device *device,
>> u8 port_num,
>>  	struct net_device *ndev = NULL;
>>
>>  	memset(ah_attr, 0, sizeof *ah_attr);
>> +	ah_attr->type = rdma_ah_find_type(device, port_num);
>>
>>  	rdma_ah_set_dlid(ah_attr, be16_to_cpu(rec->dlid));
>>  	rdma_ah_set_sl(ah_attr, rec->sl);
>> @@ -1192,7 +1193,7 @@ int ib_init_ah_from_path(struct ib_device *device,
>> u8 port_num,
>>  	}
>>
>>  	if (use_roce)
>> -		memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
>> +		memcpy(ah_attr->eth.dmac, rec->dmac, ETH_ALEN);
>>
>>  	return 0;
>>  }
>> @@ -2029,6 +2030,8 @@ static void update_sm_ah(struct work_struct
>> *work)
>>  		pr_err("Couldn't find index for default PKey\n");
>>
>>  	memset(&ah_attr, 0, sizeof(ah_attr));
>> +	ah_attr.type = rdma_ah_find_type(port->agent->device,
>> +					 port->port_num);
>>  	rdma_ah_set_dlid(&ah_attr, port_attr.sm_lid);
>>  	rdma_ah_set_sl(&ah_attr, port_attr.sm_sl);
>>  	rdma_ah_set_port_num(&ah_attr, port->port_num); diff --git
>> a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
>> index c4c5f4b..200422d 100644
>> --- a/drivers/infiniband/core/user_mad.c
>> +++ b/drivers/infiniband/core/user_mad.c
>> @@ -491,6 +491,8 @@ static ssize_t ib_umad_write(struct file *filp, const
>> char __user *buf,
>>  	}
>>
>>  	memset(&ah_attr, 0, sizeof ah_attr);
>> +	ah_attr.type = rdma_ah_find_type(file->port->ib_dev,
>> +					 file->port->port_num);
>>  	rdma_ah_set_dlid(&ah_attr, be16_to_cpu(packet->mad.hdr.lid));
>>  	rdma_ah_set_sl(&ah_attr, packet->mad.hdr.sl);
>>  	rdma_ah_set_path_bits(&ah_attr, packet->mad.hdr.path_bits); diff
>> --git a/drivers/infiniband/core/uverbs_cmd.c
>> b/drivers/infiniband/core/uverbs_cmd.c
>> index a5eb428..1663676 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -1954,6 +1954,8 @@ static int modify_qp(struct ib_uverbs_file *file,
>>  	attr->alt_timeout	  = cmd->base.alt_timeout;
>>  	attr->rate_limit	  = cmd->rate_limit;
>>
>> +	attr->ah_attr.type = rdma_ah_find_type(qp->device,
>> +					       cmd->base.dest.port_num);
>>  	if (cmd->base.dest.is_global) {
>>  		rdma_ah_set_grh(&attr->ah_attr, NULL,
>>  				cmd->base.dest.flow_label,
>> @@ -1971,6 +1973,8 @@ static int modify_qp(struct ib_uverbs_file *file,
>>  	rdma_ah_set_port_num(&attr->ah_attr,
>>  			     cmd->base.dest.port_num);
>>
>> +	attr->alt_ah_attr.type = rdma_ah_find_type(qp->device,
>> +						   cmd-
>>> base.dest.port_num);
>>  	if (cmd->base.alt_dest.is_global) {
>>  		rdma_ah_set_grh(&attr->alt_ah_attr, NULL,
>>  				cmd->base.alt_dest.flow_label,
>> @@ -2540,6 +2544,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file
>> *file,
>>  		goto err;
>>  	}
>>
>> +	attr.type = rdma_ah_find_type(ib_dev, cmd.attr.port_num);
>>  	rdma_ah_set_dlid(&attr, cmd.attr.dlid);
>>  	rdma_ah_set_sl(&attr, cmd.attr.sl);
>>  	rdma_ah_set_path_bits(&attr, cmd.attr.src_path_bits); diff --git
>> a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c index
>> 0225aaa..5529a3d 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -321,6 +321,7 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr)
>>  		ah->device  = pd->device;
>>  		ah->pd      = pd;
>>  		ah->uobject = NULL;
>> +		ah->type    = ah_attr->type;
>>  		atomic_inc(&pd->usecnt);
>>  	}
>>
>> @@ -464,6 +465,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8
>> port_num,
>>  	union ib_gid sgid;
>>
>>  	memset(ah_attr, 0, sizeof *ah_attr);
>> +	ah_attr->type = rdma_ah_find_type(device, port_num);
>>  	if (rdma_cap_eth_ah(device, port_num)) {
>>  		if (wc->wc_flags & IB_WC_WITH_NETWORK_HDR_TYPE)
>>  			net_type = wc->network_hdr_type;
>> @@ -493,8 +495,9 @@ int ib_init_ah_from_wc(struct ib_device *device, u8
>> port_num,
>>  		if (!idev)
>>  			return -ENODEV;
>>
>> +		ah_attr->type = RDMA_AH_ATTR_TYPE_ETH;
>>  		ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
>> -						   ah_attr->dmac,
>> +						   ah_attr->eth.dmac,
>>  						   wc->wc_flags &
>> IB_WC_WITH_VLAN ?
>>  						   NULL : &vlan_id,
>>  						   &if_index, &hoplimit);
>> @@ -571,6 +574,9 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd
>> *pd, const struct ib_wc *wc,
>>
>>  int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)  {
>> +	if (ah->type != ah_attr->type)
>> +		return -EINVAL;
>> +
>>  	return ah->device->modify_ah ?
>>  		ah->device->modify_ah(ah, ah_attr) :
>>  		-ENOSYS;
>> @@ -1207,14 +1213,14 @@ int ib_resolve_eth_dmac(struct ib_device
>> *device,
>>  	if (!rdma_is_port_valid(device, rdma_ah_get_port_num(ah_attr)))
>>  		return -EINVAL;
>>
>> -	if (!rdma_cap_eth_ah(device, rdma_ah_get_port_num(ah_attr)))
>> +	if (ah_attr->type != RDMA_AH_ATTR_TYPE_ETH)
>>  		return 0;
> Can you keep rdma_cap_eth_ah to do the work of the above code?
> This function is useful for other patches that I am working on. That way we don't have to open code for this comparison.

Not too sure i follow. Are you suggesting we keep the old 
rdma_cap_eth_ah check?
I can change the type check into a function if you feel its open coded. 
One of the benefits of adding type to ah_attr is exactly the above code. 
The caller doesnt have to call into the core (rdma_cap_eth_ah) to know 
what 'protocol' its working with. That information is contained in the 
ah_attr itself.

>
>>
>>  	grh = rdma_ah_retrieve_grh(ah_attr);
>>
>>  	if (rdma_link_local_addr((struct in6_addr *)grh->dgid.raw)) {
>>  		rdma_get_ll_mac((struct in6_addr *)grh->dgid.raw,
>> -				ah_attr->dmac);
>> +				ah_attr->eth.dmac);
>>  	} else {
>>  		union ib_gid		sgid;
>>  		struct ib_gid_attr	sgid_attr;
>> @@ -1236,7 +1242,7 @@ int ib_resolve_eth_dmac(struct ib_device *device,
>>
>>  		ret =
>>  		rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
>> -					     ah_attr->dmac,
>> +					     ah_attr->eth.dmac,
>>  					     NULL, &ifindex, &hop_limit);
>>
>>  		dev_put(sgid_attr.ndev);
>> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> index 0de43c7..2d0d6fe 100644
>> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> @@ -597,7 +597,7 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd
>> *ib_pd,
>>  			break;
>>  		}
>>  		rc = rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
>> -						  ah_attr->dmac, &vlan_tag,
>> +						  ah_attr->eth.dmac,
>> &vlan_tag,
>>  						  &sgid_attr.ndev->ifindex,
>>  						  NULL);
>>  		if (rc) {
>> @@ -606,7 +606,7 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd
>> *ib_pd,
>>  		}
>>  	}
>>
>> -	memcpy(ah->qplib_ah.dmac, ah_attr->dmac, ETH_ALEN);
>> +	memcpy(ah->qplib_ah.dmac, ah_attr->eth.dmac, ETH_ALEN);
>>  	rc = bnxt_qplib_create_ah(&rdev->qplib_res, &ah->qplib_ah);
>>  	if (rc) {
>>  		dev_err(rdev_to_dev(rdev), "Failed to allocate HW AH");
>> @@ -644,8 +644,9 @@ int bnxt_re_query_ah(struct ib_ah *ib_ah, struct
>> rdma_ah_attr *ah_attr)  {
>>  	struct bnxt_re_ah *ah = container_of(ib_ah, struct bnxt_re_ah,
>> ib_ah);
>>
>> +	ah_attr->type = ib_ah->type;
>>  	rdma_ah_set_sl(ah_attr, ah->qplib_ah.sl);
>> -	memcpy(ah_attr->dmac, ah->qplib_ah.dmac, ETH_ALEN);
>> +	memcpy(ah_attr->eth.dmac, ah->qplib_ah.dmac, ETH_ALEN);
>>  	rdma_ah_set_grh(ah_attr, NULL, 0,
>>  			ah->qplib_ah.host_sgid_index,
>>  			0, ah->qplib_ah.traffic_class);
>> @@ -1280,7 +1281,8 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct
>> ib_qp_attr *qp_attr,
>>  		qp->qplib_qp.ah.hop_limit = grh->hop_limit;
>>  		qp->qplib_qp.ah.traffic_class = grh->traffic_class;
>>  		qp->qplib_qp.ah.sl = rdma_ah_get_sl(&qp_attr->ah_attr);
>> -		ether_addr_copy(qp->qplib_qp.ah.dmac, qp_attr-
>>> ah_attr.dmac);
>> +		ether_addr_copy(qp->qplib_qp.ah.dmac,
>> +				qp_attr->ah_attr.eth.dmac);
>>
>>  		status = ib_get_cached_gid(&rdev->ibdev, 1,
>>  					   grh->sgid_index,
>> @@ -1423,13 +1425,14 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp,
>> struct ib_qp_attr *qp_attr,
>>  	qp_attr->qp_access_flags = __to_ib_access_flags(qplib_qp.access);
>>  	qp_attr->pkey_index = qplib_qp.pkey_index;
>>  	qp_attr->qkey = qplib_qp.qkey;
>> +	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ETH;
>>  	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp.ah.flow_label,
>>  			qplib_qp.ah.host_sgid_index,
>>  			qplib_qp.ah.hop_limit,
>>  			qplib_qp.ah.traffic_class);
>>  	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp.ah.dgid.data);
>>  	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp.ah.sl);
>> -	ether_addr_copy(qp_attr->ah_attr.dmac, qplib_qp.ah.dmac);
>> +	ether_addr_copy(qp_attr->ah_attr.eth.dmac, qplib_qp.ah.dmac);
>>  	qp_attr->path_mtu = __to_ib_mtu(qplib_qp.path_mtu);
>>  	qp_attr->timeout = qplib_qp.timeout;
>>  	qp_attr->retry_cnt = qplib_qp.retry_cnt; diff --git
>> a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
>> index be3077d..0e464f0 100644
>> --- a/drivers/infiniband/hw/hfi1/verbs.c
>> +++ b/drivers/infiniband/hw/hfi1/verbs.c
>> @@ -1509,8 +1509,12 @@ struct ib_ah *hfi1_create_qp0_ah(struct
>> hfi1_ibport *ibp, u16 dlid)
>>  	struct rdma_ah_attr attr;
>>  	struct ib_ah *ah = ERR_PTR(-EINVAL);
>>  	struct rvt_qp *qp0;
>> +	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
>> +	struct hfi1_devdata *dd = dd_from_ppd(ppd);
>> +	u8 port_num = ppd->port;
>>
>>  	memset(&attr, 0, sizeof(attr));
>> +	attr.type = rdma_ah_find_type(&dd->verbs_dev.rdi.ibdev,
>> port_num);
>>  	rdma_ah_set_dlid(&attr, dlid);
>>  	rdma_ah_set_port_num(&attr, ppd_from_ibp(ibp)->port);
>>  	rcu_read_lock();
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> index 6a0353d..9c6fa06 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> @@ -2737,7 +2737,7 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp,
>> const struct ib_qp_attr *attr,
>>  			goto out;
>>  		}
>>
>> -		dmac = (u8 *)attr->ah_attr.dmac;
>> +		dmac = (u8 *)attr->ah_attr.eth.dmac;
>>
>>  		context->sq_rq_bt_l = (u32)(dma_handle);
>>  		roce_set_field(context->qpc_bytes_24,
>> diff --git a/drivers/infiniband/hw/mlx4/ah.c
>> b/drivers/infiniband/hw/mlx4/ah.c index 3cbac5f..44934b9 100644
>> --- a/drivers/infiniband/hw/mlx4/ah.c
>> +++ b/drivers/infiniband/hw/mlx4/ah.c
>> @@ -96,7 +96,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd,
>>  		is_mcast = 1;
>>  		rdma_get_mcast_mac(&in6, ah->av.eth.mac);
>>  	} else {
>> -		memcpy(ah->av.eth.mac, ah_attr->dmac, ETH_ALEN);
>> +		memcpy(ah->av.eth.mac, ah_attr->eth.dmac, ETH_ALEN);
>>  	}
>>  	ret = ib_get_cached_gid(pd->device,
>> rdma_ah_get_port_num(ah_attr),
>>  				grh->sgid_index, &sgid, &gid_attr); @@ -
>> 154,9 +154,7 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct
>> rdma_ah_attr *ah_attr,
>>  	if (!ah)
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	if (rdma_port_get_link_layer(pd->device,
>> -				     rdma_ah_get_port_num(ah_attr)) ==
>> -	    IB_LINK_LAYER_ETHERNET) {
>> +	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ETH) {
>>  		if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH)) {
>>  			ret = ERR_PTR(-EINVAL);
>>  		} else {
>> @@ -182,30 +180,29 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr,  int mlx4_ib_query_ah(struct ib_ah *ibah,
>> struct rdma_ah_attr *ah_attr)  {
>>  	struct mlx4_ib_ah *ah = to_mah(ibah);
>> -	enum rdma_link_layer ll;
>> +	int port_num = be32_to_cpu(ah->av.ib.port_pd) >> 24;
>>
>>  	memset(ah_attr, 0, sizeof *ah_attr);
>> -	rdma_ah_set_port_num(ah_attr,
>> -			     be32_to_cpu(ah->av.ib.port_pd) >> 24);
>> -	ll = rdma_port_get_link_layer(ibah->device,
>> -				      rdma_ah_get_port_num(ah_attr));
>> -	if (ll == IB_LINK_LAYER_ETHERNET)
>> +	ah_attr->type = ibah->type;
>> +
>> +	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ETH) {
>> +		rdma_ah_set_dlid(ah_attr, 0);
>>  		rdma_ah_set_sl(ah_attr,
>>  			       be32_to_cpu(ah->av.eth.sl_tclass_flowlabel)
>>  			       >> 29);
>> -	else
>> +	} else {
>> +		rdma_ah_set_dlid(ah_attr, be16_to_cpu(ah->av.ib.dlid));
>>  		rdma_ah_set_sl(ah_attr,
>>  			       be32_to_cpu(ah->av.ib.sl_tclass_flowlabel)
>>  			       >> 28);
>> +	}
>>
>> -	rdma_ah_set_dlid(ah_attr, (ll == IB_LINK_LAYER_INFINIBAND) ?
>> -			 be16_to_cpu(ah->av.ib.dlid) : 0);
>> +	rdma_ah_set_port_num(ah_attr, port_num);
>>  	if (ah->av.ib.stat_rate)
>>  		rdma_ah_set_static_rate(ah_attr,
>>  					ah->av.ib.stat_rate -
>>  					MLX4_STAT_RATE_OFFSET);
>>  	rdma_ah_set_path_bits(ah_attr, ah->av.ib.g_slid & 0x7F);
>> -
>>  	if (mlx4_ib_ah_grh_present(ah)) {
>>  		u32 tc_fl = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel);
>>
>> diff --git a/drivers/infiniband/hw/mlx4/mad.c
>> b/drivers/infiniband/hw/mlx4/mad.c
>> index 425515e..b469471 100644
>> --- a/drivers/infiniband/hw/mlx4/mad.c
>> +++ b/drivers/infiniband/hw/mlx4/mad.c
>> @@ -196,6 +196,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev,
>> u8 port_num, u16 lid, u8 sl)
>>  		return;
>>
>>  	memset(&ah_attr, 0, sizeof ah_attr);
>> +	ah_attr.type = rdma_ah_find_type(&dev->ib_dev, port_num);
>>  	rdma_ah_set_dlid(&ah_attr, lid);
>>  	rdma_ah_set_sl(&ah_attr, sl);
>>  	rdma_ah_set_port_num(&ah_attr, port_num); @@ -555,6 +556,7
>> @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
>>  	/* create ah. Just need an empty one with the port num for the post
>> send.
>>  	 * The driver will set the force loopback bit in post_send */
>>  	memset(&attr, 0, sizeof attr);
>> +	attr.type = rdma_ah_find_type(&dev->ib_dev, port);
>>
>>  	rdma_ah_set_port_num(&attr, port);
>>  	if (is_eth) {
>> diff --git a/drivers/infiniband/hw/mlx4/qp.c
>> b/drivers/infiniband/hw/mlx4/qp.c index 0c016d8..fa3f374 100644
>> --- a/drivers/infiniband/hw/mlx4/qp.c
>> +++ b/drivers/infiniband/hw/mlx4/qp.c
>> @@ -1388,8 +1388,6 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev,
>>  			  u64 smac, u16 vlan_tag, struct mlx4_qp_path *path,
>>  			  struct mlx4_roce_smac_vlan_info *smac_info, u8
>> port)  {
>> -	int is_eth = rdma_port_get_link_layer(&dev->ib_dev, port) ==
>> -		IB_LINK_LAYER_ETHERNET;
>>  	int vidx;
>>  	int smac_index;
>>  	int err;
>> @@ -1426,7 +1424,7 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev,
>>  		memcpy(path->rgid, grh->dgid.raw, 16);
>>  	}
>>
>> -	if (is_eth) {
>> +	if (ah->type == RDMA_AH_ATTR_TYPE_ETH) {
>
> Lets have the macro/function for this change, instead of open code.

I can create an function. I liked the straightforward comparison though, 
it just made it easier to understand on seeing the code.
On the aspect of open coding --  IMO, the type attribute is something 
the caller needs to be aware of and work with. We added functions for 
many of the other fields as they were more internal to the structure. 
Can definitely change it into a function if you feel strongly about it.

>
>>  		if (!(rdma_ah_get_ah_flags(ah) & IB_AH_GRH))
>>  			return -1;
>>
>> @@ -1490,7 +1488,7 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev,
>>  		} else {
>>  			smac_index = smac_info->smac_index;
>>  		}
>> -		memcpy(path->dmac, ah->dmac, 6);
>> +		memcpy(path->dmac, ah->eth.dmac, 6);
>>  		path->ackto = MLX4_IB_LINK_TYPE_ETH;
>>  		/* put MAC table smac index for IBoE */
>>  		path->grh_mylmc = (u8) (smac_index) | 0x80; @@ -3402,23
>> +3400,19 @@ static void to_rdma_ah_attr(struct mlx4_ib_dev *ibdev,
>>  			    struct mlx4_qp_path *path)
>>  {
>>  	struct mlx4_dev *dev = ibdev->dev;
>> -	int is_eth;
>>  	u8 port_num = path->sched_queue & 0x40 ? 2 : 1;
>>
>>  	memset(ah_attr, 0, sizeof(*ah_attr));
>> -	rdma_ah_set_port_num(ah_attr, port_num);
>> -
>> +	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, port_num);
>>  	if (port_num == 0 || port_num > dev->caps.num_ports)
>>  		return;
>>
>> -	is_eth = rdma_port_get_link_layer(&ibdev->ib_dev,
>> -					  rdma_ah_get_port_num(ah_attr))
>> ==
>> -			IB_LINK_LAYER_ETHERNET;
>> -	if (is_eth)
>> +	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ETH)
>>  		rdma_ah_set_sl(ah_attr, ((path->sched_queue >> 3) & 0x7)
>> |
>>  			       ((path->sched_queue & 4) << 1));
>>  	else
>>  		rdma_ah_set_sl(ah_attr, (path->sched_queue >> 2) & 0xf);
>> +	rdma_ah_set_port_num(ah_attr, port_num);
>>
>>  	rdma_ah_set_dlid(ah_attr, be16_to_cpu(path->rlid));
>>  	rdma_ah_set_path_bits(ah_attr, path->grh_mylmc & 0x7f); diff --git
>> a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c index
>> 5455f3f..2d19a22 100644
>> --- a/drivers/infiniband/hw/mlx5/ah.c
>> +++ b/drivers/infiniband/hw/mlx5/ah.c
>> @@ -34,8 +34,7 @@
>>
>>  static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
>>  				  struct mlx5_ib_ah *ah,
>> -				  struct rdma_ah_attr *ah_attr,
>> -				  enum rdma_link_layer ll)
>> +				  struct rdma_ah_attr *ah_attr)
>>  {
>>  	if (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) {
>>  		const struct ib_global_route *grh =
>> rdma_ah_read_grh(ah_attr); @@ -50,8 +49,9 @@ static struct ib_ah
>> *create_ib_ah(struct mlx5_ib_dev *dev,
>>
>>  	ah->av.stat_rate_sl = (rdma_ah_get_static_rate(ah_attr) << 4);
>>
>> -	if (ll == IB_LINK_LAYER_ETHERNET) {
>> -		memcpy(ah->av.rmac, ah_attr->dmac, sizeof(ah_attr-
>>> dmac));
>> +	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ETH) {
>> +		memcpy(ah->av.rmac, ah_attr->eth.dmac,
>> +		       sizeof(ah_attr->eth.dmac));
>>  		ah->av.udp_sport =
>>  		mlx5_get_roce_udp_sport(dev,
>>  					rdma_ah_get_port_num(ah_attr),
>> @@ -72,16 +72,13 @@ struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr,  {
>>  	struct mlx5_ib_ah *ah;
>>  	struct mlx5_ib_dev *dev = to_mdev(pd->device);
>> -	enum rdma_link_layer ll;
>> +	enum rdma_ah_attr_type ah_type = ah_attr->type;
>>
>> -	ll = pd->device->get_link_layer(pd->device,
>> -					rdma_ah_get_port_num(ah_attr));
>> -
>> -	if (ll == IB_LINK_LAYER_ETHERNET &&
>> +	if ((ah_type == RDMA_AH_ATTR_TYPE_ETH) &&
>>  	    !(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
>>  		return ERR_PTR(-EINVAL);
>>
>> -	if (ll == IB_LINK_LAYER_ETHERNET && udata) {
>> +	if (ah_type == RDMA_AH_ATTR_TYPE_ETH && udata) {
>>  		int err;
>>  		struct mlx5_ib_create_ah_resp resp = {};
>>  		u32 min_resp_len = offsetof(typeof(resp), dmac) + @@ -
>> 96,7 +93,7 @@ struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct
>> rdma_ah_attr *ah_attr,
>>  		if (err)
>>  			return ERR_PTR(err);
>>
>> -		memcpy(resp.dmac, ah_attr->dmac, ETH_ALEN);
>> +		memcpy(resp.dmac, ah_attr->eth.dmac, ETH_ALEN);
>>  		err = ib_copy_to_udata(udata, &resp,
>> resp.response_length);
>>  		if (err)
>>  			return ERR_PTR(err);
>> @@ -106,7 +103,7 @@ struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr,
>>  	if (!ah)
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	return create_ib_ah(dev, ah, ah_attr, ll); /* never fails */
>> +	return create_ib_ah(dev, ah, ah_attr); /* never fails */
>>  }
>>
>>  int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
>> @@ -115,6 +112,7 @@ int mlx5_ib_query_ah(struct ib_ah *ibah, struct
>> rdma_ah_attr *ah_attr)
>>  	u32 tmp;
>>
>>  	memset(ah_attr, 0, sizeof(*ah_attr));
>> +	ah_attr->type = ibah->type;
>>
>>  	tmp = be32_to_cpu(ah->av.grh_gid_fl);
>>  	if (tmp & (1 << 30)) {
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c
>> b/drivers/infiniband/hw/mlx5/qp.c index f65adf4..131c753 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
>> @@ -2211,7 +2211,6 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev,
>> struct mlx5_ib_qp *qp,
>>  			 bool alt)
>>  {
>>  	const struct ib_global_route *grh = rdma_ah_read_grh(ah);
>> -	enum rdma_link_layer ll = rdma_port_get_link_layer(&dev->ib_dev,
>> port);
>>  	int err;
>>  	enum ib_gid_type gid_type;
>>  	u8 ah_flags = rdma_ah_get_ah_flags(ah); @@ -2230,14 +2229,15
>> @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp
>> *qp,
>>  			return -EINVAL;
>>  		}
>>  	}
>> -	if (ll == IB_LINK_LAYER_ETHERNET) {
>> +
>> +	if (ah->type == RDMA_AH_ATTR_TYPE_ETH) {
>>  		if (!(ah_flags & IB_AH_GRH))
>>  			return -EINVAL;
>> -		err = mlx5_get_roce_gid_type(dev, port, ah-
>>> grh.sgid_index,
>> +		err = mlx5_get_roce_gid_type(dev, port, grh->sgid_index,
>>  					     &gid_type);
>>  		if (err)
>>  			return err;
>> -		memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
>> +		memcpy(path->rmac, ah->eth.dmac, sizeof(ah->eth.dmac));
>>  		path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
>>  							  grh->sgid_index);
>>  		path->dci_cfi_prio_sl = (sl & 0x7) << 4; @@ -4258,6 +4258,7
>> @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
>>
>>  	memset(ah_attr, 0, sizeof(*ah_attr));
>>
>> +	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, path->port);
>>  	rdma_ah_set_port_num(ah_attr, path->port);
>>  	if (rdma_ah_get_port_num(ah_attr) == 0 ||
>>  	    rdma_ah_get_port_num(ah_attr) > MLX5_CAP_GEN(dev,
>> num_ports)) diff --git a/drivers/infiniband/hw/mthca/mthca_av.c
>> b/drivers/infiniband/hw/mthca/mthca_av.c
>> index d315f52..2aec990 100644
>> --- a/drivers/infiniband/hw/mthca/mthca_av.c
>> +++ b/drivers/infiniband/hw/mthca/mthca_av.c
>> @@ -303,6 +303,7 @@ int mthca_ah_query(struct ib_ah *ibah, struct
>> rdma_ah_attr *attr)
>>  		return -ENOSYS;
>>
>>  	memset(attr, 0, sizeof *attr);
>> +	attr->type = ibah->type;
>>  	rdma_ah_set_dlid(attr, be16_to_cpu(ah->av->dlid));
>>  	rdma_ah_set_sl(attr, be32_to_cpu(ah->av->sl_tclass_flowlabel) >>
>> 28);
>>  	rdma_ah_set_port_num(attr, port_num);
>> diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c
>> b/drivers/infiniband/hw/mthca/mthca_mad.c
>> index 45fe150..7df3db7 100644
>> --- a/drivers/infiniband/hw/mthca/mthca_mad.c
>> +++ b/drivers/infiniband/hw/mthca/mthca_mad.c
>> @@ -82,6 +82,7 @@ static void update_sm_ah(struct mthca_dev *dev,
>>  		return;
>>
>>  	memset(&ah_attr, 0, sizeof ah_attr);
>> +	ah_attr.type = rdma_ah_find_type(&dev->ib_dev, port_num);
>>  	rdma_ah_set_dlid(&ah_attr, lid);
>>  	rdma_ah_set_sl(&ah_attr, sl);
>>  	rdma_ah_set_port_num(&ah_attr, port_num); diff --git
>> a/drivers/infiniband/hw/mthca/mthca_qp.c
>> b/drivers/infiniband/hw/mthca/mthca_qp.c
>> index 6ef9b6a..d21960c 100644
>> --- a/drivers/infiniband/hw/mthca/mthca_qp.c
>> +++ b/drivers/infiniband/hw/mthca/mthca_qp.c
>> @@ -403,6 +403,7 @@ static void to_rdma_ah_attr(struct mthca_dev *dev,
>>
>>  	if (port_num == 0 || port_num > dev->limits.num_ports)
>>  		return;
>> +	ah_attr->type = rdma_ah_find_type(&dev->ib_dev, port_num);
>>  	rdma_ah_set_port_num(ah_attr, port_num);
>>
>>  	rdma_ah_set_dlid(ah_attr, be16_to_cpu(path->rlid)); diff --git
>> a/drivers/infiniband/hw/ocrdma/ocrdma.h
>> b/drivers/infiniband/hw/ocrdma/ocrdma.h
>> index afcbd2a..51ce358 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma.h
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
>> @@ -537,7 +537,7 @@ static inline int ocrdma_resolve_dmac(struct
>> ocrdma_dev *dev,
>>  	else if (rdma_link_local_addr(&in6))
>>  		rdma_get_ll_mac(&in6, mac_addr);
>>  	else
>> -		memcpy(mac_addr, ah_attr->dmac, ETH_ALEN);
>> +		memcpy(mac_addr, ah_attr->eth.dmac, ETH_ALEN);
>>  	return 0;
>>  }
>>
>> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
>> b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
>> index 97a829d..3df00b5 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
>> @@ -170,7 +170,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd,
>> struct rdma_ah_attr *attr,
>>  	const struct ib_global_route *grh;
>>  	union ib_gid sgid;
>>
>> -	if (!(rdma_ah_get_ah_flags(attr) & IB_AH_GRH))
>> +	if ((attr->type != RDMA_AH_ATTR_TYPE_ETH) ||
>> +	    !(rdma_ah_get_ah_flags(attr) & IB_AH_GRH))
>>  		return ERR_PTR(-EINVAL);
>>
>>  	grh = rdma_ah_read_grh(attr);
>> @@ -204,7 +205,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd,
>> struct rdma_ah_attr *attr,
>>  	    (!rdma_is_multicast_addr((struct in6_addr *)grh->dgid.raw)) &&
>>  	    (!rdma_link_local_addr((struct in6_addr *)grh->dgid.raw))) {
>>  		status = rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
>> -						      attr->dmac,
>> +						      attr->eth.dmac,
>>  						      &vlan_tag,
>>  						      &sgid_attr.ndev->ifindex,
>>  						      NULL);
>> @@ -259,6 +260,7 @@ int ocrdma_query_ah(struct ib_ah *ibah, struct
>> rdma_ah_attr *attr)
>>  	struct ocrdma_av *av = ah->av;
>>  	struct ocrdma_grh *grh;
>>
>> +	attr->type = ibah->type;
>>  	if (ah->av->valid & OCRDMA_AV_VALID) {
>>  		grh = (struct ocrdma_grh *)((u8 *)ah->av +
>>  				sizeof(struct ocrdma_eth_vlan));
>> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>> b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>> index 1cf6c0e..39ebf0a 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>> @@ -1601,6 +1601,7 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
>>  	qp_attr->cap.max_recv_sge = qp->rq.max_sges;
>>  	qp_attr->cap.max_inline_data = qp->max_inline_data;
>>  	qp_init_attr->cap = qp_attr->cap;
>> +	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ETH;
>>
>>  	rdma_ah_set_grh(&qp_attr->ah_attr, NULL,
>>  			params.rnt_rc_sl_fl &
>> diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c
>> b/drivers/infiniband/hw/qedr/qedr_cm.c
>> index bd1d0e8..0a870c4 100644
>> --- a/drivers/infiniband/hw/qedr/qedr_cm.c
>> +++ b/drivers/infiniband/hw/qedr/qedr_cm.c
>> @@ -311,7 +311,7 @@ static inline int qedr_gsi_build_header(struct
>> qedr_dev *dev,
>>  	}
>>
>>  	/* ENET + VLAN headers */
>> -	ether_addr_copy(udh->eth.dmac_h, ah_attr->dmac);
>> +	ether_addr_copy(udh->eth.dmac_h, ah_attr->eth.dmac);
>>  	ether_addr_copy(udh->eth.smac_h, dev->ndev->dev_addr);
>>  	if (has_vlan) {
>>  		udh->eth.type = htons(ETH_P_8021Q);
>> diff --git a/drivers/infiniband/hw/qedr/verbs.c
>> b/drivers/infiniband/hw/qedr/verbs.c
>> index 72e8cf9..e700258 100644
>> --- a/drivers/infiniband/hw/qedr/verbs.c
>> +++ b/drivers/infiniband/hw/qedr/verbs.c
>> @@ -1970,6 +1970,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
>>  	qp_attr->cap.max_inline_data =
>> ROCE_REQ_MAX_INLINE_DATA_SIZE;
>>  	qp_init_attr->cap = qp_attr->cap;
>>
>> +	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ETH;
>>  	rdma_ah_set_grh(&qp_attr->ah_attr, NULL,
>>  			params.flow_label, qp->sgid_idx,
>>  			params.hop_limit_ttl, params.traffic_class_tos); diff -
>> -git a/drivers/infiniband/hw/qib/qib_verbs.c
>> b/drivers/infiniband/hw/qib/qib_verbs.c
>> index 144475c..e89c0bc 100644
>> --- a/drivers/infiniband/hw/qib/qib_verbs.c
>> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
>> @@ -1368,9 +1368,11 @@ struct ib_ah *qib_create_qp0_ah(struct
>> qib_ibport *ibp, u16 dlid)
>>  	struct ib_ah *ah = ERR_PTR(-EINVAL);
>>  	struct rvt_qp *qp0;
>>  	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
>> +	struct qib_devdata *dd = dd_from_ppd(ppd);
>>  	u8 port_num = ppd->port;
>>
>>  	memset(&attr, 0, sizeof(attr));
>> +	attr.type = rdma_ah_find_type(&dd->verbs_dev.rdi.ibdev,
>> port_num);
>>  	rdma_ah_set_dlid(&attr, dlid);
>>  	rdma_ah_set_port_num(&attr, port_num);
>>  	rcu_read_lock();
>> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
>> b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
>> index d6178c2..2afe9bc 100644
>> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
>> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
>> @@ -280,6 +280,7 @@ void ib_global_route_to_pvrdma(struct
>> pvrdma_global_route *dst,  void pvrdma_ah_attr_to_rdma(struct
>> rdma_ah_attr *dst,
>>  			    const struct pvrdma_ah_attr *src)  {
>> +	dst->type = RDMA_AH_ATTR_TYPE_ETH;
>>  	pvrdma_global_route_to_ib(rdma_ah_retrieve_grh(dst), &src-
>>> grh);
>>  	rdma_ah_set_dlid(dst, src->dlid);
>>  	rdma_ah_set_sl(dst, src->sl);
>> @@ -287,7 +288,7 @@ void pvrdma_ah_attr_to_rdma(struct rdma_ah_attr
>> *dst,
>>  	rdma_ah_set_static_rate(dst, src->static_rate);
>>  	rdma_ah_set_ah_flags(dst, src->ah_flags);
>>  	rdma_ah_set_port_num(dst, src->port_num);
>> -	memcpy(dst->dmac, &src->dmac, ETH_ALEN);
>> +	memcpy(dst->eth.dmac, &src->dmac, ETH_ALEN);
>>  }
>>
>>  void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst, @@ -300,5
>> +301,5 @@ void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
>>  	dst->static_rate = rdma_ah_get_static_rate(src);
>>  	dst->ah_flags = rdma_ah_get_ah_flags(src);
>>  	dst->port_num = rdma_ah_get_port_num(src);
>> -	memcpy(&dst->dmac, src->dmac, sizeof(dst->dmac));
>> +	memcpy(&dst->dmac, src->eth.dmac, sizeof(dst->dmac));
>>  }
>> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
>> b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
>> index 6b11e57..0b8a7e7 100644
>> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
>> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
>> @@ -525,17 +525,14 @@ struct ib_ah *pvrdma_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr,  {
>>  	struct pvrdma_dev *dev = to_vdev(pd->device);
>>  	struct pvrdma_ah *ah;
>> -	enum rdma_link_layer ll;
>>  	const struct ib_global_route *grh;
>>  	u8 port_num = rdma_ah_get_port_num(ah_attr);
>>
>>  	if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
>>  		return ERR_PTR(-EINVAL);
>> -	ll = rdma_port_get_link_layer(pd->device,
>> -				      rdma_ah_get_port_num(ah_attr));
>> -	grh = rdma_ah_read_grh(ah_attr);
>>
>> -	if (ll != IB_LINK_LAYER_ETHERNET ||
>> +	grh = rdma_ah_read_grh(ah_attr);
>> +	if ((ah_attr->type != RDMA_AH_ATTR_TYPE_ETH)  ||
>>  	    rdma_is_multicast_addr((struct in6_addr *)grh->dgid.raw))
>>  		return ERR_PTR(-EINVAL);
>>
>> @@ -556,7 +553,7 @@ struct ib_ah *pvrdma_create_ah(struct ib_pd *pd,
>> struct rdma_ah_attr *ah_attr,
>>  	ah->av.sl_tclass_flowlabel = (grh->traffic_class << 20) |
>>  				      grh->flow_label;
>>  	memcpy(ah->av.dgid, grh->dgid.raw, 16);
>> -	memcpy(ah->av.dmac, ah_attr->dmac, ETH_ALEN);
>> +	memcpy(ah->av.dmac, ah_attr->eth.dmac, ETH_ALEN);
>>
>>  	ah->ibah.device = pd->device;
>>  	ah->ibah.pd = pd;
>> diff --git a/drivers/infiniband/sw/rxe/rxe_av.c
>> b/drivers/infiniband/sw/rxe/rxe_av.c
>> index e043e99..d64b089 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_av.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_av.c
>> @@ -70,6 +70,7 @@ int rxe_av_from_attr(struct rxe_dev *rxe, u8
>> port_num,  int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
>>  		   struct rdma_ah_attr *attr)
>>  {
>> +	attr->type = RDMA_AH_ATTR_TYPE_ETH;
>>  	memcpy(rdma_ah_retrieve_grh(attr), &av->grh, sizeof(av->grh));
>>  	rdma_ah_set_ah_flags(attr, IB_AH_GRH);
>>  	rdma_ah_set_port_num(attr, av->port_num); diff --git
>> a/drivers/infiniband/sw/rxe/rxe_verbs.c
>> b/drivers/infiniband/sw/rxe/rxe_verbs.c
>> index f4b382b..830d22e 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
>> @@ -378,6 +378,7 @@ static int rxe_query_ah(struct ib_ah *ibah, struct
>> rdma_ah_attr *attr)
>>  	struct rxe_ah *ah = to_rah(ibah);
>>
>>  	memset(attr, 0, sizeof(*attr));
>> +	attr->type = ibah->type;
>>  	rxe_av_to_attr(rxe, &ah->av, attr);
>>  	return 0;
>>  }
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> index 399b1d7..f16fd9e 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> @@ -273,6 +273,7 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast
>> *mcast,
>>  	}
>>
>>  	memset(&av, 0, sizeof(av));
>> +	av.type = rdma_ah_find_type(priv->ca, priv->port);
>>  	rdma_ah_set_dlid(&av, be16_to_cpu(mcast->mcmember.mlid)),
>>  	rdma_ah_set_port_num(&av, priv->port);
>>  	rdma_ah_set_sl(&av, mcast->mcmember.sl); diff --git
>> a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
>> c1f179d..1d76438 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -837,17 +837,39 @@ struct ib_mr_status {
>>   */
>>  __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
>>
>> -struct rdma_ah_attr {
>> +enum rdma_ah_attr_type {
>> +	RDMA_AH_ATTR_TYPE_IB,
>> +	RDMA_AH_ATTR_TYPE_ETH,
>> +};
>> +
>> +struct ib_ah_attr {
>> +	struct ib_global_route	grh;
>> +	u16			dlid;
>> +	u8			sl;
>> +	u8			src_path_bits;
>> +	u8			static_rate;
>> +	u8			dmac[ETH_ALEN];
>> +};
>> +
>> +struct eth_ah_attr {
>>  	struct ib_global_route	grh;
>>  	u16			dlid;
> Please remove it from eth, as there is no dlid for Eth.

Will do.

>
>>  	u8			sl;
>>  	u8			src_path_bits;
>>  	u8			static_rate;
>> -	u8			ah_flags;
>> -	u8			port_num;
>>  	u8			dmac[ETH_ALEN];
>>  };
>>
>
> Its better to have
> struct ib_ah_common_attr {} to have common fields between IB and ETH.
> And have instance of them in eth_ah_attr and ib_ah_attr structure.

The common ones to ib_ah_attr and eth_ah_attr are at the top level 
rdma_ah_attr structure. I can collect them in a common_ah_attr if that 
improves readability.

>
>> +struct rdma_ah_attr {
>> +	u8	port_num;
>> +	u8	ah_flags;
>> +	enum rdma_ah_attr_type type;
>> +	union {
>> +		struct ib_ah_attr ib;
>> +		struct eth_ah_attr eth;
>> +	};
>> +};
>> +
>>  enum ib_wc_status {
>>  	IB_WC_SUCCESS,
>>  	IB_WC_LOC_LEN_ERR,
>> @@ -1463,6 +1485,7 @@ struct ib_ah {
>>  	struct ib_device	*device;
>>  	struct ib_pd		*pd;
>>  	struct ib_uobject	*uobject;
>> +	enum rdma_ah_attr_type	type;
>>  };
>>
>>  typedef void (*ib_comp_handler)(struct ib_cq *cq, void *cq_context); @@ -
>> 3411,38 +3434,59 @@ int ib_resolve_eth_dmac(struct ib_device *device,
>>
>>  static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)  {
>> -	return attr->dmac;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_ETH)
>> +		return attr->eth.dmac;
>> +	return NULL;
>>  }
>>
>> -static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u32 dlid)
>> +static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u16
>> +dlid)
>>  {
>> -	attr->dlid = (u16)dlid;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		attr->ib.dlid = dlid;
>> +	else
> This should be error for else or else should not be support for non IB.

Will remove dlid and this else should go away.

>> +		attr->eth.dlid = dlid;
>>  }
>>
>> -static inline u32 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
>> +static inline u16 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
>>  {
>> -	return attr->dlid;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return attr->ib.dlid;
>> +	else
>> +		return attr->eth.dlid;
>>  }
>>
>>  static inline void rdma_ah_set_sl(struct rdma_ah_attr *attr, u8 sl)  {
>> -	attr->sl = sl;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		attr->ib.sl = sl;
>> +	else
>> +		attr->eth.sl = sl;
>>  }
>>
>>  static inline u8 rdma_ah_get_sl(const struct rdma_ah_attr *attr)  {
>> -	return attr->sl;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return attr->ib.sl;
>> +	else
>> +		return attr->eth.sl;
>>  }
>>
>
> For common fields, avoid the if() condition as once you have common structure for common fields, if condition will automatically go away.

I only made two fields common in this first version. We can make many 
more common if there is consensus. The idea of not keeping 'sl' as a 
common attibute is that it will provide an opportunity for future code 
to actually use a more meaningful name instead of overloading the 'sl' 
field. In essence, fields that have the same meaning for all types can 
be made common.
>
>
>>  static inline void rdma_ah_set_path_bits(struct rdma_ah_attr *attr,
>>  					 u8 src_path_bits)
>>  {
>> -	attr->src_path_bits = src_path_bits;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		attr->ib.src_path_bits = src_path_bits;
>> +	else
>> +		attr->eth.src_path_bits = src_path_bits;
>>  }
>>
>>  static inline u8 rdma_ah_get_path_bits(const struct rdma_ah_attr *attr)  {
>> -	return attr->src_path_bits;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return attr->ib.src_path_bits;
>> +	else
>> +		return attr->eth.src_path_bits;
>>  }
>>
>>  static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u8
>> port_num) @@ -3458,12 +3502,18 @@ static inline u8
>> rdma_ah_get_port_num(const struct rdma_ah_attr *attr)  static inline void
>> rdma_ah_set_static_rate(struct rdma_ah_attr *attr,
>>  					   u8 static_rate)
>>  {
>> -	attr->static_rate = static_rate;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		attr->ib.static_rate = static_rate;
>> +	else
>> +		attr->eth.static_rate = static_rate;
>>  }
>>
>>  static inline u8 rdma_ah_get_static_rate(const struct rdma_ah_attr *attr)  {
>> -	return attr->static_rate;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return attr->ib.static_rate;
>> +	else
>> +		return attr->eth.static_rate;
>>  }
>>
>>  static inline void rdma_ah_set_ah_flags(struct rdma_ah_attr *attr, @@ -
>> 3481,14 +3531,20 @@ static inline void rdma_ah_set_ah_flags(struct
>> rdma_ah_attr *attr,  static inline const struct ib_global_route
>>  		*rdma_ah_read_grh(const struct rdma_ah_attr *attr)  {
>> -	return &attr->grh;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return &attr->ib.grh;
>> +	else
>> +		return &attr->eth.grh;
>>  }
>>
>>  /*To retrieve and modify the grh */
>>  static inline struct ib_global_route
>>  		*rdma_ah_retrieve_grh(struct rdma_ah_attr *attr)  {
>> -	return &attr->grh;
>> +	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
>> +		return &attr->ib.grh;
>> +	else
>> +		return &attr->eth.grh;
>>  }
>>
>>  static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr, void
>> *dgid) @@ -3529,4 +3585,15 @@ static inline void rdma_ah_set_grh(struct
>> rdma_ah_attr *attr,
>>  	grh->hop_limit = hop_limit;
>>  	grh->traffic_class = traffic_class;
>>  }
>> +
>> +/*Get AH type */
>> +static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device
>> *dev,
>> +						       u32 port_num)
>> +{
>> +	if ((rdma_protocol_roce(dev, port_num)) ||
>> +	    (rdma_protocol_iwarp(dev, port_num)))
>> +		return RDMA_AH_ATTR_TYPE_ETH;
>> +	else
>> +		return RDMA_AH_ATTR_TYPE_IB;
>> +}
>>  #endif /* IB_VERBS_H */
>> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c index f2867b2..96dda85
>> 100644
>> --- a/net/smc/smc_ib.c
>> +++ b/net/smc/smc_ib.c
>> @@ -80,10 +80,11 @@ static int smc_ib_modify_qp_rtr(struct smc_link *lnk)
>>  	memset(&qp_attr, 0, sizeof(qp_attr));
>>  	qp_attr.qp_state = IB_QPS_RTR;
>>  	qp_attr.path_mtu = min(lnk->path_mtu, lnk->peer_mtu);
>> +	qp_attr.ah_attr.type = RDMA_AH_ATTR_TYPE_ETH;
>>  	rdma_ah_set_port_num(&qp_attr.ah_attr, lnk->ibport);
>>  	rdma_ah_set_grh(&qp_attr.ah_attr, NULL, 0, 0, 1, 0);
>>  	rdma_ah_set_dgid_raw(&qp_attr.ah_attr, lnk->peer_gid);
>> -	memcpy(&qp_attr.ah_attr.dmac, lnk->peer_mac,
>> +	memcpy(&qp_attr.ah_attr.eth.dmac, lnk->peer_mac,
>>  	       sizeof(lnk->peer_mac));
>>  	qp_attr.dest_qp_num = lnk->peer_qpn;
>>  	qp_attr.rq_psn = lnk->peer_psn; /* starting receive packet seq # */
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
