From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/hns: Add driver files for hns RoCE driver
Date: Thu, 13 Oct 2016 21:18:02 +0800
Message-ID: <57FF898A.80100@huawei.com>
References: <20161013114341.GA8275@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161013114341.GA8275@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/13 19:43, Dan Carpenter 写道:
> Hello oulijun,
> 
> The patch 9a4435375cd1: "IB/hns: Add driver files for hns RoCE
> driver" from Jul 21, 2016, leads to the following static checker
> warning:
> 
> 	drivers/infiniband/hw/hns/hns_roce_mr.c:575 hns_roce_reg_user_mr()
> 	warn: no lower bound on 'n'
> 
> drivers/infiniband/hw/hns/hns_roce_mr.c
>    542  struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>    543                                     u64 virt_addr, int access_flags,
>    544                                     struct ib_udata *udata)
>    545  {
>    546          struct hns_roce_dev *hr_dev = to_hr_dev(pd->device);
>    547          struct device *dev = &hr_dev->pdev->dev;
>    548          struct hns_roce_mr *mr = NULL;
>    549          int ret = 0;
>    550          int n = 0;
>                 ^^^^^^^^^
> 
> Notice this is signed.  Please don't initialize variables to bogus
> values.  The compiler has a feature to warn about uninitialized
> variables but by assigning bogus valus to "n" then you are disabling the
> safety checks and potentially hiding bugs.

Thanks, we will fix it in next patch!
> 
>    551  
>    552          mr = kmalloc(sizeof(*mr), GFP_KERNEL);
>    553          if (!mr)
>    554                  return ERR_PTR(-ENOMEM);
>    555  
>    556          mr->umem = ib_umem_get(pd->uobject->context, start, length,
>    557                                 access_flags, 0);
>    558          if (IS_ERR(mr->umem)) {
>    559                  ret = PTR_ERR(mr->umem);
>    560                  goto err_free;
>    561          }
>    562  
>    563          n = ib_umem_page_count(mr->umem);
> 
> Depending on the config then ib_umem_page_count() can return -EINVAL.
> Probably it's not possible here.  Anyway, probably the right thing is
> to check:
> 
> 	if (n < 0) {
> 		ret = -EINVAL;
> 		goto umem;
> 	}
> 
Thanks for your reviewing. I have checked the ib_umem_page_count(), Maybe it
will not return the -EINVAL

when configured CONFIG_INFINIBAND_USER_MEM, the function is

int ib_umem_page_count(struct ib_umem *umem)
{
	int shift;
	int i;
	int n;
	struct scatterlist *sg;

	if (umem->odp_data)
		return ib_umem_num_pages(umem);

	shift = ilog2(umem->page_size);

	n = 0;
	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, i)
		n += sg_dma_len(sg) >> shift;

	return n;
}
EXPORT_SYMBOL(ib_umem_page_count);

when not configured CONFIG_INFINIBAND_USER_MEM, the function as follow:
static inline int ib_umem_page_count(struct ib_umem *umem) { return 0; }

> It silences the static checker warning.
> 
>    564          if (mr->umem->page_size != HNS_ROCE_HEM_PAGE_SIZE) {
>    565                  dev_err(dev, "Just support 4K page size but is 0x%x now!\n",
>    566                          mr->umem->page_size);
> 
> Should we continue here or is there supposed to be a goto umem;?

Thanks, Dan Carpenter
We have taken notice of the problem and have sent a patch to Doug to fix last two problem. the patch link as follow:
https://patchwork.kernel.org/patch/9342015/

> 
>    567          }
>    568  
>    569          if (n > HNS_ROCE_MAX_MTPT_PBL_NUM) {
>    570                  dev_err(dev, " MR len %lld err. MR is limited to 4G at most!\n",
>    571                          length);
> 
> 
> We should be setting "ret = -EINVAL;" here.

Thanks, Dan Carpenter
We have taken notice of the problem and have sent a patch to Doug to fix last two problem. the patch link as follow:
https://patchwork.kernel.org/patch/9342015/

> 
>    572                  goto err_umem;
>    573          }
>    574  
>    575          ret = hns_roce_mr_alloc(hr_dev, to_hr_pd(pd)->pdn, virt_addr, length,
>    576                                  access_flags, n, mr);
>    577          if (ret)
>    578                  goto err_umem;
>    579  
> 
> regards,
> dan carpenter
> 
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
