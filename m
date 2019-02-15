From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Fri, 15 Feb 2019 10:35:39 -0700
Message-ID: <20190215173539.GD30706@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-13-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 11:10:59AM -0600, Shiraz Saleem wrote:

> +static int irdma_alloc_pd(struct ib_pd *pd,
> +			  struct ib_ucontext *context,
> +			  struct ib_udata *udata)
> +{
> +	struct irdma_pd *iwpd = to_iwpd(pd);
> +	struct irdma_device *iwdev = to_iwdev(pd->device);
> +	struct irdma_sc_dev *dev = &iwdev->rf->sc_dev;
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_alloc_pd_resp uresp = {};
> +	struct irdma_sc_pd *sc_pd;
> +	struct irdma_ucontext *ucontext;
> +	u32 pd_id = 0;
> +	int err;
> +
> +	if (iwdev->closing)
> +		return -ENODEV;

No crazy unlocked 'closing' flags. The core code takes care of
everything a driver needs to worry about if you use it properly.

> +/**
> + * irdma_create_cq - create cq
> + * @ibdev: device pointer from stack
> + * @attr: attributes for cq
> + * @context: user context created during alloc
> + * @udata: user data
> + */
> +static struct ib_cq *irdma_create_cq(struct ib_device *ibdev,
> +				     const struct ib_cq_init_attr *attr,
> +				     struct ib_ucontext *context,
> +				     struct ib_udata *udata)
> +{
> +	struct irdma_device *iwdev = to_iwdev(ibdev);
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_cq *iwcq;
> +	struct irdma_pbl *iwpbl;
> +	u32 cq_num = 0;
> +	struct irdma_sc_cq *cq;
> +	struct irdma_sc_dev *dev = &rf->sc_dev;
> +	struct irdma_cq_init_info info = {};
> +	enum irdma_status_code status;
> +	struct irdma_cqp_request *cqp_request;
> +	struct cqp_cmds_info *cqp_info;
> +	struct irdma_cq_uk_init_info *ukinfo = &info.cq_uk_init_info;
> +	unsigned long flags;
> +	int err_code;
> +	int entries = attr->cqe;
> +
> +	if (iwdev->closing)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (entries > rf->max_cqe)
> +		return ERR_PTR(-EINVAL);
> +
> +	iwcq = kzalloc(sizeof(*iwcq), GFP_KERNEL);
> +	if (!iwcq)
> +		return ERR_PTR(-ENOMEM);
> +
> +	err_code = irdma_alloc_rsrc(rf, rf->allocated_cqs,
> +				    rf->max_cq, &cq_num,
> +				    &rf->next_cq);
> +	if (err_code)
> +		goto error;
> +
> +	cq = &iwcq->sc_cq;
> +	cq->back_cq = (void *)iwcq;
> +	spin_lock_init(&iwcq->lock);
> +	info.dev = dev;
> +	ukinfo->cq_size = max(entries, 4);
> +	ukinfo->cq_id = cq_num;
> +	iwcq->ibcq.cqe = info.cq_uk_init_info.cq_size;
> +	if (attr->comp_vector < rf->ceqs_count)
> +		info.ceq_id = attr->comp_vector;
> +	info.ceq_id_valid = true;
> +	info.ceqe_mask = 1;
> +	info.type = IRDMA_CQ_TYPE_IWARP;
> +	info.vsi = &iwdev->vsi;
> +
> +	if (context) {

Drivers should rarely write 'if context'. The test for userspaceness
is 'if (udata)' - and in this case context is guarenteed. Lots of
places with this wrong..

Also this will need to be rebased as this all changed.

> +	return (struct ib_cq *)iwcq;

And don't write casts like that, &iwcq->ib_qp or something. 

Find and fix them all please.

> +/**
> + * irdma_set_page - populate pbl list for fmr
> + * @ibmr: ib mem to access iwarp mr pointer
> + * @addr: page dma address fro pbl list
> + */
> +static int irdma_set_page(struct ib_mr *ibmr,
> +			  u64 addr)

Can you please read through this giant driver and hit various places
with wonky formatting with clang-format? We don't need to start out a
new driver with bonkers indentation.
> +
> +static const struct ib_device_ops irdma_roce_dev_ops = {
> +	.get_link_layer = irdma_get_link_layer,
> +	.query_ah = irdma_query_ah,
> +	.attach_mcast = irdma_attach_mcast,
> +	.detach_mcast = irdma_detach_mcast,
> +	.query_gid = irdma_query_gid_roce,
> +	.modify_qp = irdma_modify_qp_roce,
> +};
> +
> +static const struct ib_device_ops irdma_iw_dev_ops = {
> +	.query_gid = irdma_query_gid,
> +	.modify_qp = irdma_modify_qp,
> +};
> +
> +static const struct ib_device_ops irdma_dev_ops = {
> +	.get_port_immutable = irdma_port_immutable,
> +	.get_netdev = irdma_get_netdev,
> +	.query_port = irdma_query_port,
> +	.modify_port = irdma_modify_port,
> +	.query_pkey = irdma_query_pkey,
> +	.alloc_ucontext = irdma_alloc_ucontext,
> +	.dealloc_ucontext = irdma_dealloc_ucontext,
> +	.mmap = irdma_mmap,
> +	.alloc_pd = irdma_alloc_pd,
> +	.dealloc_pd = irdma_dealloc_pd,
> +	.create_qp = irdma_create_qp,
> +	.query_qp = irdma_query_qp,
> +	.destroy_qp = irdma_destroy_qp,
> +	.create_cq = irdma_create_cq,
> +	.destroy_cq = irdma_destroy_cq,
> +	.get_dma_mr = irdma_get_dma_mr,
> +	.reg_user_mr = irdma_reg_user_mr,
> +	.dereg_mr = irdma_dereg_mr,
> +	.alloc_mw = irdma_alloc_mw,
> +	.dealloc_mw = irdma_dealloc_mw,
> +	.alloc_hw_stats = irdma_alloc_hw_stats,
> +	.get_hw_stats = irdma_get_hw_stats,
> +	.query_device = irdma_query_device,
> +	.create_ah = irdma_create_ah,
> +	.destroy_ah = irdma_destroy_ah,
> +	.drain_sq = irdma_drain_sq,
> +	.drain_rq = irdma_drain_rq,
> +	.alloc_mr = irdma_alloc_mr,
> +	.map_mr_sg = irdma_map_mr_sg,
> +	.get_dev_fw_str = irdma_get_dev_fw_str,
> +	.poll_cq = irdma_poll_cq,
> +	.req_notify_cq = irdma_req_notify_cq,
> +	.post_send = irdma_post_send,
> +	.post_recv = irdma_post_recv,
> +	.disassociate_ucontext = irdma_disassociate_ucontext,
> +	INIT_RDMA_OBJ_SIZE(ib_pd, irdma_pd, ibpd),
> +};

All lists of things should be sorted. I saw many examples of unsorted
lists.

> +/**
> + * irdma_init_roce_device - initialization of iwarp rdma device
> + * @iwibdev: irdma ib device
> + */
> +static int irdma_init_iw_device(struct irdma_ib_device *iwibdev)
> +{
> +	struct net_device *netdev = iwibdev->iwdev->netdev;
> +
> +	iwibdev->ibdev.node_type = RDMA_NODE_RNIC;
> +	ether_addr_copy((u8 *)&iwibdev->ibdev.node_guid, netdev->dev_addr);
> +	iwibdev->ibdev.iwcm = kzalloc(sizeof(*iwibdev->ibdev.iwcm), GFP_KERNEL);
> +	if (!iwibdev->ibdev.iwcm)
> +		return -ENOMEM;
> +
> +	iwibdev->ibdev.iwcm->add_ref = irdma_add_ref;
> +	iwibdev->ibdev.iwcm->rem_ref = irdma_rem_ref;
> +	iwibdev->ibdev.iwcm->get_qp = irdma_get_qp;
> +	iwibdev->ibdev.iwcm->connect = irdma_connect;
> +	iwibdev->ibdev.iwcm->accept = irdma_accept;
> +	iwibdev->ibdev.iwcm->reject = irdma_reject;
> +	iwibdev->ibdev.iwcm->create_listen = irdma_create_listen;
> +	iwibdev->ibdev.iwcm->destroy_listen = irdma_destroy_listen;

Huh. These should probably be moved into the ops structure too.

> +/**
> + * irdma_register_rdma_device - register iwarp device to IB
> + * @iwdev: iwarp device
> + */
> +int irdma_register_rdma_device(struct irdma_device *iwdev)
> +{
> +	int ret;
> +	struct irdma_ib_device *iwibdev;
> +
> +	ret = irdma_init_rdma_device(iwdev);
> +	if (ret)
> +		return ret;
> +
> +	iwibdev = iwdev->iwibdev;
> +	rdma_set_device_sysfs_group(&iwibdev->ibdev, &irdma_attr_group);
> +	if (iwdev->rf->sc_dev.hw_attrs.hw_rev == IRDMA_GEN_1)
> +		/* backward compat with old user-space libi40iw */
> +		iwibdev->ibdev.driver_id = RDMA_DRIVER_I40IW;

Really? Then what is the problem in rdma-core? 

Why are we getting a replacement driver instead of fixing the old one?

This is very long, I didn't read it super closely :(

Jason
