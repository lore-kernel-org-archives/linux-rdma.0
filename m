From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/7] Add CM and a bugfix to hip08
Date: Tue, 16 Jan 2018 20:50:37 -0700
Message-ID: <20180117035037.GB30206@ziepe.ca>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515566393-63888-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 02:39:46PM +0800, Lijun Ou wrote:
> This patch series adds the CM(Connection Mangement) support
> to hip08 RoCE driver. Changes done are primarily to add
> support of APIs in IB device and some fixes over the
> origin driver to support RDMA CM. This patch series
> also adjust some codes style in order to fill the
> sq wqe of ud type and fix a bug for tx_cqn field.
> 
> Change from V1:
> - Add a new patch named assign the correct value for
>   tx_cqn splited from the first patchset
> - Fix the comments given by Leon Romanovsky
> - Add the options for free sq lock when qp is illegal
>   qp type
>  
> Lijun Ou (7):
>   RDMA/hns: Assign the correct value for tx_cqn
>   RDMA/hns: Create gsi qp in hip08
>   RDMA/hns: Add gsi qp support for modifying qp in hip08
>   RDMA/hns: Fill sq wqe context of ud type in hip08
>   RDMA/hns: Assign zero for pkey_index of wc in hip08
>   RDMA/hns: Update the verbs of polling for completion
>   RDMA/hns: Set the guid for hip08 RoCE device

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
