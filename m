Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3F2EB64DD
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Aug 2023 06:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjHGGVn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Aug 2023 02:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjHGGVn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Aug 2023 02:21:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938CF9
        for <linux-rdma@vger.kernel.org>; Sun,  6 Aug 2023 23:21:41 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RK5lw4Y79zrS97;
        Mon,  7 Aug 2023 14:20:28 +0800 (CST)
Received: from [10.67.102.17] (10.67.102.17) by kwepemi500006.china.huawei.com
 (7.221.188.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 14:21:37 +0800
Message-ID: <9b87aea4-cc61-0498-4e85-e13375651911@hisilicon.com>
Date:   Mon, 7 Aug 2023 14:21:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH -next] RDMA/hns: Remove unused declaration
 hns_roce_modify_srq()
Content-Language: en-US
To:     Yue Haibing <yuehaibing@huawei.com>, <xuhaoyue1@hisilicon.com>,
        <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>
References: <20230804130418.41728-1-yuehaibing@huawei.com>
From:   Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20230804130418.41728-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.17]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Thanks.
Reviewed-by: Junxian Huang <huangjunxian6@hisilicon.com>

On 2023/8/4 21:04, Yue Haibing wrote:
> Commit c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
> declared but never implemented this.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index 34e099efaae3..4dd6437ca410 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -1159,9 +1159,6 @@ int hns_roce_get_umem_bufs(struct hns_roce_dev *hr_dev, dma_addr_t *bufs,
>  int hns_roce_create_srq(struct ib_srq *srq,
>  			struct ib_srq_init_attr *srq_init_attr,
>  			struct ib_udata *udata);
> -int hns_roce_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr,
> -			enum ib_srq_attr_mask srq_attr_mask,
> -			struct ib_udata *udata);
>  int hns_roce_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata);
>  
>  int hns_roce_alloc_xrcd(struct ib_xrcd *ib_xrcd, struct ib_udata *udata);
