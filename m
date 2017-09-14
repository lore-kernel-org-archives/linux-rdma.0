From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Report if kernel allows using MPW in
 SQ
Date: Thu, 14 Sep 2017 16:30:40 +0300
Message-ID: <a3eeb133-24d0-d1b2-8c82-b16e73cd9539@dev.mellanox.co.il>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
 <1505130185-32658-2-git-send-email-yishaih@mellanox.com>
 <20170911164257.GA2403@obsidianresearch.com>
 <1bb5967f-45fd-fb22-7772-10bf6b35e2e1@dev.mellanox.co.il>
 <20170913183849.GD1536@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170913183849.GD1536-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/13/2017 9:38 PM, Jason Gunthorpe wrote:
> On Tue, Sep 12, 2017 at 06:13:40PM +0300, Yishai Hadas wrote:
>> On 9/11/2017 7:42 PM, Jason Gunthorpe wrote:
>>> On Mon, Sep 11, 2017 at 02:43:04PM +0300, Yishai Hadas wrote:
>>>> 	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
>>>> -	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
>>>> +	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
>>>> +	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
> 
>> The bug was fixed in kernel 4.14 and now the feature is supported, the
>> legacy value 1 on resp.support_multi_pkt_send_wqe is not reported from
>> kernel any more as we can't rely on, and a new bit MLX5_ALLOW_MPW (1 << 1)
>> was introduced to indicate that feature is supported.
> 
> That is very messy.. At least delete the MLX5DV_CONTEXT_FLAGS_MPW
> constant to create a compile failure for this break.

PR was updated as you suggested, series was merged.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
