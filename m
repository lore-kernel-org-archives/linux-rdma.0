From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/14] mlx5: Update to use new udma write
 barriers
Date: Tue, 28 Feb 2017 18:02:51 +0200
Message-ID: <2969cce4-8b51-8fcf-f099-2b42a6d40a9c@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <d5921636-1911-5588-8c59-620066bca01a@dev.mellanox.co.il>
 <20170227180009.GL5891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170227180009.GL5891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/27/2017 8:00 PM, Jason Gunthorpe wrote:
> On Mon, Feb 27, 2017 at 12:56:33PM +0200, Yishai Hadas wrote:
>> On 2/16/2017 9:23 PM, Jason Gunthorpe wrote:
>>> The mlx5 comments are good so these translate fairly directly.
>>>
>>> There is one barrier in mlx5_arm_cq that I could not explain, it became
>>> mmio_ordered_writes_hack()
>>>
>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>
>>> #ifdef MLX5_DEBUG
>>> 	{
>>> @@ -1283,14 +1283,14 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
>>> 	 * Make sure that the doorbell record in host memory is
>>> 	 * written before ringing the doorbell via PCI MMIO.
>>> 	 */
>>> -	wmb();
>>> +	udma_to_device_barrier();
>>>
>>> 	doorbell[0] = htonl(sn << 28 | cmd | ci);
>>> 	doorbell[1] = htonl(cq->cqn);
>>>
>>> 	mlx5_write64(doorbell, ctx->uar[0] + MLX5_CQ_DOORBELL, &ctx->lock32);
>>>
>>> -	wc_wmb();
>>> +	mmio_ordered_writes_hack();
>>
>> We expect to use here the "mmio_flush_writes()" new macro, instead of the
>> above "hack" one. This barrier enforces the data to be flushed immediately
>> to the device so that the CQ will be armed with no delay.
>
> Hmm.....
>
> Is it even possible to 'speed up' writes to UC memory? (uar is
> UC, right?)
>

No, the UAR is mapped write combing, that's why we need here the 
mmio_flush_writes() to make sure that the device will see the data with 
no delay.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
