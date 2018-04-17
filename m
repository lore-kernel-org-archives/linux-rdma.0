From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] infiniband: mlx5: fix build error when
 INFINIBAND_USER_ACCESS=m
Date: Mon, 16 Apr 2018 18:49:37 -0700
Message-ID: <c0f4198f-9b62-60e3-0a1e-4c04ec8ffabe@infradead.org>
References: <81ea9f01-4624-38d7-2bfe-1dd7063fa3f0@infradead.org>
 <20180416215526.GX23074@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180416215526.GX23074@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 04/16/18 14:55, Jason Gunthorpe wrote:
> On Mon, Apr 16, 2018 at 02:21:07PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build errors when INFINIBAND_USER_ACCESS=m and MLX5_INFINIBAND=y.
>> The build error occurs when the mlx5 driver code attempts to use
>> USER_ACCESS interfaces, which are built as a loadable module.
>>
>> Fixes these build errors:
>>
>> drivers/infiniband/hw/mlx5/main.o: In function `populate_specs_root':
>> ../drivers/infiniband/hw/mlx5/main.c:4982: undefined reference to `uverbs_default_get_objects'
>> ../drivers/infiniband/hw/mlx5/main.c:4994: undefined reference to `uverbs_alloc_spec_tree'
>> drivers/infiniband/hw/mlx5/main.o: In function `depopulate_specs_root':
>> ../drivers/infiniband/hw/mlx5/main.c:5001: undefined reference to `uverbs_free_spec_tree'
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Matan Barak <matanb@mellanox.com>
>> Cc: Jason Gunthorpe <jgg@mellanox.com>
>> Cc: Leon Romanovsky <leonro@mellanox.com>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: linux-rdma@vger.kernel.org
>> Cc: stable@vger.kernel.org # reported against 4.16
>>  drivers/infiniband/hw/mlx5/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> +++ lnx-417-rc1/drivers/infiniband/hw/mlx5/Kconfig
>> @@ -1,6 +1,7 @@
>>  config MLX5_INFINIBAND
>>  	tristate "Mellanox Connect-IB HCA support"
>>  	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
>> +	select INFINIBAND_USER_ACCESS
> 
> Shouldn't this be done via
> 
> 	depends on m || INFINIBAND_USER_ACCESS != m
> 
> ?
> 
> We can turn off USER_ACCESS and still successfully compile the driver.

Argh, thanks, I didn't notice that.  v2 on the way but not quite the way
that you mentioned, more like it's done in other (netdev) places.

-- 
~Randy
