From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 07 Nov 2017 08:27:30 -0600
Message-ID: <20171107082730.Horde.E4rpZA7ga1h-VUypbnAbXHl@gator4166.hostgator.com>
References: <20171106143514.GA19786@embeddedor.com>
 <20171107063135.GA3815@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107063135.GA3815@yuvallap>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,

Quoting Yuval Shaia <yuval.shaia@oracle.com>:

> On Mon, Nov 06, 2017 at 08:35:14AM -0600, Gustavo A. R. Silva wrote:
>> Check on return value and goto label mbx_err are unnecessary.
>>
>> Addresses-Coverity-ID: 1268780
>
> What's that?
>

Coverity is a static code analyzer.
I am fixing Coverity issues and that is the ID Coverity assigned to  
this particular issue.

>> ---
>>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c  
>> b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>> index f8c14c7..db02bbb 100644
>> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>> @@ -1956,9 +1956,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev  
>> *dev, int fr_mr, u32 lkey)
>>  	cmd->lkey = lkey;
>>  	cmd->rsvd_frmr = fr_mr ? 1 : 0;
>>  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
>> -	if (status)
>> -		goto mbx_err;
>> -mbx_err:
>> +
>>  	kfree(cmd);
>>  	return status;
>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
>

Thank you
--
Gustavo A. R. Silva
