From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 5/5] RDMA/hns: Fix the illegal memory operation
 when cross page
Date: Wed, 23 May 2018 14:38:02 +0800
Message-ID: <5B050C4A.8090307@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-6-git-send-email-xavier.huwei@huawei.com>
 <20180523061706.GA5729@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523061706.GA5729@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/23 14:17, Leon Romanovsky wrote:
> On Thu, May 17, 2018 at 04:02:53PM +0800, Wei Hu (Xavier) wrote:
>> This patch fixed the potential illegal operation when using the
>> extend sge buffer cross page in post send operation. The bug
>> will cause the calltrace.
>>
>> Reported-by: Jie Chen <chenjie103@huawei.com>
>> Reported-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
>> Fixes: b1c1583("RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent")
> Documentation/process/submitting-patches.rst
> 183 If your patch fixes a bug in a specific commit, e.g. you found an issue using
> 184 ``git bisect``, please use the 'Fixes:' tag with the first 12 characters of
> 185 the SHA-1 ID, and the one line summary.  For example::
> 186
> 187         Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
>
> Thanks
Thanks, Leon
    Got it. We will fix it in v2.
Wei Hu
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
