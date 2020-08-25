Return-Path: <SRS0=RHPu=CD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91D5C433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 08:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B442E20706
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 08:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="teHZoydR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHYINv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 Aug 2020 04:13:51 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63357 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgHYINt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 25 Aug 2020 04:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598343229; x=1629879229;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MLZEUJrUHU6LjJqu1a2KW/s0ADM835/0EXvJywwM3FU=;
  b=teHZoydRkWjgSXIfhd9678ROhd0CKA1ZYy8I9Lr7JI3ESvLBcZNr67FT
   vGvg1k0C1oJl4Ms2AsjHqiHUK1Vceq8GrgZWkmcEE4ltM5yPqtd9b6+Gg
   BsLFqHZ/cypkfZ4ejakFFTmrgvHb5z7CXCWF8jMk2YpFe2OWocCr0SUh1
   8=;
X-IronPort-AV: E=Sophos;i="5.76,351,1592870400"; 
   d="scan'208";a="70685830"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Aug 2020 08:13:45 +0000
Received: from EX13D19EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 24BBEA1F76;
        Tue, 25 Aug 2020 08:13:44 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.162.55) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 25 Aug 2020 08:13:30 +0000
Subject: Re: [PATCH rdma-next 01/10] RDMA: Restore ability to fail on PD
 deallocate
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Lijun Ou <oulijun@huawei.com>, <linux-rdma@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <yanjunz@nvidia.com>
References: <20200824103247.1088464-1-leon@kernel.org>
 <20200824103247.1088464-2-leon@kernel.org>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <10111f1b-ea06-dce5-a8be-d18e70962547@amazon.com>
Date:   Tue, 25 Aug 2020 11:13:25 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200824103247.1088464-2-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D08UWC001.ant.amazon.com (10.43.162.110) To
 EX13D19EUB001.ant.amazon.com (10.43.166.229)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 24/08/2020 13:32, Leon Romanovsky wrote:
> diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
> index 1889dd172a25..8547f9d543df 100644
> --- a/drivers/infiniband/hw/efa/efa.h
> +++ b/drivers/infiniband/hw/efa/efa.h
> @@ -134,7 +134,7 @@ int efa_query_gid(struct ib_device *ibdev, u8 port, int index,
>  int efa_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
>  		   u16 *pkey);
>  int efa_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
> -void efa_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
> +int efa_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
>  int efa_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
>  struct ib_qp *efa_create_qp(struct ib_pd *ibpd,
>  			    struct ib_qp_init_attr *init_attr,
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 3f7f19b9f463..660a69943e02 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -383,13 +383,14 @@ int efa_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  	return err;
>  }
> 
> -void efa_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
> +int efa_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  {
>  	struct efa_dev *dev = to_edev(ibpd->device);
>  	struct efa_pd *pd = to_epd(ibpd);
> 
>  	ibdev_dbg(&dev->ibdev, "Dealloc pd[%d]\n", pd->pdn);
>  	efa_pd_dealloc(dev, pd->pdn);
> +	return 0;
>  }

Nice change, thanks Leon.
At least for EFA, I prefer to return the return value of the destroy command
instead of silently ignoring it (same for the other patches).
