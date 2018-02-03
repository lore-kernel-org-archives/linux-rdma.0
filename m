From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Regression: Connect-X5 doesn't connect with NVME-of
Date: Sun, 4 Feb 2018 00:46:09 +0200
Message-ID: <f16d45d1-f20c-253c-87ef-5d396804641b@mellanox.com>
References: <66a5332c-01ee-7a39-8224-189fa52a7298@deltatee.com>
 <e6cdfbe7-762c-c70c-be5f-397bdb08ee80@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e6cdfbe7-762c-c70c-be5f-397bdb08ee80-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Logan,

On 2/3/2018 6:53 AM, Saeed Mahameed wrote:
> 
> 
> On 02/01/2018 09:56 AM, Logan Gunthorpe wrote:
>> Hello,
>>
>> We've experienced a regression with using nvme-of and two Connect-X5s. With v4.15 and v4.14.16 we see the following dmesgs when trying to connect to the target:

I would like to repro it in our labs so please describe the environment 
and the topology you run (B2B/switch/loopback ?)

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

I fixed the panic during connect error flow by fixing the state machine 
in the NVME core.
It should be pushed to 4.16-rc and I hope to 4.15.x soon.

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
> 
> I doubt that the issue is within this fix itself, but with this fix the Automatic affinity settings
> for nvme over rdma is enabled, Maybe a bug was hiding there and we just stepped on it.
> 
> Added Sagi, maybe he can help us spot the issue here.
> 
> Thanks,
> saeed.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
