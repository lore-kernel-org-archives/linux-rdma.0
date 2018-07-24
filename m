From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Tue, 24 Jul 2018 15:52:18 -0500
Message-ID: <c0caef97-e709-d817-8629-eaaaa60a38a7@opengridcomputing.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
 <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
 <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me>
 <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
 <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
 <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
 <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
 <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
 <e32726b5-fbe5-178c-719e-8a71517977b0@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <e32726b5-fbe5-178c-719e-8a71517977b0@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


On 7/24/2018 10:24 AM, Steve Wise wrote:
>
> On 7/19/2018 8:25 PM, Max Gurtovoy wrote:
>>>>> [ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=-18
>>>> queue 9 is not mapped (overlap).
>>>> please try the bellow:
>>>>
>>> This seems to work.  Here are three mapping cases:  each vector on its
>>> own cpu, each vector on 1 cpu within the local numa node, and each
>>> vector having all cpus in its numa node.  The 2nd mapping looks kinda
>>> funny, but I think it achieved what you wanted?  And all the cases
>>> resulted in successful connections.
>>>
>> Thanks for testing this.
>> I slightly improved the setting of the left CPUs and actually used
>> Sagi's initial proposal.
>>
>> Sagi,
>> please review the attached patch and let me know if I should add your
>> signature on it.
>> I'll run some perf test early next week on it (meanwhile I run
>> login/logout with different num_queues successfully and irq settings).
>>
>> Steve,
>> It will be great if you can apply the attached in your system and send
>> your findings.
> Sorry, I got side tracked.  I'll try and test this today and report back.
>
> Steve.


###  each vector gets a unique cpu, starting with node-local:

[  754.976577] iw_cxgb4: comp_vector 0, irq 203 mask 0x100
[  754.982378] iw_cxgb4: comp_vector 1, irq 204 mask 0x200
[  754.988167] iw_cxgb4: comp_vector 2, irq 205 mask 0x400
[  754.993935] iw_cxgb4: comp_vector 3, irq 206 mask 0x800
[  754.999686] iw_cxgb4: comp_vector 4, irq 207 mask 0x1000
[  755.005509] iw_cxgb4: comp_vector 5, irq 208 mask 0x2000
[  755.011318] iw_cxgb4: comp_vector 6, irq 209 mask 0x4000
[  755.017124] iw_cxgb4: comp_vector 7, irq 210 mask 0x8000
[  755.022915] iw_cxgb4: comp_vector 8, irq 211 mask 0x1
[  755.028437] iw_cxgb4: comp_vector 9, irq 212 mask 0x2
[  755.033948] iw_cxgb4: comp_vector 10, irq 213 mask 0x4
[  755.039543] iw_cxgb4: comp_vector 11, irq 214 mask 0x8
[  755.045135] iw_cxgb4: comp_vector 12, irq 215 mask 0x10
[  755.050801] iw_cxgb4: comp_vector 13, irq 216 mask 0x20
[  755.056464] iw_cxgb4: comp_vector 14, irq 217 mask 0x40
[  755.062117] iw_cxgb4: comp_vector 15, irq 218 mask 0x80
[  755.067767] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[  755.067767] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[  755.067768] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[  755.067769] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[  755.067769] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[  755.067770] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[  755.067771] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[  755.067772] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[  755.067772] blk_mq_rdma_map_queues: set->mq_map[8] queue 0 vector 0
[  755.067773] blk_mq_rdma_map_queues: set->mq_map[9] queue 1 vector 1
[  755.067774] blk_mq_rdma_map_queues: set->mq_map[10] queue 2 vector 2
[  755.067774] blk_mq_rdma_map_queues: set->mq_map[11] queue 3 vector 3
[  755.067775] blk_mq_rdma_map_queues: set->mq_map[12] queue 4 vector 4
[  755.067775] blk_mq_rdma_map_queues: set->mq_map[13] queue 5 vector 5
[  755.067776] blk_mq_rdma_map_queues: set->mq_map[14] queue 6 vector 6
[  755.067777] blk_mq_rdma_map_queues: set->mq_map[15] queue 7 vector 7

###  each vector gets one cpu within the local node:

[  777.590913] iw_cxgb4: comp_vector 0, irq 203 mask 0x400
[  777.596588] iw_cxgb4: comp_vector 1, irq 204 mask 0x800
[  777.602249] iw_cxgb4: comp_vector 2, irq 205 mask 0x1000
[  777.607984] iw_cxgb4: comp_vector 3, irq 206 mask 0x2000
[  777.613708] iw_cxgb4: comp_vector 4, irq 207 mask 0x4000
[  777.619431] iw_cxgb4: comp_vector 5, irq 208 mask 0x8000
[  777.625142] iw_cxgb4: comp_vector 6, irq 209 mask 0x100
[  777.630762] iw_cxgb4: comp_vector 7, irq 210 mask 0x200
[  777.636373] iw_cxgb4: comp_vector 8, irq 211 mask 0x400
[  777.641982] iw_cxgb4: comp_vector 9, irq 212 mask 0x800
[  777.647583] iw_cxgb4: comp_vector 10, irq 213 mask 0x1000
[  777.653353] iw_cxgb4: comp_vector 11, irq 214 mask 0x2000
[  777.659119] iw_cxgb4: comp_vector 12, irq 215 mask 0x4000
[  777.664877] iw_cxgb4: comp_vector 13, irq 216 mask 0x8000
[  777.670628] iw_cxgb4: comp_vector 14, irq 217 mask 0x100
[  777.676289] iw_cxgb4: comp_vector 15, irq 218 mask 0x200
[  777.681946] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[  777.681947] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[  777.681947] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[  777.681948] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[  777.681948] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[  777.681949] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[  777.681950] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[  777.681950] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[  777.681951] blk_mq_rdma_map_queues: set->mq_map[8] queue 6 vector 6
[  777.681952] blk_mq_rdma_map_queues: set->mq_map[9] queue 7 vector 7
[  777.681952] blk_mq_rdma_map_queues: set->mq_map[10] queue 0 vector 0
[  777.681953] blk_mq_rdma_map_queues: set->mq_map[11] queue 1 vector 1
[  777.681953] blk_mq_rdma_map_queues: set->mq_map[12] queue 2 vector 2
[  777.681954] blk_mq_rdma_map_queues: set->mq_map[13] queue 3 vector 3
[  777.681955] blk_mq_rdma_map_queues: set->mq_map[14] queue 4 vector 4
[  777.681955] blk_mq_rdma_map_queues: set->mq_map[15] queue 5 vector 5


###  each vector gets all cpus within the local node:

[  838.251643] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
[  838.257346] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
[  838.263038] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
[  838.268710] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
[  838.274351] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
[  838.279985] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
[  838.285610] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
[  838.291234] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
[  838.296865] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
[  838.302484] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
[  838.308109] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
[  838.313827] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
[  838.319539] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
[  838.325250] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
[  838.330963] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
[  838.336674] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
[  838.342385] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[  838.342385] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[  838.342386] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[  838.342387] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[  838.342387] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[  838.342388] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[  838.342389] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[  838.342390] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[  838.342391] blk_mq_rdma_map_queues: set->mq_map[8] queue 0 vector 0
[  838.342391] blk_mq_rdma_map_queues: set->mq_map[9] queue 1 vector 1
[  838.342392] blk_mq_rdma_map_queues: set->mq_map[10] queue 2 vector 2
[  838.342392] blk_mq_rdma_map_queues: set->mq_map[11] queue 3 vector 3
[  838.342393] blk_mq_rdma_map_queues: set->mq_map[12] queue 4 vector 4
[  838.342394] blk_mq_rdma_map_queues: set->mq_map[13] queue 5 vector 5
[  838.342394] blk_mq_rdma_map_queues: set->mq_map[14] queue 6 vector 6
[  838.342395] blk_mq_rdma_map_queues: set->mq_map[15] queue 7 vector 7
