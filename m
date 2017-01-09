From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] mlx5: Add packet pacing support
Date: Mon, 9 Jan 2017 18:56:01 +0200
Message-ID: <7a1cd159-3818-2d5a-a856-a372142ebd31@dev.mellanox.co.il>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
 <1483893148-8211-4-git-send-email-yishaih@mellanox.com>
 <20170109153943.GB29687@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109153943.GB29687-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/9/2017 5:39 PM, Jason Gunthorpe wrote:
> On Sun, Jan 08, 2017 at 06:32:28PM +0200, Yishai Hadas wrote:
>> +	if (attr_mask & MLX5_MODIFY_QP_EX_ATTR_MASK)
>> +		ret = ibv_cmd_modify_qp_ex(qp, attr, attr_mask,
>> +					   &cmd_ex,
>> +					   sizeof(cmd_ex), sizeof(cmd_ex),
>> +					   &resp,
>> +					   sizeof(resp), sizeof(resp));
>> +	else
>> +		ret = ibv_cmd_modify_qp(qp, attr, attr_mask,
>> +					&cmd, sizeof(cmd));
>>
>
> What is this if doing? Is it trying to retain compat with old kernels?

Correct, only when the input mask requires the extended command it will 
be used, calling the extended command always will fail in legacy kernels 
as they don't support it, need to prevent that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
