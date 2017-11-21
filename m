From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 07:56:46 -0600
Message-ID: <68b94808-4843-2e67-fa88-800fa92d4ce7@mellanox.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 4:44 AM, Mark Bloch wrote:
> Hi,
>
> On 21/11/2017 12:26, Leon Romanovsky wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> For now the only LSM security enforcement mechanism available is
>> specific to InfiniBand. Bypass enforcement for non-IB link types.
>> This fixes a regression where modify_qp fails for iWARP because
>> querying the PKEY returns -EINVAL.
>>
>> Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
>> Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Reported-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
>> Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Tested-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/infiniband/core/security.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
>> index 23278ed5be45..314bf1137c7b 100644
>> --- a/drivers/infiniband/core/security.c
>> +++ b/drivers/infiniband/core/security.c
>> @@ -417,8 +417,17 @@ void ib_close_shared_qp_security(struct ib_qp_security *sec)
>>  
>>  int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
>>  {
>> +	u8 i = rdma_start_port(dev);
>> +	bool is_ib = false;
>>  	int ret;
>>  
>> +	while (i <= rdma_end_port(dev) && !is_ib)
>> +		is_ib = rdma_protocol_ib(dev, i++);
>> +
> What happens if we have mixed port types?
> I believe mlx4 can expose two ports where each port uses a different ll protocol.
> Was that changed?

If any port on the device is IB security is enforced on all QPs because a QP could eventually be modified to an IB port. The primary motivation was to fix a regression in iWARP, which has no concept of PKeys, queries of the PKey cache always returned -EINVAL.  There is a valid PKey cache for RoCE, so it's doesn't suffer the same issue, but this will benefit an all RoCE port device by eliminating the overhead of security enforcement.  If there is ever a multiport device that mixes iWARP and IB this would be a problem, but I don't see that happening.

>
>> +	/* If this isn't an IB device don't create the security context */
>> +	if (!is_ib)
>> +		return 0;
>> +
>>  	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
>>  	if (!qp->qp_sec)
>>  		return -ENOMEM;
>>
> Mark.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
