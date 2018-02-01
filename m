From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Fix the endian problem for hns
Date: Thu, 1 Feb 2018 16:18:58 -0700
Message-ID: <20180201231858.GV23352@mellanox.com>
References: <1517314845-126094-2-git-send-email-oulijun@huawei.com>
 <201802020744.ndxb7J1y%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201802020744.ndxb7J1y%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 07:12:47AM +0800, kbuild test robot wrote:
> Hi Lijun,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on next-20180201]
> [cannot apply to v4.15]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Lijun-Ou/Fixes-for-hns/20180202-014309
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
> >> drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: sparse: incorrect type in assignment (different base types) @@ expected unsigned int doorbell_qpn @@ got ed int doorbell_qpn @@
>    drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: expected unsigned int doorbell_qpn
>    drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: got restricted __le64 <noident>

[..]

Yikes, for a patch that is supposed to fix sparse warnings, there sure are a
lot..

You are testing your patch with sparse, right? Can you send this patch so the
driver is actually sparse clean as we did in userspace?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
