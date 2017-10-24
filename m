From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Userspace library matching for hip08 RoCE
Date: Tue, 24 Oct 2017 09:53:41 +0800
Message-ID: <143fcb67-521e-9996-fc50-c51da5d78183@huawei.com>
References: <1508245946-145697-1-git-send-email-oulijun@huawei.com>
 <20171023172725.GN2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023172725.GN2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/10/24 1:27, Leon Romanovsky 写道:
> On Tue, Oct 17, 2017 at 09:12:21PM +0800, Lijun Ou wrote:
>> This patch series add userspace library for hip08 RoCE driver. It will
>> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>>
>> Lijun Ou (5):
>>   libhns: Add new PCI device matching for hip08
>>   libhns: Introduce QP operations refered to hip08 RoCE device
>>   libhns: Introduce CQ operations refered to hip08 device
>>   libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
>>   libhns: Update consolidate repo for userspace library of hip08 RoCE
>>
> 
> Hi Lijun,
> 
> sorry for my slow response, your code causes to warnings during
> compilation:
> 
> -- Build files have been written to: /home/leonro/src/rdma-core/build
> [81/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o
> ../providers/hns/hns_roce_u_hw_v2.c: In function ‘hns_roce_v2_handle_error_cqe’:
> ../providers/hns/hns_roce_u_hw_v2.c:62:3: warning: statement will never be executed [-Wswitch-unreachable]
>    fprintf(stderr, PFX "error cqe!\n");
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Please fix it.
> 
> Thanks
>
Hi, Leon

I have checked it and sent PATCH V2. I have built by use build.sh and the as follows cmd again:
CC=/opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.05_linux/bin/aarch64-linux-gnu-gcc  cmake -GNinja -DENABLE_RESOLVE_NEIGH=0 ..

if have any other warnings, Please let me know.

Thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
