From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/14] RDMA/ocrdma: Add support for FRMR.
Date: Tue, 27 Aug 2013 23:10:29 -0700
Message-ID: <CAL1RGDVVo_5frxHY-uiydSSuSY1rOE+uQzYgSOVX6Hwjp=SjMQ@mail.gmail.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
 <2eee7e35-504e-4f2a-a364-527e90669108@CMEXHTCAS1.ad.emulex.com>
 <521B2934.3050008@acm.org> <6470282467066849AFF7BC0EABE2518C25FE5057@CMEXMB1.ad.emulex.com>
 <521CEFF4.9010706@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521CEFF4.9010706-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "B.A.L.N.Raju Gottumukkala" <B.A.L.NRaju.Gottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes, I'm fine with a renaming patch on top of the existing series.  No
need to force anyone to rewrite everything.

On Tue, Aug 27, 2013 at 11:29 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Hello Naresh,
>
> Good question. I'm not sure though what Roland prefers.
>
> Bart.
>
> On 08/27/13 16:33, B.A.L.N.Raju Gottumukkala wrote:
>>
>> Hi Bert,
>>
>> Sure I will change that.
>>
>> Some of the patches in this patch series will also get affected because of
>> that.
>>
>> It will be easy for us to address that as a separate patch on top of this
>> patch series.  Does this sound Ok ?
>>
>> Thanks!!
>> Naresh.
>>
>>
>> -----Original Message-----
>> From: Bart Van Assche [mailto:bvanassche-HInyCGIudOg@public.gmane.org]
>> Sent: Monday, August 26, 2013 3:39 PM
>> To: bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; B.A.L.N.Raju
>> Gottumukkala
>> Subject: Re: [PATCH 02/14] RDMA/ocrdma: Add support for FRMR.
>>
>> On 08/26/13 11:57, bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
>>>
>>> From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>>>
>>> Also get the max_srq value from query_config mailbox response.
>>>
>>> Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>>
>>
>> There are already a few drivers upstream in which the fast register memory
>> region work request is abbreviated as FRWR. Please consider renaming FRMR
>> into FRWR in order to avoid confusion and in order to make it easier to find
>> related code with grep in the kernel tree.
>>
>> Thanks,
>>
>> Bart.
>>
>> $ git grep -i '[^r]frwr' rdreier-infiniband/for-next | cat
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:static __be64
>> frwr_mkey_mask(void)
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:static void
>> set_frwr_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:
>> umr->mkey_mask = frwr_mkey_mask();
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:static void
>> set_frwr_pages(struct mlx5_wqe_data_seg *dseg,
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:static int
>> set_frwr_li_wr(void **seg, struct ib_send_wr *wr, int *size,
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:
>> set_frwr_umr_segment(*seg, wr, li);
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:
>> set_frwr_pages(*seg, wr, mdev, pd, writ);
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:
>> err = set_frwr_li_wr(&seg, wr, &size, mdev, to_mpd(ibqp->pd), qp);
>> rdreier-infiniband/for-next:drivers/infiniband/hw/mlx5/qp.c:
>> err = set_frwr_li_wr(&seg, wr, &size, mdev, to_mpd(ibqp->pd), qp);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:   /*
>> For fast registration - FRWR */
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:
>> } frwr;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:int
>> iser_reg_rdma_mem_frwr(struct iscsi_iser_task *task,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:void
>> iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:int
>> iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iscsi_iser.h:void
>> iser_free_frwr_pool(struct iser_conn *ib_conn);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_memory.c: *
>> iser_reg_rdma_mem_frwr - Registers memory intended for RDMA,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_memory.c:int
>> iser_reg_rdma_mem_frwr(struct iscsi_iser_task *iser_task,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_memory.c:
>> desc = list_first_entry(&ib_conn->fastreg.frwr.pool,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_memory.c:
>> list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> iser_info("FRWR supported, using FRWR for registration\n");
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> device->iser_alloc_rdma_reg_res = iser_create_frwr_pool;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> device->iser_free_rdma_reg_res = iser_free_frwr_pool;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> device->iser_reg_rdma_mem = iser_reg_rdma_mem_frwr;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> device->iser_unreg_rdma_mem = iser_unreg_mem_frwr;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> iser_err("IB device does not support FMRs nor FRWRs, can't register
>> memory\n");
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c: *
>> iser_create_frwr_pool - Creates pool of fast_reg descriptors
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:int
>> iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> INIT_LIST_HEAD(&ib_conn->fastreg.frwr.pool);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> ib_conn->fastreg.frwr.pool_size = 0;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> ib_conn->fastreg.frwr.pool_size++;
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> iser_free_frwr_pool(ib_conn);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c: *
>> iser_free_frwr_pool - releases the pool of fast_reg descriptors
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:void
>> iser_free_frwr_pool(struct iser_conn *ib_conn)
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:   if
>> (list_empty(&ib_conn->fastreg.frwr.pool))
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> iser_info("freeing conn %p frwr pool\n", ib_conn);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.frwr.pool, list) {
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:   if
>> (i < ib_conn->fastreg.frwr.pool_size)
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> ib_conn->fastreg.frwr.pool_size - i);
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:void
>> iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
>> rdreier-infiniband/for-next:drivers/infiniband/ulp/iser/iser_verbs.c:
>> list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
