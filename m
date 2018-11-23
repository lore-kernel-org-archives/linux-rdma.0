From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/3] RDMA/hns: Updates for reset process of
 roce device in hip08
Date: Fri, 23 Nov 2018 13:42:56 -0700
Message-ID: <20181123204256.GK3395@ziepe.ca>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 23, 2018 at 11:14:22PM +0800, Wei Hu (Xavier) wrote:
> Hi, Doug and Janson
> 
> This series mainly include updates for reset process of roce device
> in hip08.
> One patch adds support for reset and loading or unloading driver occur
> simultaneously to ensure work normally, one stops sending mailbox&cmq&
> doorbell when reset occured or reset is occuring, the last one modifies
> the name of hns RoCE device's name in order to ensure that the name is
> consistent before and after reset.
> 
> This series relies on the the new interfaces in hns NIC driver those
> had been accepted by David, the related commit as below:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 
> commit cb7ea80c6dfda472a068d40f4f9755d034b2dfde

Then you can't send patches to RDMA until the next cycle. Please
reasend after v4.21-rc1 is out.

We can only coordinate with Dave's tree if you are able to setup a
shared branch like Mellanox does.

Also, I don't even see cb7ea80c6dfda472a068d40f4f9755d034b2dfde in
that tree???

Jason
