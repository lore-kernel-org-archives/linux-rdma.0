From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Thu, 19 Jul 2018 13:45:21 -0500
Message-ID: <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/19/2018 9:50 AM, Max Gurtovoy wrote:
>
>
> On 7/18/2018 10:29 PM, Steve Wise wrote:
>>
>>>
>>> On 7/18/2018 2:38 PM, Sagi Grimberg wrote:
>>>>
>>>>>> IMO we must fulfil the user wish to connect to N queues and not
>>>>>> reduce
>>>>>> it because of affinity overlaps. So in order to push Leon's patch we
>>>>>> must also fix the blk_mq_rdma_map_queues to do a best effort
>>> mapping
>>>>>> according the affinity and map the rest in naive way (in that way we
>>>>>> will *always* map all the queues).
>>>>>
>>>>> That is what I would expect also.   For example, in my node, where
>>>>> there are
>>>>> 16 cpus, and 2 numa nodes, I observe much better nvmf IOPS
>>> performance by
>>>>> setting up my 16 driver completion event queues such that each is
>>>>> bound to a
>>>>> node-local cpu.  So I end up with each nodel-local cpu having 2
>>>>> queues
>>>>> bound
>>>>> to it.   W/O adding support in iw_cxgb4 for ib_get_vector_affinity(),
>>>>> this
>>>>> works fine.   I assumed adding ib_get_vector_affinity() would allow
>>>>> this to
>>>>> all "just work" by default, but I'm running into this connection
>>>>> failure
>>>>> issue.
>>>>>
>>>>> I don't understand exactly what the blk_mq layer is trying to do,
>>>>> but I
>>>>> assume it has ingress event queues and processing that it trying
>>>>> to align
>>>>> with the drivers ingress cq event handling, so everybody stays on the
>>>>> same
>>>>> cpu (or at least node).   But something else is going on.  Is there
>>>>> documentation on how this works somewhere?
>>>>
>>>> Does this (untested) patch help?
>>>
>>> I'm not sure (I'll test it tomorrow) because the issue is the unmapped
>>> queues and not the cpus.
>>> for example, if the affinity of q=6 and q=12 returned the same cpumask
>>> than q=6 will not be mapped and will fail to connect.
>>>
>>
>> Attached is a patch that applies cleanly for me.  It has problems if
>> vectors have affinity to more than 1 cpu:
>>
>> [ 2031.988881] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
>> [ 2031.994706] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
>> [ 2032.000348] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
>> [ 2032.005992] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
>> [ 2032.011629] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
>> [ 2032.017271] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
>> [ 2032.022901] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
>> [ 2032.028514] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
>> [ 2032.034110] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
>> [ 2032.039677] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
>> [ 2032.045244] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
>> [ 2032.050889] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
>> [ 2032.056531] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
>> [ 2032.062174] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
>> [ 2032.067817] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
>> [ 2032.073457] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
>> [ 2032.079102] blk_mq_rdma_map_queues: set->mq_map[0] queue 0 vector 0
>> [ 2032.085621] blk_mq_rdma_map_queues: set->mq_map[1] queue 1 vector 1
>> [ 2032.092139] blk_mq_rdma_map_queues: set->mq_map[2] queue 2 vector 2
>> [ 2032.098658] blk_mq_rdma_map_queues: set->mq_map[3] queue 3 vector 3
>> [ 2032.105177] blk_mq_rdma_map_queues: set->mq_map[4] queue 4 vector 4
>> [ 2032.111689] blk_mq_rdma_map_queues: set->mq_map[5] queue 5 vector 5
>> [ 2032.118208] blk_mq_rdma_map_queues: set->mq_map[6] queue 6 vector 6
>> [ 2032.124728] blk_mq_rdma_map_queues: set->mq_map[7] queue 7 vector 7
>> [ 2032.131246] blk_mq_rdma_map_queues: set->mq_map[8] queue 15 vector 15
>> [ 2032.137938] blk_mq_rdma_map_queues: set->mq_map[9] queue 15 vector 15
>> [ 2032.144629] blk_mq_rdma_map_queues: set->mq_map[10] queue 15
>> vector 15
>> [ 2032.151401] blk_mq_rdma_map_queues: set->mq_map[11] queue 15
>> vector 15
>> [ 2032.158172] blk_mq_rdma_map_queues: set->mq_map[12] queue 15
>> vector 15
>> [ 2032.164940] blk_mq_rdma_map_queues: set->mq_map[13] queue 15
>> vector 15
>> [ 2032.171709] blk_mq_rdma_map_queues: set->mq_map[14] queue 15
>> vector 15
>> [ 2032.178477] blk_mq_rdma_map_queues: set->mq_map[15] queue 15
>> vector 15
>> [ 2032.187409] nvme nvme0: Connect command failed, error wo/DNR bit:
>> -16402
>> [ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=-18
>
> queue 9 is not mapped (overlap).
> please try the bellow:
>

This seems to work.  Here are three mapping cases:  each vector on its
own cpu, each vector on 1 cpu within the local numa node, and each
vector having all cpus in its numa node.  The 2nd mapping looks kinda
funny, but I think it achieved what you wanted?  And all the cases
resulted in successful connections.

#### each vector on its own cpu:

[ 3844.756229] iw_cxgb4: comp_vector 0, irq 203 mask 0x100
[ 3844.762104] iw_cxgb4: comp_vector 1, irq 204 mask 0x200
[ 3844.767896] iw_cxgb4: comp_vector 2, irq 205 mask 0x400
[ 3844.773663] iw_cxgb4: comp_vector 3, irq 206 mask 0x800
[ 3844.779405] iw_cxgb4: comp_vector 4, irq 207 mask 0x1000
[ 3844.785231] iw_cxgb4: comp_vector 5, irq 208 mask 0x2000
[ 3844.791043] iw_cxgb4: comp_vector 6, irq 209 mask 0x4000
[ 3844.796835] iw_cxgb4: comp_vector 7, irq 210 mask 0x8000
[ 3844.802619] iw_cxgb4: comp_vector 8, irq 211 mask 0x1
[ 3844.808133] iw_cxgb4: comp_vector 9, irq 212 mask 0x2
[ 3844.813643] iw_cxgb4: comp_vector 10, irq 213 mask 0x4
[ 3844.819235] iw_cxgb4: comp_vector 11, irq 214 mask 0x8
[ 3844.824817] iw_cxgb4: comp_vector 12, irq 215 mask 0x10
[ 3844.830486] iw_cxgb4: comp_vector 13, irq 216 mask 0x20
[ 3844.836148] iw_cxgb4: comp_vector 14, irq 217 mask 0x40
[ 3844.841804] iw_cxgb4: comp_vector 15, irq 218 mask 0x80
[ 3844.847456] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[ 3844.847457] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[ 3844.847457] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[ 3844.847458] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[ 3844.847459] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[ 3844.847459] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[ 3844.847460] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[ 3844.847461] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[ 3844.847462] blk_mq_rdma_map_queues: set->mq_map[8] queue 0 vector 0
[ 3844.847462] blk_mq_rdma_map_queues: set->mq_map[9] queue 1 vector 1
[ 3844.847463] blk_mq_rdma_map_queues: set->mq_map[10] queue 2 vector 2
[ 3844.847463] blk_mq_rdma_map_queues: set->mq_map[11] queue 3 vector 3
[ 3844.847464] blk_mq_rdma_map_queues: set->mq_map[12] queue 4 vector 4
[ 3844.847465] blk_mq_rdma_map_queues: set->mq_map[13] queue 5 vector 5
[ 3844.847465] blk_mq_rdma_map_queues: set->mq_map[14] queue 6 vector 6
[ 3844.847466] blk_mq_rdma_map_queues: set->mq_map[15] queue 7 vector 7

#### each vector on 1 cpu in is numa node

[ 3932.840244] iw_cxgb4: comp_vector 0, irq 203 mask 0x400
[ 3932.846018] iw_cxgb4: comp_vector 1, irq 204 mask 0x800
[ 3932.851687] iw_cxgb4: comp_vector 2, irq 205 mask 0x1000
[ 3932.857428] iw_cxgb4: comp_vector 3, irq 206 mask 0x2000
[ 3932.863160] iw_cxgb4: comp_vector 4, irq 207 mask 0x4000
[ 3932.868882] iw_cxgb4: comp_vector 5, irq 208 mask 0x8000
[ 3932.874594] iw_cxgb4: comp_vector 6, irq 209 mask 0x100
[ 3932.880213] iw_cxgb4: comp_vector 7, irq 210 mask 0x200
[ 3932.885831] iw_cxgb4: comp_vector 8, irq 211 mask 0x400
[ 3932.891440] iw_cxgb4: comp_vector 9, irq 212 mask 0x800
[ 3932.897043] iw_cxgb4: comp_vector 10, irq 213 mask 0x1000
[ 3932.902812] iw_cxgb4: comp_vector 11, irq 214 mask 0x2000
[ 3932.908580] iw_cxgb4: comp_vector 12, irq 215 mask 0x4000
[ 3932.914338] iw_cxgb4: comp_vector 13, irq 216 mask 0x8000
[ 3932.920096] iw_cxgb4: comp_vector 14, irq 217 mask 0x100
[ 3932.925756] iw_cxgb4: comp_vector 15, irq 218 mask 0x200
[ 3932.931413] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[ 3932.931414] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[ 3932.931415] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[ 3932.931416] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[ 3932.931416] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[ 3932.931417] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[ 3932.931418] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[ 3932.931418] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[ 3932.931419] blk_mq_rdma_map_queues: set->mq_map[8] queue 6 vector 6
[ 3932.931420] blk_mq_rdma_map_queues: set->mq_map[9] queue 7 vector 7
[ 3932.931420] blk_mq_rdma_map_queues: set->mq_map[10] queue 0 vector 0
[ 3932.931421] blk_mq_rdma_map_queues: set->mq_map[11] queue 1 vector 1
[ 3932.931422] blk_mq_rdma_map_queues: set->mq_map[12] queue 2 vector 2
[ 3932.931423] blk_mq_rdma_map_queues: set->mq_map[13] queue 3 vector 3
[ 3932.931423] blk_mq_rdma_map_queues: set->mq_map[14] queue 4 vector 4
[ 3932.931425] blk_mq_rdma_map_queues: set->mq_map[15] queue 5 vector 5

### each vector having all cpus in its numa node

[ 4047.308234] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
[ 4047.314042] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
[ 4047.319745] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
[ 4047.325417] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
[ 4047.331062] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
[ 4047.336703] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
[ 4047.342329] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
[ 4047.347953] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
[ 4047.353578] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
[ 4047.359204] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
[ 4047.364829] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
[ 4047.370544] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
[ 4047.376264] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
[ 4047.381983] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
[ 4047.387695] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
[ 4047.393406] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
[ 4047.399118] blk_mq_rdma_map_queues: set->mq_map[0] queue 8 vector 8
[ 4047.399119] blk_mq_rdma_map_queues: set->mq_map[1] queue 9 vector 9
[ 4047.399120] blk_mq_rdma_map_queues: set->mq_map[2] queue 10 vector 10
[ 4047.399121] blk_mq_rdma_map_queues: set->mq_map[3] queue 11 vector 11
[ 4047.399121] blk_mq_rdma_map_queues: set->mq_map[4] queue 12 vector 12
[ 4047.399122] blk_mq_rdma_map_queues: set->mq_map[5] queue 13 vector 13
[ 4047.399123] blk_mq_rdma_map_queues: set->mq_map[6] queue 14 vector 14
[ 4047.399123] blk_mq_rdma_map_queues: set->mq_map[7] queue 15 vector 15
[ 4047.399124] blk_mq_rdma_map_queues: set->mq_map[8] queue 0 vector 0
[ 4047.399125] blk_mq_rdma_map_queues: set->mq_map[9] queue 1 vector 1
[ 4047.399125] blk_mq_rdma_map_queues: set->mq_map[10] queue 2 vector 2
[ 4047.399126] blk_mq_rdma_map_queues: set->mq_map[11] queue 3 vector 3
[ 4047.399127] blk_mq_rdma_map_queues: set->mq_map[12] queue 4 vector 4
[ 4047.399127] blk_mq_rdma_map_queues: set->mq_map[13] queue 5 vector 5
[ 4047.399128] blk_mq_rdma_map_queues: set->mq_map[14] queue 6 vector 6
[ 4047.399128] blk_mq_rdma_map_queues: set->mq_map[15] queue 7 vector 7
