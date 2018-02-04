From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Regression: Connect-X5 doesn't connect with NVME-of
Date: Sun, 4 Feb 2018 11:57:38 +0200
Message-ID: <0d629a68-a1fa-7297-e371-5abbc2dd5fe7@grimberg.me>
References: <66a5332c-01ee-7a39-8224-189fa52a7298@deltatee.com>
 <e6cdfbe7-762c-c70c-be5f-397bdb08ee80@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e6cdfbe7-762c-c70c-be5f-397bdb08ee80-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Hello,

Hi Logan, thanks for reporting.

>> We've experienced a regression with using nvme-of and two Connect-X5s. With v4.15 and v4.14.16 we see the following dmesgs when trying to connect to the target:
>>
>>> [   43.732539] nvme nvme2: creating 16 I/O queues.
>>> [   44.072427] nvmet: adding queue 1 to ctrl 1.
>>> [   44.072553] nvmet: adding queue 2 to ctrl 1.
>>> [   44.072597] nvme nvme2: Connect command failed, error wo/DNR bit: -16402
>>> [   44.072609] nvme nvme2: failed to connect queue: 3 ret=-18
>>> [   44.075421] nvmet_rdma: freeing queue 2
>>> [   44.075792] nvmet_rdma: freeing queue 1
>>> [   44.264293] nvmet_rdma: freeing queue 3
>>> *snip*
>>
>> (on v4.15 there is additional error panics likely do to some other nvme-of error handling bugs)
>>
>> And nvme connect returns:
>>
>>> Failed to write to /dev/nvme-fabrics: Invalid cross-device link
>>
>> The two adapters are the same with the latest available firmware:
>>
>>>      transport:            InfiniBand (0)
>>>      fw_ver:                16.21.2010
>>>      vendor_id:            0x02c9
>>>      vendor_part_id:            4119
>>>      hw_ver:                0x0
>>>      board_id:            MT_0000000010
>>
>> We bisected to find the commit that broke our setup is:
>>
>> 05e0cc84e00c net/mlx5: Fix get vector affinity helper function

I'm really bummed out about this... I seem to have missed it
in my review and apparently went in untested.

If we look at the patch, it clearly shows that the behavior changed
as mlx5_get_vector_affinity does not add the offset of
MLX5_EQ_VEC_COMP_BASE as before.

The API assumes that completion vector 0 means the first _completion_
vector which means ignoring the private/internal mlx5 vectors created
for stuff like port async events, fw commands and page requests...

What happens is that the consumer asked for affinity mask of
completion vector 0 and got the async event vector and the skew
continued leading to unmapped block queues.

So I think this should make the problem go away:
--
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a0610427e168..b82c4ae92411 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1238,7 +1238,7 @@ mlx5_get_vector_affinity(struct mlx5_core_dev 
*dev, int vector)
         int eqn;
         int err;

-       err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
+       err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, 
&irq);
         if (err)
                 return NULL;
--

Can you verify that this fixes your problem?

Regardless, it looks like we also have a second bug in here such that we 
still attempt to connect a queue which is unmapped and fail the
controller association when it fails. This was not an option before
because PCI_IRQ_AFFINITY guaranteed us that we will have the cpu spread
that we need to ignore this case, but thats changed now.

We should either settle with less queues, or fallback to the
default mq_map for the queues that are left unmapped, or we should
at least continue forward without these unmapped queues (I think
the former makes better sense).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
