From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Mon, 30 Oct 2017 09:47:27 +0100
Message-ID: <afbd8b62-012e-9350-7786-70bed05e58a6@users.sourceforge.net>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
 <0c92fc8e-ecb8-c7ed-0b4c-721752297222@users.sourceforge.net>
 <20171027193601.GI16127@mtr-leonro.local>
 <e2febce9-4b80-a40e-024e-5c24964301ac@users.sourceforge.net>
 <20171030083402.GV16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030083402.GV16127@mtr-leonro.local>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

>> Do you find the following details useful for further clarification?
> 
> Almost, you should compare sizes of mlx4_ib.ko and not drivers/infiniband/hw/mlx4/main.o.

text: -32
data: 0
bss:  0


The determined difference is the same finally.

Regards,
Markus
