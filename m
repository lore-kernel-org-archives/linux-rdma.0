From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Support rq record doorbell for
 kernel space
Date: Wed, 24 Jan 2018 20:40:42 +0800
Message-ID: <c5cfd489-e589-1d01-ef7a-718d3dc6d4e5@huawei.com>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-4-git-send-email-liuyixian@huawei.com>
 <20180123110740.GR1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123110740.GR1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/23 19:07, Leon Romanovsky wrote:
> On Thu, Jan 18, 2018 at 10:34:30AM +0800, Yixian Liu wrote:
>> This patch updates to support rq record doorbell for
>> the kernel space.
>>
>> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_db.c     | 112 ++++++++++++++++++++++++++++
>>  drivers/infiniband/hw/hns/hns_roce_device.h |   6 ++
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  15 +---
>>  drivers/infiniband/hw/hns/hns_roce_main.c   |   5 ++
>>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 ++++-
>>  5 files changed, 143 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
>> index 0908208..de3fa94 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_db.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
>> @@ -92,3 +92,115 @@ void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
>>  	mutex_unlock(&context->db_page_mutex);
>>  }
>>  EXPORT_SYMBOL(hns_roce_db_unmap_user);
>> +
>> +static struct hns_roce_db_pgdir *hns_roce_alloc_db_pgdir(
>> +					struct device *dma_device, gfp_t gfp)
>> +{
>> +	struct hns_roce_db_pgdir *pgdir;
>> +
>> +	pgdir = kzalloc(sizeof(*pgdir), gfp);
>> +	if (!pgdir)
>> +		return NULL;
>> +
>> +	bitmap_fill(pgdir->order1, HNS_ROCE_DB_PER_PAGE / 2);
>> +	pgdir->bits[0] = pgdir->order0;
> 
> order0? isn't it equal to zero?
> 

No. Here order0 is the name of a bitmap array and bits[0] points to it.

>> +	pgdir->bits[1] = pgdir->order1;
>> +	pgdir->db_page = dma_alloc_coherent(dma_device, PAGE_SIZE,
>> +					    &pgdir->db_dma, gfp);
>> +	if (!pgdir->db_page) {
>> +		kfree(pgdir);
>> +		return NULL;
>> +	}
>> +
>> +	return pgdir;
>> +}
>> +
>> +static int hns_roce_alloc_db_from_pgdir(struct hns_roce_db_pgdir *pgdir,
>> +					struct hns_roce_db *db, int order)
>> +{
>> +	int o;
>> +	int i;
>> +
>> +	for (o = order; o <= 1; ++o) {
>> +		i = find_first_bit(pgdir->bits[o], HNS_ROCE_DB_PER_PAGE >> o);
>> +		if (i < HNS_ROCE_DB_PER_PAGE >> o)
>> +			goto found;
>> +	}
>> +
>> +	return -ENOMEM;
>> +
>> +found:
>> +	clear_bit(i, pgdir->bits[o]);
>> +
>> +	i <<= o;
>> +
>> +	if (o > order)
>> +		set_bit(i ^ 1, pgdir->bits[order]);
>> +
>> +	db->u.pgdir	= pgdir;
>> +	db->index	= i;
>> +	db->db_record	= pgdir->db_page + db->index;
>> +	db->dma		= pgdir->db_dma  + db->index * 4;
>> +	db->order	= order;
>> +
>> +	return 0;
>> +}
>> +
>> +int hns_roce_alloc_db(struct hns_roce_dev *hr_dev, struct hns_roce_db *db,
>> +		      int order, gfp_t gfp)
> 
> I don't see any reason to provide "order" and "gfp" for one caller who has
> hard-coded values.
> 

You are right. Will fix it next version.

>> +{
>> +	struct hns_roce_db_pgdir *pgdir;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&hr_dev->pgdir_mutex);
>> +
>> +	list_for_each_entry(pgdir, &hr_dev->pgdir_list, list)
>> +		if (!hns_roce_alloc_db_from_pgdir(pgdir, db, order))
>> +			goto out;
>> +
>> +	pgdir = hns_roce_alloc_db_pgdir(hr_dev->dev, gfp);
>> +	if (!pgdir) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	list_add(&pgdir->list, &hr_dev->pgdir_list);
>> +
>> +	/* This should never fail -- we just allocated an empty page: */
>> +	WARN_ON(hns_roce_alloc_db_from_pgdir(pgdir, db, order));
>> +
>> +out:
>> +	mutex_unlock(&hr_dev->pgdir_mutex);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(hns_roce_alloc_db);
>> +
>> +void hns_roce_free_db(struct hns_roce_dev *hr_dev, struct hns_roce_db *db)
>> +{
>> +	int o;
>> +	int i;
>> +
>> +	mutex_lock(&hr_dev->pgdir_mutex);
>> +
>> +	o = db->order;
>> +	i = db->index;
>> +
>> +	if (db->order == 0 && test_bit(i ^ 1, db->u.pgdir->order0)) {
>> +		clear_bit(i ^ 1, db->u.pgdir->order0);
>> +		++o;
>> +	}
>> +
>> +	i >>= o;
>> +	set_bit(i, db->u.pgdir->bits[o]);
>> +
>> +	if (bitmap_full(db->u.pgdir->order1, HNS_ROCE_DB_PER_PAGE / 2)) {
>> +		dma_free_coherent(hr_dev->dev, PAGE_SIZE, db->u.pgdir->db_page,
>> +				  db->u.pgdir->db_dma);
>> +		list_del(&db->u.pgdir->list);
>> +		kfree(db->u.pgdir);
>> +	}
>> +
>> +	mutex_unlock(&hr_dev->pgdir_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(hns_roce_free_db);
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 9ee6da6..dd48559 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -761,6 +761,8 @@ struct hns_roce_dev {
>>  	spinlock_t		bt_cmd_lock;
>>  	struct hns_roce_ib_iboe iboe;
>>
>> +	struct list_head        pgdir_list;
>> +	struct mutex            pgdir_mutex;
>>  	int			irq[HNS_ROCE_MAX_IRQ_NUM];
>>  	u8 __iomem		*reg_base;
>>  	struct hns_roce_caps	caps;
>> @@ -970,6 +972,10 @@ int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
>>  			 struct hns_roce_db *db);
>>  void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
>>  			    struct hns_roce_db *db);
>> +int hns_roce_alloc_db(struct hns_roce_dev *hr_dev, struct hns_roce_db *db,
>> +		      int order, gfp_t gfp);
>> +void hns_roce_free_db(struct hns_roce_dev *hr_dev, struct hns_roce_db *db);
>> +
>>  void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
>>  void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
>>  void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index 07129d2..cb0e5ee 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -470,7 +470,6 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>>  	struct hns_roce_v2_wqe_data_seg *dseg;
>>  	struct hns_roce_rinl_sge *sge_list;
>>  	struct device *dev = hr_dev->dev;
>> -	struct hns_roce_v2_db rq_db;
>>  	unsigned long flags;
>>  	void *wqe = NULL;
>>  	int ret = 0;
>> @@ -536,17 +535,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>>  		/* Memory barrier */
>>  		wmb();
>>
>> -		rq_db.byte_4 = 0;
>> -		rq_db.parameter = 0;
>> -
>> -		roce_set_field(rq_db.byte_4, V2_DB_BYTE_4_TAG_M,
>> -			       V2_DB_BYTE_4_TAG_S, hr_qp->qpn);
>> -		roce_set_field(rq_db.byte_4, V2_DB_BYTE_4_CMD_M,
>> -			       V2_DB_BYTE_4_CMD_S, HNS_ROCE_V2_RQ_DB);
>> -		roce_set_field(rq_db.parameter, V2_DB_PARAMETER_CONS_IDX_M,
>> -			       V2_DB_PARAMETER_CONS_IDX_S, hr_qp->rq.head);
>> -
>> -		hns_roce_write64_k((__be32 *)&rq_db, hr_qp->rq.db_reg_l);
>> +		*hr_qp->rdb.db_record = hr_qp->rq.head & 0xffff;
>>  	}
>>  	spin_unlock_irqrestore(&hr_qp->rq.lock, flags);
>>
>> @@ -3443,6 +3432,8 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
>>  		kfree(hr_qp->sq.wrid);
>>  		kfree(hr_qp->rq.wrid);
>>  		hns_roce_buf_free(hr_dev, hr_qp->buff_size, &hr_qp->hr_buf);
>> +		if (hr_qp->rq.wqe_cnt)
>> +			hns_roce_free_db(hr_dev, &hr_qp->rdb);
>>  	}
>>
>>  	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
>> index dd7d882..7f4dd22d 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
>> @@ -665,6 +665,11 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
>>  	spin_lock_init(&hr_dev->sm_lock);
>>  	spin_lock_init(&hr_dev->bt_cmd_lock);
>>
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
>> +		INIT_LIST_HEAD(&hr_dev->pgdir_list);
>> +		mutex_init(&hr_dev->pgdir_mutex);
>> +	}
>> +
>>  	ret = hns_roce_init_uar_table(hr_dev);
>>  	if (ret) {
>>  		dev_err(dev, "Failed to initialize uar table. aborting\n");
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
>> index 300f760..4f7d2d1 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
>> @@ -650,6 +650,17 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  		hr_qp->rq.db_reg_l = hr_dev->reg_base + hr_dev->odb_offset +
>>  				     DB_REG_OFFSET * hr_dev->priv_uar.index;
>>
>> +		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
>> +		    hns_roce_qp_has_rq(init_attr)) {
>> +			ret = hns_roce_alloc_db(hr_dev, &hr_qp->rdb, 0,
>> +						GFP_KERNEL);
>> +			if (ret) {
>> +				dev_err(dev, "rq record doorbell alloc failed!\n");
>> +				goto err_rq_sge_list;
>> +			}
>> +			*hr_qp->rdb.db_record = 0;
>> +		}
>> +
>>  		/* Allocate QP buf */
>>  		page_shift = PAGE_SHIFT + hr_dev->caps.mtt_buf_pg_sz;
>>  		if (hns_roce_buf_alloc(hr_dev, hr_qp->buff_size,
>> @@ -657,7 +668,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  				       &hr_qp->hr_buf, page_shift)) {
>>  			dev_err(dev, "hns_roce_buf_alloc error!\n");
>>  			ret = -ENOMEM;
>> -			goto err_rq_sge_list;
>> +			goto err_db;
>>  		}
>>
>>  		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
>> @@ -747,6 +758,11 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
>>  	else
>>  		hns_roce_buf_free(hr_dev, hr_qp->buff_size, &hr_qp->hr_buf);
>>
>> +err_db:
>> +	if (!ib_pd->uobject && hns_roce_qp_has_rq(init_attr) &&
>> +	    (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB))
>> +		hns_roce_free_db(hr_dev, &hr_qp->rdb);
>> +
>>  err_rq_sge_list:
>>  	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE)
>>  		kfree(hr_qp->rq_inl_buf.wqe_list[0].sg_list);
>> --
>> 1.9.1
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
