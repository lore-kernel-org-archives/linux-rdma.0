Return-Path: <SRS0=jfUh=6F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31028C54FCC
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 15:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F087206A2
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 15:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDUPas (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:30:48 -0400
Received: from verein.lst.de ([213.95.11.211]:47368 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDUPas (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 21 Apr 2020 11:30:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 63CD368C4E; Tue, 21 Apr 2020 17:30:45 +0200 (CEST)
Date:   Tue, 21 Apr 2020 17:30:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jsmart2021@gmail.com,
        linux-rdma@vger.kernel.org, idanb@mellanox.com, axboe@kernel.dk,
        vladimirk@mellanox.com, oren@mellanox.com, shlomin@mellanox.com,
        israelr@mellanox.com, jgg@mellanox.com
Subject: Re: [PATCH 14/17] nvmet: Add metadata/T10-PI support
Message-ID: <20200421153045.GE10837@lst.de>
References: <20200327171545.98970-1-maxg@mellanox.com> <20200327171545.98970-16-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327171545.98970-16-maxg@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

> +	/*
> +	 * Max command capsule size is sqe + single page of in-capsule data.
> +	 * Disable inline data for Metadata capable controllers.
> +	 */
>  	id->ioccsz = cpu_to_le32((sizeof(struct nvme_command) +
> -				  req->port->inline_data_size) / 16);
> +				  req->port->inline_data_size *
> +				  !ctrl->pi_support) / 16);

Can we de-obsfucated this a little?

	cmd_capsule_size = sizeof(struct nvme_command);
	if (!ctrl->pi_support)
		cmd_capsule_size += req->port->inline_data_size;
	id->ioccsz = cpu_to_le32(cmd_capsule_size / 16);

> +	if (ctrl->subsys->pi_support && ctrl->port->pi_enable) {
> +		if (ctrl->port->pi_capable) {
> +			ctrl->pi_support = true;
> +			pr_info("controller %d T10-PI enabled\n", ctrl->cntlid);
> +		} else {
> +			ctrl->pi_support = false;
> +			pr_warn("T10-PI is not supported on controller %d\n",
> +				ctrl->cntlid);
> +		}

I think the printks are a little verbose.  Also why can we set
ctrl->port->pi_enable if ctrl->port->pi_capable is false?  Shoudn't
we reject that earlier?  In that case this could simply become:

	ctrl->pi_support = ctrl->subsys->pi_support && ctrl->port->pi_enable;

> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +static inline u32 nvmet_rw_md_len(struct nvmet_req *req)
> +{
> +	return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) * req->ns->ms;
> +}
> +
> +static inline bool nvmet_ns_has_pi(struct nvmet_ns *ns)
> +{
> +	return ns->md_type && ns->ms == sizeof(struct t10_pi_tuple);
> +}
> +#else
> +static inline u32 nvmet_rw_md_len(struct nvmet_req *req)
> +{
> +	return 0;

Do we really need a stub for nvmet_rw_md_len?  Also for nvmet_ns_has_pi
we could probably reword it as:

static inline bool nvmet_ns_has_pi(struct nvmet_ns *ns)
{
	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
		return false;
	return ns->pi_type && ns->metadata_size == sizeof(struct t10_pi_tuple);
}

and avoid the need for a stub as well.
