From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Sat, 20 Jan 2018 19:41:03 +0800
Message-ID: <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
 <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180119200029.GD3437-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/20 4:00, Jason Gunthorpe wrote:
> On Fri, Jan 19, 2018 at 07:04:42PM +0800, Liuyixian (Eason) wrote:
> 
>> For case 1, the new kernel driver can't support old user application or old userspace driver.
>> Because we use the record db solution (what this patchset does and why add new db_addr in kernel)
>> to substitute with operating register, which used by the old userspace driver.
>> Therefore, users need to update the userspace driver to the version which support record db.
> 
> This is not acceptable for the kernel. You must maintain compatability
> with old userspace.
> 
> Also, new userspace must work with older kernels.
> 
> Jason

Hi Jason,

Maybe my previous email caused some confusions to people.
Let me illustrate the compatibility more clear.

For hip06, which not support record db, even while it creates cq in userspace
with hns_roce_create_cq (db_addr already there), it will do nothing with db_addr.
The kernel also will not access db_addr, both for old kernel and new kernel(adding db_addr).
Because hip06 pushes db by operating register, this manner keeps unchanged.
Thus, the old/new kernel support both old/new userspace for hip06,

For hip08, which is still under development to support record db, considering
forward compatibility that new kernel with old userspace, as old userspace operates
register and new kernel still provide those registers, there is no forward compatibility
problem. The reverse (backward compatibility) is not true. It is not possible to take
new userspace will still run correctly if the kernel is old. As new userspace use
db_addr substitute operating register, it can run correctly only on new kernel
(the patchset goes with this patchset submitted to for-next) and later kernel versions.
I think it is reasonable for this case.

With carefully release-management, there would be no compatibility problem
both for hip06 and hip08.

Eason

> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
