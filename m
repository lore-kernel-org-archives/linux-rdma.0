From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 03/24] ibtrs: core: lib functions shared between client
 and server modules
Date: Mon, 5 Feb 2018 12:52:12 +0200
Message-ID: <b706bb5f-b317-fc3a-8ada-066a2a26e9ce@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-4-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180202140904.2017-4-roman.penyaev@profitbricks.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Hi Roman,

Here are some comments below.

> +int ibtrs_post_recv_empty(struct ibtrs_con *con, struct ib_cqe *cqe)
> +{
> +	struct ib_recv_wr wr, *bad_wr;
> +
> +	wr.next    = NULL;
> +	wr.wr_cqe  = cqe;
> +	wr.sg_list = NULL;
> +	wr.num_sge = 0;
> +
> +	return ib_post_recv(con->qp, &wr, &bad_wr);
> +}
> +EXPORT_SYMBOL_GPL(ibtrs_post_recv_empty);

What is this designed to do?

> +int ibtrs_iu_post_rdma_write_imm(struct ibtrs_con *con, struct ibtrs_iu *iu,
> +				 struct ib_sge *sge, unsigned int num_sge,
> +				 u32 rkey, u64 rdma_addr, u32 imm_data,
> +				 enum ib_send_flags flags)
> +{
> +	struct ib_send_wr *bad_wr;
> +	struct ib_rdma_wr wr;
> +	int i;
> +
> +	wr.wr.next	  = NULL;
> +	wr.wr.wr_cqe	  = &iu->cqe;
> +	wr.wr.sg_list	  = sge;
> +	wr.wr.num_sge	  = num_sge;
> +	wr.rkey		  = rkey;
> +	wr.remote_addr	  = rdma_addr;
> +	wr.wr.opcode	  = IB_WR_RDMA_WRITE_WITH_IMM;
> +	wr.wr.ex.imm_data = cpu_to_be32(imm_data);
> +	wr.wr.send_flags  = flags;
> +
> +	/*
> +	 * If one of the sges has 0 size, the operation will fail with an
> +	 * length error
> +	 */
> +	for (i = 0; i < num_sge; i++)
> +		if (WARN_ON(sge[i].length == 0))
> +			return -EINVAL;
> +
> +	return ib_post_send(con->qp, &wr.wr, &bad_wr);
> +}
> +EXPORT_SYMBOL_GPL(ibtrs_iu_post_rdma_write_imm);
> +
> +int ibtrs_post_rdma_write_imm_empty(struct ibtrs_con *con, struct ib_cqe *cqe,
> +				    u32 imm_data, enum ib_send_flags flags)
> +{
> +	struct ib_send_wr wr, *bad_wr;
> +
> +	memset(&wr, 0, sizeof(wr));
> +	wr.wr_cqe	= cqe;
> +	wr.send_flags	= flags;
> +	wr.opcode	= IB_WR_RDMA_WRITE_WITH_IMM;
> +	wr.ex.imm_data	= cpu_to_be32(imm_data);
> +
> +	return ib_post_send(con->qp, &wr, &bad_wr);
> +}
> +EXPORT_SYMBOL_GPL(ibtrs_post_rdma_write_imm_empty);

Christoph did a great job adding a generic rdma rw API, please
reuse it, if you rely on needed functionality that does not exist
there, please enhance it instead of open-coding a new rdma engine
library.

> +static int ibtrs_ib_dev_init(struct ibtrs_ib_dev *d, struct ib_device *dev)
> +{
> +	int err;
> +
> +	d->pd = ib_alloc_pd(dev, IB_PD_UNSAFE_GLOBAL_RKEY);
> +	if (IS_ERR(d->pd))
> +		return PTR_ERR(d->pd);
> +	d->dev = dev;
> +	d->lkey = d->pd->local_dma_lkey;
> +	d->rkey = d->pd->unsafe_global_rkey;
> +
> +	err = ibtrs_query_device(d);
> +	if (unlikely(err))
> +		ib_dealloc_pd(d->pd);
> +
> +	return err;
> +}

I must say that this makes me frustrated.. We stopped doing these
sort of things long time ago. No way we can even consider accepting
the unsafe use of the global rkey exposing the entire memory space for
remote access permissions.

Sorry for being blunt, but this protocol design which makes a concious
decision to expose unconditionally is broken by definition.

> +struct ibtrs_ib_dev *ibtrs_ib_dev_find_get(struct rdma_cm_id *cm_id)
> +{
> +	struct ibtrs_ib_dev *dev;
> +	int err;
> +
> +	mutex_lock(&device_list_mutex);
> +	list_for_each_entry(dev, &device_list, entry) {
> +		if (dev->dev->node_guid == cm_id->device->node_guid &&
> +		    kref_get_unless_zero(&dev->ref))
> +			goto out_unlock;
> +	}
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (unlikely(!dev))
> +		goto out_err;
> +
> +	kref_init(&dev->ref);
> +	err = ibtrs_ib_dev_init(dev, cm_id->device);
> +	if (unlikely(err))
> +		goto out_free;
> +	list_add(&dev->entry, &device_list);
> +out_unlock:
> +	mutex_unlock(&device_list_mutex);
> +
> +	return dev;
> +
> +out_free:
> +	kfree(dev);
> +out_err:
> +	mutex_unlock(&device_list_mutex);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(ibtrs_ib_dev_find_get);

Is it time to make this a common helper in rdma_cm?

...

> +static void schedule_hb(struct ibtrs_sess *sess)
> +{
> +	queue_delayed_work(sess->hb_wq, &sess->hb_dwork,
> +			   msecs_to_jiffies(sess->hb_interval_ms));
> +}

What does hb stand for?

> +void ibtrs_send_hb_ack(struct ibtrs_sess *sess)
> +{
> +	struct ibtrs_con *usr_con = sess->con[0];
> +	u32 imm;
> +	int err;
> +
> +	imm = ibtrs_to_imm(IBTRS_HB_ACK_IMM, 0);
> +	err = ibtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe,
> +					      imm, IB_SEND_SIGNALED);
> +	if (unlikely(err)) {
> +		sess->hb_err_handler(usr_con, err);
> +		return;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(ibtrs_send_hb_ack);

What is this?

What is all this hb stuff?

> +
> +static int ibtrs_str_ipv4_to_sockaddr(const char *addr, size_t len,
> +				      short port, struct sockaddr *dst)
> +{
> +	struct sockaddr_in *dst_sin = (struct sockaddr_in *)dst;
> +	int ret;
> +
> +	ret = in4_pton(addr, len, (u8 *)&dst_sin->sin_addr.s_addr,
> +		       '\0', NULL);
> +	if (ret == 0)
> +		return -EINVAL;
> +
> +	dst_sin->sin_family = AF_INET;
> +	dst_sin->sin_port = htons(port);
> +
> +	return 0;
> +}
> +
> +static int ibtrs_str_ipv6_to_sockaddr(const char *addr, size_t len,
> +				      short port, struct sockaddr *dst)
> +{
> +	struct sockaddr_in6 *dst_sin6 = (struct sockaddr_in6 *)dst;
> +	int ret;
> +
> +	ret = in6_pton(addr, len, dst_sin6->sin6_addr.s6_addr,
> +		       '\0', NULL);
> +	if (ret != 1)
> +		return -EINVAL;
> +
> +	dst_sin6->sin6_family = AF_INET6;
> +	dst_sin6->sin6_port = htons(port);
> +
> +	return 0;
> +}

We already added helpers for this in net utils, you don't need to
code it again.

> +
> +static int ibtrs_str_gid_to_sockaddr(const char *addr, size_t len,
> +				     short port, struct sockaddr *dst)
> +{
> +	struct sockaddr_ib *dst_ib = (struct sockaddr_ib *)dst;
> +	int ret;
> +
> +	/* We can use some of the I6 functions since GID is a valid
> +	 * IPv6 address format
> +	 */
> +	ret = in6_pton(addr, len, dst_ib->sib_addr.sib_raw, '\0', NULL);
> +	if (ret == 0)
> +		return -EINVAL;
> +
> +	dst_ib->sib_family = AF_IB;
> +	/*
> +	 * Use the same TCP server port number as the IB service ID
> +	 * on the IB port space range
> +	 */
> +	dst_ib->sib_sid = cpu_to_be64(RDMA_IB_IP_PS_IB | port);
> +	dst_ib->sib_sid_mask = cpu_to_be64(0xffffffffffffffffULL);
> +	dst_ib->sib_pkey = cpu_to_be16(0xffff);
> +
> +	return 0;
> +}

Would be a nice addition to net utils.
