From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 15:56:19 +0200
Message-ID: <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121132215.GU18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 21/11/2017 15:22, Leon Romanovsky wrote:
> On Tue, Nov 21, 2017 at 12:44:10PM +0200, Mark Bloch wrote:
>> Hi,
>>
>> On 21/11/2017 12:26, Leon Romanovsky wrote:
>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> For now the only LSM security enforcement mechanism available is
>>> specific to InfiniBand. Bypass enforcement for non-IB link types.
>>> This fixes a regression where modify_qp fails for iWARP because
>>> querying the PKEY returns -EINVAL.
>>>
>>> Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
>>> Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Reported-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>>> Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
>>> Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
>>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Tested-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>>  drivers/infiniband/core/security.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
>>> index 23278ed5be45..314bf1137c7b 100644
>>> --- a/drivers/infiniband/core/security.c
>>> +++ b/drivers/infiniband/core/security.c
>>> @@ -417,8 +417,17 @@ void ib_close_shared_qp_security(struct ib_qp_security *sec)
>>>
>>>  int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
>>>  {
>>> +	u8 i = rdma_start_port(dev);
>>> +	bool is_ib = false;
>>>  	int ret;
>>>
>>> +	while (i <= rdma_end_port(dev) && !is_ib)
>>> +		is_ib = rdma_protocol_ib(dev, i++);
>>> +
>>
>> What happens if we have mixed port types?
> 
> We will have is_ib set and qp_sec will be allocated on device layer and
> not on port level, but because pkeys are IB specific term (at least, I
> didn't find any mentioning in RoCE spec), the modify_qp won't query
> for PKEYS.
> 
What is port level for qp_sec?

I just gave mlx4 as an example, but I was talking more about the ability of the RDMA
subsystem to support mixed port types, so in this case, if in the future a vendor
will come with an ib_device with 2 ports, one is IB and one is iWARP bad things will happen.

>> I believe mlx4 can expose two ports where each port uses a different ll protocol.
>> Was that changed?
> 
> It is still true.
> 
>>
>>> +	/* If this isn't an IB device don't create the security context */
>>> +	if (!is_ib)
>>> +		return 0;
>>> +
>>>  	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
>>>  	if (!qp->qp_sec)
>>>  		return -ENOMEM;
>>>
>>
>> Mark.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
