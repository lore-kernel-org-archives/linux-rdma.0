From: YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH -next] RDMA/hns: Make hns_roce_cmq_send static
Date: Wed, 20 Mar 2019 23:32:36 +0800
Message-ID: <9e289f57-9be9-f02f-9cc7-63e665a3367a@huawei.com>
References: <20190320135047.23184-1-yuehaibing@huawei.com>
 <20190320152807.GV4823@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320152807.GV4823@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 2019/3/20 23:28, Leon Romanovsky wrote:
> On Wed, Mar 20, 2019 at 09:50:47PM +0800, Yue Haibing wrote:
>> From: YueHaibing <yuehaibing@huawei.com>
>>
>> Fix sparse warning:
>>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1089:5:
>>  warning: symbol 'hns_roce_cmq_send' was not declared. Should it be static?
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> Thanks for your patch, but such fix was already submitted.
> https://patchwork.kernel.org/patch/10859135/

Good to know this, Thanks!

> 
> Thanks
> 
