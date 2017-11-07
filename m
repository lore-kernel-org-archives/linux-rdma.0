From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 07 Nov 2017 08:56:37 -0600
Message-ID: <20171107085637.Horde.qFzN3uJQkHeQUTyEgZzV4mv@gator4166.hostgator.com>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
 <20171107144517.GA25631@embeddedor.com>
 <20171107145018.GJ18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107145018.GJ18825@mtr-leonro.local>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Quoting Leon Romanovsky <leon@kernel.org>:

> On Tue, Nov 07, 2017 at 08:45:17AM -0600, Gustavo A. R. Silva wrote:
>> Check on return value and goto label mbx_err are unnecessary.
>>
>> Addresses-Coverity-ID: 1268780
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
>> ---
>> Changes in v2:
>>  Remove assignment from "int status = -ENOMEM" as suggested by Leon  
>> Romanovsky.
>>
>>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> Please use git send-email to send patches and not reply to the conversation.
>

I'm using mutt.
What would be the advantage of using git send-email in this case?

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thank you
--
Gustavo A. R. Silva
