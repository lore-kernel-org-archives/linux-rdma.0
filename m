From: Dag Moxnes <dag.moxnes@oracle.com>
Subject: Re: [PATCH] RDMA/core: Fix race when resolving IP address
Date: Mon, 24 Jun 2019 15:40:24 +0200
Message-ID: <e9b4abe6-0acb-c169-fbac-4e62d2ad2808@oracle.com>
References: <1561126156-10162-1-git-send-email-dag.moxnes@oracle.com>
 <20190621145604.GS19891@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621145604.GS19891@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, leon@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Parav Pandit <parav@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,


Thanks for the review.


On 6/21/19 4:56 PM, Jason Gunthorpe wrote:
> On Fri, Jun 21, 2019 at 04:09:16PM +0200, Dag Moxnes wrote:
>> Use neighbour lock when copying MAC address from neighbour data struct
>> in dst_fetch_ha.
>>
>> When not using the lock, it is possible for the function to race with
>> neigh_update, causing it to copy an invalid MAC address.
>>
>> It is possible to provoke this error by calling rdma_resolve_addr in a
>> tight loop, while deleting the corresponding ARP entry in another tight
>> loop.
>>
>> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
>> Change-Id: I3c5f982b304457f0a83ea7def2fac70315ed38b4
>>   drivers/infiniband/core/addr.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
>> index 2f7d141598..e4945fd1bb 100644
>> +++ b/drivers/infiniband/core/addr.c
>> @@ -333,12 +333,16 @@ static int dst_fetch_ha(const struct dst_entry *dst,
>>   	if (!n)
>>   		return -ENODATA;
>>   
>> +	read_lock_bh(&n->lock)
Miising semicolon at end of statement. Sorry about that.
>>   	if (!(n->nud_state & NUD_VALID)) {
>> -		neigh_event_send(n, NULL);
>>   		ret = -ENODATA;
>>   	} else {
>>   		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
>>   	}
>> +	read_unlock_bh(&n->lock);
>> +
>> +	if (ret)
>> +		neigh_event_send(n, NULL);
>>   
>>   	neigh_release(n);
> Can we write this with less spaghetti please, maybe:
>
> static int dst_fetch_ha(const struct dst_entry *dst,
> 			struct rdma_dev_addr *dev_addr,
> 			const void *daddr)
> {
> 	struct neighbour *n;
> 	int ret = 0;
>
> 	n = dst_neigh_lookup(dst, daddr);
> 	if (!n)
> 		return -ENODATA;
>
> 	read_lock_bh(&n->lock);
> 	if (!(n->nud_state & NUD_VALID)) {
> 		read_unlock_bh(&n->lock);
> 		goto out_send;
> 	}
> 	memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
> 	read_unlock_bh(&n->lock);
>
> 	goto out_release;
>
> out_send:
> 	neigh_event_send(n, NULL);
> 	ret = -ENODATA;
> out_release:
> 	neigh_release(n);
>
> 	return ret;
> }

Personally I find it more readable when the unlock is done in one place,

but sure, I can rewrite it the way you suggest if the reviewers agree that

that way is preferable.

Regards,

-Dag


> Also, Parav should look at it.
>
> Thanks,
> Jason
