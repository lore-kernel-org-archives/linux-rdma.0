From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Fri, 27 Oct 2017 09:34:18 +0200
Message-ID: <0c92fc8e-ecb8-c7ed-0b4c-721752297222@users.sourceforge.net>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rdma@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

>> Add a jump target so that a bit of exception handling can be better reused
>> at the end of this function.
> 
> I'm not sure this is that big of a win.

Such a view is appropriate because I proposed just another small adjustment
for this source code place.


> I mean you aren't really making the code any smaller

Would anybody like to check corresponding effects in more detail
after a specific function call was replaced by a goto statement?


> and it's not making it any easier to read really.

Is the code readability still good enough there?

Regards,
Markus
