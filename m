From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Tue, 24 Oct 2017 16:41:57 +0800
Message-ID: <6b081786-72a5-5add-a302-37b51a6c02a4@huawei.com>
References: <1508812550-98920-1-git-send-email-oulijun@huawei.com>
 <20171024043742.GF16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024043742.GF16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/10/24 12:37, Leon Romanovsky 写道:
> On Tue, Oct 24, 2017 at 10:35:45AM +0800, Lijun Ou wrote:
>> This patch series add userspace library for hip08 RoCE driver. It will
>> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>>
>> Change from V1:
>> - Fix build warning due to the strange placement of fprintf
>>
> 
> It still fails to build cleanly.
> https://travis-ci.org/linux-rdma/rdma-core/builds/291891845?utm_source=github_status&utm_medium=notification
> 
> [74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o
> FAILED: /usr/bin/clang-4.0 -Dhns_rdmav16_EXPORTS -Werror -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g -fPIC -Iinclude -I/usr/include/libnl3 -std=gnu11 -MMD -MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -MF providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o.d -o providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -c ../providers/hns/hns_roce_u_hw_v2.c
> ../providers/hns/hns_roce_u_hw_v2.c:40:20: error: unused function 'set_raddr_seg_v2' [-Werror,-Wunused-function]
> static inline void set_raddr_seg_v2(struct hns_roce_v2_wqe_raddr_seg *rseg,
>  ^
> 1 error generated.
> [74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_hw_v1.c.o
> 
> Please use buildlib/cbuild script to test your patch series, the option "travis" will run the same checkers as I'm running.
> 
> Thanks
> 
Hi， leon
 sorry, I am fail to run cbuild tools.
 the cmd as follows:
 oulijun@Turing-Arch-b:~/rdma/rdma-core/buildlib$ ./cbuild pkg travis
HEAD is now at 5d410f5 libhns: Update consolidate repo for userspace library of hip08 RoCE

Can I use the cbuild tools quickly? Can I use buildlib/cbuild scripts for check?

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
