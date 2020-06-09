Return-Path: <SRS0=N7RC=7W=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73014C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 15:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4641D2072F
	for <linux-rdma@archiver.kernel.org>; Tue,  9 Jun 2020 15:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgFIPyC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jun 2020 11:54:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:4236 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgFIPyB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 9 Jun 2020 11:54:01 -0400
IronPort-SDR: gBmHGsHiu4t0KZjjxRmGC9mk1B6ysSkZe0OctVOX0qX01fKX0KhQ/1Dy5qJf0YQNGMizcUKRkM
 DmL3V/84xjLA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 08:54:00 -0700
IronPort-SDR: geHkTrUZMj15qOc12rlaH2e0SMypdb98/seukcAPFvrRVbaK2xehJqdF8spQYw3AZkNENu0UOS
 BL6dIwvL++hQ==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="447168863"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.203.173]) ([10.254.203.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 08:53:58 -0700
Subject: Re: [PATCH 02/17] drivers: infiniband: Fix trivial spelling
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jiri Kosina <trivial@kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
 <20200609124610.3445662-3-kieran.bingham+renesas@ideasonboard.com>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <8909aaf3-027d-17ed-d887-6bffe5c04366@intel.com>
Date:   Tue, 9 Jun 2020 11:53:56 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200609124610.3445662-3-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 6/9/2020 8:45 AM, Kieran Bingham wrote:
> The word 'descriptor' is misspelled throughout the tree.
> 
> Fix it up accordingly:
>      decriptors -> descriptors
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>   drivers/infiniband/hw/hfi1/iowait.h      | 2 +-
>   drivers/infiniband/hw/hfi1/verbs_txreq.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/iowait.h b/drivers/infiniband/hw/hfi1/iowait.h
> index 07847cb72169..d580aa17ae37 100644
> --- a/drivers/infiniband/hw/hfi1/iowait.h
> +++ b/drivers/infiniband/hw/hfi1/iowait.h
> @@ -399,7 +399,7 @@ static inline void iowait_get_priority(struct iowait *w)
>    * @wait_head: the wait queue
>    *
>    * This function is called to insert an iowait struct into a
> - * wait queue after a resource (eg, sdma decriptor or pio
> + * wait queue after a resource (eg, sdma descriptor or pio
>    * buffer) is run out.
>    */
>   static inline void iowait_queue(bool pkts_sent, struct iowait *w,
> diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
> index bfa6e081cb56..d2d526c5a756 100644
> --- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
> +++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
> @@ -91,7 +91,7 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
>   	tx->mr = NULL;
>   	tx->sde = priv->s_sde;
>   	tx->psc = priv->s_sendcontext;
> -	/* so that we can test if the sdma decriptors are there */
> +	/* so that we can test if the sdma descriptors are there */
>   	tx->txreq.num_desc = 0;
>   	/* Set the header type */
>   	tx->phdr.hdr.hdr_type = priv->hdr_type;
> 

Thanks

Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
