From: Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 05/24] ibtrs: client: main functionality
Date: Mon, 5 Feb 2018 15:19:12 +0100
Message-ID: <CAJrWOzBRar_YjYJMYcmk7tr7o+L7TdrXLv78dL84zV2zvTDJGQ@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-6-roman.penyaev@profitbricks.com> <c593c579-c5b9-8a3e-10dd-c7731b91b55a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c593c579-c5b9-8a3e-10dd-c7731b91b55a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On Mon, Feb 5, 2018 at 12:19 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> Hi Roman,
>
>> +static inline void ibtrs_clt_state_lock(void)
>> +{
>> +       rcu_read_lock();
>> +}
>> +
>> +static inline void ibtrs_clt_state_unlock(void)
>> +{
>> +       rcu_read_unlock();
>> +}
>
>
> This looks rather pointless...

Yeah, old scraps.  Some time later those were not only wrappers
around rcu.  Now rcu can be called explicitly, that is true.
Thanks.

>
>> +
>> +#define cmpxchg_min(var, new) ({                                       \
>> +       typeof(var) old;                                                \
>> +                                                                       \
>> +       do {                                                            \
>> +               old = var;                                              \
>> +               new = (!old ? new : min_t(typeof(var), old, new));      \
>> +       } while (cmpxchg(&var, old, new) != old);                       \
>> +})
>
>
> Why is this sort of thing local to your driver?

Good question :)  Most likely because personally I do not know
what is the good generic place for this kind of stuff.

Probably I share the same feeling with the author of these lines
in nvme/host/rdma.c: put_unaligned_le24() :)

>> +/**
>> + * struct ibtrs_fr_pool - pool of fast registration descriptors
>> + *
>> + * An entry is available for allocation if and only if it occurs in
>> @free_list.
>> + *
>> + * @size:      Number of descriptors in this pool.
>> + * @max_page_list_len: Maximum fast registration work request page list
>> length.
>> + * @lock:      Protects free_list.
>> + * @free_list: List of free descriptors.
>> + * @desc:      Fast registration descriptor pool.
>> + */
>> +struct ibtrs_fr_pool {
>> +       int                     size;
>> +       int                     max_page_list_len;
>> +       spinlock_t              lock; /* protects free_list */
>> +       struct list_head        free_list;
>> +       struct ibtrs_fr_desc    desc[0];
>> +};
>
>
> We already have a per-qp fr list implementation, any specific reason to
> implement it again?

No, fr is a part of the code which we are not using, fmr is faster
in our setup.  So we will need to reiterate on fr mode, thanks.


>> +static inline struct ibtrs_tag *
>> +__ibtrs_get_tag(struct ibtrs_clt *clt, enum ibtrs_clt_con_type con_type)
>> +{
>> +       size_t max_depth = clt->queue_depth;
>> +       struct ibtrs_tag *tag;
>> +       int cpu, bit;
>> +
>> +       cpu = get_cpu();
>> +       do {
>> +               bit = find_first_zero_bit(clt->tags_map, max_depth);
>> +               if (unlikely(bit >= max_depth)) {
>> +                       put_cpu();
>> +                       return NULL;
>> +               }
>> +
>> +       } while (unlikely(test_and_set_bit_lock(bit, clt->tags_map)));
>> +       put_cpu();
>> +
>> +       tag = GET_TAG(clt, bit);
>> +       WARN_ON(tag->mem_id != bit);
>> +       tag->cpu_id = cpu;
>> +       tag->con_type = con_type;
>> +
>> +       return tag;
>> +}
>> +
>> +static inline void __ibtrs_put_tag(struct ibtrs_clt *clt,
>> +                                  struct ibtrs_tag *tag)
>> +{
>> +       clear_bit_unlock(tag->mem_id, clt->tags_map);
>> +}
>> +
>> +struct ibtrs_tag *ibtrs_clt_get_tag(struct ibtrs_clt *clt,
>> +                                   enum ibtrs_clt_con_type con_type,
>> +                                   int can_wait)
>> +{
>> +       struct ibtrs_tag *tag;
>> +       DEFINE_WAIT(wait);
>> +
>> +       tag = __ibtrs_get_tag(clt, con_type);
>> +       if (likely(tag) || !can_wait)
>> +               return tag;
>> +
>> +       do {
>> +               prepare_to_wait(&clt->tags_wait, &wait,
>> TASK_UNINTERRUPTIBLE);
>> +               tag = __ibtrs_get_tag(clt, con_type);
>> +               if (likely(tag))
>> +                       break;
>> +
>> +               io_schedule();
>> +       } while (1);
>> +
>> +       finish_wait(&clt->tags_wait, &wait);
>> +
>> +       return tag;
>> +}
>> +EXPORT_SYMBOL(ibtrs_clt_get_tag);
>> +
>> +void ibtrs_clt_put_tag(struct ibtrs_clt *clt, struct ibtrs_tag *tag)
>> +{
>> +       if (WARN_ON(!test_bit(tag->mem_id, clt->tags_map)))
>> +               return;
>> +
>> +       __ibtrs_put_tag(clt, tag);
>> +
>> +       /*
>> +        * Putting a tag is a barrier, so we will observe
>> +        * new entry in the wait list, no worries.
>> +        */
>> +       if (waitqueue_active(&clt->tags_wait))
>> +               wake_up(&clt->tags_wait);
>> +}
>> +EXPORT_SYMBOL(ibtrs_clt_put_tag);
>
>
> Again, the tags are not clear why they are needed...

We have two separate instances: block device (IBNBD) and a transport
library (IBTRS).  Many block devices share the same IBTRS session
with fixed size queue depth.  Tags is a part of IBTRS, so with allocated
tag you get a free slot of a buffer where you can read/write, so once
you've allocated a tag you won't sleep on IO path inside a library.
Also tag helps a lot on IO fail-over to another connection (multipath
implementation, which is also a part of the transport library, not a
block device), where you simply reuse the same buffer slot (with a tag
in your hands) forwarding IO to another RDMA connection.

>> +/**
>> + * ibtrs_destroy_fr_pool() - free the resources owned by a pool
>> + * @pool: Fast registration pool to be destroyed.
>> + */
>> +static void ibtrs_destroy_fr_pool(struct ibtrs_fr_pool *pool)
>> +{
>> +       struct ibtrs_fr_desc *d;
>> +       int i, err;
>> +
>> +       if (!pool)
>> +               return;
>> +
>> +       for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
>> +               if (d->mr) {
>> +                       err = ib_dereg_mr(d->mr);
>> +                       if (err)
>> +                               pr_err("Failed to deregister memory
>> region,"
>> +                                      " err: %d\n", err);
>> +               }
>> +       }
>> +       kfree(pool);
>> +}
>> +
>> +/**
>> + * ibtrs_create_fr_pool() - allocate and initialize a pool for fast
>> registration
>> + * @device:            IB device to allocate fast registration
>> descriptors for.
>> + * @pd:                Protection domain associated with the FR
>> descriptors.
>> + * @pool_size:         Number of descriptors to allocate.
>> + * @max_page_list_len: Maximum fast registration work request page list
>> length.
>> + */
>> +static struct ibtrs_fr_pool *ibtrs_create_fr_pool(struct ib_device
>> *device,
>> +                                                 struct ib_pd *pd,
>> +                                                 int pool_size,
>> +                                                 int max_page_list_len)
>> +{
>> +       struct ibtrs_fr_pool *pool;
>> +       struct ibtrs_fr_desc *d;
>> +       struct ib_mr *mr;
>> +       int i, ret;
>> +
>> +       if (pool_size <= 0) {
>> +               pr_warn("Creating fr pool failed, invalid pool size %d\n",
>> +                       pool_size);
>> +               ret = -EINVAL;
>> +               goto err;
>> +       }
>> +
>> +       pool = kzalloc(sizeof(*pool) + pool_size * sizeof(*d),
>> GFP_KERNEL);
>> +       if (!pool) {
>> +               ret = -ENOMEM;
>> +               goto err;
>> +       }
>> +
>> +       pool->size = pool_size;
>> +       pool->max_page_list_len = max_page_list_len;
>> +       spin_lock_init(&pool->lock);
>> +       INIT_LIST_HEAD(&pool->free_list);
>> +
>> +       for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
>> +               mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
>> max_page_list_len);
>> +               if (IS_ERR(mr)) {
>> +                       pr_warn("Failed to allocate fast region
>> memory\n");
>> +                       ret = PTR_ERR(mr);
>> +                       goto destroy_pool;
>> +               }
>> +               d->mr = mr;
>> +               list_add_tail(&d->entry, &pool->free_list);
>> +       }
>> +
>> +       return pool;
>> +
>> +destroy_pool:
>> +       ibtrs_destroy_fr_pool(pool);
>> +err:
>> +       return ERR_PTR(ret);
>> +}
>> +
>> +/**
>> + * ibtrs_fr_pool_get() - obtain a descriptor suitable for fast
>> registration
>> + * @pool: Pool to obtain descriptor from.
>> + */
>> +static struct ibtrs_fr_desc *ibtrs_fr_pool_get(struct ibtrs_fr_pool
>> *pool)
>> +{
>> +       struct ibtrs_fr_desc *d = NULL;
>> +
>> +       spin_lock_bh(&pool->lock);
>> +       if (!list_empty(&pool->free_list)) {
>> +               d = list_first_entry(&pool->free_list, typeof(*d), entry);
>> +               list_del(&d->entry);
>> +       }
>> +       spin_unlock_bh(&pool->lock);
>> +
>> +       return d;
>> +}
>> +
>> +/**
>> + * ibtrs_fr_pool_put() - put an FR descriptor back in the free list
>> + * @pool: Pool the descriptor was allocated from.
>> + * @desc: Pointer to an array of fast registration descriptor pointers.
>> + * @n:    Number of descriptors to put back.
>> + *
>> + * Note: The caller must already have queued an invalidation request for
>> + * desc->mr->rkey before calling this function.
>> + */
>> +static void ibtrs_fr_pool_put(struct ibtrs_fr_pool *pool,
>> +                             struct ibtrs_fr_desc **desc, int n)
>> +{
>> +       int i;
>> +
>> +       spin_lock_bh(&pool->lock);
>> +       for (i = 0; i < n; i++)
>> +               list_add(&desc[i]->entry, &pool->free_list);
>> +       spin_unlock_bh(&pool->lock);
>> +}
>> +
>> +static void ibtrs_map_desc(struct ibtrs_map_state *state, dma_addr_t
>> dma_addr,
>> +                          u32 dma_len, u32 rkey, u32 max_desc)
>> +{
>> +       struct ibtrs_sg_desc *desc = state->desc;
>> +
>> +       pr_debug("dma_addr %llu, key %u, dma_len %u\n",
>> +                dma_addr, rkey, dma_len);
>> +       desc->addr = cpu_to_le64(dma_addr);
>> +       desc->key  = cpu_to_le32(rkey);
>> +       desc->len  = cpu_to_le32(dma_len);
>> +
>> +       state->total_len += dma_len;
>> +       if (state->ndesc < max_desc) {
>> +               state->desc++;
>> +               state->ndesc++;
>> +       } else {
>> +               state->ndesc = INT_MIN;
>> +               pr_err("Could not fit S/G list into buffer descriptor
>> %d.\n",
>> +                      max_desc);
>> +       }
>> +}
>> +
>> +static int ibtrs_map_finish_fmr(struct ibtrs_map_state *state,
>> +                               struct ibtrs_clt_con *con)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       struct ib_pool_fmr *fmr;
>> +       dma_addr_t dma_addr;
>> +       u64 io_addr = 0;
>> +
>> +       fmr = ib_fmr_pool_map_phys(sess->fmr_pool, state->pages,
>> +                                  state->npages, io_addr);
>> +       if (IS_ERR(fmr)) {
>> +               ibtrs_wrn_rl(sess, "Failed to map FMR from FMR pool, "
>> +                            "err: %ld\n", PTR_ERR(fmr));
>> +               return PTR_ERR(fmr);
>> +       }
>> +
>> +       *state->next_fmr++ = fmr;
>> +       state->nmdesc++;
>> +       dma_addr = state->base_dma_addr & ~sess->mr_page_mask;
>> +       pr_debug("ndesc = %d, nmdesc = %d, npages = %d\n",
>> +                state->ndesc, state->nmdesc, state->npages);
>> +       if (state->dir == DMA_TO_DEVICE)
>> +               ibtrs_map_desc(state, dma_addr, state->dma_len,
>> fmr->fmr->lkey,
>> +                              sess->max_desc);
>> +       else
>> +               ibtrs_map_desc(state, dma_addr, state->dma_len,
>> fmr->fmr->rkey,
>> +                              sess->max_desc);
>> +
>> +       return 0;
>> +}
>> +
>> +static void ibtrs_clt_fast_reg_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +       struct ibtrs_clt_con *con = cq->cq_context;
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +
>> +       if (unlikely(wc->status != IB_WC_SUCCESS)) {
>> +               ibtrs_err(sess, "Failed IB_WR_REG_MR: %s\n",
>> +                         ib_wc_status_msg(wc->status));
>> +               ibtrs_rdma_error_recovery(con);
>> +       }
>> +}
>> +
>> +static struct ib_cqe fast_reg_cqe = {
>> +       .done = ibtrs_clt_fast_reg_done
>> +};
>> +
>> +/* TODO */
>> +static int ibtrs_map_finish_fr(struct ibtrs_map_state *state,
>> +                              struct ibtrs_clt_con *con, int sg_cnt,
>> +                              unsigned int *sg_offset_p)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       struct ibtrs_fr_desc *desc;
>> +       struct ib_send_wr *bad_wr;
>> +       struct ib_reg_wr wr;
>> +       struct ib_pd *pd;
>> +       u32 rkey;
>> +       int n;
>> +
>> +       pd = sess->s.ib_dev->pd;
>> +       if (sg_cnt == 1 && (pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)) {
>> +               unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
>> +
>> +               ibtrs_map_desc(state, sg_dma_address(state->sg) +
>> sg_offset,
>> +                              sg_dma_len(state->sg) - sg_offset,
>> +                              pd->unsafe_global_rkey, sess->max_desc);
>> +               if (sg_offset_p)
>> +                       *sg_offset_p = 0;
>> +               return 1;
>> +       }
>> +
>> +       desc = ibtrs_fr_pool_get(con->fr_pool);
>> +       if (!desc) {
>> +               ibtrs_wrn_rl(sess, "Failed to get descriptor from FR
>> pool\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       rkey = ib_inc_rkey(desc->mr->rkey);
>> +       ib_update_fast_reg_key(desc->mr, rkey);
>> +
>> +       memset(&wr, 0, sizeof(wr));
>> +       n = ib_map_mr_sg(desc->mr, state->sg, sg_cnt, sg_offset_p,
>> +                        sess->mr_page_size);
>> +       if (unlikely(n < 0)) {
>> +               ibtrs_fr_pool_put(con->fr_pool, &desc, 1);
>> +               return n;
>> +       }
>> +
>> +       wr.wr.next = NULL;
>> +       wr.wr.opcode = IB_WR_REG_MR;
>> +       wr.wr.wr_cqe = &fast_reg_cqe;
>> +       wr.wr.num_sge = 0;
>> +       wr.wr.send_flags = 0;
>> +       wr.mr = desc->mr;
>> +       wr.key = desc->mr->rkey;
>> +       wr.access = (IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE);
>
>
> Do you actually ever have remote write access in your protocol?

We do not have reads, instead client writes on write and server writes
on read. (write only storage solution :)

>
>> +static void ibtrs_clt_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +       struct ibtrs_clt_con *con = cq->cq_context;
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +
>> +       if (unlikely(wc->status != IB_WC_SUCCESS)) {
>> +               ibtrs_err(sess, "Failed IB_WR_LOCAL_INV: %s\n",
>> +                         ib_wc_status_msg(wc->status));
>> +               ibtrs_rdma_error_recovery(con);
>> +       }
>> +}
>> +
>> +static struct ib_cqe local_inv_cqe = {
>> +       .done = ibtrs_clt_inv_rkey_done
>> +};
>> +
>> +static int ibtrs_inv_rkey(struct ibtrs_clt_con *con, u32 rkey)
>> +{
>> +       struct ib_send_wr *bad_wr;
>> +       struct ib_send_wr wr = {
>> +               .opcode             = IB_WR_LOCAL_INV,
>> +               .wr_cqe             = &local_inv_cqe,
>> +               .next               = NULL,
>> +               .num_sge            = 0,
>> +               .send_flags         = 0,
>> +               .ex.invalidate_rkey = rkey,
>> +       };
>> +
>> +       return ib_post_send(con->c.qp, &wr, &bad_wr);
>> +}
>
>
> Is not signalling the local invalidate safe? A recent report
> suggested that this is not safe in the presence of ack drops.

For our setup we use fmr, so frankly I do not follow any fr discussions.
Could you please provide the link?

>> +static int ibtrs_post_send_rdma(struct ibtrs_clt_con *con,
>> +                               struct ibtrs_clt_io_req *req,
>> +                               u64 addr, u32 off, u32 imm)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       enum ib_send_flags flags;
>> +       struct ib_sge list[1];
>> +
>> +       if (unlikely(!req->sg_size)) {
>> +               ibtrs_wrn(sess, "Doing RDMA Write failed, no data
>> supplied\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* user data and user message in the first list element */
>> +       list[0].addr   = req->iu->dma_addr;
>> +       list[0].length = req->sg_size;
>> +       list[0].lkey   = sess->s.ib_dev->lkey;
>> +
>> +       /*
>> +        * From time to time we have to post signalled sends,
>> +        * or send queue will fill up and only QP reset can help.
>> +        */
>> +       flags = atomic_inc_return(&con->io_cnt) % sess->queue_depth ?
>> +                       0 : IB_SEND_SIGNALED;
>> +       return ibtrs_iu_post_rdma_write_imm(&con->c, req->iu, list, 1,
>> +                                           sess->srv_rdma_buf_rkey,
>> +                                           addr + off, imm, flags);
>> +}
>> +
>> +static void ibtrs_set_sge_with_desc(struct ib_sge *list,
>> +                                   struct ibtrs_sg_desc *desc)
>> +{
>> +       list->addr   = le64_to_cpu(desc->addr);
>> +       list->length = le32_to_cpu(desc->len);
>> +       list->lkey   = le32_to_cpu(desc->key);
>> +       pr_debug("dma_addr %llu, key %u, dma_len %u\n",
>> +                list->addr, list->lkey, list->length);
>> +}
>> +
>> +static void ibtrs_set_rdma_desc_last(struct ibtrs_clt_con *con,
>> +                                    struct ib_sge *list,
>> +                                    struct ibtrs_clt_io_req *req,
>> +                                    struct ib_rdma_wr *wr, int offset,
>> +                                    struct ibtrs_sg_desc *desc, int m,
>> +                                    int n, u64 addr, u32 size, u32 imm)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       enum ib_send_flags flags;
>> +       int i;
>> +
>> +       for (i = m; i < n; i++, desc++)
>> +               ibtrs_set_sge_with_desc(&list[i], desc);
>> +
>> +       list[i].addr   = req->iu->dma_addr;
>> +       list[i].length = size;
>> +       list[i].lkey   = sess->s.ib_dev->lkey;
>> +
>> +       wr->wr.wr_cqe = &req->iu->cqe;
>> +       wr->wr.sg_list = &list[m];
>> +       wr->wr.num_sge = n - m + 1;
>> +       wr->remote_addr = addr + offset;
>> +       wr->rkey = sess->srv_rdma_buf_rkey;
>> +
>> +       /*
>> +        * From time to time we have to post signalled sends,
>> +        * or send queue will fill up and only QP reset can help.
>> +        */
>> +       flags = atomic_inc_return(&con->io_cnt) % sess->queue_depth ?
>> +                       0 : IB_SEND_SIGNALED;
>> +
>> +       wr->wr.opcode = IB_WR_RDMA_WRITE_WITH_IMM;
>> +       wr->wr.send_flags  = flags;
>> +       wr->wr.ex.imm_data = cpu_to_be32(imm);
>> +}
>> +
>> +static int ibtrs_post_send_rdma_desc_more(struct ibtrs_clt_con *con,
>> +                                         struct ib_sge *list,
>> +                                         struct ibtrs_clt_io_req *req,
>> +                                         struct ibtrs_sg_desc *desc, int
>> n,
>> +                                         u64 addr, u32 size, u32 imm)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       size_t max_sge, num_sge, num_wr;
>> +       struct ib_send_wr *bad_wr;
>> +       struct ib_rdma_wr *wrs, *wr;
>> +       int j = 0, k, offset = 0, len = 0;
>> +       int m = 0;
>> +       int ret;
>> +
>> +       max_sge = sess->max_sge;
>> +       num_sge = 1 + n;
>> +       num_wr = DIV_ROUND_UP(num_sge, max_sge);
>> +
>> +       wrs = kcalloc(num_wr, sizeof(*wrs), GFP_ATOMIC);
>> +       if (!wrs)
>> +               return -ENOMEM;
>> +
>> +       if (num_wr == 1)
>> +               goto last_one;
>> +
>> +       for (; j < num_wr; j++) {
>> +               wr = &wrs[j];
>> +               for (k = 0; k < max_sge; k++, desc++) {
>> +                       m = k + j * max_sge;
>> +                       ibtrs_set_sge_with_desc(&list[m], desc);
>> +                       len += le32_to_cpu(desc->len);
>> +               }
>> +               wr->wr.wr_cqe = &req->iu->cqe;
>> +               wr->wr.sg_list = &list[m];
>> +               wr->wr.num_sge = max_sge;
>> +               wr->remote_addr = addr + offset;
>> +               wr->rkey = sess->srv_rdma_buf_rkey;
>> +
>> +               offset += len;
>> +               wr->wr.next = &wrs[j + 1].wr;
>> +               wr->wr.opcode = IB_WR_RDMA_WRITE;
>> +       }
>> +
>> +last_one:
>> +       wr = &wrs[j];
>> +
>> +       ibtrs_set_rdma_desc_last(con, list, req, wr, offset,
>> +                                desc, m, n, addr, size, imm);
>> +
>> +       ret = ib_post_send(con->c.qp, &wrs[0].wr, &bad_wr);
>> +       if (unlikely(ret))
>> +               ibtrs_err(sess, "Posting write request to QP failed,"
>> +                         " err: %d\n", ret);
>> +       kfree(wrs);
>> +       return ret;
>> +}
>> +
>> +static int ibtrs_post_send_rdma_desc(struct ibtrs_clt_con *con,
>> +                                    struct ibtrs_clt_io_req *req,
>> +                                    struct ibtrs_sg_desc *desc, int n,
>> +                                    u64 addr, u32 size, u32 imm)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       enum ib_send_flags flags;
>> +       struct ib_sge *list;
>> +       size_t num_sge;
>> +       int ret, i;
>> +
>> +       num_sge = 1 + n;
>> +       list = kmalloc_array(num_sge, sizeof(*list), GFP_ATOMIC);
>> +       if (!list)
>> +               return -ENOMEM;
>> +
>> +       if (num_sge < sess->max_sge) {
>> +               for (i = 0; i < n; i++, desc++)
>> +                       ibtrs_set_sge_with_desc(&list[i], desc);
>> +               list[i].addr   = req->iu->dma_addr;
>> +               list[i].length = size;
>> +               list[i].lkey   = sess->s.ib_dev->lkey;
>> +
>> +               /*
>> +                * From time to time we have to post signalled sends,
>> +                * or send queue will fill up and only QP reset can help.
>> +                */
>> +               flags = atomic_inc_return(&con->io_cnt) %
>> sess->queue_depth ?
>> +                               0 : IB_SEND_SIGNALED;
>> +               ret = ibtrs_iu_post_rdma_write_imm(&con->c, req->iu, list,
>> +                                                  num_sge,
>> +
>> sess->srv_rdma_buf_rkey,
>> +                                                  addr, imm, flags);
>> +       } else {
>> +               ret = ibtrs_post_send_rdma_desc_more(con, list, req, desc,
>> n,
>> +                                                    addr, size, imm);
>> +       }
>> +
>> +       kfree(list);
>> +       return ret;
>> +}
>> +
>> +static int ibtrs_post_send_rdma_more(struct ibtrs_clt_con *con,
>> +                                    struct ibtrs_clt_io_req *req,
>> +                                    u64 addr, u32 size, u32 imm)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       struct ib_device *ibdev = sess->s.ib_dev->dev;
>> +       enum ib_send_flags flags;
>> +       struct scatterlist *sg;
>> +       struct ib_sge *list;
>> +       size_t num_sge;
>> +       int i, ret;
>> +
>> +       num_sge = 1 + req->sg_cnt;
>> +       list = kmalloc_array(num_sge, sizeof(*list), GFP_ATOMIC);
>> +       if (!list)
>> +               return -ENOMEM;
>> +
>> +       for_each_sg(req->sglist, sg, req->sg_cnt, i) {
>> +               list[i].addr   = ib_sg_dma_address(ibdev, sg);
>> +               list[i].length = ib_sg_dma_len(ibdev, sg);
>> +               list[i].lkey   = sess->s.ib_dev->lkey;
>> +       }
>> +       list[i].addr   = req->iu->dma_addr;
>> +       list[i].length = size;
>> +       list[i].lkey   = sess->s.ib_dev->lkey;
>> +
>> +       /*
>> +        * From time to time we have to post signalled sends,
>> +        * or send queue will fill up and only QP reset can help.
>> +        */
>> +       flags = atomic_inc_return(&con->io_cnt) % sess->queue_depth ?
>> +                       0 : IB_SEND_SIGNALED;
>> +       ret = ibtrs_iu_post_rdma_write_imm(&con->c, req->iu, list,
>> num_sge,
>> +                                          sess->srv_rdma_buf_rkey,
>> +                                          addr, imm, flags);
>> +       kfree(list);
>> +
>> +       return ret;
>> +}
>
>
> All these rdma halpers looks like that can be reused from the rdma rw
> API if it was enhanced with immediate capabilities.

True.

>> +static inline unsigned long ibtrs_clt_get_raw_ms(void)
>> +{
>> +       struct timespec ts;
>> +
>> +       getrawmonotonic(&ts);
>> +
>> +       return timespec_to_ns(&ts) / NSEC_PER_MSEC;
>> +}
>
>
> Why is this local to your driver?
>
>> +
>> +static void complete_rdma_req(struct ibtrs_clt_io_req *req,
>> +                             int errno, bool notify)
>> +{
>> +       struct ibtrs_clt_con *con = req->con;
>> +       struct ibtrs_clt_sess *sess;
>> +       enum dma_data_direction dir;
>> +       struct ibtrs_clt *clt;
>> +       void *priv;
>> +
>> +       if (WARN_ON(!req->in_use))
>> +               return;
>> +       if (WARN_ON(!req->con))
>> +               return;
>> +       sess = to_clt_sess(con->c.sess);
>> +       clt = sess->clt;
>> +
>> +       if (req->sg_cnt > fmr_sg_cnt)
>> +               ibtrs_unmap_fast_reg_data(req->con, req);
>> +       if (req->sg_cnt)
>> +               ib_dma_unmap_sg(sess->s.ib_dev->dev, req->sglist,
>> +                               req->sg_cnt, req->dir);
>> +       if (sess->stats.enable_rdma_lat)
>> +               ibtrs_clt_update_rdma_lat(&sess->stats,
>> +                                         req->dir == DMA_FROM_DEVICE,
>> +                                         ibtrs_clt_get_raw_ms() -
>> +                                         req->start_time);
>> +       ibtrs_clt_decrease_inflight(&sess->stats);
>> +
>> +       req->in_use = false;
>> +       req->con = NULL;
>> +       priv = req->priv;
>> +       dir = req->dir;
>> +
>> +       if (notify)
>> +               req->conf(priv, errno);
>> +}
>
>
>
>
>> +
>> +static void process_io_rsp(struct ibtrs_clt_sess *sess, u32 msg_id, s16
>> errno)
>> +{
>> +       if (WARN_ON(msg_id >= sess->queue_depth))
>> +               return;
>> +
>> +       complete_rdma_req(&sess->reqs[msg_id], errno, true);
>> +}
>> +
>> +static struct ib_cqe io_comp_cqe = {
>> +       .done = ibtrs_clt_rdma_done
>> +};
>> +
>> +static void ibtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +       struct ibtrs_clt_con *con = cq->cq_context;
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       u32 imm_type, imm_payload;
>> +       int err;
>> +
>> +       if (unlikely(wc->status != IB_WC_SUCCESS)) {
>> +               if (wc->status != IB_WC_WR_FLUSH_ERR) {
>> +                       ibtrs_err(sess, "RDMA failed: %s\n",
>> +                                 ib_wc_status_msg(wc->status));
>> +                       ibtrs_rdma_error_recovery(con);
>> +               }
>> +               return;
>> +       }
>> +       ibtrs_clt_update_wc_stats(con);
>> +
>> +       switch (wc->opcode) {
>> +       case IB_WC_RDMA_WRITE:
>> +               /*
>> +                * post_send() RDMA write completions of IO reqs
>> (read/write)
>> +                * and hb
>> +                */
>> +               break;
>> +       case IB_WC_RECV_RDMA_WITH_IMM:
>> +               /*
>> +                * post_recv() RDMA write completions of IO reqs
>> (read/write)
>> +                * and hb
>> +                */
>> +               if (WARN_ON(wc->wr_cqe != &io_comp_cqe))
>> +                       return;
>> +               err = ibtrs_post_recv_empty(&con->c, &io_comp_cqe);
>> +               if (unlikely(err)) {
>> +                       ibtrs_err(sess, "ibtrs_post_recv_empty(): %d\n",
>> err);
>> +                       ibtrs_rdma_error_recovery(con);
>> +                       break;
>> +               }
>> +               ibtrs_from_imm(be32_to_cpu(wc->ex.imm_data),
>> +                              &imm_type, &imm_payload);
>> +               if (likely(imm_type == IBTRS_IO_RSP_IMM)) {
>> +                       u32 msg_id;
>> +
>> +                       ibtrs_from_io_rsp_imm(imm_payload, &msg_id, &err);
>> +                       process_io_rsp(sess, msg_id, err);
>> +               } else if (imm_type == IBTRS_HB_MSG_IMM) {
>> +                       WARN_ON(con->c.cid);
>> +                       ibtrs_send_hb_ack(&sess->s);
>> +               } else if (imm_type == IBTRS_HB_ACK_IMM) {
>> +                       WARN_ON(con->c.cid);
>> +                       sess->s.hb_missed_cnt = 0;
>> +               } else {
>> +                       ibtrs_wrn(sess, "Unknown IMM type %u\n",
>> imm_type);
>> +               }
>> +               break;
>> +       default:
>> +               ibtrs_wrn(sess, "Unexpected WC type: %s\n",
>> +                         ib_wc_opcode_str(wc->opcode));
>> +               return;
>> +       }
>
>
> Is there a spec somewhere with the protocol information that explains
> how this all works?

Not yet.  The transfer procedure is described in vault presentation.
Is README is a good place for such stuff?  I mean some low-level
protocol spec.

>> +struct path_it {
>> +       int i;
>> +       struct list_head skip_list;
>> +       struct ibtrs_clt *clt;
>> +       struct ibtrs_clt_sess *(*next_path)(struct path_it *);
>> +};
>> +
>> +#define do_each_path(path, clt, it) {                                  \
>> +       path_it_init(it, clt);                                          \
>> +       ibtrs_clt_state_lock();                                         \
>> +       for ((it)->i = 0; ((path) = ((it)->next_path)(it)) &&           \
>> +                         (it)->i < (it)->clt->paths_num;               \
>> +            (it)->i++)
>> +
>> +#define while_each_path(it)                                            \
>> +       path_it_deinit(it);                                             \
>> +       ibtrs_clt_state_unlock();                                       \
>> +       }
>> +
>> +/**
>> + * get_next_path_rr() - Returns path in round-robin fashion.
>> + *
>> + * Related to @MP_POLICY_RR
>> + *
>> + * Locks:
>> + *    ibtrs_clt_state_lock() must be hold.
>> + */
>> +static struct ibtrs_clt_sess *get_next_path_rr(struct path_it *it)
>> +{
>> +       struct ibtrs_clt_sess __percpu * __rcu *ppcpu_path, *path;
>> +       struct ibtrs_clt *clt = it->clt;
>> +
>> +       ppcpu_path = this_cpu_ptr(clt->pcpu_path);
>> +       path = rcu_dereference(*ppcpu_path);
>> +       if (unlikely(!path))
>> +               path = list_first_or_null_rcu(&clt->paths_list,
>> +                                             typeof(*path), s.entry);
>> +       else
>> +               path = list_next_or_null_rcu_rr(path, &clt->paths_list,
>> +                                               s.entry);
>> +       rcu_assign_pointer(*ppcpu_path, path);
>> +
>> +       return path;
>> +}
>> +
>> +/**
>> + * get_next_path_min_inflight() - Returns path with minimal inflight
>> count.
>> + *
>> + * Related to @MP_POLICY_MIN_INFLIGHT
>> + *
>> + * Locks:
>> + *    ibtrs_clt_state_lock() must be hold.
>> + */
>> +static struct ibtrs_clt_sess *get_next_path_min_inflight(struct path_it
>> *it)
>> +{
>> +       struct ibtrs_clt_sess *min_path = NULL;
>> +       struct ibtrs_clt *clt = it->clt;
>> +       struct ibtrs_clt_sess *sess;
>> +       int min_inflight = INT_MAX;
>> +       int inflight;
>> +
>> +       list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
>> +               if
>> (unlikely(!list_empty(raw_cpu_ptr(sess->mp_skip_entry))))
>> +                       continue;
>> +
>> +               inflight = atomic_read(&sess->stats.inflight);
>> +
>> +               if (inflight < min_inflight) {
>> +                       min_inflight = inflight;
>> +                       min_path = sess;
>> +               }
>> +       }
>> +
>> +       /*
>> +        * add the path to the skip list, so that next time we can get
>> +        * a different one
>> +        */
>> +       if (min_path)
>> +               list_add(raw_cpu_ptr(min_path->mp_skip_entry),
>> &it->skip_list);
>> +
>> +       return min_path;
>> +}
>> +
>> +static inline void path_it_init(struct path_it *it, struct ibtrs_clt
>> *clt)
>> +{
>> +       INIT_LIST_HEAD(&it->skip_list);
>> +       it->clt = clt;
>> +       it->i = 0;
>> +
>> +       if (clt->mp_policy == MP_POLICY_RR)
>> +               it->next_path = get_next_path_rr;
>> +       else
>> +               it->next_path = get_next_path_min_inflight;
>> +}
>> +
>> +static inline void path_it_deinit(struct path_it *it)
>> +{
>> +       struct list_head *skip, *tmp;
>> +       /*
>> +        * The skip_list is used only for the MIN_INFLIGHT policy.
>> +        * We need to remove paths from it, so that next IO can insert
>> +        * paths (->mp_skip_entry) into a skip_list again.
>> +        */
>> +       list_for_each_safe(skip, tmp, &it->skip_list)
>> +               list_del_init(skip);
>> +}
>> +
>> +static inline void ibtrs_clt_init_req(struct ibtrs_clt_io_req *req,
>> +                                     struct ibtrs_clt_sess *sess,
>> +                                     ibtrs_conf_fn *conf,
>> +                                     struct ibtrs_tag *tag, void *priv,
>> +                                     const struct kvec *vec, size_t
>> usr_len,
>> +                                     struct scatterlist *sg, size_t
>> sg_cnt,
>> +                                     size_t data_len, int dir)
>> +{
>> +       req->tag = tag;
>> +       req->in_use = true;
>> +       req->usr_len = usr_len;
>> +       req->data_len = data_len;
>> +       req->sglist = sg;
>> +       req->sg_cnt = sg_cnt;
>> +       req->priv = priv;
>> +       req->dir = dir;
>> +       req->con = ibtrs_tag_to_clt_con(sess, tag);
>> +       req->conf = conf;
>> +       copy_from_kvec(req->iu->buf, vec, usr_len);
>> +       if (sess->stats.enable_rdma_lat)
>> +               req->start_time = ibtrs_clt_get_raw_ms();
>> +}
>> +
>> +static inline struct ibtrs_clt_io_req *
>> +ibtrs_clt_get_req(struct ibtrs_clt_sess *sess, ibtrs_conf_fn *conf,
>> +                 struct ibtrs_tag *tag, void *priv,
>> +                 const struct kvec *vec, size_t usr_len,
>> +                 struct scatterlist *sg, size_t sg_cnt,
>> +                 size_t data_len, int dir)
>> +{
>> +       struct ibtrs_clt_io_req *req;
>> +
>> +       req = &sess->reqs[tag->mem_id];
>> +       ibtrs_clt_init_req(req, sess, conf, tag, priv, vec, usr_len,
>> +                          sg, sg_cnt, data_len, dir);
>> +       return req;
>> +}
>> +
>> +static inline struct ibtrs_clt_io_req *
>> +ibtrs_clt_get_copy_req(struct ibtrs_clt_sess *alive_sess,
>> +                      struct ibtrs_clt_io_req *fail_req)
>> +{
>> +       struct ibtrs_clt_io_req *req;
>> +       struct kvec vec = {
>> +               .iov_base = fail_req->iu->buf,
>> +               .iov_len  = fail_req->usr_len
>> +       };
>> +
>> +       req = &alive_sess->reqs[fail_req->tag->mem_id];
>> +       ibtrs_clt_init_req(req, alive_sess, fail_req->conf, fail_req->tag,
>> +                          fail_req->priv, &vec, fail_req->usr_len,
>> +                          fail_req->sglist, fail_req->sg_cnt,
>> +                          fail_req->data_len, fail_req->dir);
>> +       return req;
>> +}
>> +
>> +static int ibtrs_clt_write_req(struct ibtrs_clt_io_req *req);
>> +static int ibtrs_clt_read_req(struct ibtrs_clt_io_req *req);
>> +
>> +static int ibtrs_clt_failover_req(struct ibtrs_clt *clt,
>> +                                 struct ibtrs_clt_io_req *fail_req)
>> +{
>> +       struct ibtrs_clt_sess *alive_sess;
>> +       struct ibtrs_clt_io_req *req;
>> +       int err = -ECONNABORTED;
>> +       struct path_it it;
>> +
>> +       do_each_path(alive_sess, clt, &it) {
>> +               if (unlikely(alive_sess->state != IBTRS_CLT_CONNECTED))
>> +                       continue;
>> +               req = ibtrs_clt_get_copy_req(alive_sess, fail_req);
>> +               if (req->dir == DMA_TO_DEVICE)
>> +                       err = ibtrs_clt_write_req(req);
>> +               else
>> +                       err = ibtrs_clt_read_req(req);
>> +               if (unlikely(err)) {
>> +                       req->in_use = false;
>> +                       continue;
>> +               }
>> +               /* Success path */
>> +               ibtrs_clt_inc_failover_cnt(&alive_sess->stats);
>> +               break;
>> +       } while_each_path(&it);
>> +
>> +       return err;
>> +}
>> +
>> +static void fail_all_outstanding_reqs(struct ibtrs_clt_sess *sess,
>> +                                     bool failover)
>> +{
>> +       struct ibtrs_clt *clt = sess->clt;
>> +       struct ibtrs_clt_io_req *req;
>> +       int i;
>> +
>> +       if (!sess->reqs)
>> +               return;
>> +       for (i = 0; i < sess->queue_depth; ++i) {
>> +               bool notify;
>> +               int err = 0;
>> +
>> +               req = &sess->reqs[i];
>> +               if (!req->in_use)
>> +                       continue;
>> +
>> +               if (failover)
>> +                       err = ibtrs_clt_failover_req(clt, req);
>> +
>> +               notify = (!failover || err);
>> +               complete_rdma_req(req, -ECONNABORTED, notify);
>> +       }
>> +}
>> +
>> +static void free_sess_reqs(struct ibtrs_clt_sess *sess)
>> +{
>> +       struct ibtrs_clt_io_req *req;
>> +       int i;
>> +
>> +       if (!sess->reqs)
>> +               return;
>> +       for (i = 0; i < sess->queue_depth; ++i) {
>> +               req = &sess->reqs[i];
>> +               if (sess->fast_reg_mode == IBTRS_FAST_MEM_FR)
>> +                       kfree(req->fr_list);
>> +               else if (sess->fast_reg_mode == IBTRS_FAST_MEM_FMR)
>> +                       kfree(req->fmr_list);
>> +               kfree(req->map_page);
>> +               ibtrs_iu_free(req->iu, DMA_TO_DEVICE,
>> +                             sess->s.ib_dev->dev);
>> +       }
>> +       kfree(sess->reqs);
>> +       sess->reqs = NULL;
>> +}
>> +
>> +static int alloc_sess_reqs(struct ibtrs_clt_sess *sess)
>> +{
>> +       struct ibtrs_clt_io_req *req;
>> +       void *mr_list;
>> +       int i;
>> +
>> +       sess->reqs = kcalloc(sess->queue_depth, sizeof(*sess->reqs),
>> +                            GFP_KERNEL);
>> +       if (unlikely(!sess->reqs))
>> +               return -ENOMEM;
>> +
>> +       for (i = 0; i < sess->queue_depth; ++i) {
>> +               req = &sess->reqs[i];
>> +               req->iu = ibtrs_iu_alloc(i, sess->max_req_size,
>> GFP_KERNEL,
>> +                                        sess->s.ib_dev->dev,
>> DMA_TO_DEVICE,
>> +                                        ibtrs_clt_rdma_done);
>> +               if (unlikely(!req->iu))
>> +                       goto out;
>> +               mr_list = kmalloc_array(sess->max_pages_per_mr,
>> +                                       sizeof(void *), GFP_KERNEL);
>> +               if (unlikely(!mr_list))
>> +                       goto out;
>> +               if (sess->fast_reg_mode == IBTRS_FAST_MEM_FR)
>> +                       req->fr_list = mr_list;
>> +               else if (sess->fast_reg_mode == IBTRS_FAST_MEM_FMR)
>> +                       req->fmr_list = mr_list;
>> +
>> +               req->map_page = kmalloc_array(sess->max_pages_per_mr,
>> +                                             sizeof(void *), GFP_KERNEL);
>> +               if (unlikely(!req->map_page))
>> +                       goto out;
>> +       }
>> +
>> +       return 0;
>> +
>> +out:
>> +       free_sess_reqs(sess);
>> +
>> +       return -ENOMEM;
>> +}
>> +
>> +static int alloc_tags(struct ibtrs_clt *clt)
>> +{
>> +       unsigned int chunk_bits;
>> +       int err, i;
>> +
>> +       clt->tags_map = kcalloc(BITS_TO_LONGS(clt->queue_depth),
>> sizeof(long),
>> +                               GFP_KERNEL);
>> +       if (unlikely(!clt->tags_map)) {
>> +               err = -ENOMEM;
>> +               goto out_err;
>> +       }
>> +       clt->tags = kcalloc(clt->queue_depth, TAG_SIZE(clt), GFP_KERNEL);
>> +       if (unlikely(!clt->tags)) {
>> +               err = -ENOMEM;
>> +               goto err_map;
>> +       }
>> +       chunk_bits = ilog2(clt->queue_depth - 1) + 1;
>> +       for (i = 0; i < clt->queue_depth; i++) {
>> +               struct ibtrs_tag *tag;
>> +
>> +               tag = GET_TAG(clt, i);
>> +               tag->mem_id = i;
>> +               tag->mem_off = i << (MAX_IMM_PAYL_BITS - chunk_bits);
>> +       }
>> +
>> +       return 0;
>> +
>> +err_map:
>> +       kfree(clt->tags_map);
>> +       clt->tags_map = NULL;
>> +out_err:
>> +       return err;
>> +}
>> +
>> +static void free_tags(struct ibtrs_clt *clt)
>> +{
>> +       kfree(clt->tags_map);
>> +       clt->tags_map = NULL;
>> +       kfree(clt->tags);
>> +       clt->tags = NULL;
>> +}
>> +
>> +static void query_fast_reg_mode(struct ibtrs_clt_sess *sess)
>> +{
>> +       struct ibtrs_ib_dev *ib_dev;
>> +       u64 max_pages_per_mr;
>> +       int mr_page_shift;
>> +
>> +       ib_dev = sess->s.ib_dev;
>> +       if (ib_dev->dev->alloc_fmr && ib_dev->dev->dealloc_fmr &&
>> +           ib_dev->dev->map_phys_fmr && ib_dev->dev->unmap_fmr) {
>> +               sess->fast_reg_mode = IBTRS_FAST_MEM_FMR;
>> +               ibtrs_info(sess, "Device %s supports FMR\n",
>> ib_dev->dev->name);
>> +       }
>> +       if (ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS
>> &&
>> +           use_fr) {
>> +               sess->fast_reg_mode = IBTRS_FAST_MEM_FR;
>> +               ibtrs_info(sess, "Device %s supports FR\n",
>> ib_dev->dev->name);
>> +       }
>> +
>> +       /*
>> +        * Use the smallest page size supported by the HCA, down to a
>> +        * minimum of 4096 bytes. We're unlikely to build large sglists
>> +        * out of smaller entries.
>> +        */
>> +       mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) -
>> 1);
>> +       sess->mr_page_size = 1 << mr_page_shift;
>> +       sess->max_sge      = ib_dev->attrs.max_sge;
>> +       sess->mr_page_mask = ~((u64)sess->mr_page_size - 1);
>> +       max_pages_per_mr   = ib_dev->attrs.max_mr_size;
>> +       do_div(max_pages_per_mr, sess->mr_page_size);
>> +       sess->max_pages_per_mr = min_t(u64, sess->max_pages_per_mr,
>> +                                      max_pages_per_mr);
>> +       if (sess->fast_reg_mode == IBTRS_FAST_MEM_FR) {
>> +               sess->max_pages_per_mr =
>> +                       min_t(u32, sess->max_pages_per_mr,
>> +                             ib_dev->attrs.max_fast_reg_page_list_len);
>> +       }
>> +       sess->mr_max_size = sess->mr_page_size * sess->max_pages_per_mr;
>> +}
>> +
>> +static int alloc_con_fast_pool(struct ibtrs_clt_con *con)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       struct ibtrs_fr_pool *fr_pool;
>> +       int err = 0;
>> +
>> +       if (sess->fast_reg_mode == IBTRS_FAST_MEM_FR) {
>> +               fr_pool = ibtrs_create_fr_pool(sess->s.ib_dev->dev,
>> +                                              sess->s.ib_dev->pd,
>> +                                              sess->queue_depth,
>> +                                              sess->max_pages_per_mr);
>> +               if (unlikely(IS_ERR(fr_pool))) {
>> +                       err = PTR_ERR(fr_pool);
>> +                       ibtrs_err(sess, "FR pool allocation failed, err:
>> %d\n",
>> +                                 err);
>> +                       return err;
>> +               }
>> +               con->fr_pool = fr_pool;
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +static void free_con_fast_pool(struct ibtrs_clt_con *con)
>> +{
>> +       if (con->fr_pool) {
>> +               ibtrs_destroy_fr_pool(con->fr_pool);
>> +               con->fr_pool = NULL;
>> +       }
>> +}
>> +
>> +static int alloc_sess_fast_pool(struct ibtrs_clt_sess *sess)
>> +{
>> +       struct ib_fmr_pool_param fmr_param;
>> +       struct ib_fmr_pool *fmr_pool;
>> +       int err = 0;
>> +
>> +       if (sess->fast_reg_mode == IBTRS_FAST_MEM_FMR) {
>> +               memset(&fmr_param, 0, sizeof(fmr_param));
>> +               fmr_param.pool_size         = sess->queue_depth *
>> +                                             sess->max_pages_per_mr;
>> +               fmr_param.dirty_watermark   = fmr_param.pool_size / 4;
>> +               fmr_param.cache             = 0;
>> +               fmr_param.max_pages_per_fmr = sess->max_pages_per_mr;
>> +               fmr_param.page_shift        = ilog2(sess->mr_page_size);
>> +               fmr_param.access            = (IB_ACCESS_LOCAL_WRITE |
>> +                                              IB_ACCESS_REMOTE_WRITE);
>> +
>> +               fmr_pool = ib_create_fmr_pool(sess->s.ib_dev->pd,
>> &fmr_param);
>> +               if (unlikely(IS_ERR(fmr_pool))) {
>> +                       err = PTR_ERR(fmr_pool);
>> +                       ibtrs_err(sess, "FMR pool allocation failed, err:
>> %d\n",
>> +                                 err);
>> +                       return err;
>> +               }
>> +               sess->fmr_pool = fmr_pool;
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +static void free_sess_fast_pool(struct ibtrs_clt_sess *sess)
>> +{
>> +       if (sess->fmr_pool) {
>> +               ib_destroy_fmr_pool(sess->fmr_pool);
>> +               sess->fmr_pool = NULL;
>> +       }
>> +}
>> +
>> +static int alloc_sess_io_bufs(struct ibtrs_clt_sess *sess)
>> +{
>> +       int ret;
>> +
>> +       ret = alloc_sess_reqs(sess);
>> +       if (unlikely(ret)) {
>> +               ibtrs_err(sess, "alloc_sess_reqs(), err: %d\n", ret);
>> +               return ret;
>> +       }
>> +       ret = alloc_sess_fast_pool(sess);
>> +       if (unlikely(ret)) {
>> +               ibtrs_err(sess, "alloc_sess_fast_pool(), err: %d\n", ret);
>> +               goto free_reqs;
>> +       }
>> +
>> +       return 0;
>> +
>> +free_reqs:
>> +       free_sess_reqs(sess);
>> +
>> +       return ret;
>> +}
>> +
>> +static void free_sess_io_bufs(struct ibtrs_clt_sess *sess)
>> +{
>> +       free_sess_reqs(sess);
>> +       free_sess_fast_pool(sess);
>> +}
>> +
>> +static bool __ibtrs_clt_change_state(struct ibtrs_clt_sess *sess,
>> +                                    enum ibtrs_clt_state new_state)
>> +{
>> +       enum ibtrs_clt_state old_state;
>> +       bool changed = false;
>> +
>> +       old_state = sess->state;
>> +       switch (new_state) {
>> +       case IBTRS_CLT_CONNECTING:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_RECONNECTING:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_RECONNECTING:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CONNECTED:
>> +               case IBTRS_CLT_CONNECTING_ERR:
>> +               case IBTRS_CLT_CLOSED:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_CONNECTED:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CONNECTING:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_CONNECTING_ERR:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CONNECTING:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_CLOSING:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CONNECTING:
>> +               case IBTRS_CLT_CONNECTING_ERR:
>> +               case IBTRS_CLT_RECONNECTING:
>> +               case IBTRS_CLT_CONNECTED:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_CLOSED:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CLOSING:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       case IBTRS_CLT_DEAD:
>> +               switch (old_state) {
>> +               case IBTRS_CLT_CLOSED:
>> +                       changed = true;
>> +                       /* FALLTHRU */
>> +               default:
>> +                       break;
>> +               }
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +       if (changed) {
>> +               sess->state = new_state;
>> +               wake_up_locked(&sess->state_wq);
>> +       }
>> +
>> +       return changed;
>> +}
>> +
>> +static bool ibtrs_clt_change_state_from_to(struct ibtrs_clt_sess *sess,
>> +                                          enum ibtrs_clt_state old_state,
>> +                                          enum ibtrs_clt_state new_state)
>> +{
>> +       bool changed = false;
>> +
>> +       spin_lock_irq(&sess->state_wq.lock);
>> +       if (sess->state == old_state)
>> +               changed = __ibtrs_clt_change_state(sess, new_state);
>> +       spin_unlock_irq(&sess->state_wq.lock);
>> +
>> +       return changed;
>> +}
>> +
>> +static bool ibtrs_clt_change_state_get_old(struct ibtrs_clt_sess *sess,
>> +                                          enum ibtrs_clt_state new_state,
>> +                                          enum ibtrs_clt_state
>> *old_state)
>> +{
>> +       bool changed;
>> +
>> +       spin_lock_irq(&sess->state_wq.lock);
>> +       *old_state = sess->state;
>> +       changed = __ibtrs_clt_change_state(sess, new_state);
>> +       spin_unlock_irq(&sess->state_wq.lock);
>> +
>> +       return changed;
>> +}
>> +
>> +static bool ibtrs_clt_change_state(struct ibtrs_clt_sess *sess,
>> +                                  enum ibtrs_clt_state new_state)
>> +{
>> +       enum ibtrs_clt_state old_state;
>> +
>> +       return ibtrs_clt_change_state_get_old(sess, new_state,
>> &old_state);
>> +}
>> +
>> +static enum ibtrs_clt_state ibtrs_clt_state(struct ibtrs_clt_sess *sess)
>> +{
>> +       enum ibtrs_clt_state state;
>> +
>> +       spin_lock_irq(&sess->state_wq.lock);
>> +       state = sess->state;
>> +       spin_unlock_irq(&sess->state_wq.lock);
>> +
>> +       return state;
>> +}
>> +
>> +static void ibtrs_clt_hb_err_handler(struct ibtrs_con *c, int err)
>> +{
>> +       struct ibtrs_clt_con *con;
>> +
>> +       (void)err;
>> +       con = container_of(c, typeof(*con), c);
>> +       ibtrs_rdma_error_recovery(con);
>> +}
>> +
>> +static void ibtrs_clt_init_hb(struct ibtrs_clt_sess *sess)
>> +{
>> +       ibtrs_init_hb(&sess->s, &io_comp_cqe,
>> +                     IBTRS_HB_INTERVAL_MS,
>> +                     IBTRS_HB_MISSED_MAX,
>> +                     ibtrs_clt_hb_err_handler,
>> +                     ibtrs_wq);
>> +}
>> +
>> +static void ibtrs_clt_start_hb(struct ibtrs_clt_sess *sess)
>> +{
>> +       ibtrs_start_hb(&sess->s);
>> +}
>> +
>> +static void ibtrs_clt_stop_hb(struct ibtrs_clt_sess *sess)
>> +{
>> +       ibtrs_stop_hb(&sess->s);
>> +}
>> +
>> +static void ibtrs_clt_reconnect_work(struct work_struct *work);
>> +static void ibtrs_clt_close_work(struct work_struct *work);
>> +
>> +static struct ibtrs_clt_sess *alloc_sess(struct ibtrs_clt *clt,
>> +                                        const struct ibtrs_addr *path,
>> +                                        size_t con_num, u16 max_segments)
>> +{
>> +       struct ibtrs_clt_sess *sess;
>> +       int err = -ENOMEM;
>> +       int cpu;
>> +
>> +       sess = kzalloc(sizeof(*sess), GFP_KERNEL);
>> +       if (unlikely(!sess))
>> +               goto err;
>> +
>> +       /* Extra connection for user messages */
>> +       con_num += 1;
>> +
>> +       sess->s.con = kcalloc(con_num, sizeof(*sess->s.con), GFP_KERNEL);
>> +       if (unlikely(!sess->s.con))
>> +               goto err_free_sess;
>> +
>> +       mutex_init(&sess->init_mutex);
>> +       uuid_gen(&sess->s.uuid);
>> +       memcpy(&sess->s.dst_addr, path->dst,
>> +              rdma_addr_size((struct sockaddr *)path->dst));
>> +
>> +       /*
>> +        * rdma_resolve_addr() passes src_addr to cma_bind_addr, which
>> +        * checks the sa_family to be non-zero. If user passed
>> src_addr=NULL
>> +        * the sess->src_addr will contain only zeros, which is then fine.
>> +        */
>> +       if (path->src)
>> +               memcpy(&sess->s.src_addr, path->src,
>> +                      rdma_addr_size((struct sockaddr *)path->src));
>> +       strlcpy(sess->s.sessname, clt->sessname,
>> sizeof(sess->s.sessname));
>> +       sess->s.con_num = con_num;
>> +       sess->clt = clt;
>> +       sess->max_pages_per_mr = max_segments;
>> +       init_waitqueue_head(&sess->state_wq);
>> +       sess->state = IBTRS_CLT_CONNECTING;
>> +       atomic_set(&sess->connected_cnt, 0);
>> +       INIT_WORK(&sess->close_work, ibtrs_clt_close_work);
>> +       INIT_DELAYED_WORK(&sess->reconnect_dwork,
>> ibtrs_clt_reconnect_work);
>> +       ibtrs_clt_init_hb(sess);
>> +
>> +       sess->mp_skip_entry = alloc_percpu(typeof(*sess->mp_skip_entry));
>> +       if (unlikely(!sess->mp_skip_entry))
>> +               goto err_free_con;
>> +
>> +       for_each_possible_cpu(cpu)
>> +               INIT_LIST_HEAD(per_cpu_ptr(sess->mp_skip_entry, cpu));
>> +
>> +       err = ibtrs_clt_init_stats(&sess->stats);
>> +       if (unlikely(err))
>> +               goto err_free_percpu;
>> +
>> +       return sess;
>> +
>> +err_free_percpu:
>> +       free_percpu(sess->mp_skip_entry);
>> +err_free_con:
>> +       kfree(sess->s.con);
>> +err_free_sess:
>> +       kfree(sess);
>> +err:
>> +       return ERR_PTR(err);
>> +}
>> +
>> +static void free_sess(struct ibtrs_clt_sess *sess)
>> +{
>> +       ibtrs_clt_free_stats(&sess->stats);
>> +       free_percpu(sess->mp_skip_entry);
>> +       kfree(sess->s.con);
>> +       kfree(sess->srv_rdma_addr);
>> +       kfree(sess);
>> +}
>> +
>> +static int create_con(struct ibtrs_clt_sess *sess, unsigned int cid)
>> +{
>> +       struct ibtrs_clt_con *con;
>> +
>> +       con = kzalloc(sizeof(*con), GFP_KERNEL);
>> +       if (unlikely(!con))
>> +               return -ENOMEM;
>> +
>> +       /* Map first two connections to the first CPU */
>> +       con->cpu  = (cid ? cid - 1 : 0) % nr_cpu_ids;
>> +       con->c.cid = cid;
>> +       con->c.sess = &sess->s;
>> +       atomic_set(&con->io_cnt, 0);
>> +
>> +       sess->s.con[cid] = &con->c;
>> +
>> +       return 0;
>> +}
>> +
>> +static void destroy_con(struct ibtrs_clt_con *con)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +
>> +       sess->s.con[con->c.cid] = NULL;
>> +       kfree(con);
>> +}
>> +
>> +static int create_con_cq_qp(struct ibtrs_clt_con *con)
>> +{
>> +       struct ibtrs_clt_sess *sess = to_clt_sess(con->c.sess);
>> +       u16 cq_size, wr_queue_size;
>> +       int err, cq_vector;
>> +
>> +       /*
>> +        * This function can fail, but still destroy_con_cq_qp() should
>> +        * be called, this is because create_con_cq_qp() is called on cm
>> +        * event path, thus caller/waiter never knows: have we failed
>> before
>> +        * create_con_cq_qp() or after.  To solve this dilemma without
>> +        * creating any additional flags just allow destroy_con_cq_qp() be
>> +        * called many times.
>> +        */
>> +
>> +       if (con->c.cid == 0) {
>> +               cq_size = SERVICE_CON_QUEUE_DEPTH;
>> +               /* + 2 for drain and heartbeat */
>> +               wr_queue_size = SERVICE_CON_QUEUE_DEPTH + 2;
>> +               /* We must be the first here */
>> +               if (WARN_ON(sess->s.ib_dev))
>> +                       return -EINVAL;
>> +
>> +               /*
>> +                * The whole session uses device from user connection.
>> +                * Be careful not to close user connection before ib dev
>> +                * is gracefully put.
>> +                */
>> +               sess->s.ib_dev = ibtrs_ib_dev_find_get(con->c.cm_id);
>> +               if (unlikely(!sess->s.ib_dev)) {
>> +                       ibtrs_wrn(sess, "ibtrs_ib_dev_find_get(): no
>> memory\n");
>> +                       return -ENOMEM;
>> +               }
>> +               sess->s.ib_dev_ref = 1;
>> +               query_fast_reg_mode(sess);
>> +       } else {
>> +               int num_wr;
>> +
>> +               /*
>> +                * Here we assume that session members are correctly set.
>> +                * This is always true if user connection (cid == 0) is
>> +                * established first.
>> +                */
>> +               if (WARN_ON(!sess->s.ib_dev))
>> +                       return -EINVAL;
>> +               if (WARN_ON(!sess->queue_depth))
>> +                       return -EINVAL;
>> +
>> +               /* Shared between connections */
>> +               sess->s.ib_dev_ref++;
>> +               cq_size = sess->queue_depth;
>> +               num_wr = DIV_ROUND_UP(sess->max_pages_per_mr,
>> sess->max_sge);
>> +               wr_queue_size = sess->s.ib_dev->attrs.max_qp_wr;
>> +               wr_queue_size = min_t(int, wr_queue_size,
>> +                                     sess->queue_depth * num_wr *
>> +                                     (use_fr ? 3 : 2) + 1);
>> +       }
>> +       cq_vector = con->cpu % sess->s.ib_dev->dev->num_comp_vectors;
>> +       err = ibtrs_cq_qp_create(&sess->s, &con->c, sess->max_sge,
>> +                                cq_vector, cq_size, wr_queue_size,
>> +                                IB_POLL_SOFTIRQ);
>> +       /*
>> +        * In case of error we do not bother to clean previous
>> allocations,
>> +        * since destroy_con_cq_qp() must be called.
>> +        */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
