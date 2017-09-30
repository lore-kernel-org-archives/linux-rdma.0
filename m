From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Update the size and member order of
 hns_roce_create_qp structure
Date: Sat, 30 Sep 2017 09:45:18 -0600
Message-ID: <20170930154518.GA14152@obsidianresearch.com>
References: <1506761477-47350-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506761477-47350-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 30, 2017 at 04:51:17PM +0800, Lijun Ou wrote:
> In order to keep the size and member order with the
> hns_roce_ib_create_qp sturcture of the kernel driver,
> it need to update hns_roce_create_qp's structure
> members. Otherwise, it will run fail.

What?

Did you break the uapi? What kernel patch does this match with?

Generally structs in the u_abi.h headers cannot be changed like this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
