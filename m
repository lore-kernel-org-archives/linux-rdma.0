From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: Re: [PATCH] infiniband: nes: add unlikely() to assert()
Date: Wed, 5 Sep 2018 21:54:30 +0300
Message-ID: <62351491-66cb-0541-85e4-481251433a19@gmail.com>
References: <20180831192418.12346-1-igor.stoppa@huawei.com>
 <20180905060106.GI2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905060106.GI2977@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Igor Stoppa <igor.stoppa@huawei.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 05/09/18 09:01, Leon Romanovsky wrote:
> On Fri, Aug 31, 2018 at 10:24:18PM +0300, Igor Stoppa wrote:
>> Typically the assert is expected to not fail.
> 
> This whole assert can be removed.

ok

>>
>> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
>> Acked-by: Doug Ledford <dledford@redhat.com>
> 
> Most probably that I missed discussion, but anyway, does this
> "Acked-by" come from internal or external discussion?

https://lkml.org/lkml/2018/8/31/456

--
igor
