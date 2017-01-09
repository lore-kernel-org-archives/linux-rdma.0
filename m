From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] ibverbs: Add support for packet pacing
Date: Mon, 9 Jan 2017 23:44:55 +0200
Message-ID: <c50008b5-f0f2-a1a4-94e7-2354ea2b0123@dev.mellanox.co.il>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
 <1483893148-8211-3-git-send-email-yishaih@mellanox.com>
 <20170109153856.GA29687@obsidianresearch.com>
 <b9cca64f-0d67-6174-74e5-291f93b48c1c@dev.mellanox.co.il>
 <20170109170200.GB13960@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109170200.GB13960-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/9/2017 7:02 PM, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2017 at 06:46:33PM +0200, Yishai Hadas wrote:
>
>>> cmd->rate_limit is not being 0'd if it isn't set
>>
>> The 'cmd' was fully set to 0'd by the provider, see usage in the last patch.
>
> Why are some providers zeroing this and other are not?

ibv_cmd_modify_qp_ex is used only by mlx5 and it uses the = {} 
initialization.
>
>> In case we want to do it in this layer I would vote on using memset at the
>> beginning of that function to prevent repeating this for any new field. Your
>> last patch in that area could do it as well.
>
> Sounds like you should clean this all up and use = {} consistently in
> the providers and drop the explicit = 0.

We can add some pre-patch to the series to make the 
ibv_cmd_modify/ibv_cmd_modify_ex behaves similarly by cleaning up the 
explicit = 0 and use = {} in all the providers.

>> We can consider adding an extra check in ibv_cmd_query_qp as part of this
>> series to check whether IBV_QP_RATE_LIMIT or higher bits were asked, if yes
>> return an error as there is no support for that value without using an
>> extended command, makes sense ?
>
> Absolutely.

Will add this check as part of V1 and return an error for that attr_mask 
value (i.e IBV_QP_RATE_LIMIT) and for higher future bits.

When the extended query_qp command in the kernel will be added we can 
re-discuss whether attr_mask which comes from the application as part of 
ibv_query_qp can serve as an output indication and we can stay with 
current API from application point of view. My personal tendency is go 
with that approach and let applications use one API and handle the 
choice whether to call the legacy or the extended command internally 
based on attr_mask.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
