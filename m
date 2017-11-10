From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/2] Bugfixes for hip08 libhns
Date: Fri, 10 Nov 2017 17:45:11 +0800
Message-ID: <c56afe42-413e-37e7-68d4-e72db9aba0b7@huawei.com>
References: <1510309253-229097-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510309253-229097-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/11/10 18:20, Lijun Ou Ð´µÀ:
> This path series update the usage of two fields in cq doorbell and
> sqwqe.
> 
> Change from V1:
> 1. Update commit log
> 2. Remove the third patch, name is
>    libhns: Fix endian format of payload and immediate
> 
> Lijun Ou (2):
>   libhns: Set owner bit of SQWQE in user mode
>   libhns: Modify the usage of cmd_sn in hip08 RoCE userspace
> 
>  providers/hns/hns_roce_u_hw_v2.c | 10 +++++++++-
>  providers/hns/hns_roce_u_hw_v2.h |  2 ++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
Hi, leon&jgunthorpe
   In PATCH V2 version, I am remove the patch
	libhns: Fix endian format of payload and immediate

   I am trying to test it by using jason's patch and it has some questions within the next few days
	hns: Make the provider sparse clean

   I am tested it aginst D05(ARM64), when use hip08 as server and D05 as client, it is ok
   when use hip08 as client and D05 as server, it is fail. These test use the rdma operation with immediately scene.

   I have attending to resolving this bug and will send a patch serperately after resolved it

Thanks
Lijun Ou



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
