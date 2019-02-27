From: Gal Pressman <galpress@amazon.com>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Wed, 27 Feb 2019 09:31:39 +0200
Message-ID: <d4aec1c7-a840-d7d6-e2e3-b1501e8a1b8c@amazon.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <01b0d571-81d8-ed6c-77b7-e83ee0ab9caa@amazon.com>
 <9DD61F30A802C4429A01CA4200E302A7A5A4FB85@fmsmsx124.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A4FB85@fmsmsx124.amr.corp.intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "davem@davemloft.net" <davem@davemloft.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, Yossi Leybovich <sleybo@amazon.com>
List-Id: linux-rdma@vger.kernel.org

On 26-Feb-19 23:09, Saleem, Shiraz wrote:
>> Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
>>
>> On 15-Feb-19 19:10, Shiraz Saleem wrote:
>>> /**
>>>  * irdma_dealloc_ucontext - deallocate the user context data structure
>>>  * @context: user context created during alloc  */ static int
>>> irdma_dealloc_ucontext(struct ib_ucontext *context) {
>>> 	struct irdma_ucontext *ucontext = to_ucontext(context);
>>> 	unsigned long flags;
>>>
>>> 	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
>>> 	if (!list_empty(&ucontext->cq_reg_mem_list)) {
>>> 		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
>>> 		return -EBUSY;
>>> 	}
>>> 	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
>>>
>>> 	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
>>> 	if (!list_empty(&ucontext->qp_reg_mem_list)) {
>>> 		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
>>> 		return -EBUSY;
>>
>> Drivers are not permitted to fail dealloc_ucontext.
> 
> This is fixed in RFC v1 submission. Maybe this was pasted from the v0 ver?
> 
> [..]
> 
>>> +/**
>>> + * irdma_alloc_pd - allocate protection domain
>>> + * @pd: PD pointer
>>> + * @context: user context created during alloc
>>> + * @udata: user data
>>> + */
>>> +static int irdma_alloc_pd(struct ib_pd *pd,
>>> +			  struct ib_ucontext *context,
>>> +			  struct ib_udata *udata)
>>> +{
>>> +	struct irdma_pd *iwpd = to_iwpd(pd);
>>> +	struct irdma_device *iwdev = to_iwdev(pd->device);
>>> +	struct irdma_sc_dev *dev = &iwdev->rf->sc_dev;
>>> +	struct irdma_pci_f *rf = iwdev->rf;
>>> +	struct irdma_alloc_pd_resp uresp = {};
>>> +	struct irdma_sc_pd *sc_pd;
>>> +	struct irdma_ucontext *ucontext;
>>> +	u32 pd_id = 0;
>>> +	int err;
>>> +
>>> +	if (iwdev->closing)
>>> +		return -ENODEV;
>>> +
>>> +	err = irdma_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
>>> +			       &rf->next_pd);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	sc_pd = &iwpd->sc_pd;
>>> +	if (context) {
>>
>> I think this should be 'if (udata)', this applies to many other places in this driver.
> 
> That’s right. Will fix it.
> 
>>
>>> +		ucontext = to_ucontext(context);
>>> +		dev->iw_pd_ops->pd_init(dev, sc_pd, pd_id, ucontext->abi_ver);
>>> +		uresp.pd_id = pd_id;
>>> +		if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
>>> +			err = -EFAULT;
>>> +			goto error;
>>> +		}
>>> +	} else {
>>> +		dev->iw_pd_ops->pd_init(dev, sc_pd, pd_id, -1);
>>> +	}
>>> +
>>> +	irdma_add_pdusecount(iwpd);
>>> +
>>> +	return 0;
>>> +error:
>>> +	irdma_free_rsrc(rf, rf->allocated_pds, pd_id);
>>> +
>>> +	return err;
>>> +}
>>> +/**
>>> + * irdma_create_qp - create qp
>>> + * @ibpd: ptr of pd
>>> + * @init_attr: attributes for qp
>>> + * @udata: user data for create qp
>>> + */
>>> +static struct ib_qp *irdma_create_qp(struct ib_pd *ibpd,
>>> +				     struct ib_qp_init_attr *init_attr,
>>> +				     struct ib_udata *udata)
>>> +{
>>> +	struct irdma_pd *iwpd = to_iwpd(ibpd);
>>> +	struct irdma_device *iwdev = to_iwdev(ibpd->device);
>>> +	struct irdma_pci_f *rf = iwdev->rf;
>>> +	struct irdma_cqp *iwcqp = &rf->cqp;
>>> +	struct irdma_qp *iwqp;
>>> +	struct irdma_ucontext *ucontext;
>>> +	struct irdma_create_qp_req req;
>>> +	struct irdma_create_qp_resp uresp = {};
>>> +	struct i40iw_create_qp_resp uresp_gen1 = {};
>>> +	u32 qp_num = 0;
>>> +	void *mem;
>>> +	enum irdma_status_code ret;
>>> +	int err_code = 0;
>>> +	int sq_size;
>>> +	int rq_size;
>>> +	struct irdma_sc_qp *qp;
>>> +	struct irdma_sc_dev *dev = &rf->sc_dev;
>>> +	struct irdma_qp_init_info init_info = {};
>>> +	struct irdma_create_qp_info *qp_info;
>>> +	struct irdma_cqp_request *cqp_request;
>>> +	struct cqp_cmds_info *cqp_info;
>>> +	struct irdma_qp_host_ctx_info *ctx_info;
>>> +	struct irdma_iwarp_offload_info *iwarp_info;
>>> +	struct irdma_roce_offload_info *roce_info;
>>> +	struct irdma_udp_offload_info *udp_info;
>>> +	unsigned long flags;
>>> +
>>> +	if (iwdev->closing)
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	if (init_attr->create_flags)
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>> +	if (init_attr->cap.max_inline_data > dev->hw_attrs.max_hw_inline)
>>> +		init_attr->cap.max_inline_data = dev->hw_attrs.max_hw_inline;
>>> +
>>> +	if (init_attr->cap.max_send_sge > dev->hw_attrs.max_hw_wq_frags)
>>> +		init_attr->cap.max_send_sge = dev-
>>> hw_attrs.max_hw_wq_frags;
>>> +
>>> +	if (init_attr->cap.max_recv_sge > dev->hw_attrs.max_hw_wq_frags)
>>> +		init_attr->cap.max_recv_sge = dev->hw_attrs.max_hw_wq_frags;
>>
>> AFAIK, you can change the requested values to be greater than or equal to the
>> values requested. I don't think you can change them to something smaller.
> 
> Hmm...This is a sanity check to make sure we don’t exceed the device supported values.
> But we should fail the call.
> 
> [..]
> 
>>> +	mem = kzalloc(sizeof(*iwqp), GFP_KERNEL);
>>> +	if (!mem)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	iwqp = (struct irdma_qp *)mem;
>>> +	iwqp->allocated_buf = mem;
>>
>> 'allocated_buf' feels redundant. Why is iwqp not sufficient?
> 
> I agree.
> [..]
> 
>>> +	if (udata) {
>>> +		err_code = ib_copy_from_udata(&req, udata, sizeof(req));
>>
>> Perhaps ib_copy_from_udata(&req, udata, min(sizeof(req), udata->inlen)?
>> Applies to other call sites of ib_copy_from/to_udata as well.
>>
> 
> It’s a good idea.
> 
>>> + * irdma_query - query qp attributes
>>> + * @ibqp: qp pointer
>>> + * @attr: attributes pointer
>>> + * @attr_mask: Not used
>>> + * @init_attr: qp attributes to return  */ static int
>>> +irdma_query_qp(struct ib_qp *ibqp,
>>> +			  struct ib_qp_attr *attr,
>>> +			  int attr_mask,
>>> +			  struct ib_qp_init_attr *init_attr) {
>>> +	struct irdma_qp *iwqp = to_iwqp(ibqp);
>>> +	struct irdma_sc_qp *qp = &iwqp->sc_qp;
>>> +
>>> +	attr->qp_state = iwqp->ibqp_state;
>>> +	attr->cur_qp_state = iwqp->ibqp_state;
>>> +	attr->qp_access_flags = 0;
>>> +	attr->cap.max_send_wr = qp->qp_uk.sq_size - 1;
>>> +	attr->cap.max_recv_wr = qp->qp_uk.rq_size - 1;
>>
>> Why -1?
> 
> It's reserved for HW. But the equation should be 
> (sqdepth - I40IW_SQ_RSVD) >> sqshift.
> 
> [....]
>>
>>> +	attr->cap.max_inline_data = qp->qp_uk.max_inline_data;
>>> +	attr->cap.max_send_sge = qp->qp_uk.max_sq_frag_cnt;
>>> +	attr->cap.max_recv_sge = qp->qp_uk.max_rq_frag_cnt;
>>> +	attr->qkey = iwqp->roce_info.qkey;
>>> +
>>> +	init_attr->event_handler = iwqp->ibqp.event_handler;
>>> +	init_attr->qp_context = iwqp->ibqp.qp_context;
>>> +	init_attr->send_cq = iwqp->ibqp.send_cq;
>>> +	init_attr->recv_cq = iwqp->ibqp.recv_cq;
>>> +	init_attr->srq = iwqp->ibqp.srq;
>>> +	init_attr->cap = attr->cap;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/**
>>> + * irdma_destroy_cq - destroy cq
>>> + * @ib_cq: cq pointer
>>> + */
>>> +static int irdma_destroy_cq(struct ib_cq *ib_cq) {
>>> +	struct irdma_cq *iwcq;
>>> +	struct irdma_device *iwdev;
>>> +	struct irdma_sc_cq *cq;
>>> +
>>> +	if (!ib_cq) {
>>> +		irdma_pr_err("ib_cq == NULL\n");
>>> +		return 0;
>>> +	}
>>
>> Is this really needed? Which caller can pass NULL pointer?
> 
> Not needed.
> 
>>> +
>>> +/**
>>> + * board_id_show
>>> + */
>>> +static ssize_t board_id_show(struct device *dev,
>>> +			     struct device_attribute *attr,
>>> +			     char *buf)
>>> +{
>>> +	return sprintf(buf, "%.*s\n", 32, "IRDMA Board ID");
>>
>> That doesn't add much information.
> 
> Will fix.
> 
>>
>>> +}
>>> +
>>> +static DEVICE_ATTR_RO(hw_rev);
>>> +static DEVICE_ATTR_RO(hca_type);
>>> +static DEVICE_ATTR_RO(board_id);
>>> +
>>> +static struct attribute *irdma_dev_attributes[] = {
>>> +	&dev_attr_hw_rev.attr,
>>> +	&dev_attr_hca_type.attr,
>>> +	&dev_attr_board_id.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static const struct attribute_group irdma_attr_group = {
>>> +	.attrs = irdma_dev_attributes,
>>> +};
>>> +
>>> +/**
>>> + * irdma_modify_port  Modify port properties
>>> + * @ibdev: device pointer from stack
>>> + * @port: port number
>>> + * @port_modify_mask: mask for port modifications
>>> + * @props: port properties
>>> + */
>>> +static int irdma_modify_port(struct ib_device *ibdev,
>>> +			     u8 port,
>>> +			     int port_modify_mask,
>>> +			     struct ib_port_modify *props) {
>>> +	return 0;
>>> +}
>>
>> Same question as disacossiate_ucontext.
> 
> This was likely added during early dev. and can be removed.
> 
>>
>>> +
>>> +/**
>>> + * irdma_query_gid_roce - Query port GID for Roce
>>> + * @ibdev: device pointer from stack
>>> + * @port: port number
>>> + * @index: Entry index
>>> + * @gid: Global ID
>>> + */
>>> +static int irdma_query_gid_roce(struct ib_device *ibdev,
>>> +				u8 port,
>>> +				int index,
>>> +				union ib_gid *gid)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = rdma_query_gid(ibdev, port, index, gid);
>>> +	if (ret == -EAGAIN) {
>>
>> I can't see a path where rdma_query_gid returns -EAGAIN.
> 
> This function can be removed now. It's only applicable to non-Roce providers.
> 
>>
>>> +		memcpy(gid, &zgid, sizeof(*gid));
>>> +		return 0;
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>
>>> +/**
>>> + * irdma_create_ah - create address handle
>>> + * @ibpd: ptr to protection domain
>>> + * @ah_attr: address handle attributes
>>
>> 'ah_attr' -> 'attr', missing flags and udata.
> 
> Will fix all these hits in the driver.
> 
> [..]
>>> + */
>>> +static int irdma_destroy_ah(struct ib_ah *ibah, u32 flags) {
>>> +	struct irdma_device *iwdev = to_iwdev(ibah->device);
>>> +	struct irdma_ah *ah = to_iwah(ibah);
>>> +	int err;
>>> +
>>> +	if (!ah->sc_ah.ah_info.ah_valid)
>>> +		return -EINVAL;
>>> +
>>> +	err = irdma_ah_cqp_op(iwdev->rf, &ah->sc_ah,
>> IRDMA_OP_AH_DESTROY,
>>> +			      flags & RDMA_DESTROY_AH_SLEEPABLE,
>>> +			      irdma_destroy_ah_cb, ah);
>>> +	if (!err)
>>> +		return 0;
>>
>> Why are the rest of the cleanups only in case of error?
> 
> On success, the cleanup is done in the callback, irdma_destroy_ah_cb.
> 
> [...]
> 
> 
>>> +static __be64 irdma_mac_to_guid(struct net_device *ndev) {
>>> +	unsigned char *mac = ndev->dev_addr;
>>> +	__be64 guid;
>>> +	unsigned char *dst = (unsigned char *)&guid;
>>> +
>>> +	dst[0] = mac[0] ^ 2;
>>> +	dst[1] = mac[1];
>>> +	dst[2] = mac[2];
>>> +	dst[3] = 0xff;
>>> +	dst[4] = 0xfe;
>>> +	dst[5] = mac[3];
>>> +	dst[6] = mac[4];
>>> +	dst[7] = mac[5];
>>> +
>>> +	return guid;
>>> +}
>>
>> There's a variant of this function in irdma, bnxt_re, ocrdma and qedr.
>> Maybe it's time to provide it in common code?
> 
> Agreed.
> 

Other than that:
Reviewed-by: Gal Pressman <galpress@amazon.com>
