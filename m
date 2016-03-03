From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 13:02:09 +0100
Message-ID: <20160303120209.GC20543@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-8-git-send-email-hch@lst.de> <56D81790.8090305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D81790.8090305@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 12:53:04PM +0200, Sagi Grimberg wrote:
>
>> +int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
>> +{
>> +	struct ib_device *dev = qp->pd->device;
>> +	int ret = 0;
>> +
>> +	if (rdma_rw_use_mr(dev, attr->port_num)) {
>> +		ret = ib_mr_pool_init(qp, &qp->rdma_mrs,
>> +				attr->cap.max_rdma_ctxs, IB_MR_TYPE_MEM_REG,
>> +				dev->attrs.max_fast_reg_page_list_len);
>
> Christoph,
>
> This is a problem for mlx5 which exposes:
>
>         props->max_fast_reg_page_list_len = (unsigned int)-1;
>
> Which is obviously wrong and needs to be corrected, but this is sort of
> an overkill to allocate max supported unconditionally.
>
> How about choosing a sane default of 256/512 pages for now? I don't
> think we'll see a lot of larger transfers in iser/nvmf (which actually
> need MRs for iWARP).
>
> Alternatively we can allow the caller to limit the MR size?

I'm fine with a limit in the core rdma r/w code.  But why is this
a problem for mlx5?  If it offers unlimited MR sizes it should support
that, or report a useful value.  I don't see why fixing mlx5 should
be a problem, and would rather see this driver bug fixed ASAP.
