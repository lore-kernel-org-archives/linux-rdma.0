From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v4 1/6] RDMA/bnxt_re: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 10:08:16 -0500
Message-ID: <3e6cfa25-6b9f-24ff-499a-6df2740b658b@codeaurora.org>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-2-git-send-email-okaya@codeaurora.org>
 <20180320144801.GE19744@ziepe.ca>
 <d31c062b-5629-62b8-c291-c656e23c6f82@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d31c062b-5629-62b8-c291-c656e23c6f82@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/20/2018 10:00 AM, Sinan Kaya wrote:
> On 3/20/2018 9:48 AM, Jason Gunthorpe wrote:
>> On Mon, Mar 19, 2018 at 10:47:43PM -0400, Sinan Kaya wrote:
>>> Code includes wmb() followed by writel(). writel() already has a barrier on
>>> some architectures like arm64.
>>>
>>> This ends up CPU observing two barriers back to back before executing the
>>> register write.
>>>
>>> Since code already has an explicit barrier call, changing writel() to
>>> writel_relaxed().
>>>
>>> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
>>>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
>>> index 8329ec6..4a6b981 100644
>>> +++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
>>> @@ -181,10 +181,10 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
>>>  
>>>  	/* ring CMDQ DB */
>>>  	wmb();
>>> -	writel(cmdq_prod, rcfw->cmdq_bar_reg_iomem +
>>> -	       rcfw->cmdq_bar_reg_prod_off);
>>> -	writel(RCFW_CMDQ_TRIG_VAL, rcfw->cmdq_bar_reg_iomem +
>>> -	       rcfw->cmdq_bar_reg_trig_off);
>>> +	writel_relaxed(cmdq_prod, rcfw->cmdq_bar_reg_iomem +
>>> +		       rcfw->cmdq_bar_reg_prod_off);
>>> +	writel_relaxed(RCFW_CMDQ_TRIG_VAL, rcfw->cmdq_bar_reg_iomem +
>>> +		       rcfw->cmdq_bar_reg_trig_off);
>>
>> Woah, this may not be safe..
>>
>> The definition of writel_relaxed() is that it is fully unordered, so
>> the above two writes may change order now. Broadcom guys would have to
>> ack if that it is OK or not for their hardware.
>>
>> In general this is not an OK approach for a mechanical
>> conversion.. Only the first writel can be convereted.
>>
>> You need to check all your patches to make sure there are no
>> subsequent writel's in the places touched.
> 
> I paid special attention to this one and went to check the barriers
> document. According to the document, writes (whether it is relaxed or not)
> are always observed by the HW inorder with respect to each other.
> It just doesn't guarantee anything above writel_relaxed() to be observed.
> Since we already have a wmb(), this is taken care of. 
> 
> If somebody wants things to be observed after register write, there should
> have been a wmb() or mmiowb() afterwards.

Never mind, it will break some architectures. I'll only change the first one.

 (1) On some systems, I/O stores are not strongly ordered across all CPUs, and
     so for _all_ general drivers locks should be used and mmiowb() must be
     issued prior to unlocking the critical section.

 (2) If the accessor functions are used to refer to an I/O memory window with
     relaxed memory access properties, then _mandatory_ memory barriers are
     required to enforce ordering. 


> 
> 
>>
>> Jason
>>
> 
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
