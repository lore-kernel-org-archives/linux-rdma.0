From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Wed, 15 Mar 2017 15:48:40 +0800
Message-ID: <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
 <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com>
 <20170310165214.GC14379@mtr-leonro.local>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
 <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DAB4B59A52D1CC2208C1CC73"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0a825b18-df06-9a6d-38c9-402f4ee121f7-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------DAB4B59A52D1CC2208C1CC73
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 03/15/2017 12:52 AM, Max Gurtovoy wrote:
>
>
> On 3/14/2017 3:35 PM, Yi Zhang wrote:
>>
>>
>> On 03/13/2017 02:16 AM, Max Gurtovoy wrote:
>>>
>>>
>>> On 3/10/2017 6:52 PM, Leon Romanovsky wrote:
>>>> On Thu, Mar 09, 2017 at 12:20:14PM +0800, Yi Zhang wrote:
>>>>>
>>>>>> I'm using CX5-LX device and have not seen any issues with it.
>>>>>>
>>>>>> Would it be possible to retest with kmemleak?
>>>>>>
>>>>> Here is the device I used.
>>>>>
>>>>> Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
>>>>>
>>>>> The issue always can be reproduced with about 1000 time.
>>>>>
>>>>> Another thing is I found one strange phenomenon from the log:
>>>>>
>>>>> before the OOM occurred, most of the log are  about "adding 
>>>>> queue", and
>>>>> after the OOM occurred, most of the log are about "nvmet_rdma: 
>>>>> freeing
>>>>> queue".
>>>>>
>>>>> seems the release work: "schedule_work(&queue->release_work);" not
>>>>> executed
>>>>> timely, not sure whether the OOM is caused by this reason.
>>>>
>>>> Sagi,
>>>> The release function is placed in global workqueue. I'm not familiar
>>>> with NVMe design and I don't know all the details, but maybe the
>>>> proper way will
>>>> be to create special workqueue with MEM_RECLAIM flag to ensure the
>>>> progress?
>>>>
>>>
>>> Hi,
>>>
>>> I was able to repro it in my lab with ConnectX3. added a dedicated
>>> workqueue with high priority but the bug still happens.
>>> if I add a "sleep 1" after echo 1
>>> >/sys/block/nvme0n1/device/reset_controller the test pass. So there is
>>> no leak IMO, but the allocation process is much faster than the
>>> destruction of the resources.
>>> In the initiator we don't wait for RDMA_CM_EVENT_DISCONNECTED event
>>> after we call rdma_disconnect, and we try to connect immediatly again.
>>> maybe we need to slow down the storm of connect requests from the
>>> initiator somehow to let the target time to settle up.
>>>
>>> Max.
>>>
>>>
>> Hi Sagi
>> Let's use this mail loop to track the OOM issue. :)
>>
>> Thanks
>> Yi
>
> Hi Yi,
> I can't repro the OOM issue with 4.11-rc2 (don't know why actually).
> which kernel are you using ?
>
> Max.
Hi Max
I tried with 4.11.0-rc2, and still can reproduced it with less than 2000 
times.

Thanks
Yi

--------------DAB4B59A52D1CC2208C1CC73
Content-Type: text/plain; charset=UTF-8;
 name="OOM.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="OOM.txt"

[ 6021.582232] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.582233] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.582233] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.582236] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.582236] Call Trace:
[ 6021.582239]  dump_stack+0x63/0x87
[ 6021.582240]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.582242]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.582246]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.582249]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.582253]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.582255]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.582260]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.582262]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.582263]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.582265]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.582267]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.582268]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.582270]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.582272]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.582274]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.582275]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.582277]  process_one_work+0x165/0x410
[ 6021.582278]  worker_thread+0x137/0x4c0
[ 6021.582280]  kthread+0x101/0x140
[ 6021.582281]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.582283]  ? kthread_park+0x90/0x90
[ 6021.582284]  ret_from_fork+0x2c/0x40
[ 6021.588220] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.588222] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.588222] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.588225] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.588226] Call Trace:
[ 6021.588229]  dump_stack+0x63/0x87
[ 6021.588231]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.588232]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.588236]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.588240]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.588244]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.588247]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.588252]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.588254]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.588255]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.588257]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.588259]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.588261]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.588263]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.588265]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.588266]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.588268]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.588270]  process_one_work+0x165/0x410
[ 6021.588271]  worker_thread+0x137/0x4c0
[ 6021.588273]  kthread+0x101/0x140
[ 6021.588274]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.588275]  ? kthread_park+0x90/0x90
[ 6021.588276]  ret_from_fork+0x2c/0x40
[ 6021.593827] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.593828] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.593829] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.593831] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.593832] Call Trace:
[ 6021.593834]  dump_stack+0x63/0x87
[ 6021.593836]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.593837]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.593842]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.593845]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.593848]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.593851]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.593856]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.593858]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.593860]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.593862]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.593863]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.593865]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.593867]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.593869]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.593870]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.593872]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.593874]  process_one_work+0x165/0x410
[ 6021.593875]  worker_thread+0x137/0x4c0
[ 6021.593876]  kthread+0x101/0x140
[ 6021.593878]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.593879]  ? kthread_park+0x90/0x90
[ 6021.593881]  ret_from_fork+0x2c/0x40
[ 6021.595897] nvmet: adding queue 1 to ctrl 1061.
[ 6021.596096] nvmet: adding queue 2 to ctrl 1061.
[ 6021.601856] nvmet: adding queue 3 to ctrl 1061.
[ 6021.602078] nvmet: adding queue 4 to ctrl 1061.
[ 6021.602318] nvmet: adding queue 5 to ctrl 1061.
[ 6021.602497] nvmet: adding queue 6 to ctrl 1061.
[ 6021.602764] nvmet: adding queue 7 to ctrl 1061.
[ 6021.603052] nvmet: adding queue 8 to ctrl 1061.
[ 6021.603290] nvmet: adding queue 9 to ctrl 1061.
[ 6021.603644] nvmet: adding queue 10 to ctrl 1061.
[ 6021.603946] nvmet: adding queue 11 to ctrl 1061.
[ 6021.604241] nvmet: adding queue 12 to ctrl 1061.
[ 6021.622259] nvmet: adding queue 13 to ctrl 1061.
[ 6021.622573] nvmet: adding queue 14 to ctrl 1061.
[ 6021.622941] nvmet: adding queue 15 to ctrl 1061.
[ 6021.623275] nvmet: adding queue 16 to ctrl 1061.
[ 6021.676942] nvmet_rdma: freeing queue 18021
[ 6021.679059] nvmet_rdma: freeing queue 18022
[ 6021.727425] nvmet: creating controller 1062 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.731639] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.731641] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.731642] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.731645] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.731645] Call Trace:
[ 6021.731649]  dump_stack+0x63/0x87
[ 6021.731651]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.731652]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.731657]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.731660]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.731664]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.731667]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.731672]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.731674]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.731676]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.731678]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.731679]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.731681]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.731683]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.731685]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.731686]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.731688]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.731690]  process_one_work+0x165/0x410
[ 6021.731691]  worker_thread+0x137/0x4c0
[ 6021.731693]  kthread+0x101/0x140
[ 6021.731694]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.731695]  ? kthread_park+0x90/0x90
[ 6021.731697]  ret_from_fork+0x2c/0x40
[ 6021.737314] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.737315] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.737316] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.737318] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.737319] Call Trace:
[ 6021.737321]  dump_stack+0x63/0x87
[ 6021.737323]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.737325]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.737329]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.737332]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.737336]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.737338]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.737343]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.737345]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.737347]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.737349]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.737350]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.737352]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.737354]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.737356]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.737357]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.737359]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.737361]  process_one_work+0x165/0x410
[ 6021.737362]  worker_thread+0x137/0x4c0
[ 6021.737364]  kthread+0x101/0x140
[ 6021.737365]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.737366]  ? kthread_park+0x90/0x90
[ 6021.737368]  ret_from_fork+0x2c/0x40
[ 6021.742828] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.742829] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.742829] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.742832] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.742833] Call Trace:
[ 6021.742835]  dump_stack+0x63/0x87
[ 6021.742837]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.742838]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.742843]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.742847]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.742850]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.742853]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.742857]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.742859]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.742861]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.742863]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.742864]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.742866]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.742868]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.742870]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.742872]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.742873]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.742875]  process_one_work+0x165/0x410
[ 6021.742876]  worker_thread+0x137/0x4c0
[ 6021.742878]  kthread+0x101/0x140
[ 6021.742879]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.742880]  ? kthread_park+0x90/0x90
[ 6021.742882]  ret_from_fork+0x2c/0x40
[ 6021.748754] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.748755] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.748755] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.748758] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.748759] Call Trace:
[ 6021.748761]  dump_stack+0x63/0x87
[ 6021.748763]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.748764]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.748769]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.748772]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.748775]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.748778]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.748783]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.748785]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.748786]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.748788]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.748790]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.748792]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.748793]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.748795]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.748797]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.748799]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.748800]  process_one_work+0x165/0x410
[ 6021.748802]  worker_thread+0x137/0x4c0
[ 6021.748803]  kthread+0x101/0x140
[ 6021.748805]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.748806]  ? kthread_park+0x90/0x90
[ 6021.748807]  ret_from_fork+0x2c/0x40
[ 6021.754730] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.754732] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.754732] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.754735] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.754735] Call Trace:
[ 6021.754738]  dump_stack+0x63/0x87
[ 6021.754740]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.754741]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.754745]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.754749]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.754752]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.754755]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.754759]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.754762]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.754763]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.754765]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.754766]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.754768]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.754770]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.754772]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.754774]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.754776]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.754777]  process_one_work+0x165/0x410
[ 6021.754778]  worker_thread+0x137/0x4c0
[ 6021.754780]  kthread+0x101/0x140
[ 6021.754781]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.754783]  ? kthread_park+0x90/0x90
[ 6021.754784]  ret_from_fork+0x2c/0x40
[ 6021.760237] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.760238] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.760239] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.760241] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.760242] Call Trace:
[ 6021.760245]  dump_stack+0x63/0x87
[ 6021.760247]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.760248]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.760252]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.760256]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.760259]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.760262]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.760267]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.760269]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.760271]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.760273]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.760274]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.760276]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.760278]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.760280]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.760282]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.760284]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.760285]  process_one_work+0x165/0x410
[ 6021.760287]  worker_thread+0x137/0x4c0
[ 6021.760288]  kthread+0x101/0x140
[ 6021.760290]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.760291]  ? kthread_park+0x90/0x90
[ 6021.760293]  ret_from_fork+0x2c/0x40
[ 6021.765587] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.765588] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.765589] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.765591] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.765592] Call Trace:
[ 6021.765595]  dump_stack+0x63/0x87
[ 6021.765597]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.765598]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.765602]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.765606]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.765609]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.765612]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.765614]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.765616]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.765621]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.765623]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.765625]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.765627]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.765628]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.765630]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.765632]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.765634]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.765635]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.765637]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.765639]  process_one_work+0x165/0x410
[ 6021.765640]  worker_thread+0x137/0x4c0
[ 6021.765642]  kthread+0x101/0x140
[ 6021.765643]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.765644]  ? kthread_park+0x90/0x90
[ 6021.765646]  ret_from_fork+0x2c/0x40
[ 6021.771643] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.771644] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.771645] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.771647] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.771648] Call Trace:
[ 6021.771650]  dump_stack+0x63/0x87
[ 6021.771652]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.771653]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.771658]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.771662]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.771664]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.771667]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.771672]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.771674]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.771676]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.771678]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.771679]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.771681]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.771683]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.771685]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.771687]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.771688]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.771690]  process_one_work+0x165/0x410
[ 6021.771691]  worker_thread+0x137/0x4c0
[ 6021.771693]  kthread+0x101/0x140
[ 6021.771694]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.771696]  ? kthread_park+0x90/0x90
[ 6021.771697]  ret_from_fork+0x2c/0x40
[ 6021.775924] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.775926] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.775926] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.775929] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.775930] Call Trace:
[ 6021.775933]  dump_stack+0x63/0x87
[ 6021.775935]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.775936]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.775941]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.775944]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.775948]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.775951]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.775956]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.775958]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.775960]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.775962]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.775963]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.775965]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.775967]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.775969]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.775971]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.775973]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.775974]  process_one_work+0x165/0x410
[ 6021.775976]  worker_thread+0x137/0x4c0
[ 6021.775977]  kthread+0x101/0x140
[ 6021.775979]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.775980]  ? kthread_park+0x90/0x90
[ 6021.775982]  ret_from_fork+0x2c/0x40
[ 6021.779888] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.779889] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.779890] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.779893] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.779893] Call Trace:
[ 6021.779896]  dump_stack+0x63/0x87
[ 6021.779898]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.779900]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.779904]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.779908]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.779911]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.779915]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.779920]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.779922]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.779923]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.779926]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.779927]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.779929]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.779931]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.779933]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.779934]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.779936]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.779938]  process_one_work+0x165/0x410
[ 6021.779939]  worker_thread+0x137/0x4c0
[ 6021.779941]  kthread+0x101/0x140
[ 6021.779942]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.779944]  ? kthread_park+0x90/0x90
[ 6021.779945]  ret_from_fork+0x2c/0x40
[ 6021.784247] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.784248] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.784249] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.784252] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.784252] Call Trace:
[ 6021.784255]  dump_stack+0x63/0x87
[ 6021.784257]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.784259]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.784263]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.784267]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.784270]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.784273]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.784278]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.784280]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.784282]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.784284]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.784285]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.784287]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.784289]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.784291]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.784292]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.784294]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.784296]  process_one_work+0x165/0x410
[ 6021.784297]  worker_thread+0x137/0x4c0
[ 6021.784299]  kthread+0x101/0x140
[ 6021.784300]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.784301]  ? kthread_park+0x90/0x90
[ 6021.784303]  ret_from_fork+0x2c/0x40
[ 6021.789458] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.789460] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.789460] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.789463] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.789463] Call Trace:
[ 6021.789466]  dump_stack+0x63/0x87
[ 6021.789468]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.789469]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.789473]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.789477]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.789480]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.789483]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.789487]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.789490]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.789491]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.789493]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.789494]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.789496]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.789498]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.789500]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.789502]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.789504]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.789505]  process_one_work+0x165/0x410
[ 6021.789506]  worker_thread+0x137/0x4c0
[ 6021.789508]  kthread+0x101/0x140
[ 6021.789509]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.789511]  ? kthread_park+0x90/0x90
[ 6021.789512]  ret_from_fork+0x2c/0x40
[ 6021.794462] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.794464] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.794464] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.794466] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.794467] Call Trace:
[ 6021.794469]  dump_stack+0x63/0x87
[ 6021.794471]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.794472]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.794477]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.794480]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.794483]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.794486]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.794491]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.794493]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.794494]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.794496]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.794498]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.794499]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.794501]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.794503]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.794505]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.794507]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.794508]  process_one_work+0x165/0x410
[ 6021.794509]  worker_thread+0x137/0x4c0
[ 6021.794511]  kthread+0x101/0x140
[ 6021.794512]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.794514]  ? kthread_park+0x90/0x90
[ 6021.794515]  ret_from_fork+0x2c/0x40
[ 6021.800220] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.800221] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.800222] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.800224] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.800225] Call Trace:
[ 6021.800227]  dump_stack+0x63/0x87
[ 6021.800229]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.800230]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.800235]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.800238]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.800242]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.800245]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.800250]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.800252]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.800253]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.800256]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.800257]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.800259]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.800261]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.800263]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.800264]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.800266]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.800268]  process_one_work+0x165/0x410
[ 6021.800269]  worker_thread+0x137/0x4c0
[ 6021.800271]  kthread+0x101/0x140
[ 6021.800272]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.800273]  ? kthread_park+0x90/0x90
[ 6021.800275]  ret_from_fork+0x2c/0x40
[ 6021.805461] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.805463] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.805463] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.805466] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.805466] Call Trace:
[ 6021.805469]  dump_stack+0x63/0x87
[ 6021.805471]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.805472]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.805477]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.805480]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.805484]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.805486]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.805491]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.805493]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.805495]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.805497]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.805498]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.805500]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.805502]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.805504]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.805506]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.805508]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.805509]  process_one_work+0x165/0x410
[ 6021.805511]  worker_thread+0x137/0x4c0
[ 6021.805513]  kthread+0x101/0x140
[ 6021.805514]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.805515]  ? kthread_park+0x90/0x90
[ 6021.805517]  ret_from_fork+0x2c/0x40
[ 6021.810822] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.810824] CPU: 4 PID: 6384 Comm: kworker/4:153 Not tainted 4.11.0-rc2 #6
[ 6021.810824] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.810828] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.810829] Call Trace:
[ 6021.810832]  dump_stack+0x63/0x87
[ 6021.810835]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.810836]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.810843]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.810846]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.810850]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.810853]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.810859]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.810862]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.810864]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.810866]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.810867]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.810869]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.810872]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.810874]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.810875]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.810877]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.810879]  process_one_work+0x165/0x410
[ 6021.810881]  worker_thread+0x137/0x4c0
[ 6021.810883]  kthread+0x101/0x140
[ 6021.810884]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.810885]  ? kthread_park+0x90/0x90
[ 6021.810887]  ret_from_fork+0x2c/0x40
[ 6021.812621] nvmet: adding queue 1 to ctrl 1062.
[ 6021.812804] nvmet: adding queue 2 to ctrl 1062.
[ 6021.813092] nvmet: adding queue 3 to ctrl 1062.
[ 6021.813265] nvmet: adding queue 4 to ctrl 1062.
[ 6021.813490] nvmet: adding queue 5 to ctrl 1062.
[ 6021.813615] nvmet: adding queue 6 to ctrl 1062.
[ 6021.813739] nvmet: adding queue 7 to ctrl 1062.
[ 6021.813850] nvmet: adding queue 8 to ctrl 1062.
[ 6021.813982] nvmet: adding queue 9 to ctrl 1062.
[ 6021.828342] nvmet: adding queue 10 to ctrl 1062.
[ 6021.828699] nvmet: adding queue 11 to ctrl 1062.
[ 6021.848059] nvmet: adding queue 12 to ctrl 1062.
[ 6021.848439] nvmet: adding queue 13 to ctrl 1062.
[ 6021.848815] nvmet: adding queue 14 to ctrl 1062.
[ 6021.849172] nvmet: adding queue 15 to ctrl 1062.
[ 6021.849518] nvmet: adding queue 16 to ctrl 1062.
[ 6021.900726] nvmet_rdma: freeing queue 18048
[ 6021.901911] nvmet_rdma: freeing queue 18049
[ 6021.903491] nvmet_rdma: freeing queue 18050
[ 6021.935901] nvmet: creating controller 1063 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.939116] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.939118] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.939118] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.939121] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.939122] Call Trace:
[ 6021.939125]  dump_stack+0x63/0x87
[ 6021.939127]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.939128]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.939132]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.939136]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.939139]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.939142]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.939147]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.939149]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.939151]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.939153]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.939154]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.939156]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.939158]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.939160]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.939161]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.939163]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.939165]  process_one_work+0x165/0x410
[ 6021.939166]  worker_thread+0x137/0x4c0
[ 6021.939168]  kthread+0x101/0x140
[ 6021.939169]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.939170]  ? kthread_park+0x90/0x90
[ 6021.939172]  ret_from_fork+0x2c/0x40
[ 6023.983224] INFO: task kworker/3:0:30 blocked for more than 120 seconds.
[ 6023.983225]       Not tainted 4.11.0-rc2 #6
[ 6023.983226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983226] kworker/3:0     D    0    30      2 0x00000000
[ 6023.983231] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983232] Call Trace:
[ 6023.983235]  __schedule+0x289/0x8f0
[ 6023.983238]  ? sched_clock+0x9/0x10
[ 6023.983251]  schedule+0x36/0x80
[ 6023.983252]  schedule_timeout+0x249/0x300
[ 6023.983255]  ? console_trylock+0x12/0x50
[ 6023.983256]  ? vprintk_emit+0x2ca/0x370
[ 6023.983257]  wait_for_completion+0x121/0x180
[ 6023.983259]  ? wake_up_q+0x80/0x80
[ 6023.983272]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983273]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983275]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983276]  process_one_work+0x165/0x410
[ 6023.983278]  worker_thread+0x137/0x4c0
[ 6023.983280]  kthread+0x101/0x140
[ 6023.983281]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983282]  ? kthread_park+0x90/0x90
[ 6023.983284]  ret_from_fork+0x2c/0x40
[ 6023.983312] INFO: task kworker/1:1:206 blocked for more than 120 seconds.
[ 6023.983313]       Not tainted 4.11.0-rc2 #6
[ 6023.983313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983313] kworker/1:1     D    0   206      2 0x00000000
[ 6023.983316] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983316] Call Trace:
[ 6023.983317]  __schedule+0x289/0x8f0
[ 6023.983319]  ? sched_clock+0x9/0x10
[ 6023.983320]  schedule+0x36/0x80
[ 6023.983321]  schedule_timeout+0x249/0x300
[ 6023.983322]  ? console_trylock+0x12/0x50
[ 6023.983329]  ? vprintk_emit+0x2ca/0x370
[ 6023.983330]  wait_for_completion+0x121/0x180
[ 6023.983331]  ? wake_up_q+0x80/0x80
[ 6023.983333]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983334]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983336]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983337]  process_one_work+0x165/0x410
[ 6023.983338]  worker_thread+0x137/0x4c0
[ 6023.983340]  kthread+0x101/0x140
[ 6023.983341]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983342]  ? kthread_park+0x90/0x90
[ 6023.983343]  ret_from_fork+0x2c/0x40
[ 6023.983347] INFO: task kworker/21:1:223 blocked for more than 120 seconds.
[ 6023.983347]       Not tainted 4.11.0-rc2 #6
[ 6023.983348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983348] kworker/21:1    D    0   223      2 0x00000000
[ 6023.983350] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983350] Call Trace:
[ 6023.983352]  __schedule+0x289/0x8f0
[ 6023.983353]  ? sched_clock+0x9/0x10
[ 6023.983354]  schedule+0x36/0x80
[ 6023.983355]  schedule_timeout+0x249/0x300
[ 6023.983356]  ? console_trylock+0x12/0x50
[ 6023.983357]  ? vprintk_emit+0x2ca/0x370
[ 6023.983358]  wait_for_completion+0x121/0x180
[ 6023.983359]  ? wake_up_q+0x80/0x80
[ 6023.983361]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983362]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983363]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983364]  process_one_work+0x165/0x410
[ 6023.983366]  worker_thread+0x137/0x4c0
[ 6023.983367]  kthread+0x101/0x140
[ 6023.983368]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983369]  ? kthread_park+0x90/0x90
[ 6023.983371]  ret_from_fork+0x2c/0x40
[ 6023.983375] INFO: task kworker/0:2:308 blocked for more than 120 seconds.
[ 6023.983376]       Not tainted 4.11.0-rc2 #6
[ 6023.983376] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983376] kworker/0:2     D    0   308      2 0x00000000
[ 6023.983378] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983379] Call Trace:
[ 6023.983380]  __schedule+0x289/0x8f0
[ 6023.983381]  ? sched_clock+0x9/0x10
[ 6023.983382]  schedule+0x36/0x80
[ 6023.983383]  schedule_timeout+0x249/0x300
[ 6023.983384]  ? console_trylock+0x12/0x50
[ 6023.983385]  ? vprintk_emit+0x2ca/0x370
[ 6023.983386]  wait_for_completion+0x121/0x180
[ 6023.983387]  ? wake_up_q+0x80/0x80
[ 6023.983388]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983390]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983391]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983392]  process_one_work+0x165/0x410
[ 6023.983394]  worker_thread+0x137/0x4c0
[ 6023.983395]  kthread+0x101/0x140
[ 6023.983396]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983397]  ? kthread_park+0x90/0x90
[ 6023.983399]  ret_from_fork+0x2c/0x40
[ 6023.983401] INFO: task kworker/3:1:325 blocked for more than 120 seconds.
[ 6023.983401]       Not tainted 4.11.0-rc2 #6
[ 6023.983402] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983402] kworker/3:1     D    0   325      2 0x00000000
[ 6023.983404] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983404] Call Trace:
[ 6023.983406]  __schedule+0x289/0x8f0
[ 6023.983407]  ? sched_clock+0x9/0x10
[ 6023.983407]  schedule+0x36/0x80
[ 6023.983408]  schedule_timeout+0x249/0x300
[ 6023.983410]  ? console_trylock+0x12/0x50
[ 6023.983411]  ? vprintk_emit+0x2ca/0x370
[ 6023.983412]  wait_for_completion+0x121/0x180
[ 6023.983413]  ? wake_up_q+0x80/0x80
[ 6023.983414]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983416]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983417]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983418]  process_one_work+0x165/0x410
[ 6023.983419]  worker_thread+0x137/0x4c0
[ 6023.983421]  kthread+0x101/0x140
[ 6023.983422]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983423]  ? kthread_park+0x90/0x90
[ 6023.983424]  ret_from_fork+0x2c/0x40
[ 6023.983426] INFO: task kworker/5:1:329 blocked for more than 120 seconds.
[ 6023.983426]       Not tainted 4.11.0-rc2 #6
[ 6023.983427] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983427] kworker/5:1     D    0   329      2 0x00000000
[ 6023.983429] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983429] Call Trace:
[ 6023.983430]  __schedule+0x289/0x8f0
[ 6023.983432]  ? sched_clock+0x9/0x10
[ 6023.983432]  schedule+0x36/0x80
[ 6023.983433]  schedule_timeout+0x249/0x300
[ 6023.983434]  ? console_trylock+0x12/0x50
[ 6023.983435]  ? vprintk_emit+0x2ca/0x370
[ 6023.983436]  wait_for_completion+0x121/0x180
[ 6023.983437]  ? wake_up_q+0x80/0x80
[ 6023.983439]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983440]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983442]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983443]  process_one_work+0x165/0x410
[ 6023.983444]  worker_thread+0x137/0x4c0
[ 6023.983446]  kthread+0x101/0x140
[ 6023.983447]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983448]  ? kthread_park+0x90/0x90
[ 6023.983449]  ret_from_fork+0x2c/0x40
[ 6023.983450] INFO: task kworker/7:1:332 blocked for more than 120 seconds.
[ 6023.983451]       Not tainted 4.11.0-rc2 #6
[ 6023.983451] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983451] kworker/7:1     D    0   332      2 0x00000000
[ 6023.983453] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983453] Call Trace:
[ 6023.983455]  __schedule+0x289/0x8f0
[ 6023.983456]  ? sched_clock+0x9/0x10
[ 6023.983457]  schedule+0x36/0x80
[ 6023.983458]  schedule_timeout+0x249/0x300
[ 6023.983458]  ? console_trylock+0x12/0x50
[ 6023.983459]  ? vprintk_emit+0x2ca/0x370
[ 6023.983460]  wait_for_completion+0x121/0x180
[ 6023.983461]  ? wake_up_q+0x80/0x80
[ 6023.983463]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983464]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983466]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983467]  process_one_work+0x165/0x410
[ 6023.983468]  worker_thread+0x137/0x4c0
[ 6023.983469]  kthread+0x101/0x140
[ 6023.983470]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983472]  ? kthread_park+0x90/0x90
[ 6023.983473]  ret_from_fork+0x2c/0x40
[ 6023.983474] INFO: task kworker/18:1:333 blocked for more than 120 seconds.
[ 6023.983475]       Not tainted 4.11.0-rc2 #6
[ 6023.983475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983475] kworker/18:1    D    0   333      2 0x00000000
[ 6023.983477] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983478] Call Trace:
[ 6023.983479]  __schedule+0x289/0x8f0
[ 6023.983480]  ? sched_clock+0x9/0x10
[ 6023.983481]  schedule+0x36/0x80
[ 6023.983482]  schedule_timeout+0x249/0x300
[ 6023.983483]  ? console_trylock+0x12/0x50
[ 6023.983484]  ? vprintk_emit+0x2ca/0x370
[ 6023.983485]  wait_for_completion+0x121/0x180
[ 6023.983486]  ? wake_up_q+0x80/0x80
[ 6023.983487]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983489]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983490]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983491]  process_one_work+0x165/0x410
[ 6023.983492]  worker_thread+0x137/0x4c0
[ 6023.983494]  kthread+0x101/0x140
[ 6023.983495]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983496]  ? kthread_park+0x90/0x90
[ 6023.983497]  ret_from_fork+0x2c/0x40
[ 6023.983499] INFO: task kworker/19:1:334 blocked for more than 120 seconds.
[ 6023.983499]       Not tainted 4.11.0-rc2 #6
[ 6023.983500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983500] kworker/19:1    D    0   334      2 0x00000000
[ 6023.983502] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983502] Call Trace:
[ 6023.983504]  __schedule+0x289/0x8f0
[ 6023.983505]  ? sched_clock+0x9/0x10
[ 6023.983506]  schedule+0x36/0x80
[ 6023.983507]  schedule_timeout+0x249/0x300
[ 6023.983508]  ? console_trylock+0x12/0x50
[ 6023.983509]  ? vprintk_emit+0x2ca/0x370
[ 6023.983510]  wait_for_completion+0x121/0x180
[ 6023.983511]  ? wake_up_q+0x80/0x80
[ 6023.983512]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983513]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983515]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983516]  process_one_work+0x165/0x410
[ 6023.983517]  worker_thread+0x137/0x4c0
[ 6023.983519]  kthread+0x101/0x140
[ 6023.983520]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983521]  ? kthread_park+0x90/0x90
[ 6023.983522]  ret_from_fork+0x2c/0x40
[ 6023.983523] INFO: task kworker/22:1:336 blocked for more than 120 seconds.
[ 6023.983524]       Not tainted 4.11.0-rc2 #6
[ 6023.983524] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983524] kworker/22:1    D    0   336      2 0x00000000
[ 6023.983526] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983527] Call Trace:
[ 6023.983528]  __schedule+0x289/0x8f0
[ 6023.983529]  ? sched_clock+0x9/0x10
[ 6023.983530]  schedule+0x36/0x80
[ 6023.983531]  schedule_timeout+0x249/0x300
[ 6023.983532]  ? console_trylock+0x12/0x50
[ 6023.983533]  ? vprintk_emit+0x2ca/0x370
[ 6023.983534]  wait_for_completion+0x121/0x180
[ 6023.983535]  ? wake_up_q+0x80/0x80
[ 6023.983536]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983538]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983539]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983540]  process_one_work+0x165/0x410
[ 6023.983541]  worker_thread+0x137/0x4c0
[ 6023.983543]  kthread+0x101/0x140
[ 6023.983544]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983545]  ? kthread_park+0x90/0x90
[ 6023.983546]  ret_from_fork+0x2c/0x40
[ 6025.263203] nvmet: ctrl 1007 keep-alive timer (15 seconds) expired!
[ 6025.263210] nvmet: ctrl 1007 fatal error occurred!
[ 6029.103135] nvmet: ctrl 1030 keep-alive timer (15 seconds) expired!
[ 6029.103137] nvmet: ctrl 1030 fatal error occurred!
[ 6032.303082] nvmet: ctrl 1046 keep-alive timer (15 seconds) expired!
[ 6032.303083] nvmet: ctrl 1046 fatal error occurred!
[ 6036.143015] nvmet: ctrl 1058 keep-alive timer (15 seconds) expired!
[ 6036.143017] nvmet: ctrl 1058 fatal error occurred!
[ 6041.102122] pgrep invoked oom-killer: gfp_mask=0x16040d0(GFP_TEMPORARY|__GFP_COMP|__GFP_NOTRACK), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.102124] pgrep cpuset=/ mems_allowed=0-1
[ 6041.102128] CPU: 9 PID: 6418 Comm: pgrep Not tainted 4.11.0-rc2 #6
[ 6041.102129] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.102129] Call Trace:
[ 6041.102137]  dump_stack+0x63/0x87
[ 6041.102139]  dump_header+0x9f/0x233
[ 6041.102143]  ? selinux_capable+0x20/0x30
[ 6041.102145]  ? security_capable_noaudit+0x45/0x60
[ 6041.102148]  oom_kill_process+0x21c/0x3f0
[ 6041.102149]  out_of_memory+0x114/0x4a0
[ 6041.102151]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.102154]  __alloc_pages_nodemask+0x240/0x260
[ 6041.102157]  alloc_pages_current+0x88/0x120
[ 6041.102159]  new_slab+0x41f/0x5b0
[ 6041.102160]  ___slab_alloc+0x33e/0x4b0
[ 6041.102163]  ? __d_alloc+0x25/0x1d0
[ 6041.102164]  ? __d_alloc+0x25/0x1d0
[ 6041.102165]  __slab_alloc+0x40/0x5c
[ 6041.102166]  kmem_cache_alloc+0x16d/0x1a0
[ 6041.102167]  ? __d_alloc+0x25/0x1d0
[ 6041.102168]  __d_alloc+0x25/0x1d0
[ 6041.102170]  d_alloc+0x22/0xc0
[ 6041.102171]  d_alloc_parallel+0x6c/0x500
[ 6041.102174]  ? __inode_permission+0x48/0xd0
[ 6041.102175]  ? lookup_fast+0x215/0x3d0
[ 6041.102176]  path_openat+0xc91/0x13c0
[ 6041.102178]  do_filp_open+0x91/0x100
[ 6041.102180]  ? __alloc_fd+0x46/0x170
[ 6041.102182]  do_sys_open+0x124/0x210
[ 6041.102185]  ? __audit_syscall_exit+0x209/0x290
[ 6041.102186]  SyS_open+0x1e/0x20
[ 6041.102189]  do_syscall_64+0x67/0x180
[ 6041.102192]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.102193] RIP: 0033:0x7f6caba59a10
[ 6041.102194] RSP: 002b:00007ffd316e1698 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[ 6041.102195] RAX: ffffffffffffffda RBX: 00007ffd316e16b0 RCX: 00007f6caba59a10
[ 6041.102196] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd316e16b0
[ 6041.102196] RBP: 00007f6cac149ab0 R08: 00007f6cab9b9938 R09: 0000000000000010
[ 6041.102197] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000006d7100
[ 6041.102197] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000000
[ 6041.102199] Mem-Info:
[ 6041.102204] active_anon:0 inactive_anon:0 isolated_anon:0
[ 6041.102204]  active_file:538 inactive_file:167 isolated_file:0
[ 6041.102204]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.102204]  slab_reclaimable:11389 slab_unreclaimable:140375
[ 6041.102204]  mapped:492 shmem:0 pagetables:1494 bounce:0
[ 6041.102204]  free:39252 free_pcp:4025 free_cma:0
[ 6041.102208] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:12kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.102213] Node 1 active_anon:0kB inactive_anon:0kB active_file:2148kB inactive_file:672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1956kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:899 all_unreclaimable? no
[ 6041.102214] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.102217] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.102219] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.102222] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.102223] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7304kB local_pcp:184kB free_cma:0kB
[ 6041.102226] lowmem_reserve[]: 0 0 0 0 0
[ 6041.102228] Node 1 Normal free:44892kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:2148kB inactive_file:672kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278224kB kernel_stack:18520kB pagetables:2868kB bounce:0kB free_pcp:6872kB local_pcp:400kB free_cma:0kB
[ 6041.102231] lowmem_reserve[]: 0 0 0 0 0
[ 6041.102232] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.102238] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.102244] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.102250] Node 1 Normal: 380*4kB (UMEH) 173*8kB (UMEH) 66*16kB (UMH) 219*32kB (UME) 146*64kB (UM) 101*128kB (UME) 36*256kB (UM) 3*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 43992kB
[ 6041.102256] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.102257] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.102258] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.102259] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.102259] 996 total pagecache pages
[ 6041.102260] 39 pages in swap cache
[ 6041.102261] Swap cache stats: add 40374, delete 40331, find 7034/12915
[ 6041.102261] Free swap  = 16387932kB
[ 6041.102262] Total swap = 16516092kB
[ 6041.102262] 8379718 pages RAM
[ 6041.102263] 0 pages HighMem/MovableOnly
[ 6041.102263] 153941 pages reserved
[ 6041.102263] 0 pages cma reserved
[ 6041.102263] 0 pages hwpoisoned
[ 6041.102264] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.102278] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.102280] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.102281] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.102284] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.102286] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.102287] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.102288] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.102289] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.102291] [ 1152]     0  1152     4889       23      14       3      147             0 irqbalance
[ 6041.102292] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.102293] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.102294] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.102296] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.102297] [ 1178]     0  1178    28814       17      11       3       66             0 ksmtuned
[ 6041.102298] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.102299] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.102300] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.102302] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.102303] [ 1968]     0  1968   138299      235      91       4     3231             0 tuned
[ 6041.102304] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.102305] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.102306] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.102308] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.102309] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.102310] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.102311] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.102312] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.102313] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.102316] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.102317] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.102318] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.102319] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.102320] [ 3376]     0  3376    90269        1      96       3     4723             0 beah-beaker-bac
[ 6041.102321] [ 3377]     0  3377    64652        1      84       4     3446             0 beah-srv
[ 6041.102322] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.102324] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.102325] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.102444] [ 6416]     0  6416    28814       17      11       3       64             0 ksmtuned
[ 6041.102445] [ 6417]     0  6417    28814       20      11       3       61             0 ksmtuned
[ 6041.102446] [ 6418]     0  6418    37150      153      28       3       73             0 pgrep
[ 6041.102447] Out of memory: Kill process 3376 (beah-beaker-bac) score 0 or sacrifice child
[ 6041.102453] Killed process 3376 (beah-beaker-bac) total-vm:361076kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.113686] oom_reaper: reaped process 3376 (beah-beaker-bac), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.123498] beah-beaker-bac invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.123500] beah-beaker-bac cpuset=/ mems_allowed=0-1
[ 6041.123503] CPU: 26 PID: 3401 Comm: beah-beaker-bac Not tainted 4.11.0-rc2 #6
[ 6041.123503] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.123503] Call Trace:
[ 6041.123507]  dump_stack+0x63/0x87
[ 6041.123508]  dump_header+0x9f/0x233
[ 6041.123510]  ? selinux_capable+0x20/0x30
[ 6041.123511]  ? security_capable_noaudit+0x45/0x60
[ 6041.123512]  oom_kill_process+0x21c/0x3f0
[ 6041.123513]  out_of_memory+0x114/0x4a0
[ 6041.123514]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.123516]  __alloc_pages_nodemask+0x240/0x260
[ 6041.123518]  alloc_pages_vma+0xa5/0x220
[ 6041.123521]  __read_swap_cache_async+0x148/0x1f0
[ 6041.123522]  read_swap_cache_async+0x26/0x60
[ 6041.123523]  swapin_readahead+0x16b/0x200
[ 6041.123525]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.123528]  ? find_get_entry+0x20/0x140
[ 6041.123529]  ? pagecache_get_page+0x2c/0x240
[ 6041.123531]  do_swap_page+0x2aa/0x780
[ 6041.123532]  __handle_mm_fault+0x6f0/0xe60
[ 6041.123536]  ? hrtimer_try_to_cancel+0xc9/0x120
[ 6041.123538]  handle_mm_fault+0xce/0x240
[ 6041.123541]  __do_page_fault+0x22a/0x4a0
[ 6041.123542]  do_page_fault+0x30/0x80
[ 6041.123544]  page_fault+0x28/0x30
[ 6041.123546] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.123547] RSP: 0018:ffffc90006c6bc28 EFLAGS: 00010287
[ 6041.123548] RAX: 00007f536b73c9e7 RBX: ffff880828ceec80 RCX: 00000000000002b0
[ 6041.123548] RDX: ffff880829182d00 RSI: ffff880828ceec80 RDI: ffff880829182d00
[ 6041.123549] RBP: ffffc90006c6bc78 R08: 000000000001f480 R09: ffff88082af74148
[ 6041.123549] R10: 000000002d827401 R11: ffff88082d820000 R12: ffff880829182d00
[ 6041.123550] R13: 00007f536b73c9e0 R14: ffff880829182d00 R15: ffff8808285299c0
[ 6041.123553]  ? exit_robust_list+0x37/0x120
[ 6041.123555]  mm_release+0x11a/0x130
[ 6041.123557]  do_exit+0x152/0xb80
[ 6041.123559]  ? __unqueue_futex+0x2f/0x60
[ 6041.123560]  do_group_exit+0x3f/0xb0
[ 6041.123562]  get_signal+0x1bf/0x5e0
[ 6041.123565]  do_signal+0x37/0x6a0
[ 6041.123566]  ? do_futex+0xfd/0x570
[ 6041.123568]  exit_to_usermode_loop+0x3f/0x85
[ 6041.123569]  do_syscall_64+0x165/0x180
[ 6041.123571]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.123572] RIP: 0033:0x7f537b92379b
[ 6041.123572] RSP: 002b:00007f536b73ae90 EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
[ 6041.123573] RAX: fffffffffffffe00 RBX: 00000000000000ca RCX: 00007f537b92379b
[ 6041.123574] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f53640028a0
[ 6041.123574] RBP: 00007f53640028a0 R08: 0000000000000000 R09: 00000000016739e0
[ 6041.123575] R10: 0000000000000000 R11: 0000000000000282 R12: fffffffeffffffff
[ 6041.123575] R13: 0000000000000000 R14: 0000000001f45670 R15: 0000000001ec2998
[ 6041.123576] Mem-Info:
[ 6041.123580] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.123580]  active_file:452 inactive_file:211 isolated_file:0
[ 6041.123580]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.123580]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.123580]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.123580]  free:39213 free_pcp:4164 free_cma:0
[ 6041.123585] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.123589] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:848kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1306 all_unreclaimable? no
[ 6041.123589] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.123592] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.123594] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.123597] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.123599] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7304kB local_pcp:152kB free_cma:0kB
[ 6041.123601] lowmem_reserve[]: 0 0 0 0 0
[ 6041.123603] Node 1 Normal free:44736kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:848kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:7428kB local_pcp:608kB free_cma:0kB
[ 6041.123605] lowmem_reserve[]: 0 0 0 0 0
[ 6041.123607] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.123612] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.123618] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB  writepending:0kB present:13631488kB managed:13364292kB mlocked4kB (UMH) 173*8kB (UMH) 66*16kB (UMH) 218*32kB (UM) 146*64kB (UM) 101*128kB (UM) 36*256kB (UM) 3*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 43960kB
[ 6041.123630] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.123630] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.123631] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.123631] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.123632] 870 total pagecache pages
[ 6041.123633] 39 pages in swap cache
[ 6041.123634] Swap cache stats: add 40375, delete 40332, find 7035/12918
[ 6041.123634] Free swap  = 16406620kB
[ 6041.123635] Total swap = 16516092kB
[ 6041.123635] 8379718 pages RAM
[ 6041.123635] 0 pages HighMem/MovableOnly
[ 6041.123636] 153941 pages reserved
[ 6041.123636] 0 pages cma reserved
[ 6041.123636] 0 pages hwpoisone1       3       82             0 systemd-journal
[ 6041.123651] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.123652] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.123655] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.123656] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.123657] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.123659] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.123660] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.123661] [ 1152]     0  1152     4889       22      14       3      147             0 irqbalance
[ 6041.123662] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.123663] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.123664] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.123665] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.123666] [ 1178]     0  1178    28814       17      11       3       66             0 ksmtuned
[ 6041.123667] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.123668] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.123669] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.123670] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.123672] [ 1968]     0  1968   138299      193      91       4     3231             0 tuned
[ 6041.12 40       4      785             0 rsyslogd
[ 6041.123675] [ 1987]     0  1987 677] [ 2047]     0  2047    20619        0      44       3      214         -100 2537    27511        1      12       3       32             0 agetty
[ 6041.123679] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.123680] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.123681] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.123683] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.123684] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.123685] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.123686] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.123688] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.123689] [ 3377]     0  3377    64652        1      84       4     3446             0 beah-srv
[ 6041.123690] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.123691] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.123693] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.123811] [ 6416]     0  6416    28814       17      11       3       64             0 ksmtuned
[ 6041.123812] [ 6417]     0  6417    28814       20      11       3       61             0 ksmtuned
[ 6041.123813] [ 6418]     0  6418    37150      144      28       3       73             0 pgrep
[ 6041.123814] Out of memory: Kill process 3377 (beah-srv) score 0 or sacrifice child
[ 6041.123818] Killed process 3377 (beah-srv) total-vm:258608kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.143543] systemd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.143545] systemd cpuset=/ mems_allowed=0-1
[ 6041.143547] CPU: 27 PID: 1 Comm: systemd Not tainted 4.11.0-rc2 #6
[ 6041.143548] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.143548] Call Trace:
[ 6041.143552]  dump_stack+0x63/0x87
[ 6041.143553]  dump_header+0x9f/0x233
[ 6041.143554]  ? selinux_capable+0x20/0x30
[ 6041.143555]  ? security_capable_noaudit+0x45/0x60
[ 6041.143557]  oom_kill_process+0x21c/0x3f0
[ 6041.143558]  out_of_memory+0x114/0x4a0
[ 6041.143559]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.143561]  __alloc_pages_nodemask+0x240/0x260
[ 6041.143562]  alloc_pages_vma+0xa5/0x220
[ 6041.143564]  __read_swap_cache_async+0x148/0x1f0
[ 6041.143565]  read_swap_cache_async+0x26/0x60
[ 6041.143566]  swapin_readahead+0x16b/0x200
[ 6041.143567]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.143569]  ? find_get_entry+0x20/0x140
[ 6041.143570]  ? pagecache_get_page+0x2c/0x240
[ 6041.143571]  do_swap_page+0x2aa/0x780
[ 6041.143572]  __handle_mm_fault+0x6f0/0xe60
[ 6041.143573]  ? do_anonymous_page+0x283/0x550
[ 6041.143575]  handle_mm_fault+0xce/0x240
[ 6041.143576]  __do_page_fault+0x22a/0x4a0
[ 6041.143577]  ? free_hot_cold_page+0x21f/0x280
[ 6041.143579]  do_page_fault+0x30/0x80
[ 6041.143580]  ? dequeue_entity+0xed/0x420
[ 6041.143582]  page_fault+0x28/0x30
[ 6041.143585] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.143586] RSP: 0018:ffffc90003147d88 EFLAGS: 00010246
[ 6041.143587] RAX: 0000000000000001 RBX: ffffc90003147e08 RCX: 00007ffcfa85b820
[ 6041.143587] RDX: 0000000000000000 RSI: ffff88042fcb3190 RDI: ffff8804be4f8808
[ 6041.143588] RBP: ffffc90003147de0 R08: ffff88042fcb0698 R09: cccccccccccccccd
[ 6041.143588] R10: 0000057e6104dc4a R11: 0000000000000008 R12: 0000000000000000
[ 6041.143589] R13: ffffc90003147ea0 R14: ffff88017d4d6a80 R15: ffff88042fcb0698
[ 6041.143591]  ? ep_send_events_proc+0x93/0x1e0
[ 6041.143592]  ? ep_poll+0x3c0/0x3c0
[ 6041.143593]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.143595]  ep_poll+0x195/0x3c0
[ 6041.143596]  ? wake_up_q+0x80/0x80
[ 6041.143598]  SyS_epoll_wait+0xbc/0xe0
[ 6041.143599]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 6041.143600] RIP: 0033:0x7f43b421bcf3
[ 6041.143601] RSP: 002b:00007ffcfa85b818 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.143602] RAX: ffffffffffffffda RBX: 000055c0f44c5e10 RCX: 00007f43b421bcf3
[ 6041.143602] RDX: 0000000000000029 RSI: 00007ffcfa85b820 RDI: 0000000000000004
[ 6041.143603] RBP: 0000000000000000 R08: 00000000000c9362 R09: 0000000000000000
[ 6041.143603] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 6041.143604] R13: 00007ffcfa859548 R14: 000000000000000c R15: 00007ffcfa859552
[ 6041.143605] Mem-Info:
[ 6041.143609] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.143609]  active_file:452 inactive_file:196 isolated_file:0
[ 6041.143609]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.143609]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.143609]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.143609]  free:39213 free_pcp:4378 free_cma:0
[ 6041.143614] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.143618] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:124 all_unreclaimable? no
[ 6041.143618] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.143621] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.143623] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.143626] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.143627] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7660kB local_pcp:100kB free_cma:0kB
[ 6041.143630] lowmem_reserve[]: 0 0 0 0 0
[ 6041.143632] Node 1 Normal free:44736kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:7928kB local_pcp:636kB free_cma:0kB
[ 6041.143634] lowmem_reserve[]: 0 0 0 0 0
[ 6041.143636] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.143641] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.143647] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.143653] Node 1 Normal: 531*4kB (UMH) 215*8kB (UMH) 73*16kB (UMH) 221*32kB (UM) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45044kB
[ 6041.143659] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.143660] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.143660] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.143661] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.143661] 579 total pagecache pages
[ 6041.143662] 27 pages in swap cache
[ 6041.143663] Swap cache stats: add 40386, delete 40355, find 7036/12923
[ 6041.143663] Free swap  = 16420444kB
[ 6041.143664] Total swap = 16516092kB
[ 6041.143664] 8379718 pages RAM
[ 6041.143664] 0 pages HighMem/MovableOnly
[ 6041.143665] 153941 pages reserved
[ 6041.143665] 0 pages cma reserved
[ 6041.143665] 0 pages hwpoisoned
[ 6041.143665] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.143678] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.143679] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.143680] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.143683] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.143684] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.143686] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.143687] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.143688] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.143689] [ 1152]     0  1152     4889       10      14       3      147             0 irqbalance
[ 6041.143690] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.143691] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.143692] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.143693] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.143694] [ 1178]     0  1178    28814        9      11       3       66             0 ksmtuned
[ 6041.143695] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.143696] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.143697] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.143699] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.143700] [ 1968]     0  1968   138299        0      91       4     3231             0 tuned
[ 6041.143701] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.143702] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.143703] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.143704] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.143705] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.143706] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.143707] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.143708] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.143710] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.143711] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.143712] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.143714] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.143715] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.143716] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.143717] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.143719] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.143720] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.143839] [ 6416]     0  6416    28814        9      11       3       64             0 ksmtuned
[ 6041.143840] [ 6417]     0  6417    28814       12      11       3       61             0 ksmtuned
[ 6041.143841] [ 6418]     0  6418    37150       81      28       3       85             0 pgrep
[ 6041.143842] Out of memory: Kill process 1968 (tuned) score 0 or sacrifice child
[ 6041.143852] Killed process 1968 (tuned) total-vm:553196kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.163655] oom_reaper: reaped process 1968 (tuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.173411] beah-fwd-backen invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.173414] beah-fwd-backen cpuset=/ mems_allowed=0-1
[ 6041.173416] CPU: 24 PID: 3374 Comm: beah-fwd-backen Not tainted 4.11.0-rc2 #6
[ 6041.173417] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.173417] Call Trace:
[ 6041.173420]  dump_stack+0x63/0x87
[ 6041.173422]  dump_header+0x9f/0x233
[ 6041.173423]  ? selinux_capable+0x20/0x30
[ 6041.173424]  ? security_capable_noaudit+0x45/0x60
[ 6041.173425]  oom_kill_process+0x21c/0x3f0
[ 6041.173426]  out_of_memory+0x114/0x4a0
[ 6041.173428]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.173463]  ? xfs_buf_trylock+0x1f/0xd0 [xfs]
[ 6041.173465]  __alloc_pages_nodemask+0x240/0x260
[ 6041.173466]  alloc_pages_vma+0xa5/0x220
[ 6041.173468]  __read_swap_cache_async+0x148/0x1f0
[ 6041.173469]  ? __compute_runnable_contrib+0x1c/0x20
[ 6041.173471]  read_swap_cache_async+0x26/0x60
[ 6041.173472]  swapin_readahead+0x16b/0x200
[ 6041.173473]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.173475]  ? find_get_entry+0x20/0x140
[ 6041.173476]  ? pagecache_get_page+0x2c/0x240
[ 6041.173477]  do_swap_page+0x2aa/0x780
[ 6041.173479]  __handle_mm_fault+0x6f0/0xe60
[ 6041.173481]  ? __block_commit_write.isra.29+0x7a/0xb0
[ 6041.173483]  handle_mm_fault+0xce/0x240
[ 6041.173484]  __do_page_fault+0x22a/0x4a0
[ 6041.173486]  do_page_fault+0x30/0x80
[ 6041.173487]  page_fault+0x28/0x30
[ 6041.173489] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.173489] RSP: 0018:ffffc900056f7d60 EFLAGS: 00010246
[ 6041.173490] RAX: 0000000000000011 RBX: ffffc900056f7de0 RCX: 000000000144afc0
[ 6041.173491] RDX: 0000000000000000 RSI: ffff8808268cf240 RDI: ffff88042eab7100
[ 6041.173491] RBP: ffffc900056f7db8 R08: ffff880829ce6498 R09: cccccccccccccccd
[ 6041.173492] R10: 0000057e5cc9b096 R11: 0000000000000008 R12: 0000000000000000
[ 6041.173493] R13: ffffc900056f7e78 R14: ffff88017db58e40 R15: ffff880829ce6498
[ 6041.173495]  ? ep_poll+0x3c0/0x3c0
[ 6041.173496]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.173497]  ? hrtimer_init+0x190/0x190
[ 6041.173498]  ep_poll+0x195/0x3c0
[ 6041.173500]  ? wake_up_q+0x80/0x80
[ 6041.173501]  SyS_epoll_wait+0xbc/0xe0
[ 6041.173502]  do_syscall_64+0x67/0x180
[ 6041.173504]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.173504] RIP: 0033:0x7fc583ffacf3
[ 6041.173505] RSP: 002b:00007ffc38c49708 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.173506] RAX: ffffffffffffffda RBX: 00007fc58513f210 RCX: 00007fc583ffacf3
[ 6041.173506] RDX: 0000000000000003 RSI: 000000000144afc0 RDI: 0000000000000006
[ 6041.173507] RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000024
[ 6041.173507] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000cac0a0
[ 6041.173508] R13: 000000000144afc0 R14: 000000000153f1f0 R15: 00000000014edab8
[ 6041.173509] Mem-Info:
[ 6041.173514] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.173514]  active_file:452 inactive_file:196 isolated_file:0
[ 6041.173514]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.173514]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.173514]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.173514]  free:39310 free_pcp:4606 free_cma:0
[ 6041.173519] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.173524] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:98 all_unreclaimable? yes
[ 6041.173525] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.173527] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.173529] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.173532] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.173534] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7668kB local_pcp:120kB free_cma:0kB
[ 6041.173536] lowmem_reserve[]: 0 0 0 0 0
[ 6041.173538] Node 1 Normal free:45124kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:8832kB local_pcp:468kB free_cma:0kB
[ 6041.173540] lowmem_reserve[]: 0 0 0 0 0
[ 6041.173542] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.173547] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.173554] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.173559] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.173565] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.173566] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.173567] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.173567] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.173568] 482 total pagecache pages
[ 6041.173569] 23 pages in swap cache
[ 6041.173569] Swap cache stats: add 40392, delete 40365, find 7038/12930
[ 6041.173570] Free swap  = 16433244kB
[ 6041.173570] Total swap = 16516092kB
[ 6041.173571] 8379718 pages RAM
[ 6041.173571] 0 pages HighMem/MovableOnly
[ 6041.173571] 153941 pages reserved
[ 6041.173572] 0 pages cma reserved
[ 6041.173572] 0 pages hwpoisoned
[ 6041.173572] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.173585] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.173586] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.173587] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.173590] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.173591] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.173592] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.173593] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.173594] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.173595] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.173596] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.173598] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.173599] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.173600] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.173601] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.173602] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.173603] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.173604] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.173606] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.173607] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.173608] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.173609] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.173611] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.173612] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.173613] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.173614] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.173615] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.173616] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.173617] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.173619] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.173620] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.173621] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.173623] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.173624] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.173625] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.173627] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.173628] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.173748] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.173749] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.173750] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.173751] Out of memory: Kill process 1897 (dhclient) score 0 or sacrifice child
[ 6041.173756] Killed process 1897 (dhclient) total-vm:112836kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.203482] gmain invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.203484] gmain cpuset=/ mems_allowed=0-1
[ 6041.203487] CPU: 20 PID: 3080 Comm: gmain Not tainted 4.11.0-rc2 #6
[ 6041.203488] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.203488] Call Trace:
[ 6041.203492]  dump_stack+0x63/0x87
[ 6041.203495]  dump_header+0x9f/0x233
[ 6041.203497]  ? selinux_capable+0x20/0x30
[ 6041.203499]  ? security_capable_noaudit+0x45/0x60
[ 6041.203502]  oom_kill_process+0x21c/0x3f0
[ 6041.203503]  out_of_memory+0x114/0x4a0
[ 6041.203504]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.203507]  __alloc_pages_nodemask+0x240/0x260
[ 6041.203510]  alloc_pages_vma+0xa5/0x220
[ 6041.203512]  __read_swap_cache_async+0x148/0x1f0
[ 6041.203513]  read_swap_cache_async+0x26/0x60
[ 6041.203514]  swapin_readahead+0x16b/0x200
[ 6041.203516]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.203518]  ? find_get_entry+0x20/0x140
[ 6041.203519]  ? pagecache_get_page+0x2c/0x240
[ 6041.203521]  do_swap_page+0x2aa/0x780
[ 6041.203522]  __handle_mm_fault+0x6f0/0xe60
[ 6041.203524]  handle_mm_fault+0xce/0x240
[ 6041.203526]  __do_page_fault+0x22a/0x4a0
[ 6041.203527]  do_page_fault+0x30/0x80
[ 6041.203529]  page_fault+0x28/0x30
[ 6041.203532] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.203532] RSP: 0000:ffffc90006e9bad0 EFLAGS: 00010246
[ 6041.203533] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.203534] RDX: 0000000000000000 RSI: ffffc90006e9bb30 RDI: ffffc90006e9bb3c
[ 6041.203534] RBP: ffffc90006e9bee0 R08: 0000000000000000 R09: ffff880828d95280
[ 6041.203535] R10: 0000000000000040 R11: ffff880402286c38 R12: 0000000000000000
[ 6041.203536] R13: ffffc90006e9bb44 R14: 00000000fffffffc R15: 00007ff5700008e0
[ 6041.203538]  ? get_page_from_freelist+0x3e3/0xbe0
[ 6041.203539]  ? get_page_from_freelist+0x3e3/0xbe0
[ 6041.203541]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.203542]  ? __alloc_pages_nodemask+0xe3/0x260
[ 6041.203545]  ? mem_cgroup_commit_charge+0x89/0x120
[ 6041.203547]  ? lru_cache_add_active_or_unevictable+0x35/0xb0
[ 6041.203550]  ? eventfd_ctx_read+0x67/0x210
[ 6041.203551]  ? wake_up_q+0x80/0x80
[ 6041.203552]  ? eventfd_read+0x5d/0x90
[ 6041.203554]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.203555]  SyS_poll+0x74/0x100
[ 6041.203557]  do_syscall_64+0x67/0x180
[ 6041.203559]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.203559] RIP: 0033:0x7ff583029dfd
[ 6041.203560] RSP: 002b:00007ff5749f9e70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.203561] RAX: ffffffffffffffda RBX: 0000000001ed1e00 RCX: 00007ff583029dfd
[ 6041.203561] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007ff5700008e0
[ 6041.203562] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[ 6041.203563] R10: 0000000000000001 R11: 0000000000000293 R12: 00007ff5700008e0
[ 6041.203563] R13: 00000000ffffffff R14: 00007ff5774878b0 R15: 0000000000000001
[ 6041.203564] Mem-Info:
[ 6041.203569] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.203569]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.203569]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.203569]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.203569]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.203569]  free:39185 free_pcp:4665 free_cma:0
[ 6041.203574] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.203578] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:890 all_unreclaimable? yes
[ 6041.203579] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.203581] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.203583] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.203586] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.203588] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7676kB local_pcp:204kB free_cma:0kB
[ 6041.203591] lowmem_reserve[]: 0 0 0 0 0
[ 6041.203592] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9060kB local_pcp:256kB free_cma:0kB
[ 6041.203595] lowmem_reserve[]: 0 0 0 0 0
[ 6041.203596] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.203602] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.203608] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.203614] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.203621] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.203621] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.203622] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.203623] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.203623] 367 total pagecache pages
[ 6041.203626] 23 pages in swap cache
[ 6041.203627] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.203627] Free swap  = 16445788kB
[ 6041.203628] Total swap = 16516092kB
[ 6041.203628] 8379718 pages RAM
[ 6041.203629] 0 pages HighMem/MovableOnly
[ 6041.203629] 153941 pages reserved
[ 6041.203629] 0 pages cma reserved
[ 6041.203630] 0 pages hwpoisoned
[ 6041.203630] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.203644] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.203646] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.203647] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.203650] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.203651] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.203653] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.203654] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.203655] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.203656] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.203657] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.203658] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.203660] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.203661] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.203662] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.203663] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.203664] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.203665] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.203667] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.203668] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.203669] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.203670] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.203672] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.203673] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.203674] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.203675] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.203676] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.203677] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.203679] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.203681] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.203682] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.203683] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.203684] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.203685] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.203687] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.203688] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.203855] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.203856] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.203857] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.203858] Out of memory: Kill process 3374 (beah-fwd-backen) score 0 or sacrifice child
[ 6041.203862] Killed process 3374 (beah-fwd-backen) total-vm:243088kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.204562] oom_reaper: reaped process 3374 (beah-fwd-backen), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.222947] beah-fwd-backen: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.222973] beah-fwd-backen cpuset=/ mems_allowed=0-1
[ 6041.222976] CPU: 24 PID: 3374 Comm: beah-fwd-backen Not tainted 4.11.0-rc2 #6
[ 6041.222976] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.222977] Call Trace:
[ 6041.222981]  dump_stack+0x63/0x87
[ 6041.222982]  warn_alloc+0x114/0x1c0
[ 6041.222984]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.223007]  ? xfs_buf_trylock+0x1f/0xd0 [xfs]
[ 6041.223009]  __alloc_pages_nodemask+0x240/0x260
[ 6041.223011]  alloc_pages_vma+0xa5/0x220
[ 6041.223012]  __read_swap_cache_async+0x148/0x1f0
[ 6041.223014]  ? __compute_runnable_contrib+0x1c/0x20
[ 6041.223016]  read_swap_cache_async+0x26/0x60
[ 6041.223017]  swapin_readahead+0x16b/0x200
[ 6041.223018]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.223020]  ? find_get_entry+0x20/0x140
[ 6041.223021]  ? pagecache_get_page+0x2c/0x240
[ 6041.223034]  do_swap_page+0x2aa/0x780
[ 6041.223036]  __handle_mm_fault+0x6f0/0xe60
[ 6041.223037]  ? __block_commit_write.isra.29+0x7a/0xb0
[ 6041.223038]  handle_mm_fault+0xce/0x240
[ 6041.223040]  __do_page_fault+0x22a/0x4a0
[ 6041.223041]  do_page_fault+0x30/0x80
[ 6041.223043]  page_fault+0x28/0x30
[ 6041.223045] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.223045] RSP: 0018:ffffc900056f7d60 EFLAGS: 00010246
[ 6041.223046] RAX: 0000000000000011 RBX: ffffc900056f7de0 RCX: 000000000144afc0
[ 6041.223047] RDX: 0000000000000000 RSI: ffff8808268cf240 RDI: ffff88042eab7100
[ 6041.223048] RBP: ffffc900056f7db8 R08: ffff880829ce6498 R09: cccccccccccccccd
[ 6041.223049] R10: 0000057e5cc9b096 R11: 0000000000000008 R12: 0000000000000000
[ 6041.223049] R13: ffffc900056f7e78 R14: ffff88017db58e40 R15: ffff880829ce6498
[ 6041.223052]  ? ep_poll+0x3c0/0x3c0
[ 6041.223053]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.223054]  ? hrtimer_init+0x190/0x190
[ 6041.223056]  ep_poll+0x195/0x3c0
[ 6041.223057]  ? wake_up_q+0x80/0x80
[ 6041.223059]  SyS_epoll_wait+0xbc/0xe0
[ 6041.223060]  do_syscall_64+0x67/0x180
[ 6041.223062]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.223063] RIP: 0033:0x7fc583ffacf3
[ 6041.223063] RSP: 002b:00007ffc38c49708 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.223064] RAX: ffffffffffffffda RBX: 00007fc58513f210 RCX: 00007fc583ffacf3
[ 6041.223065] RDX: 0000000000000003 RSI: 000000000144afc0 RDI: 0000000000000006
[ 6041.223065] RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000024
[ 6041.223066] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000cac0a0
[ 6041.223067] R13: 000000000144afc0 R14: 000000000153f1f0 R15: 00000000014edab8
[ 6041.223068] Mem-Info:
[ 6041.223073] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.223073]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.223073]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.223073]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.223073]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.223073]  free:39185 free_pcp:4665 free_cma:0
[ 6041.223078] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.223084] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:991 all_unreclaimable? yes
[ 6041.223084] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.223087] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.223089] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.223092] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.223094] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7676kB local_pcp:120kB free_cma:0kB
[ 6041.223097] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223098] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9060kB local_pcp:468kB free_cma:0kB
[ 6041.223101] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223103] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.223109] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.223115] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.223122] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.223128] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223129] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223130] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223131] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223131] 367 total pagecache pages
[ 6041.223133] 23 pages in swap cache
[ 6041.223133] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.223134] Free swap  = 16458332kB
[ 6041.223134] Total swap = 16516092kB
[ 6041.223135] 8379718 pages RAM
[ 6041.223135] 0 pages HighMem/MovableOnly
[ 6041.223135] 153941 pages reserved
[ 6041.223136] 0 pages cma reserved
[ 6041.223136] 0 pages hwpoisoned
[ 6041.223431] tuned invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.223433] tuned cpuset=/ mems_allowed=0-1
[ 6041.223435] CPU: 23 PID: 3082 Comm: tuned Not tainted 4.11.0-rc2 #6
[ 6041.223436] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.223436] Call Trace:
[ 6041.223439]  dump_stack+0x63/0x87
[ 6041.223441]  dump_header+0x9f/0x233
[ 6041.223442]  ? selinux_capable+0x20/0x30
[ 6041.223443]  ? security_capable_noaudit+0x45/0x60
[ 6041.223445]  oom_kill_process+0x21c/0x3f0
[ 6041.223446]  out_of_memory+0x114/0x4a0
[ 6041.223447]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.223450]  ? hrtimer_try_to_cancel+0xc9/0x120
[ 6041.223452]  __alloc_pages_nodemask+0x240/0x260
[ 6041.223453]  alloc_pages_vma+0xa5/0x220
[ 6041.223455]  __read_swap_cache_async+0x148/0x1f0
[ 6041.223456]  read_swap_cache_async+0x26/0x60
[ 6041.223457]  swapin_readahead+0x16b/0x200
[ 6041.223458]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.223460]  ? find_get_entry+0x20/0x140
[ 6041.223461]  ? pagecache_get_page+0x2c/0x240
[ 6041.223462]  do_swap_page+0x2aa/0x780
[ 6041.223463]  __handle_mm_fault+0x6f0/0xe60
[ 6041.223465]  handle_mm_fault+0xce/0x240
[ 6041.223466]  __do_page_fault+0x22a/0x4a0
[ 6041.223468]  do_page_fault+0x30/0x80
[ 6041.223469]  page_fault+0x28/0x30
[ 6041.223471] RIP: 0010:copy_user_generic_string+0x2c/0x40
[ 6041.223472] RSP: 0018:ffffc90006eabe48 EFLAGS: 00010246
[ 6041.223472] RAX: 0000000000000010 RBX: 00000000fffffdfe RCX: 0000000000000002
[ 6041.223473] RDX: 0000000000000000 RSI: ffffc90006eabe80 RDI: 00007ff56f7fcdd0
[ 6041.223474] RBP: ffffc90006eabe50 R08: 00007ffffffff000 R09: 0000000000000000
[ 6041.223474] R10: ffff88042f9d4760 R11: 0000000000000049 R12: ffffc90006eabed0
[ 6041.223475] R13: 00007ff56f7fcdd0 R14: 0000000000000001 R15: 0000000000000000
[ 6041.223477]  ? _copy_to_user+0x2d/0x40
[ 6041.223478]  poll_select_copy_remaining+0xfb/0x150
[ 6041.223480]  SyS_select+0xcc/0x110
[ 6041.223481]  do_syscall_64+0x67/0x180
[ 6041.223482]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.223483] RIP: 0033:0x7ff58302bba3
[ 6041.223484] RSP: 002b:00007ff56f7fcda0 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[ 6041.223485] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff58302bba3
[ 6041.223485] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 6041.223486] RBP: 00000000021c2400 R08: 00007ff56f7fcdd0 R09: 00007ff56f7fcb80
[ 6041.223486] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ff57b785810
[ 6041.223487] R13: 0000000000000001 R14: 00007ff56000dda0 R15: 00007ff584089ef0
[ 6041.223488] Mem-Info:
[ 6041.223503] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.223503]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.223503]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.223503]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.223503]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.223503]  free:39185 free_pcp:4746 free_cma:0
[ 6041.223508] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.223512] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1196 all_unreclaimable? yes
[ 6041.223513] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.223515] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.223517] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.223520] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.223522] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7868kB local_pcp:96kB free_cma:0kB
[ 6041.223525] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223526] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:296kB free_cma:0kB
[ 6041.223529] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223530] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.223536] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.223542] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.223548] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.223555] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223555] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223556] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223557] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223557] 367 total pagecache pages
[ 6041.223558] 23 pages in swap cache
[ 6041.223559] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.223559] Free swap  = 16458332kB
[ 6041.223559] Total swap = 16516092kB
[ 6041.223560] 8379718 pages RAM
[ 6041.223560] 0 pages HighMem/MovableOnly
[ 6041.223561] 153941 pages reserved
[ 6041.223561] 0 pages cma reserved
[ 6041.223561] 0 pages hwpoisoned
[ 6041.223562] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.223574] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.223576] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.223577] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.223580] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.223581] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.223583] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.223584] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.223585] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.223586] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.223587] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.223588] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.223589] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.223590] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.223591] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.223592] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.223593] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.223594] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.223596] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.223597] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.223598] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.223599] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.223600] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.223601] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.223602] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.223603] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.223604] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.223605] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.223607] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.223608] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.223609] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.223611] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.223612] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.223613] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.223614] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.223786] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.223787] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.223788] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.223789] Out of memory: Kill process 1987 (libvirtd) score 0 or sacrifice child
[ 6041.223841] Killed process 1987 (libvirtd) total-vm:618888kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.224657] oom_reaper: reaped process 1987 (libvirtd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.243393] tuned invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.243395] tuned cpuset=/ mems_allowed=0-1
[ 6041.243399] CPU: 16 PID: 3081 Comm: tuned Not tainted 4.11.0-rc2 #6
[ 6041.243400] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.243400] Call Trace:
[ 6041.243405]  dump_stack+0x63/0x87
[ 6041.243407]  dump_header+0x9f/0x233
[ 6041.243409]  ? selinux_capable+0x20/0x30
[ 6041.243411]  ? security_capable_noaudit+0x45/0x60
[ 6041.243413]  oom_kill_process+0x21c/0x3f0
[ 6041.243414]  out_of_memory+0x114/0x4a0
[ 6041.243416]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.243419]  __alloc_pages_nodemask+0x240/0x260
[ 6041.243421]  alloc_pages_vma+0xa5/0x220
[ 6041.243423]  __read_swap_cache_async+0x148/0x1f0
[ 6041.243425]  read_swap_cache_async+0x26/0x60
[ 6041.243427]  swapin_readahead+0x16b/0x200
[ 6041.243429]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.243431]  ? find_get_entry+0x20/0x140
[ 6041.243433]  ? pagecache_get_page+0x2c/0x240
[ 6041.243435]  do_swap_page+0x2aa/0x780
[ 6041.243436]  __handle_mm_fault+0x6f0/0xe60
[ 6041.243437]  ? update_load_avg+0x809/0x950
[ 6041.243439]  handle_mm_fault+0xce/0x240
[ 6041.243440]  __do_page_fault+0x22a/0x4a0
[ 6041.243442]  do_page_fault+0x30/0x80
[ 6041.243444]  page_fault+0x28/0x30
[ 6041.243446] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.243446] RSP: 0018:ffffc90006ea3ad0 EFLAGS: 00010246
[ 6041.243447] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.243460] RDX: 0000000000000000 RSI: ffffc90006ea3b30 RDI: ffffc90006ea3b3c
[ 6041.243460] RBP: ffffc90006ea3ee0 R08: 0000000000000000 R09: ffff880828d95280
[ 6041.243461] R10: 0000000000000030 R11: ffff880402286938 R12: 0000000000000000
[ 6041.243462] R13: ffffc90006ea3b4c R14: 00000000fffffffc R15: 00007ff568001b80
[ 6041.243464]  ? dequeue_entity+0xed/0x420
[ 6041.243466]  ? select_idle_sibling+0x29/0x3d0
[ 6041.243467]  ? pick_next_task_fair+0x11f/0x540
[ 6041.243469]  ? account_entity_enqueue+0xd8/0x100
[ 6041.243470]  ? __enqueue_entity+0x6c/0x70
[ 6041.243471]  ? enqueue_entity+0x1eb/0x700
[ 6041.243473]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.243474]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.243475]  ? try_to_wake_up+0x59/0x450
[ 6041.243476]  ? wake_up_q+0x4f/0x80
[ 6041.243478]  ? futex_wake+0x90/0x180
[ 6041.243480]  ? do_futex+0x11c/0x570
[ 6041.243482]  ? __vfs_read+0x37/0x150
[ 6041.243483]  ? security_file_permission+0x9d/0xc0
[ 6041.243484]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.243486]  SyS_poll+0x74/0x100
[ 6041.243487]  do_syscall_64+0x67/0x180
[ 6041.243489]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.243489] RIP: 0033:0x7ff583029dfd
[ 6041.243490] RSP: 002b:00007ff56fffdeb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.243491] RAX: ffffffffffffffda RBX: 0000000002128750 RCX: 00007ff583029dfd
[ 6041.243491] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007ff568001b80
[ 6041.243492] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[ 6041.243493] R10: 0000000000000001 R11: 0000000000000293 R12: 00007ff568001b80
[ 6041.243493] R13: 00000000ffffffff R14: 00007ff5774878b0 R15: 0000000000000002
[ 6041.243494] Mem-Info:
[ 6041.243499] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.243499]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.243499]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.243499]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.243499]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.243499]  free:39185 free_pcp:4775 free_cma:0
[ 6041.243522] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.243527] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1806 all_unreclaimable? yes
[ 6041.243527] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.243530] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.243532] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:184kB free_cma:0kB
[ 6041.243535] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.243537] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7984kB local_pcp:788kB free_cma:0kB
[ 6041.243539] lowmem_reserve[]: 0 0 0 0 0
[ 6041.243541] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:688kB free_cma:0kB
[ 6041.243543] lowmem_reserve[]: 0 0 0 0 0
[ 6041.243545] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.243550] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.243557] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.243563] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.243574] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.243574] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.243575] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.243575] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.243576] 367 total pagecache pages
[ 6041.243577] 23 pages in swap cache
[ 6041.243578] Swap cache stats: add 40396, delete 40369, find 7041/12951
[ 6041.243578] Free swap  = 16466780kB
[ 6041.243578] Total swap = 16516092kB
[ 6041.243579] 8379718 pages RAM
[ 6041.243579] 0 pages HighMem/MovableOnly
[ 6041.243580] 153941 pages reserved
[ 6041.243580] 0 pages cma reserved
[ 6041.243580] 0 pages hwpoisoned
[ 6041.243580] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.243593] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.243595] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.243596] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.243599] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.243600] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.243601] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.243602] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.243603] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.243604] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.243606] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.243607] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.243608] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.243609] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.243610] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.243611] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.243612] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.243613] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.243615] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.243616] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.243617] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.243618] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.243619] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.243620] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.243621] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.243622] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.243623] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.243624] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.243626] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.243627] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.243628] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.243630] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.243631] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.243633] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.243641] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.243817] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.243818] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.243819] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.243820] Out of memory: Kill process 1161 (polkitd) score 0 or sacrifice child
[ 6041.243845] Killed process 1161 (polkitd) total-vm:529604kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.244458] oom_reaper: reaped process 1161 (polkitd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.253520] libvirtd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.253522] libvirtd cpuset=/ mems_allowed=0-1
[ 6041.253526] CPU: 1 PID: 3196 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.253527] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.253527] Call Trace:
[ 6041.253530]  dump_stack+0x63/0x87
[ 6041.253532]  dump_header+0x9f/0x233
[ 6041.253533]  ? selinux_capable+0x20/0x30
[ 6041.253535]  ? security_capable_noaudit+0x45/0x60
[ 6041.253536]  oom_kill_process+0x21c/0x3f0
[ 6041.253538]  out_of_memory+0x114/0x4a0
[ 6041.253539]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.253541]  __alloc_pages_nodemask+0x240/0x260
[ 6041.253543]  alloc_pages_vma+0xa5/0x220
[ 6041.253545]  __read_swap_cache_async+0x148/0x1f0
[ 6041.253546]  read_swap_cache_async+0x26/0x60
[ 6041.253548]  swapin_readahead+0x16b/0x200
[ 6041.253550]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.253552]  ? find_get_entry+0x20/0x140
[ 6041.253554]  ? pagecache_get_page+0x2c/0x240
[ 6041.253555]  do_swap_page+0x2aa/0x780
[ 6041.253556]  __handle_mm_fault+0x6f0/0xe60
[ 6041.253559]  ? mls_context_isvalid+0x2b/0xa0
[ 6041.253560]  handle_mm_fault+0xce/0x240
[ 6041.253562]  __do_page_fault+0x22a/0x4a0
[ 6041.253563]  do_page_fault+0x30/0x80
[ 6041.253565]  page_fault+0x28/0x30
[ 6041.253567] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.253568] RSP: 0018:ffffc9000547fc28 EFLAGS: 00010287
[ 6041.253569] RAX: 00007fbe0fd9c9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.253570] RDX: ffff880827191680 RSI: ffff88041395e4c0 RDI: ffff880827191680
[ 6041.253570] RBP: ffffc9000547fc78 R08: 0000000000000101 R09: 000000018020001f
[ 6041.253571] R10: 0000000000000001 R11: ffff880827347400 R12: ffff880827191680
[ 6041.253572] R13: 00007fbe0fd9c9e0 R14: ffff880827191680 R15: ffff8808284ab280
[ 6041.253574]  ? exit_robust_list+0x37/0x120
[ 6041.253576]  mm_release+0x11a/0x130
[ 6041.253577]  do_exit+0x152/0xb80
[ 6041.253578]  ? __unqueue_futex+0x2f/0x60
[ 6041.253580]  do_group_exit+0x3f/0xb0
[ 6041.253581]  get_signal+0x1bf/0x5e0
[ 6041.253584]  do_signal+0x37/0x6a0
[ 6041.253585]  ? do_futex+0xfd/0x570
[ 6041.253588]  exit_to_usermode_loop+0x3f/0x85
[ 6041.253589]  do_syscall_64+0x165/0x180
[ 6041.253591]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.253591] RIP: 0033:0x7fbe2a8576d5
[ 6041.253592] RSP: 002b:00007fbe0fd9bcf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.253593] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.253594] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7d47ec
[ 6041.253594] RBP: 000055c46b7d4848 R08: 000055c46b7d4700 R09: 0000000000000000
[ 6041.253595] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7d4860
[ 6041.253596] R13: 000055c46b7d47c0 R14: 000055c46b7d47e8 R15: 000055c46b7d4780
[ 6041.253597] Mem-Info:
[ 6041.253602] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.253602]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.253602]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.253602]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.253602]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.253602]  free:39185 free_pcp:4773 free_cma:0
[ 6041.253608] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.253614] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:2213 all_unreclaimable? yes
[ 6041.253615] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.253618] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.253621] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.253624] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.253626] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7976kB local_pcp:0kB free_cma:0kB
[ 6041.253629] lowmem_reserve[]: 0 0 0 0 0
[ 6041.253631] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:0kB free_cma:0kB
[ 6041.253634] lowmem_reserve[]: 0 0 0 0 0
[ 6041.253636] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.253643] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.253651] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.253658] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.253665] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.253666] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.253667] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.253667] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.253668] 367 total pagecache pages
[ 6041.253669] 23 pages in swap cache
[ 6041.253670] Swap cache stats: add 40398, delete 40371, find 7042/12959
[ 6041.253670] Free swap  = 16474204kB
[ 6041.253670] Total swap = 16516092kB
[ 6041.253671] 8379718 pages RAM
[ 6041.253672] 0 pages HighMem/MovableOnly
[ 6041.253672] 153941 pages reserved
[ 6041.253672] 0 pages cma reserved
[ 6041.253672] 0 pages hwpoisoned
[ 6041.253673] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.253686] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.253688] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.253689] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.253692] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.253694] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.253696] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.253697] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.253698] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.253699] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.253701] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.253702] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.253703] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.253705] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.253706] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.253707] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.253709] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.253710] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.253712] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.253713] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.253714] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.253716] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.253717] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.253718] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.253719] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.253721] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.253722] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.253723] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.253726] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.253727] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.253728] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.253730] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.253731] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.253733] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.253735] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.253900] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.253902] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.253903] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.253904] Out of memory: Kill process 1977 (rsyslogd) score 0 or sacrifice child
[ 6041.253914] Killed process 1977 (rsyslogd) total-vm:221916kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.283216] oom_reaper: reaped process 1977 (rsyslogd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.283411] kworker/u130:2 invoked oom-killer: gfp_mask=0x17002c2(GFP_KERNEL_ACCOUNT|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_NOTRACK), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.283413] kworker/u130:2 cpuset=/ mems_allowed=0-1
[ 6041.283416] CPU: 15 PID: 1115 Comm: kworker/u130:2 Not tainted 4.11.0-rc2 #6
[ 6041.283417] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.283420] Workqueue: events_unbound call_usermodehelper_exec_work
[ 6041.283421] Call Trace:
[ 6041.283424]  dump_stack+0x63/0x87
[ 6041.283425]  dump_header+0x9f/0x233
[ 6041.283427]  ? selinux_capable+0x20/0x30
[ 6041.283428]  ? security_capable_noaudit+0x45/0x60
[ 6041.283429]  oom_kill_process+0x21c/0x3f0
[ 6041.283431]  out_of_memory+0x114/0x4a0
[ 6041.283432]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.283434]  __alloc_pages_nodemask+0x240/0x260
[ 6041.283436]  alloc_pages_current+0x88/0x120
[ 6041.283437]  __vmalloc_node_range+0x1bb/0x2a0
[ 6041.283438]  ? _do_fork+0xed/0x390
[ 6041.283440]  ? kmem_cache_alloc_node+0x1c4/0x1f0
[ 6041.283441]  copy_process.part.34+0x658/0x1d10
[ 6041.283442]  ? _do_fork+0xed/0x390
[ 6041.283443]  ? call_usermodehelper_exec_work+0xd0/0xd0
[ 6041.283444]  _do_fork+0xed/0x390
[ 6041.283446]  ? __switch_to+0x229/0x450
[ 6041.283447]  kernel_thread+0x29/0x30
[ 6041.283448]  call_usermodehelper_exec_work+0x3a/0xd0
[ 6041.283450]  process_one_work+0x165/0x410
[ 6041.283451]  worker_thread+0x137/0x4c0
[ 6041.283463]  kthread+0x101/0x140
[ 6041.283464]  ? rescuer_thread+0x3b0/0x3b0
[ 6041.283466]  ? kthread_park+0x90/0x90
[ 6041.283467]  ret_from_fork+0x2c/0x40
[ 6041.283468] Mem-Info:
[ 6041.283473] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.283473]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.283473]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.283473]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.283473]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.283473]  free:39030 free_pcp:4818 free_cma:0
[ 6041.283478] Node 0 active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.283483] Node 1 active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1488kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:3325 all_unreclaimable? yes
[ 6041.283484] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.283487] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.283489] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.283503] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.283504] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2780kB bounce:0kB free_pcp:7996kB local_pcp:352kB free_cma:0kB
[ 6041.283507] lowmem_reserve[]: 0 0 0 0 0
[ 6041.283509] Node 1 Normal free:44348kB min:45292kB low:61800kB high:78308kB active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2692kB bounce:0kB free_pcp:9352kB local_pcp:164kB free_cma:0kB
[ 6041.283511] lowmem_reserve[]: 0 0 0 0 0
[ 6041.283513] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.283526] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.283532] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.283538] Node 1 Normal: 524*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45168kB
[ 6041.283545] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.283545] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.283546] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.283546] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.283547] 429 total pagecache pages
[ 6041.283548] 18 pages in swap cache
[ 6041.283549] Swap cache stats: add 40409, delete 40387, find 7044/12965
[ 6041.283549] Free swap  = 16477276kB
[ 6041.283549] Total swap = 16516092kB
[ 6041.283550] 8379718 pages RAM
[ 6041.283550] 0 pages HighMem/MovableOnly
[ 6041.283551] 153941 pages reserved
[ 6041.283551] 0 pages cma reserved
[ 6041.283551] 0 pages hwpoisoned
[ 6041.283552] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.283564] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.283565] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.283567] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.283570] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.283571] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.283572] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.283573] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.283575] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.283576] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.283577] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.283587] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.283588] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.283589] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.283590] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.283591] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.283592] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.283593] [ 1296]     0  1296   637906        0      85       6      605             0 opensm
[ 6041.283595] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.283596] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.283597] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.283599] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.283600] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.283601] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.283602] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.283603] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.283615] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.283616] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.283618] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.283619] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.283620] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.283622] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.283623] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.283625] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.283626] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.283746] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.283747] [ 6417]     0  6417    28814        2      11       3       62             0 ksmtuned
[ 6041.283748] [ 6418]     0  6418    37150        0      28       3       90             0 pgrep
[ 6041.283749] Out of memory: Kill process 1296 (opensm) score 0 or sacrifice child
[ 6041.283831] Killed process 1296 (opensm) total-vm:2551624kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.303267] oom_reaper: reaped process 1296 (opensm), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.303530] runaway-killer- invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.303533] runaway-killer- cpuset=/ mems_allowed=0-1
[ 6041.303537] CPU: 1 PID: 1289 Comm: runaway-killer- Not tainted 4.11.0-rc2 #6
[ 6041.303538] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.303538] Call Trace:
[ 6041.303542]  dump_stack+0x63/0x87
[ 6041.303543]  dump_header+0x9f/0x233
[ 6041.303545]  ? selinux_capable+0x20/0x30
[ 6041.303546]  ? security_capable_noaudit+0x45/0x60
[ 6041.303548]  oom_kill_process+0x21c/0x3f0
[ 6041.303549]  out_of_memory+0x114/0x4a0
[ 6041.303551]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.303553]  __alloc_pages_nodemask+0x240/0x260
[ 6041.303555]  alloc_pages_vma+0xa5/0x220
[ 6041.303557]  __read_swap_cache_async+0x148/0x1f0
[ 6041.303559]  read_swap_cache_async+0x26/0x60
[ 6041.303560]  swapin_readahead+0x16b/0x200
[ 6041.303561]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.303563]  ? find_get_entry+0x20/0x140
[ 6041.303565]  ? pagecache_get_page+0x2c/0x240
[ 6041.303567]  do_swap_page+0x2aa/0x780
[ 6041.303568]  __handle_mm_fault+0x6f0/0xe60
[ 6041.303570]  handle_mm_fault+0xce/0x240
[ 6041.303572]  __do_page_fault+0x22a/0x4a0
[ 6041.303574]  do_page_fault+0x30/0x80
[ 6041.303576]  page_fault+0x28/0x30
[ 6041.303578] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.303578] RSP: 0018:ffffc90005a9fad0 EFLAGS: 00010246
[ 6041.303580] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.303581] RDX: 0000000000000000 RSI: ffffc90005a9fb30 RDI: ffffc90005a9fb3c
[ 6041.303581] RBP: ffffc90005a9fee0 R08: 0000000000000000 R09: ffff880828fda940
[ 6041.303582] R10: 0000000000000048 R11: ffff88042a64ee38 R12: 0000000000000000
[ 6041.303583] R13: ffffc90005a9fb44 R14: 00000000fffffffc R15: 00007f9640001220
[ 6041.303586]  ? select_idle_sibling+0x29/0x3d0
[ 6041.303588]  ? select_task_rq_fair+0x942/0xa70
[ 6041.303590]  ? __vma_adjust+0x4a7/0x700
[ 6041.303591]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.303593]  ? sched_clock+0x9/0x10
[ 6041.303595]  ? sched_clock_cpu+0x11/0xb0
[ 6041.303596]  ? try_to_wake_up+0x59/0x450
[ 6041.303599]  ? plist_del+0x62/0xb0
[ 6041.303600]  ? wake_up_q+0x4f/0x80
[ 6041.303602]  ? eventfd_ctx_read+0x67/0x210
[ 6041.303604]  ? futex_wake+0x90/0x180
[ 6041.303605]  ? wake_up_q+0x80/0x80
[ 6041.303607]  ? eventfd_read+0x4c/0x90
[ 6041.303608]  ? __vfs_read+0x37/0x150
[ 6041.303610]  ? security_file_permission+0x9d/0xc0
[ 6041.303611]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.303613]  SyS_poll+0x74/0x100
[ 6041.303615]  do_syscall_64+0x67/0x180
[ 6041.303616]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.303618] RIP: 0033:0x7f9656e64dfd
[ 6041.303618] RSP: 002b:00007f96511fed10 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.303619] RAX: ffffffffffffffda RBX: 00007f96400008c0 RCX: 00007f9656e64dfd
[ 6041.303620] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f9640001220
[ 6041.303621] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[ 6041.303621] R10: 0000000000000001 R11: 0000000000000293 R12: 00007f9640001220
[ 6041.303622] R13: 00000000ffffffff R14: 00007f9657bbc8b0 R15: 0000000000000001
[ 6041.303623] Mem-Info:
[ 6041.303630] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.303630]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.303630]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.303630]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.303630]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.303630]  free:39030 free_pcp:4795 free_cma:0
[ 6041.303636] Node 0 active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4 all_unreclaimable? yes
[ 6041.303643] Node 1 active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1488kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4171 all_unreclaimable? yes
[ 6041.303644] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.303649] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.303651] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.303655] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.303657] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2780kB bounce:0kB free_pcp:7888kB local_pcp:24kB free_cma:0kB
[ 6041.303660] lowmem_reserve[]: 0 0 0 0 0
[ 6041.303663] Node 1 Normal free:44348kB min:45292kB low:61800kB high:78308kB active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2692kB bounce:0kB free_pcp:9368kB local_pcp:0kB free_cma:0kB
[ 6041.303666] lowmem_reserve[]: 0 0 0 0 0
[ 6041.303668] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.303675] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.303684] Node 0 Normal: 93*4kB (UMH) 49*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.303692] Node 1 Normal: 524*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45168kB
[ 6041.303701] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.303702] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.303703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.303703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.303704] 429 total pagecache pages
[ 6041.303705] 12 pages in swap cache
[ 6041.303706] Swap cache stats: add 40421, delete 40405, find 7046/13000
[ 6041.303706] Free swap  = 16477948kB
[ 6041.303707] Total swap = 16516092kB
[ 6041.303708] 8379718 pages RAM
[ 6041.303708] 0 pages HighMem/MovableOnly
[ 6041.303708] 153941 pages reserved
[ 6041.303709] 0 pages cma reserved
[ 6041.303709] 0 pages hwpoisoned
[ 6041.303709] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.303723] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.303725] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.303727] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.303730] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.303731] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.303733] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.303734] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.303735] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.303737] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.303738] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.303740] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.303741] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.303743] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.303744] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.303746] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.303747] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.303749] [ 1323]     0  1296   637906        0      85       6       26             0 opensm
[ 6041.303751] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.303752] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.303753] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.303755] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.303757] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.303758] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.303759] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.303761] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.303762] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.303764] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.303766] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.303768] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.303769] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.303771] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.303773] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.303775] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.303776] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.303940] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.303941] [ 6417]     0  6417    28814        0      11       3       64             0 ksmtuned
[ 6041.303943] [ 6418]     0  6418    37150        0      28       3       91             0 pgrep
[ 6041.303956] Out of memory: Kill process 1118 (abrtd) score 0 or sacrifice child
[ 6041.303963] Killed process 1118 (abrtd) total-vm:212532kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.304370] Out of memory: Kill process 1146 (abrt-watch-log) score 0 or sacrifice child
[ 6041.304377] Killed process 1146 (abrt-watch-log) total-vm:210204kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.323549] Out of memory: Kill process 805 (lvmetad) score 0 or sacrifice child
[ 6041.323555] Killed process 805 (lvmetad) total-vm:121396kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.353395] Out of memory: Kill process 4185 (bash) score 0 or sacrifice child
[ 6041.353400] Killed process 4185 (bash) total-vm:116592kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.354059] Out of memory: Kill process 4181 (sshd) score 0 or sacrifice child
[ 6041.354061] Killed process 4181 (sshd) total-vm:140880kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.354445] oom_reaper: reaped process 4181 (sshd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.354694] Out of memory: Kill process 3062 (master) score 0 or sacrifice child
[ 6041.354699] Killed process 3086 (qmgr) total-vm:91240kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.355354] Out of memory: Kill process 3062 (master) score 0 or sacrifice child
[ 6041.355356] Killed process 3062 (master) total-vm:91068kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.355700] oom_reaper: reaped process 3062 (master), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.356005] Out of memory: Kill process 3373 (crond) score 0 or sacrifice child
[ 6041.356008] Killed process 3373 (crond) total-vm:126228kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.356652] Out of memory: Kill process 1220 (gssproxy) score 0 or sacrifice child
[ 6041.356676] Killed process 1220 (gssproxy) total-vm:201220kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.356960] oom_reaper: reaped process 1220 (gssproxy), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.357203] Out of memory: Kill process 1152 (irqbalance) score 0 or sacrifice child
[ 6041.357210] Killed process 1152 (irqbalance) total-vm:19556kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.372960] sshd: 
[ 6041.372962] master: 
[ 6041.372963] page allocation failure: order:0
[ 6041.372964] page allocation failure: order:0
[ 6041.372966] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.372967] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.372968] (null)
[ 6041.372968] (null)
[ 6041.372968] sshd cpuset=
[ 6041.372969] master cpuset=
[ 6041.372969] / mems_allowed=0-1
[ 6041.372971] / mems_allowed=0-1
[ 6041.372973] CPU: 28 PID: 4181 Comm: sshd Not tainted 4.11.0-rc2 #6
[ 6041.372974] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.372974] Call Trace:
[ 6041.372978]  dump_stack+0x63/0x87
[ 6041.372980]  warn_alloc+0x114/0x1c0
[ 6041.372982]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.372984]  __alloc_pages_nodemask+0x240/0x260
[ 6041.372985]  alloc_pages_vma+0xa5/0x220
[ 6041.372987]  __read_swap_cache_async+0x148/0x1f0
[ 6041.372989]  read_swap_cache_async+0x26/0x60
[ 6041.372990]  swapin_readahead+0x16b/0x200
[ 6041.372991]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.372993]  ? find_get_entry+0x20/0x140
[ 6041.372995]  ? pagecache_get_page+0x2c/0x240
[ 6041.372996]  do_swap_page+0x2aa/0x780
[ 6041.372997]  __handle_mm_fault+0x6f0/0xe60
[ 6041.372999]  handle_mm_fault+0xce/0x240
[ 6041.373001]  __do_page_fault+0x22a/0x4a0
[ 6041.373002]  do_page_fault+0x30/0x80
[ 6041.373004]  page_fault+0x28/0x30
[ 6041.373006] RIP: 0010:copy_user_generic_string+0x2c/0x40
[ 6041.373006] RSP: 0018:ffffc900083a7d20 EFLAGS: 00010246
[ 6041.373007] RAX: 0000000000000008 RBX: 0000555561846560 RCX: 0000000000000001
[ 6041.373008] RDX: 0000000000000000 RSI: ffffc900083a7da0 RDI: 0000555561846560
[ 6041.373009] RBP: ffffc900083a7d28 R08: ffffc900083a7b98 R09: ffff88042ac29400
[ 6041.373009] R10: 0000000000000010 R11: 0000000000000114 R12: ffffc900083a7d88
[ 6041.373010] R13: 0000000000000001 R14: 000000000000000d R15: ffffc900083a7d88
[ 6041.373012]  ? set_fd_set+0x21/0x30
[ 6041.373014]  core_sys_select+0x1f3/0x2f0
[ 6041.373016]  SyS_select+0xba/0x110
[ 6041.373018]  do_syscall_64+0x67/0x180
[ 6041.373019]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.373020] RIP: 0033:0x7effdb4e2b83
[ 6041.373021] RSP: 002b:00007ffd3a4d8698 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[ 6041.373022] RAX: ffffffffffffffda RBX: 00007ffd3a4d8738 RCX: 00007effdb4e2b83
[ 6041.373022] RDX: 00005555618474c0 RSI: 0000555561846560 RDI: 000000000000000d
[ 6041.373023] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 6041.373023] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd3a4d8740
[ 6041.373024] R13: 00007ffd3a4d8730 R14: 00007ffd3a4d8734 R15: 0000555561846560
[ 6041.373026] CPU: 15 PID: 3062 Comm: master Not tainted 4.11.0-rc2 #6
[ 6041.373027] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.373027] Call Trace:
[ 6041.373031]  dump_stack+0x63/0x87
[ 6041.373032]  warn_alloc+0x114/0x1c0
[ 6041.373034]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.373036]  __alloc_pages_nodemask+0x240/0x260
[ 6041.373038]  alloc_pages_vma+0xa5/0x220
[ 6041.373040]  __read_swap_cache_async+0x148/0x1f0
[ 6041.373041]  ? update_sd_lb_stats+0x180/0x620
[ 6041.373043]  read_swap_cache_async+0x26/0x60
[ 6041.373044]  swapin_readahead+0x16b/0x200
[ 6041.373045]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.373047]  ? find_get_entry+0x20/0x140
[ 6041.373049]  ? pagecache_get_page+0x2c/0x240
[ 6041.373050]  do_swap_page+0x2aa/0x780
[ 6041.373051]  __handle_mm_fault+0x6f0/0xe60
[ 6041.373053]  handle_mm_fault+0xce/0x240
[ 6041.373055]  __do_page_fault+0x22a/0x4a0
[ 6041.373056]  do_page_fault+0x30/0x80
[ 6041.373058]  page_fault+0x28/0x30
[ 6041.373060] RIP: 0010:__clear_user+0x25/0x50
[ 6041.373060] RSP: 0018:ffffc90006b2bda0 EFLAGS: 00010202
[ 6041.373061] RAX: 0000000000000000 RBX: 00007fff9c6e4680 RCX: 0000000000000008
[ 6041.373062] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007fff9c6e4880
[ 6041.373063] RBP: ffffc90006b2bda0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.373063] R10: 0000000028c6b701 R11: 00007fff9c6e4680 R12: 00007fff9c6e4680
[ 6041.373064] R13: ffff88082a408000 R14: 0000000000000000 R15: 0000000000000000
[ 6041.373067]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.373069]  do_signal+0x516/0x6a0
[ 6041.373071]  exit_to_usermode_loop+0x3f/0x85
[ 6041.373073]  do_syscall_64+0x165/0x180
[ 6041.373074]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.373075] RIP: 0033:0x7fe4e2dfdcf3
[ 6041.373075] RSP: 002b:00007fff9c6e4a48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.373076] RAX: fffffffffffffffc RBX: 00007fff9c6e4a50 RCX: 00007fe4e2dfdcf3
[ 6041.373077] RDX: 0000000000000064 RSI: 00007fff9c6e4a50 RDI: 000000000000000f
[ 6041.373078] RBP: 0000000000000038 R08: 0000000000000000 R09: 0000000000000000
[ 6041.373078] R10: 000000000000dac0 R11: 0000000000000246 R12: 000055ae43cd36e4
[ 6041.373079] R13: 000055ae43cd3660 R14: 000055ae43cd49c8 R15: 000055ae4480db50
[ 6041.373415] Out of memory: Kill process 1156 (smartd) score 0 or sacrifice child
[ 6041.373425] Killed process 1156 (smartd) total-vm:127876kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.393400] Out of memory: Kill process 6418 (pgrep) score 0 or sacrifice child
[ 6041.393403] Killed process 6418 (pgrep) total-vm:148600kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.393741] oom_reaper: reaped process 6418 (pgrep), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.394087] Out of memory: Kill process 779 (systemd-journal) score 0 or sacrifice child
[ 6041.394090] Killed process 779 (systemd-journal) total-vm:36824kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.394354] oom_reaper: reaped process 779 (systemd-journal), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.394719] Out of memory: Kill process 1163 (systemd-logind) score 0 or sacrifice child
[ 6041.394722] Killed process 1163 (systemd-logind) total-vm:24200kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.394984] oom_reaper: reaped process 1163 (systemd-logind), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.395357] Out of memory: Kill process 1123 (chronyd) score 0 or sacrifice child
[ 6041.395362] Killed process 1123 (chronyd) total-vm:22688kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.396025] Out of memory: Kill process 1178 (ksmtuned) score 0 or sacrifice child
[ 6041.396028] Killed process 6416 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.396604] Out of memory: Kill process 1178 (ksmtuned) score 0 or sacrifice child
[ 6041.396607] Killed process 1178 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.396744] ksmtuned: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.396746] ksmtuned cpuset=/ mems_allowed=0-1
[ 6041.396748] CPU: 31 PID: 1178 Comm: ksmtuned Not tainted 4.11.0-rc2 #6
[ 6041.396749] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.396749] Call Trace:
[ 6041.396753]  dump_stack+0x63/0x87
[ 6041.396754]  warn_alloc+0x114/0x1c0
[ 6041.396755]  ? out_of_memory+0x11e/0x4a0
[ 6041.396757]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.396759]  __alloc_pages_nodemask+0x240/0x260
[ 6041.396760]  alloc_pages_vma+0xa5/0x220
[ 6041.396762]  __read_swap_cache_async+0x148/0x1f0
[ 6041.396763]  read_swap_cache_async+0x26/0x60
[ 6041.396764]  swapin_readahead+0x16b/0x200
[ 6041.396765]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.396767]  ? find_get_entry+0x20/0x140
[ 6041.396768]  ? pagecache_get_page+0x2c/0x240
[ 6041.396770]  do_swap_page+0x2aa/0x780
[ 6041.396771]  __handle_mm_fault+0x6f0/0xe60
[ 6041.396772]  handle_mm_fault+0xce/0x240
[ 6041.396774]  __do_page_fault+0x22a/0x4a0
[ 6041.396775]  do_page_fault+0x30/0x80
[ 6041.396777]  page_fault+0x28/0x30
[ 6041.396778] RIP: 0010:__clear_user+0x25/0x50
[ 6041.396779] RSP: 0018:ffffc90005d3fda0 EFLAGS: 00010202
[ 6041.396780] RAX: 0000000000000000 RBX: 00007fff89b0f000 RCX: 0000000000000008
[ 6041.396780] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007fff89b0f200
[ 6041.396781] RBP: ffffc90005d3fda0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.396781] R10: 0000000028d8bc01 R11: 00007fff89b0f000 R12: 00007fff89b0f000
[ 6041.396782] R13: ffff880826b14380 R14: 0000000000000000 R15: 0000000000000000
[ 6041.396785]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.396786]  do_signal+0x516/0x6a0
[ 6041.396788]  exit_to_usermode_loop+0x3f/0x85
[ 6041.396789]  do_syscall_64+0x165/0x180
[ 6041.396791]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.396791] RIP: 0033:0x7fe23a73bc00
[ 6041.396792] RSP: 002b:00007fff89b0f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 6041.396793] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 00007fe23a73bc00
[ 6041.396793] RDX: 0000000000000080 RSI: 00007fff89b0f470 RDI: 0000000000000003
[ 6041.396794] RBP: 0000000000000080 R08: 00007fff89b0f380 R09: 00007fff89b0f230
[ 6041.396794] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff89b0f470
[ 6041.396795] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000001
[ 6041.396798] oom_reaper: reaped process 1178 (ksmtuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.402965] systemd-journal: page allocation failure: order:0
[ 6041.402968] pgrep: 
[ 6041.402969] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.402971] page allocation failure: order:0
[ 6041.402971] (null)
[ 6041.402973] , mode:0x16040d0(GFP_TEMPORARY|__GFP_COMP|__GFP_NOTRACK), nodemask=
[ 6041.402973] systemd-journal cpuset=
[ 6041.402974] (null)
[ 6041.402974] /
[ 6041.402975] pgrep cpuset=
[ 6041.402976]  mems_allowed=0-1
[ 6041.402977] /
[ 6041.402979] CPU: 10 PID: 779 Comm: systemd-journal Not tainted 4.11.0-rc2 #6
[ 6041.402980]  mems_allowed=0-1
[ 6041.402980] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.402981] Call Trace:
[ 6041.402985]  dump_stack+0x63/0x87
[ 6041.402987]  warn_alloc+0x114/0x1c0
[ 6041.402989]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.402992]  __alloc_pages_nodemask+0x240/0x260
[ 6041.402994]  alloc_pages_vma+0xa5/0x220
[ 6041.402997]  __read_swap_cache_async+0x148/0x1f0
[ 6041.402998]  ? select_task_rq_fair+0x942/0xa70
[ 6041.403000]  read_swap_cache_async+0x26/0x60
[ 6041.403002]  swapin_readahead+0x16b/0x200
[ 6041.403004]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.403006]  ? find_get_entry+0x20/0x140
[ 6041.403008]  ? pagecache_get_page+0x2c/0x240
[ 6041.403009]  do_swap_page+0x2aa/0x780
[ 6041.403011]  __handle_mm_fault+0x6f0/0xe60
[ 6041.403013]  handle_mm_fault+0xce/0x240
[ 6041.403015]  __do_page_fault+0x22a/0x4a0
[ 6041.403018]  do_page_fault+0x30/0x80
[ 6041.403019]  ? dequeue_entity+0xed/0x420
[ 6041.403021]  page_fault+0x28/0x30
[ 6041.403023] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.403024] RSP: 0018:ffffc90005093d88 EFLAGS: 00010246
[ 6041.403026] RAX: 0000000000000011 RBX: ffffc90005093e08 RCX: 00007ffddc3838d0
[ 6041.403027] RDX: 0000000000000000 RSI: ffff88082f2f8f80 RDI: ffff880827246700
[ 6041.403028] RBP: ffffc90005093de0 R08: ffff880829d62718 R09: cccccccccccccccd
[ 6041.403029] R10: 0000057e5ecdb8d3 R11: 0000000000000008 R12: 0000000000000000
[ 6041.403030] R13: ffffc90005093ea0 R14: ffff8804297dab40 R15: ffff880829d62718
[ 6041.403032]  ? ep_send_events_proc+0x93/0x1e0
[ 6041.403034]  ? ep_poll+0x3c0/0x3c0
[ 6041.403036]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.403038]  ep_poll+0x195/0x3c0
[ 6041.403040]  ? wake_up_q+0x80/0x80
[ 6041.403042]  SyS_epoll_wait+0xbc/0xe0
[ 6041.403044]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 6041.403046] RIP: 0033:0x7ff643546cf3
[ 6041.403046] RSP: 002b:00007ffddc3838c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.403048] RAX: ffffffffffffffda RBX: 000000000000001b RCX: 00007ff643546cf3
[ 6041.403049] RDX: 000000000000001b RSI: 00007ffddc3838d0 RDI: 0000000000000007
[ 6041.403050] RBP: 00007ff64492a6a0 R08: 000000000007923c R09: 0000000000000001
[ 6041.403051] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 6041.403052] R13: 000000000000001b R14: 00007ffddc384f7d R15: 00005592ded50190
[ 6041.403056] CPU: 25 PID: 6418 Comm: pgrep Not tainted 4.11.0-rc2 #6
[ 6041.403056] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.403057] Call Trace:
[ 6041.403061]  dump_stack+0x63/0x87
[ 6041.403063]  warn_alloc+0x114/0x1c0
[ 6041.403066]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.403068]  __alloc_pages_nodemask+0x240/0x260
[ 6041.403070]  alloc_pages_current+0x88/0x120
[ 6041.403072]  new_slab+0x41f/0x5b0
[ 6041.403074]  ___slab_alloc+0x33e/0x4b0
[ 6041.403076]  ? __d_alloc+0x25/0x1d0
[ 6041.403078]  ? __d_alloc+0x25/0x1d0
[ 6041.403079]  __slab_alloc+0x40/0x5c
[ 6041.403081]  kmem_cache_alloc+0x16d/0x1a0
[ 6041.403082]  ? __d_alloc+0x25/0x1d0
[ 6041.403084]  __d_alloc+0x25/0x1d0
[ 6041.403086]  d_alloc+0x22/0xc0
[ 6041.403088]  d_alloc_parallel+0x6c/0x500
[ 6041.403091]  ? __inode_permission+0x48/0xd0
[ 6041.403093]  ? lookup_fast+0x215/0x3d0
[ 6041.403095]  path_openat+0xc91/0x13c0
[ 6041.403097]  do_filp_open+0x91/0x100
[ 6041.403099]  ? __alloc_fd+0x46/0x170
[ 6041.403101]  do_sys_open+0x124/0x210
[ 6041.403102]  ? __audit_syscall_exit+0x209/0x290
[ 6041.403104]  SyS_open+0x1e/0x20
[ 6041.403106]  do_syscall_64+0x67/0x180
[ 6041.403108]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.403110] RIP: 0033:0x7f6caba59a10
[ 6041.403111] RSP: 002b:00007ffd316e1698 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[ 6041.403112] RAX: ffffffffffffffda RBX: 00007ffd316e16b0 RCX: 00007f6caba59a10
[ 6041.403113] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd316e16b0
[ 6041.403114] RBP: 00007f6cac149ab0 R08: 00007f6cab9b9938 R09: 0000000000000010
[ 6041.403115] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000006d7100
[ 6041.403116] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000000
[ 6041.403120] SLUB: Unable to allocate memory on node -1, gfp=0x14000c0(GFP_KERNEL)
[ 6041.403121]   cache: dentry, object size: 192, buffer size: 192, default order: 1, min order: 0
[ 6041.403122]   node 0: slabs: 463, objs: 19425, free: 0
[ 6041.403123]   node 1: slabs: 884, objs: 35112, free: 0
[ 6041.403514] Out of memory: Kill process 6417 (ksmtuned) score 0 or sacrifice child
[ 6041.403517] Killed process 6417 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.412951] systemd-logind: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.412971] systemd-logind cpuset=/ mems_allowed=0-1
[ 6041.412974] CPU: 24 PID: 1163 Comm: systemd-logind Not tainted 4.11.0-rc2 #6
[ 6041.412974] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.412975] Call Trace:
[ 6041.412978]  dump_stack+0x63/0x87
[ 6041.412980]  warn_alloc+0x114/0x1c0
[ 6041.412981]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.412984]  __alloc_pages_nodemask+0x240/0x260
[ 6041.412985]  alloc_pages_vma+0xa5/0x220
[ 6041.412987]  __read_swap_cache_async+0x148/0x1f0
[ 6041.412988]  read_swap_cache_async+0x26/0x60
[ 6041.412990]  swapin_readahead+0x16b/0x200
[ 6041.412991]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.412993]  ? find_get_entry+0x20/0x140
[ 6041.412994]  ? pagecache_get_page+0x2c/0x240
[ 6041.412996]  do_swap_page+0x2aa/0x780
[ 6041.412997]  __handle_mm_fault+0x6f0/0xe60
[ 6041.412999]  handle_mm_fault+0xce/0x240
[ 6041.413000]  __do_page_fault+0x22a/0x4a0
[ 6041.413002]  do_page_fault+0x30/0x80
[ 6041.413004]  page_fault+0x28/0x30
[ 6041.413005] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.413006] RSP: 0018:ffffc90005ce7d60 EFLAGS: 00010246
[ 6041.413007] RAX: 0000000000000010 RBX: ffffc90005ce7de0 RCX: 00007ffc58e36210
[ 6041.413008] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000002
[ 6041.413008] RBP: ffffc90005ce7db8 R08: ffff88042e222d18 R09: cccccccccccccccd
[ 6041.413009] R10: 0000057e6b9137a4 R11: 0000000000000018 R12: 0000000000000000
[ 6041.413009] R13: ffffc90005ce7e78 R14: ffff8804bd9f5440 R15: ffff88042e222d18
[ 6041.413012]  ? ep_poll+0x3c0/0x3c0
[ 6041.413013]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.413015]  ep_poll+0x195/0x3c0
[ 6041.413016]  ? wake_up_q+0x80/0x80
[ 6041.413018]  SyS_epoll_wait+0xbc/0xe0
[ 6041.413019]  do_syscall_64+0x67/0x180
[ 6041.413021]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.413021] RIP: 0033:0x7f751d498cf3
[ 6041.413022] RSP: 002b:00007ffc58e36208 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.413023] RAX: ffffffffffffffda RBX: 00007ffc58e36210 RCX: 00007f751d498cf3
[ 6041.413023] RDX: 000000000000000b RSI: 00007ffc58e36210 RDI: 0000000000000004
[ 6041.413024] RBP: 00007ffc58e36390 R08: 000000000000000e R09: 0000000000000001
[ 6041.413025] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000001
[ 6041.413025] R13: ffffffffffffffff R14: 00007ffc58e363f0 R15: 00005581334e9260
[ 6041.423461] ksmtuned: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.423465] ksmtuned cpuset=/ mems_allowed=0-1
[ 6041.423469] CPU: 12 PID: 6417 Comm: ksmtuned Not tainted 4.11.0-rc2 #6
[ 6041.423470] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.423471] Call Trace:
[ 6041.423475]  dump_stack+0x63/0x87
[ 6041.423477]  warn_alloc+0x114/0x1c0
[ 6041.423480]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.423482]  ? schedule_timeout+0x249/0x300
[ 6041.423485]  __alloc_pages_nodemask+0x240/0x260
[ 6041.423487]  alloc_pages_vma+0xa5/0x220
[ 6041.423490]  __read_swap_cache_async+0x148/0x1f0
[ 6041.423491]  read_swap_cache_async+0x26/0x60
[ 6041.423493]  swapin_readahead+0x16b/0x200
[ 6041.423494]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.423497]  ? find_get_entry+0x20/0x140
[ 6041.423499]  ? pagecache_get_page+0x2c/0x240
[ 6041.423500]  do_swap_page+0x2aa/0x780
[ 6041.423502]  __handle_mm_fault+0x6f0/0xe60
[ 6041.423504]  handle_mm_fault+0xce/0x240
[ 6041.423506]  __do_page_fault+0x22a/0x4a0
[ 6041.423508]  do_page_fault+0x30/0x80
[ 6041.423510]  page_fault+0x28/0x30
[ 6041.423512] RIP: 0010:__put_user_4+0x1c/0x30
[ 6041.423513] RSP: 0018:ffffc900082a7dc8 EFLAGS: 00010297
[ 6041.423515] RAX: 0000000000000009 RBX: 00007fffffffeffd RCX: 00007fff89b0e590
[ 6041.423516] RDX: ffff8808291bee80 RSI: 0000000000000009 RDI: ffff880828fe41c8
[ 6041.423517] RBP: ffffc900082a7e38 R08: 0000000000000000 R09: 0000000000000219
[ 6041.423518] R10: 0000000000000000 R11: 000000000003de7d R12: ffff880823278000
[ 6041.423519] R13: ffffc900082a7ea0 R14: 0000000000000010 R15: 0000000000001912
[ 6041.423522]  ? wait_consider_task+0x46c/0xb40
[ 6041.423524]  ? sched_clock_cpu+0x11/0xb0
[ 6041.423525]  do_wait+0xf4/0x240
[ 6041.423527]  SyS_wait4+0x80/0x100
[ 6041.423529]  ? task_stopped_code+0x50/0x50
[ 6041.423531]  do_syscall_64+0x67/0x180
[ 6041.423533]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.423535] RIP: 0033:0x7fe23a71127c
[ 6041.423535] RSP: 002b:00007fff89b0e568 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
[ 6041.423537] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe23a71127c
[ 6041.423538] RDX: 0000000000000000 RSI: 00007fff89b0e590 RDI: ffffffffffffffff
[ 6041.423539] RBP: 0000000000bb4d50 R08: 0000000000bb4d50 R09: 0000000000000000
[ 6041.423540] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 6041.423541] R13: 0000000000000001 R14: 0000000000bb48c0 R15: 0000000000000000
[ 6041.433391] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 6041.433397] Killed process 3340 (dnsmasq) total-vm:15524kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434032] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 6041.434034] Killed process 3339 (dnsmasq) total-vm:15552kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434300] oom_reaper: reaped process 3339 (dnsmasq), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434658] Out of memory: Kill process 1991 (atd) score 0 or sacrifice child
[ 6041.434662] Killed process 1991 (atd) total-vm:25852kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.435291] Out of memory: Kill process 1295 (opensm-launch) score 0 or sacrifice child
[ 6041.435295] Killed process 1295 (opensm-launch) total-vm:115252kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.435912] Out of memory: Kill process 1976 (rhsmcertd) score 0 or sacrifice child
[ 6041.435917] Killed process 1976 (rhsmcertd) total-vm:113348kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.436542] Out of memory: Kill process 1155 (lsmd) score 0 or sacrifice child
[ 6041.436546] Killed process 1155 (lsmd) total-vm:8532kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.437170] Out of memory: Kill process 2537 (agetty) score 0 or sacrifice child
[ 6041.437173] Killed process 2537 (agetty) total-vm:110044kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.437782] Out of memory: Kill process 2540 (agetty) score 0 or sacrifice child
[ 6041.437785] Killed process 2540 (agetty) total-vm:110044kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.438391] Out of memory: Kill process 3381 (rhnsd) score 0 or sacrifice child
[ 6041.438395] Killed process 3381 (rhnsd) total-vm:107892kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.438950] Out of memory: Kill process 1121 (dbus-daemon) score 0 or sacrifice child
[ 6041.438957] Killed process 1121 (dbus-daemon) total-vm:34856kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.452934] dnsmasq: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.452938] dnsmasq cpuset=/ mems_allowed=0-1
[ 6041.452942] CPU: 31 PID: 3339 Comm: dnsmasq Not tainted 4.11.0-rc2 #6
[ 6041.452943] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.452943] Call Trace:
[ 6041.452948]  dump_stack+0x63/0x87
[ 6041.452950]  warn_alloc+0x114/0x1c0
[ 6041.452952]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.452954]  ? __switch_to+0x229/0x450
[ 6041.452957]  __alloc_pages_nodemask+0x240/0x260
[ 6041.452959]  alloc_pages_vma+0xa5/0x220
[ 6041.452961]  __read_swap_cache_async+0x148/0x1f0
[ 6041.452963]  read_swap_cache_async+0x26/0x60
[ 6041.452965]  swapin_readahead+0x16b/0x200
[ 6041.452966]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.452969]  ? find_get_entry+0x20/0x140
[ 6041.452971]  ? pagecache_get_page+0x2c/0x240
[ 6041.452973]  do_swap_page+0x2aa/0x780
[ 6041.452974]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.452976]  __handle_mm_fault+0x6f0/0xe60
[ 6041.452978]  handle_mm_fault+0xce/0x240
[ 6041.452980]  __do_page_fault+0x22a/0x4a0
[ 6041.452982]  do_page_fault+0x30/0x80
[ 6041.452984]  page_fault+0x28/0x30
[ 6041.452987] RIP: 0010:__clear_user+0x25/0x50
[ 6041.452987] RSP: 0018:ffffc90005817da0 EFLAGS: 00010202
[ 6041.452989] RAX: 0000000000000000 RBX: 00007ffe6a725dc0 RCX: 0000000000000008
[ 6041.452990] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007ffe6a725fc0
[ 6041.452991] RBP: ffffc90005817da0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.452992] R10: 0000000028d1b901 R11: 00007ffe6a725dc0 R12: 00007ffe6a725dc0
[ 6041.452993] R13: ffff880829239680 R14: 0000000000000000 R15: 0000000000000000
[ 6041.452996]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.452998]  do_signal+0x516/0x6a0
[ 6041.453001]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453003]  do_syscall_64+0x165/0x180
[ 6041.453005]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453006] RIP: 0033:0x7f26144f2b83
[ 6041.453007] RSP: 002b:00007ffe6a7261a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[ 6041.453009] RAX: fffffffffffffffc RBX: 0000559eb9450560 RCX: 00007f26144f2b83
[ 6041.453010] RDX: 00007ffe6a7262b0 RSI: 00007ffe6a726230 RDI: 0000000000000008
[ 6041.453010] RBP: 00007ffe6a726230 R08: 0000000000000000 R09: 0000000000000000
[ 6041.453011] R10: 00007ffe6a726330 R11: 0000000000000246 R12: 00007ffe6a7261ec
[ 6041.453012] R13: 0000000000000000 R14: 0000000058c8ce9e R15: 00007ffe6a7262b0
[ 6041.453021] oom_reaper: reaped process 1121 (dbus-daemon), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.453344] libvirtd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.453346] libvirtd cpuset=/ mems_allowed=0-1
[ 6041.453349] CPU: 16 PID: 2731 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.453349] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.453350] Call Trace:
[ 6041.453353]  dump_stack+0x63/0x87
[ 6041.453355]  dump_header+0x9f/0x233
[ 6041.453356]  ? oom_unkillable_task+0x9e/0xc0
[ 6041.453357]  ? find_lock_task_mm+0x3b/0x80
[ 6041.453359]  ? cpuset_mems_allowed_intersects+0x21/0x30
[ 6041.453360]  ? oom_unkillable_task+0x9e/0xc0
[ 6041.453361]  out_of_memory+0x39f/0x4a0
[ 6041.453362]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.453364]  __alloc_pages_nodemask+0x240/0x260
[ 6041.453366]  alloc_pages_vma+0xa5/0x220
[ 6041.453368]  __read_swap_cache_async+0x148/0x1f0
[ 6041.453369]  read_swap_cache_async+0x26/0x60
[ 6041.453370]  swapin_readahead+0x16b/0x200
[ 6041.453372]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.453373]  ? find_get_entry+0x20/0x140
[ 6041.453375]  ? pagecache_get_page+0x2c/0x240
[ 6041.453376]  do_swap_page+0x2aa/0x780
[ 6041.453377]  __handle_mm_fault+0x6f0/0xe60
[ 6041.453379]  handle_mm_fault+0xce/0x240
[ 6041.453381]  __do_page_fault+0x22a/0x4a0
[ 6041.453382]  do_page_fault+0x30/0x80
[ 6041.453384]  page_fault+0x28/0x30
[ 6041.453386] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.453386] RSP: 0018:ffffc900069dbc28 EFLAGS: 00010287
[ 6041.453388] RAX: 00007fbe1cfef9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.453388] RDX: ffff8804285fc380 RSI: ffff88041395e4c0 RDI: ffff8804285fc380
[ 6041.453389] RBP: ffffc900069dbc78 R08: ffff88042f79b940 R09: 0000000000000000
[ 6041.453389] R10: 0000000001afcc01 R11: ffff880401afec00 R12: ffff8804285fc380
[ 6041.453390] R13: 00007fbe1cfef9e0 R14: ffff8804285fc380 R15: ffff8808284ab280
[ 6041.453392]  ? exit_robust_list+0x37/0x120
[ 6041.453394]  mm_release+0x11a/0x130
[ 6041.453395]  do_exit+0x152/0xb80
[ 6041.453396]  ? __unqueue_futex+0x2f/0x60
[ 6041.453397]  do_group_exit+0x3f/0xb0
[ 6041.453399]  get_signal+0x1bf/0x5e0
[ 6041.453401]  do_signal+0x37/0x6a0
[ 6041.453402]  ? do_futex+0xfd/0x570
[ 6041.453404]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453405]  do_syscall_64+0x165/0x180
[ 6041.453407]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453408] RIP: 0033:0x7fbe2a8576d5
[ 6041.453408] RSP: 002b:00007fbe1cfeecf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.453409] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.453410] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7be5ac
[ 6041.453411] RBP: 000055c46b7be608 R08: 000055c46b7be500 R09: 0000000000000000
[ 6041.453411] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7be620
[ 6041.453412] R13: 000055c46b7be580 R14: 000055c46b7be5a8 R15: 000055c46b7be540
[ 6041.453413] Mem-Info:
[ 6041.453418] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.453418]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.453418]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.453418]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.453418]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.453418]  free:39224 free_pcp:5492 free_cma:0
[ 6041.453423] Node 0 active_anon:8kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4 all_unreclaimable? yes
[ 6041.453428] Node 1 active_anon:48kB inactive_anon:76kB active_file:1260kB inactive_file:996kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1552kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? yes
[ 6041.453428] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.453431] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.453433] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:184kB free_cma:0kB
[ 6041.453436] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.453451] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:8kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19240kB pagetables:2780kB bounce:0kB free_pcp:9820kB local_pcp:680kB free_cma:0kB
[ 6041.453454] lowmem_reserve[]: 0 0 0 0 0
[ 6041.453456] Node 1 Normal free:44968kB min:45292kB low:61800kB high:78308kB active_anon:48kB inactive_anon:76kB active_file:1260kB inactive_file:996kB unevictable:0kB writepending:0kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29740kB slab_unreclaimable:278232kB kernel_stack:18488kB pagetables:2512kB bounce:0kB free_pcp:10224kB local_pcp:688kB free_cma:0kB
[ 6041.453458] lowmem_reserve[]: 0 0 0 0 0
[ 6041.453460] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.453472] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.453478] Node 0 Normal: 29*4kB (UMH) 57*8kB (UMH) 64*16kB (UMH) 156*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35132kB
[ 6041.453484] Node 1 Normal: 628*4kB (UMEH) 266*8kB (UMEH) 91*16kB (UMEH) 223*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 46192kB
[ 6041.453491] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.453491] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.453492] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.453493] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.453493] 451 total pagecache pages
[ 6041.453495] 0 pages in swap cache
[ 6041.453495] Swap cache stats: add 40461, delete 40457, find 7065/13053
[ 6041.453496] Free swap  = 16492028kB
[ 6041.453496] Total swap = 16516092kB
[ 6041.453497] 8379718 pages RAM
[ 6041.453497] 0 pages HighMem/MovableOnly
[ 6041.453497] 153941 pages reserved
[ 6041.453498] 0 pages cma reserved
[ 6041.453498] 0 pages hwpoisoned
[ 6041.453498] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.453522] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.453533] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.453535] [ 1144]    81  1121     8714        0      18       3        0          -900 dbus-daemon
[ 6041.453536] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.453538] [ 1269]     0  1220    50305        0      39       3        0             0 gssproxy
[ 6041.453539] [ 1323]     0  1296   637906        0      85       6       26             0 opensm
[ 6041.453541] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.453542] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.453543] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.453544] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.453548] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.453695] Kernel panic - not syncing: Out of memory and no killable processes...
[ 6041.453695] 
[ 6041.453697] CPU: 16 PID: 2731 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.453697] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.453697] Call Trace:
[ 6041.453699]  dump_stack+0x63/0x87
[ 6041.453700]  panic+0xeb/0x239
[ 6041.453702]  out_of_memory+0x3ad/0x4a0
[ 6041.453703]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.453705]  __alloc_pages_nodemask+0x240/0x260
[ 6041.453706]  alloc_pages_vma+0xa5/0x220
[ 6041.453707]  __read_swap_cache_async+0x148/0x1f0
[ 6041.453709]  read_swap_cache_async+0x26/0x60
[ 6041.453710]  swapin_readahead+0x16b/0x200
[ 6041.453711]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.453712]  ? find_get_entry+0x20/0x140
[ 6041.453713]  ? pagecache_get_page+0x2c/0x240
[ 6041.453714]  do_swap_page+0x2aa/0x780
[ 6041.453716]  __handle_mm_fault+0x6f0/0xe60
[ 6041.453717]  handle_mm_fault+0xce/0x240
[ 6041.453718]  __do_page_fault+0x22a/0x4a0
[ 6041.453720]  do_page_fault+0x30/0x80
[ 6041.453721]  page_fault+0x28/0x30
[ 6041.453722] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.453723] RSP: 0018:ffffc900069dbc28 EFLAGS: 00010287
[ 6041.453724] RAX: 00007fbe1cfef9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.453724] RDX: ffff8804285fc380 RSI: ffff88041395e4c0 RDI: ffff8804285fc380
[ 6041.453725] RBP: ffffc900069dbc78 R08: ffff88042f79b940 R09: 0000000000000000
[ 6041.453725] R10: 0000000001afcc01 R11: ffff880401afec00 R12: ffff8804285fc380
[ 6041.453726] R13: 00007fbe1cfef9e0 R14: ffff8804285fc380 R15: ffff8808284ab280
[ 6041.453727]  ? exit_robust_list+0x37/0x120
[ 6041.453728]  mm_release+0x11a/0x130
[ 6041.453730]  do_exit+0x152/0xb80
[ 6041.453731]  ? __unqueue_futex+0x2f/0x60
[ 6041.453732]  do_group_exit+0x3f/0xb0
[ 6041.453733]  get_signal+0x1bf/0x5e0
[ 6041.453735]  do_signal+0x37/0x6a0
[ 6041.453736]  ? do_futex+0xfd/0x570
[ 6041.453737]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453739]  do_syscall_64+0x165/0x180
[ 6041.453740]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453740] RIP: 0033:0x7fbe2a8576d5
[ 6041.453741] RSP: 002b:00007fbe1cfeecf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.453742] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.453742] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7be5ac
[ 6041.453743] RBP: 000055c46b7be608 R08: 000055c46b7be500 R09: 0000000000000000
[ 6041.453743] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7be620
[ 6041.453744] R13: 000055c46b7be580 R14: 000055c46b7be5a8 R15: 000055c46b7be540
[ 6041.464876] Kernel Offset: disabled
[ 6020.755107] nvmet: creating controller 1058 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6020.756795] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.756797] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.756797] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.756801] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.756801] Call Trace:
[ 6020.756805]  dump_stack+0x63/0x87
[ 6020.756807]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.756809]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.756815]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.756819]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.756823]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.756826]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.756833]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.756836]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.756837]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.756840]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.756841]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.756843]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.756844]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.756847]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.756848]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.756850]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.756852]  process_one_work+0x165/0x410
[ 6020.756853]  worker_thread+0x137/0x4c0
[ 6020.756855]  kthread+0x101/0x140
[ 6020.756856]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.756857]  ? kthread_park+0x90/0x90
[ 6020.756859]  ret_from_fork+0x2c/0x40
[ 6020.759785] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.759786] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.759786] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.759789] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.759789] Call Trace:
[ 6020.759791]  dump_stack+0x63/0x87
[ 6020.759793]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.759795]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.759799]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.759803]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.759806]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.759808]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.759813]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.759815]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.759816]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.759818]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.759820]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.759821]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.759823]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.759825]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.759827]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.759828]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.759830]  process_one_work+0x165/0x410
[ 6020.759831]  worker_thread+0x137/0x4c0
[ 6020.759833]  kthread+0x101/0x140
[ 6020.759834]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.759835]  ? kthread_park+0x90/0x90
[ 6020.759837]  ret_from_fork+0x2c/0x40
[ 6020.762929] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.762930] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.762931] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.762933] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.762933] Call Trace:
[ 6020.762935]  dump_stack+0x63/0x87
[ 6020.762937]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.762938]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.762942]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.762946]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.762949]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.762951]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.762955]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.762957]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.762959]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.762961]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.762962]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.762964]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.762965]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.762967]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.762969]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.762970]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.762972]  process_one_work+0x165/0x410
[ 6020.762973]  worker_thread+0x137/0x4c0
[ 6020.762975]  kthread+0x101/0x140
[ 6020.762976]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.762977]  ? kthread_park+0x90/0x90
[ 6020.762979]  ret_from_fork+0x2c/0x40
[ 6020.787416] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.787419] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.787419] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.787426] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.787427] Call Trace:
[ 6020.787433]  dump_stack+0x63/0x87
[ 6020.787436]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.787439]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.787449]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.787453]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.787459]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.787461]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.787472]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.787475]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.787478]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.787480]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.787481]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.787483]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.787484]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.787486]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.787488]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.787490]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.787492]  process_one_work+0x165/0x410
[ 6020.787493]  worker_thread+0x137/0x4c0
[ 6020.787495]  kthread+0x101/0x140
[ 6020.787496]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.787498]  ? kthread_park+0x90/0x90
[ 6020.787500]  ret_from_fork+0x2c/0x40
[ 6020.791654] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.791655] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.791656] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.791658] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.791658] Call Trace:
[ 6020.791661]  dump_stack+0x63/0x87
[ 6020.791663]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.791665]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.791669]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.791673]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.791675]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.791678]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.791683]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.791685]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.791687]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.791689]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.791690]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.791691]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.791693]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.791695]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.791697]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.791698]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.791700]  process_one_work+0x165/0x410
[ 6020.791701]  worker_thread+0x137/0x4c0
[ 6020.791703]  kthread+0x101/0x140
[ 6020.791704]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.791705]  ? kthread_park+0x90/0x90
[ 6020.791706]  ret_from_fork+0x2c/0x40
[ 6020.795988] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.795989] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.795990] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.795993] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.795993] Call Trace:
[ 6020.795996]  dump_stack+0x63/0x87
[ 6020.795998]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.796000]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.796005]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.796008]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.796011]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.796014]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.796019]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.796021]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.796023]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.796025]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.796026]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.796028]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.796030]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.796032]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.796034]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.796035]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.796037]  process_one_work+0x165/0x410
[ 6020.796038]  worker_thread+0x137/0x4c0
[ 6020.796040]  kthread+0x101/0x140
[ 6020.796041]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.796043]  ? kthread_park+0x90/0x90
[ 6020.796044]  ret_from_fork+0x2c/0x40
[ 6020.799181] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.799183] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.799184] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.799186] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.799187] Call Trace:
[ 6020.799190]  dump_stack+0x63/0x87
[ 6020.799192]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.799193]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.799198]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.799201]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.799205]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6020.799207]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.799210]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6020.799212]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.799217]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.799219]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.799220]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.799223]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.799224]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.799226]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.799228]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.799230]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.799231]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.799233]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.799235]  process_one_work+0x165/0x410
[ 6020.799236]  worker_thread+0x137/0x4c0
[ 6020.799238]  kthread+0x101/0x140
[ 6020.799239]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.799240]  ? kthread_park+0x90/0x90
[ 6020.799242]  ret_from_fork+0x2c/0x40
[ 6020.838402] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.838404] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6020.838405] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.838410] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.838411] Call Trace:
[ 6020.838417]  dump_stack+0x63/0x87
[ 6020.838420]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.838423]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.838432]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.838436]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.838441]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.838444]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.838451]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.838454]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.838456]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.838458]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.838460]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.838461]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.838463]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.838465]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.838467]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.838468]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.838471]  process_one_work+0x165/0x410
[ 6020.838472]  worker_thread+0x137/0x4c0
[ 6020.838474]  kthread+0x101/0x140
[ 6020.838475]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.838476]  ? kthread_park+0x90/0x90
[ 6020.838478]  ret_from_fork+0x2c/0x40
[ 6020.843024] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.843025] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.843026] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.843029] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.843029] Call Trace:
[ 6020.843032]  dump_stack+0x63/0x87
[ 6020.843034]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.843035]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.843040]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.843044]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.843047]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.843050]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.843055]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.843057]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.843059]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.843061]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.843062]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.843064]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.843065]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.843067]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.843069]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.843071]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.843072]  process_one_work+0x165/0x410
[ 6020.843073]  worker_thread+0x137/0x4c0
[ 6020.843075]  kthread+0x101/0x140
[ 6020.843076]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.843077]  ? kthread_park+0x90/0x90
[ 6020.843079]  ret_from_fork+0x2c/0x40
[ 6020.847429] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.847431] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.847431] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.847434] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.847435] Call Trace:
[ 6020.847438]  dump_stack+0x63/0x87
[ 6020.847439]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.847441]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.847445]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.847449]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.847452]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.847455]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.847460]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.847462]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.847464]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.847466]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.847467]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.847469]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.847471]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.847473]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.847474]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.847476]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.847478]  process_one_work+0x165/0x410
[ 6020.847479]  worker_thread+0x137/0x4c0
[ 6020.847481]  kthread+0x101/0x140
[ 6020.847482]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.847483]  ? kthread_park+0x90/0x90
[ 6020.847485]  ret_from_fork+0x2c/0x40
[ 6020.850748] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.850749] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.850750] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.850752] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.850752] Call Trace:
[ 6020.850755]  dump_stack+0x63/0x87
[ 6020.850756]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.850758]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.850762]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.850765]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.850768]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.850771]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.850775]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.850777]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.850779]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.850781]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.850782]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.850783]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.850785]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.850787]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.850789]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.850791]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.850792]  process_one_work+0x165/0x410
[ 6020.850793]  worker_thread+0x137/0x4c0
[ 6020.850795]  kthread+0x101/0x140
[ 6020.850796]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.850798]  ? kthread_park+0x90/0x90
[ 6020.850799]  ret_from_fork+0x2c/0x40
[ 6020.875373] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.875375] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.875375] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.875382] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.875383] Call Trace:
[ 6020.875389]  dump_stack+0x63/0x87
[ 6020.875392]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.875395]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.875405]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.875409]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.875414]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.875417]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.875425]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.875428]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.875430]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.875433]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.875434]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.875436]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.875438]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.875440]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.875441]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.875443]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.875445]  process_one_work+0x165/0x410
[ 6020.875446]  worker_thread+0x137/0x4c0
[ 6020.875448]  kthread+0x101/0x140
[ 6020.875449]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.875451]  ? kthread_park+0x90/0x90
[ 6020.875453]  ret_from_fork+0x2c/0x40
[ 6020.880097] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.880098] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.880098] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.880102] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.880102] Call Trace:
[ 6020.880106]  dump_stack+0x63/0x87
[ 6020.880107]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.880109]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.880114]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.880118]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.880122]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.880125]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.880129]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.880132]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.880133]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.880135]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.880137]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.880138]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.880140]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.880142]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.880144]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.880145]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.880147]  process_one_work+0x165/0x410
[ 6020.880148]  worker_thread+0x137/0x4c0
[ 6020.880150]  kthread+0x101/0x140
[ 6020.880151]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.880153]  ? kthread_park+0x90/0x90
[ 6020.880154]  ret_from_fork+0x2c/0x40
[ 6020.884957] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.884958] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.884958] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.884961] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.884962] Call Trace:
[ 6020.884964]  dump_stack+0x63/0x87
[ 6020.884966]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.884967]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.884972]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.884975]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.884979]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.884981]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.884986]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.884988]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.884990]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.884992]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.884993]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.884995]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.884997]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.884999]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.885001]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.885002]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.885004]  process_one_work+0x165/0x410
[ 6020.885005]  worker_thread+0x137/0x4c0
[ 6020.885007]  kthread+0x101/0x140
[ 6020.885008]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.885010]  ? kthread_park+0x90/0x90
[ 6020.885011]  ret_from_fork+0x2c/0x40
[ 6020.889299] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.889301] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.889301] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.889303] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.889304] Call Trace:
[ 6020.889306]  dump_stack+0x63/0x87
[ 6020.889308]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.889309]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.889314]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.889317]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.889321]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.889323]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.889328]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.889330]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.889331]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.889333]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.889335]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.889336]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.889338]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.889340]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.889342]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.889343]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.889345]  process_one_work+0x165/0x410
[ 6020.889346]  worker_thread+0x137/0x4c0
[ 6020.889348]  kthread+0x101/0x140
[ 6020.889349]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.889350]  ? kthread_park+0x90/0x90
[ 6020.889352]  ret_from_fork+0x2c/0x40
[ 6020.892856] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6020.892857] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6020.892857] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6020.892860] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6020.892861] Call Trace:
[ 6020.892864]  dump_stack+0x63/0x87
[ 6020.892865]  swiotlb_alloc_coherent+0x14a/0x160
[ 6020.892867]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6020.892871]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6020.892874]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6020.892877]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6020.892879]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6020.892884]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6020.892886]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6020.892887]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6020.892889]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6020.892891]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6020.892892]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6020.892894]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6020.892896]  cm_process_work+0x25/0x120 [ib_cm]
[ 6020.892898]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6020.892899]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6020.892901]  process_one_work+0x165/0x410
[ 6020.892902]  worker_thread+0x137/0x4c0
[ 6020.892904]  kthread+0x101/0x140
[ 6020.892905]  ? rescuer_thread+0x3b0/0x3b0
[ 6020.892906]  ? kthread_park+0x90/0x90
[ 6020.892908]  ret_from_fork+0x2c/0x40
[ 6020.894786] nvmet: adding queue 1 to ctrl 1058.
[ 6020.926256] nvmet: adding queue 2 to ctrl 1058.
[ 6020.926508] nvmet: adding queue 3 to ctrl 1058.
[ 6020.926761] nvmet: adding queue 4 to ctrl 1058.
[ 6020.926952] nvmet: adding queue 5 to ctrl 1058.
[ 6020.927161] nvmet: adding queue 6 to ctrl 1058.
[ 6020.927343] nvmet: adding queue 7 to ctrl 1058.
[ 6020.927596] nvmet: adding queue 8 to ctrl 1058.
[ 6020.927835] nvmet: adding queue 9 to ctrl 1058.
[ 6020.928216] nvmet: adding queue 10 to ctrl 1058.
[ 6020.928560] nvmet: adding queue 11 to ctrl 1058.
[ 6020.928919] nvmet: adding queue 12 to ctrl 1058.
[ 6020.929193] nvmet: adding queue 13 to ctrl 1058.
[ 6020.929444] nvmet: adding queue 14 to ctrl 1058.
[ 6020.929694] nvmet: adding queue 15 to ctrl 1058.
[ 6020.946149] nvmet: adding queue 16 to ctrl 1058.
[ 6021.035848] nvmet: creating controller 1059 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.037789] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.037790] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.037790] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.037793] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.037794] Call Trace:
[ 6021.037797]  dump_stack+0x63/0x87
[ 6021.037799]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.037800]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.037805]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.037808]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.037812]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.037815]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.037820]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.037822]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.037823]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.037825]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.037826]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.037828]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.037830]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.037832]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.037834]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.037835]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.037837]  process_one_work+0x165/0x410
[ 6021.037838]  worker_thread+0x137/0x4c0
[ 6021.037840]  kthread+0x101/0x140
[ 6021.037841]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.037842]  ? kthread_park+0x90/0x90
[ 6021.037844]  ret_from_fork+0x2c/0x40
[ 6021.041729] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.041731] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.041731] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.041735] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.041735] Call Trace:
[ 6021.041739]  dump_stack+0x63/0x87
[ 6021.041741]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.041742]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.041748]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.041751]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.041755]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.041758]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.041763]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.041766]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.041767]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.041769]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.041771]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.041772]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.041774]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.041777]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.041778]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.041780]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.041782]  process_one_work+0x165/0x410
[ 6021.041783]  worker_thread+0x137/0x4c0
[ 6021.041785]  kthread+0x101/0x140
[ 6021.041786]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.041787]  ? kthread_park+0x90/0x90
[ 6021.041789]  ret_from_fork+0x2c/0x40
[ 6021.044874] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.044876] CPU: 6 PID: 6388 Comm: kworker/6:138 Not tainted 4.11.0-rc2 #6
[ 6021.044876] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.044880] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.044880] Call Trace:
[ 6021.044884]  dump_stack+0x63/0x87
[ 6021.044886]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.044888]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.044893]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.044897]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.044900]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.044903]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.044905]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.044907]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.044913]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.044915]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.044917]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.044919]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.044920]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.044922]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.044924]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.044926]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.044928]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.044929]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.044931]  process_one_work+0x165/0x410
[ 6021.044932]  worker_thread+0x137/0x4c0
[ 6021.044934]  kthread+0x101/0x140
[ 6021.044935]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.044937]  ? kthread_park+0x90/0x90
[ 6021.044938]  ret_from_fork+0x2c/0x40
[ 6021.048067] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.048069] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.048069] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.048072] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.048073] Call Trace:
[ 6021.048076]  dump_stack+0x63/0x87
[ 6021.048078]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.048079]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.048084]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.048088]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.048091]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.048094]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.048099]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.048101]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.048103]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.048105]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.048106]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.048108]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.048110]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.048112]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.048114]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.048116]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.048117]  process_one_work+0x165/0x410
[ 6021.048118]  worker_thread+0x137/0x4c0
[ 6021.048120]  kthread+0x101/0x140
[ 6021.048121]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.048123]  ? kthread_park+0x90/0x90
[ 6021.048124]  ret_from_fork+0x2c/0x40
[ 6021.051245] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.051247] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.051248] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.051250] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.051251] Call Trace:
[ 6021.051254]  dump_stack+0x63/0x87
[ 6021.051256]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.051258]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.051262]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.051266]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.051269]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.051273]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.051277]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.051280]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.051281]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.051283]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.051285]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.051286]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.051288]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.051291]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.051292]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.051294]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.051296]  process_one_work+0x165/0x410
[ 6021.051297]  worker_thread+0x137/0x4c0
[ 6021.051299]  kthread+0x101/0x140
[ 6021.051300]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.051301]  ? kthread_park+0x90/0x90
[ 6021.051303]  ret_from_fork+0x2c/0x40
[ 6021.055931] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.055933] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.055933] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.055935] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.055936] Call Trace:
[ 6021.055938]  dump_stack+0x63/0x87
[ 6021.055940]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.055941]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.055945]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.055949]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.055952]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.055955]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.055959]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.055961]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.055963]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.055964]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.055966]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.055967]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.055969]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.055971]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.055973]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.055974]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.055976]  process_one_work+0x165/0x410
[ 6021.055977]  worker_thread+0x137/0x4c0
[ 6021.055979]  kthread+0x101/0x140
[ 6021.055980]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.055981]  ? kthread_park+0x90/0x90
[ 6021.055983]  ret_from_fork+0x2c/0x40
[ 6021.059086] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.059087] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.059087] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.059091] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.059091] Call Trace:
[ 6021.059094]  dump_stack+0x63/0x87
[ 6021.059095]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.059096]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.059101]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.059104]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.059107]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.059109]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.059113]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.059115]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.059117]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.059119]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.059120]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.059121]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.059123]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.059125]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.059127]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.059128]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.059130]  process_one_work+0x165/0x410
[ 6021.059131]  worker_thread+0x137/0x4c0
[ 6021.059133]  kthread+0x101/0x140
[ 6021.059134]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.059135]  ? kthread_park+0x90/0x90
[ 6021.059137]  ret_from_fork+0x2c/0x40
[ 6021.100084] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.100086] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.100087] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.100093] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.100094] Call Trace:
[ 6021.100100]  dump_stack+0x63/0x87
[ 6021.100103]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.100105]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.100115]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.100118]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.100124]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.100126]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.100136]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.100139]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.100141]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.100143]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.100145]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.100146]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.100148]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.100150]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.100152]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.100153]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.100155]  process_one_work+0x165/0x410
[ 6021.100157]  worker_thread+0x137/0x4c0
[ 6021.100159]  kthread+0x101/0x140
[ 6021.100160]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.100161]  ? kthread_park+0x90/0x90
[ 6021.100164]  ret_from_fork+0x2c/0x40
[ 6021.104720] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.104722] CPU: 3 PID: 6387 Comm: kworker/3:104 Not tainted 4.11.0-rc2 #6
[ 6021.104723] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.104726] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.104726] Call Trace:
[ 6021.104729]  dump_stack+0x63/0x87
[ 6021.104731]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.104733]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.104737]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.104741]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.104744]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.104747]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.104753]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.104755]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.104756]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.104758]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.104760]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.104761]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.104763]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.104765]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.104767]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.104769]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.104770]  process_one_work+0x165/0x410
[ 6021.104771]  worker_thread+0x137/0x4c0
[ 6021.104773]  kthread+0x101/0x140
[ 6021.104774]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.104776]  ? kthread_park+0x90/0x90
[ 6021.104777]  ret_from_fork+0x2c/0x40
[ 6021.108601] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.108603] CPU: 1 PID: 6351 Comm: kworker/1:126 Not tainted 4.11.0-rc2 #6
[ 6021.108603] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.108608] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.108609] Call Trace:
[ 6021.108613]  dump_stack+0x63/0x87
[ 6021.108615]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.108617]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.108624]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.108629]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.108633]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.108637]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.108644]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.108647]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.108649]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.108651]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.108653]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.108655]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.108657]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.108660]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.108661]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.108664]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.108666]  process_one_work+0x165/0x410
[ 6021.108667]  worker_thread+0x137/0x4c0
[ 6021.108669]  kthread+0x101/0x140
[ 6021.108671]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.108672]  ? kthread_park+0x90/0x90
[ 6021.108674]  ret_from_fork+0x2c/0x40
[ 6021.112225] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.112227] CPU: 23 PID: 6383 Comm: kworker/23:156 Not tainted 4.11.0-rc2 #6
[ 6021.112227] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.112230] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.112231] Call Trace:
[ 6021.112234]  dump_stack+0x63/0x87
[ 6021.112236]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.112237]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.112242]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.112246]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.112250]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.112253]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.112258]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.112260]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.112262]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.112264]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.112265]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.112267]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.112269]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.112272]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.112273]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.112275]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.112277]  process_one_work+0x165/0x410
[ 6021.112278]  worker_thread+0x137/0x4c0
[ 6021.112280]  kthread+0x101/0x140
[ 6021.112281]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.112283]  ? kthread_park+0x90/0x90
[ 6021.112284]  ret_from_fork+0x2c/0x40
[ 6021.115944] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.115945] CPU: 2 PID: 6374 Comm: kworker/2:204 Not tainted 4.11.0-rc2 #6
[ 6021.115946] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.115949] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.115950] Call Trace:
[ 6021.115953]  dump_stack+0x63/0x87
[ 6021.115954]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.115956]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.115960]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.115964]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.115968]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.115971]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.115975]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.115978]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.115979]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.115981]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.115983]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.115985]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.115987]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.115989]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.115990]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.115992]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.115994]  process_one_work+0x165/0x410
[ 6021.115995]  worker_thread+0x137/0x4c0
[ 6021.115997]  kthread+0x101/0x140
[ 6021.115998]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.116000]  ? kthread_park+0x90/0x90
[ 6021.116001]  ret_from_fork+0x2c/0x40
[ 6021.119271] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.119273] CPU: 3 PID: 6387 Comm: kworker/3:104 Not tainted 4.11.0-rc2 #6
[ 6021.119273] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.119276] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.119277] Call Trace:
[ 6021.119280]  dump_stack+0x63/0x87
[ 6021.119282]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.119283]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.119288]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.119291]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.119295]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.119298]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.119303]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.119305]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.119307]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.119309]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.119310]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.119312]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.119314]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.119316]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.119318]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.119319]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.119321]  process_one_work+0x165/0x410
[ 6021.119322]  worker_thread+0x137/0x4c0
[ 6021.119324]  kthread+0x101/0x140
[ 6021.119325]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.119327]  ? kthread_park+0x90/0x90
[ 6021.119328]  ret_from_fork+0x2c/0x40
[ 6021.122470] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.122472] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.122473] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.122476] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.122477] Call Trace:
[ 6021.122480]  dump_stack+0x63/0x87
[ 6021.122482]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.122483]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.122488]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.122492]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.122496]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.122499]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.122504]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.122507]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.122508]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.122511]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.122512]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.122514]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.122516]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.122518]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.122520]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.122522]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.122523]  process_one_work+0x165/0x410
[ 6021.122525]  worker_thread+0x137/0x4c0
[ 6021.122527]  kthread+0x101/0x140
[ 6021.122528]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.122529]  ? kthread_park+0x90/0x90
[ 6021.122531]  ret_from_fork+0x2c/0x40
[ 6021.125775] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.125777] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.125777] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.125780] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.125781] Call Trace:
[ 6021.125784]  dump_stack+0x63/0x87
[ 6021.125786]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.125788]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.125792]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.125796]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.125799]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.125802]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.125807]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.125809]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.125811]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.125813]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.125814]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.125816]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.125818]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.125821]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.125822]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.125824]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.125826]  process_one_work+0x165/0x410
[ 6021.125827]  worker_thread+0x137/0x4c0
[ 6021.125829]  kthread+0x101/0x140
[ 6021.125830]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.125831]  ? kthread_park+0x90/0x90
[ 6021.125833]  ret_from_fork+0x2c/0x40
[ 6021.129152] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.129153] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.129154] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.129156] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.129156] Call Trace:
[ 6021.129159]  dump_stack+0x63/0x87
[ 6021.129160]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.129162]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.129166]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.129170]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.129173]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.129175]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.129180]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.129182]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.129183]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.129185]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.129187]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.129189]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.129190]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.129192]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.129194]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.129196]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.129197]  process_one_work+0x165/0x410
[ 6021.129199]  worker_thread+0x137/0x4c0
[ 6021.129201]  kthread+0x101/0x140
[ 6021.129202]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.129203]  ? kthread_park+0x90/0x90
[ 6021.129205]  ret_from_fork+0x2c/0x40
[ 6021.146094] nvmet: adding queue 1 to ctrl 1059.
[ 6021.146345] nvmet: adding queue 2 to ctrl 1059.
[ 6021.146672] nvmet: adding queue 3 to ctrl 1059.
[ 6021.146849] nvmet: adding queue 4 to ctrl 1059.
[ 6021.147056] nvmet: adding queue 5 to ctrl 1059.
[ 6021.147234] nvmet: adding queue 6 to ctrl 1059.
[ 6021.147443] nvmet: adding queue 7 to ctrl 1059.
[ 6021.147645] nvmet: adding queue 8 to ctrl 1059.
[ 6021.147990] nvmet: adding queue 9 to ctrl 1059.
[ 6021.166320] nvmet: adding queue 10 to ctrl 1059.
[ 6021.166624] nvmet: adding queue 11 to ctrl 1059.
[ 6021.166981] nvmet: adding queue 12 to ctrl 1059.
[ 6021.167315] nvmet: adding queue 13 to ctrl 1059.
[ 6021.167667] nvmet: adding queue 14 to ctrl 1059.
[ 6021.168112] nvmet: adding queue 15 to ctrl 1059.
[ 6021.168463] nvmet: adding queue 16 to ctrl 1059.
[ 6021.254427] nvmet: creating controller 1060 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.256277] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.256278] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.256279] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.256282] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.256283] Call Trace:
[ 6021.256286]  dump_stack+0x63/0x87
[ 6021.256288]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.256290]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.256295]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.256299]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.256303]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.256306]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.256311]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.256314]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.256316]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.256318]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.256319]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.256321]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.256323]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.256325]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.256326]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.256328]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.256330]  process_one_work+0x165/0x410
[ 6021.256331]  worker_thread+0x137/0x4c0
[ 6021.256333]  kthread+0x101/0x140
[ 6021.256334]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.256335]  ? kthread_park+0x90/0x90
[ 6021.256337]  ret_from_fork+0x2c/0x40
[ 6021.259525] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.259526] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.259527] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.259529] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.259529] Call Trace:
[ 6021.259532]  dump_stack+0x63/0x87
[ 6021.259533]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.259534]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.259539]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.259542]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.259545]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.259548]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.259552]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.259554]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.259556]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.259558]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.259559]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.259561]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.259563]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.259564]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.259566]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.259568]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.259569]  process_one_work+0x165/0x410
[ 6021.259571]  worker_thread+0x137/0x4c0
[ 6021.259572]  kthread+0x101/0x140
[ 6021.259573]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.259575]  ? kthread_park+0x90/0x90
[ 6021.259576]  ret_from_fork+0x2c/0x40
[ 6021.262400] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.262401] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.262401] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.262403] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.262404] Call Trace:
[ 6021.262406]  dump_stack+0x63/0x87
[ 6021.262408]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.262409]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.262413]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.262417]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.262419]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.262422]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.262426]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.262428]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.262430]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.262431]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.262433]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.262434]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.262436]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.262438]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.262440]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.262441]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.262443]  process_one_work+0x165/0x410
[ 6021.262444]  worker_thread+0x137/0x4c0
[ 6021.262446]  kthread+0x101/0x140
[ 6021.262447]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.262448]  ? kthread_park+0x90/0x90
[ 6021.262450]  ret_from_fork+0x2c/0x40
[ 6021.265910] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.265911] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.265911] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.265913] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.265914] Call Trace:
[ 6021.265916]  dump_stack+0x63/0x87
[ 6021.265918]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.265919]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.265923]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.265927]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.265929]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.265931]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.265934]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.265936]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.265940]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.265942]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.265943]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.265945]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.265946]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.265948]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.265950]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.265952]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.265953]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.265955]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.265957]  process_one_work+0x165/0x410
[ 6021.265958]  worker_thread+0x137/0x4c0
[ 6021.265959]  kthread+0x101/0x140
[ 6021.265960]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.265962]  ? kthread_park+0x90/0x90
[ 6021.265963]  ret_from_fork+0x2c/0x40
[ 6021.268752] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.268753] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.268753] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.268755] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.268756] Call Trace:
[ 6021.268758]  dump_stack+0x63/0x87
[ 6021.268759]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.268761]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.268765]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.268768]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.268771]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.268773]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.268777]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.268779]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.268781]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.268783]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.268784]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.268785]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.268787]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.268789]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.268791]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.268792]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.268794]  process_one_work+0x165/0x410
[ 6021.268795]  worker_thread+0x137/0x4c0
[ 6021.268797]  kthread+0x101/0x140
[ 6021.268798]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.268799]  ? kthread_park+0x90/0x90
[ 6021.268801]  ret_from_fork+0x2c/0x40
[ 6021.272049] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.272050] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.272051] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.272052] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.272053] Call Trace:
[ 6021.272055]  dump_stack+0x63/0x87
[ 6021.272057]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.272058]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.272063]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.272066]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.272069]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.272071]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.272075]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.272077]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.272079]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.272080]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.272082]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.272083]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.272085]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.272087]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.272088]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.272090]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.272092]  process_one_work+0x165/0x410
[ 6021.272093]  worker_thread+0x137/0x4c0
[ 6021.272095]  kthread+0x101/0x140
[ 6021.272096]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.272097]  ? kthread_park+0x90/0x90
[ 6021.272098]  ret_from_fork+0x2c/0x40
[ 6021.275118] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.275119] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.275119] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.275121] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.275122] Call Trace:
[ 6021.275124]  dump_stack+0x63/0x87
[ 6021.275125]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.275127]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.275131]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.275134]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.275137]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.275139]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.275143]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.275145]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.275147]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.275149]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.275150]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.275151]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.275153]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.275155]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.275156]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.275158]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.275160]  process_one_work+0x165/0x410
[ 6021.275161]  worker_thread+0x137/0x4c0
[ 6021.275163]  kthread+0x101/0x140
[ 6021.275164]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.275165]  ? kthread_park+0x90/0x90
[ 6021.275166]  ret_from_fork+0x2c/0x40
[ 6021.315214] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.315216] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.315217] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.315223] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.315224] Call Trace:
[ 6021.315230]  dump_stack+0x63/0x87
[ 6021.315233]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.315236]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.315246]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.315249]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.315266]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.315269]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.315278]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.315281]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.315283]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.315285]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.315287]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.315288]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.315290]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.315292]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.315294]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.315295]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.315297]  process_one_work+0x165/0x410
[ 6021.315299]  worker_thread+0x137/0x4c0
[ 6021.315301]  kthread+0x101/0x140
[ 6021.315302]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.315303]  ? kthread_park+0x90/0x90
[ 6021.315305]  ret_from_fork+0x2c/0x40
[ 6021.319317] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.319319] CPU: 6 PID: 6388 Comm: kworker/6:138 Not tainted 4.11.0-rc2 #6
[ 6021.319319] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.319323] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.319323] Call Trace:
[ 6021.319327]  dump_stack+0x63/0x87
[ 6021.319341]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.319342]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.319348]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.319352]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.319356]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.319359]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.319365]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.319368]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.319369]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.319371]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.319373]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.319375]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.319377]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.319379]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.319380]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.319382]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.319384]  process_one_work+0x165/0x410
[ 6021.319385]  worker_thread+0x137/0x4c0
[ 6021.319387]  kthread+0x101/0x140
[ 6021.319388]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.319390]  ? kthread_park+0x90/0x90
[ 6021.319392]  ret_from_fork+0x2c/0x40
[ 6021.322943] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.322944] CPU: 7 PID: 6390 Comm: kworker/7:129 Not tainted 4.11.0-rc2 #6
[ 6021.322945] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.322948] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.322949] Call Trace:
[ 6021.322953]  dump_stack+0x63/0x87
[ 6021.322955]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.322956]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.322962]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.322966]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.322970]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.322973]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.322979]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.322981]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.322983]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.322985]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.322986]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.322988]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.322990]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.322992]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.322994]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.322996]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.322998]  process_one_work+0x165/0x410
[ 6021.322999]  worker_thread+0x137/0x4c0
[ 6021.323001]  kthread+0x101/0x140
[ 6021.323002]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.323003]  ? kthread_park+0x90/0x90
[ 6021.323005]  ret_from_fork+0x2c/0x40
[ 6021.326070] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.326071] CPU: 4 PID: 6384 Comm: kworker/4:153 Not tainted 4.11.0-rc2 #6
[ 6021.326072] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.326075] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.326075] Call Trace:
[ 6021.326079]  dump_stack+0x63/0x87
[ 6021.326080]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.326082]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.326086]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.326090]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.326094]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.326097]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.326101]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.326104]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.326105]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.326107]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.326109]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.326110]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.326113]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.326115]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.326116]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.326118]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.326120]  process_one_work+0x165/0x410
[ 6021.326121]  worker_thread+0x137/0x4c0
[ 6021.326123]  kthread+0x101/0x140
[ 6021.326124]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.326126]  ? kthread_park+0x90/0x90
[ 6021.326127]  ret_from_fork+0x2c/0x40
[ 6021.329048] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.329050] CPU: 23 PID: 6383 Comm: kworker/23:156 Not tainted 4.11.0-rc2 #6
[ 6021.329050] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.329053] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.329054] Call Trace:
[ 6021.329057]  dump_stack+0x63/0x87
[ 6021.329059]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.329060]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.329065]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.329068]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.329072]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.329075]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.329080]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.329082]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.329084]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.329086]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.329087]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.329089]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.329091]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.329093]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.329095]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.329097]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.329098]  process_one_work+0x165/0x410
[ 6021.329100]  worker_thread+0x137/0x4c0
[ 6021.329114]  kthread+0x101/0x140
[ 6021.329115]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.329117]  ? kthread_park+0x90/0x90
[ 6021.329118]  ret_from_fork+0x2c/0x40
[ 6021.332155] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.332156] CPU: 22 PID: 6389 Comm: kworker/22:160 Not tainted 4.11.0-rc2 #6
[ 6021.332157] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.332160] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.332161] Call Trace:
[ 6021.332164]  dump_stack+0x63/0x87
[ 6021.332166]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.332167]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.332171]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.332175]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.332179]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.332182]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.332187]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.332189]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.332190]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.332193]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.332194]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.332196]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.332198]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.332200]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.332201]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.332203]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.332205]  process_one_work+0x165/0x410
[ 6021.332206]  worker_thread+0x137/0x4c0
[ 6021.332208]  kthread+0x101/0x140
[ 6021.332209]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.332211]  ? kthread_park+0x90/0x90
[ 6021.332212]  ret_from_fork+0x2c/0x40
[ 6021.335608] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.335610] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.335610] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.335613] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.335614] Call Trace:
[ 6021.335617]  dump_stack+0x63/0x87
[ 6021.335619]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.335620]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.335625]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.335628]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.335632]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.335635]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.335640]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.335642]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.335643]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.335646]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.335647]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.335649]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.335651]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.335653]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.335655]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.335656]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.335658]  process_one_work+0x165/0x410
[ 6021.335659]  worker_thread+0x137/0x4c0
[ 6021.335661]  kthread+0x101/0x140
[ 6021.335662]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.335664]  ? kthread_park+0x90/0x90
[ 6021.335665]  ret_from_fork+0x2c/0x40
[ 6021.338456] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.338458] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.338458] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.338461] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.338462] Call Trace:
[ 6021.338465]  dump_stack+0x63/0x87
[ 6021.338467]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.338468]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.338473]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.338476]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.338480]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.338483]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.338488]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.338490]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.338492]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.338494]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.338495]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.338497]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.338499]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.338501]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.338503]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.338505]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.338506]  process_one_work+0x165/0x410
[ 6021.338508]  worker_thread+0x137/0x4c0
[ 6021.338509]  kthread+0x101/0x140
[ 6021.338511]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.338512]  ? kthread_park+0x90/0x90
[ 6021.338514]  ret_from_fork+0x2c/0x40
[ 6021.341450] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.341452] CPU: 5 PID: 6407 Comm: kworker/5:145 Not tainted 4.11.0-rc2 #6
[ 6021.341452] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.341454] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.341455] Call Trace:
[ 6021.341457]  dump_stack+0x63/0x87
[ 6021.341459]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.341460]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.341464]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.341468]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.341471]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.341474]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.341479]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.341481]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.341482]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.341484]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.341486]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.341487]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.341489]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.341491]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.341493]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.341495]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.341496]  process_one_work+0x165/0x410
[ 6021.341498]  worker_thread+0x137/0x4c0
[ 6021.341499]  kthread+0x101/0x140
[ 6021.341501]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.341502]  ? kthread_park+0x90/0x90
[ 6021.341504]  ret_from_fork+0x2c/0x40
[ 6021.343275] nvmet: adding queue 1 to ctrl 1060.
[ 6021.353136] nvmet: adding queue 2 to ctrl 1060.
[ 6021.353408] nvmet: adding queue 3 to ctrl 1060.
[ 6021.353606] nvmet: adding queue 4 to ctrl 1060.
[ 6021.353791] nvmet: adding queue 5 to ctrl 1060.
[ 6021.373800] nvmet: adding queue 6 to ctrl 1060.
[ 6021.373996] nvmet: adding queue 7 to ctrl 1060.
[ 6021.397443] nvmet: adding queue 8 to ctrl 1060.
[ 6021.397674] nvmet: adding queue 9 to ctrl 1060.
[ 6021.397984] nvmet: adding queue 10 to ctrl 1060.
[ 6021.398333] nvmet: adding queue 11 to ctrl 1060.
[ 6021.398705] nvmet: adding queue 12 to ctrl 1060.
[ 6021.399057] nvmet: adding queue 13 to ctrl 1060.
[ 6021.399400] nvmet: adding queue 14 to ctrl 1060.
[ 6021.399743] nvmet: adding queue 15 to ctrl 1060.
[ 6021.400114] nvmet: adding queue 16 to ctrl 1060.
[ 6021.423266] nvmet: ctrl 989 keep-alive timer (15 seconds) expired!
[ 6021.423268] nvmet: ctrl 989 fatal error occurred!
[ 6021.484834] nvmet: creating controller 1061 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.486620] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.486622] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.486622] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.486625] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.486626] Call Trace:
[ 6021.486630]  dump_stack+0x63/0x87
[ 6021.486632]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.486633]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.486640]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.486643]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.486647]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.486650]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.486656]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.486658]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.486660]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.486662]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.486664]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.486665]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.486667]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.486669]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.486671]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.486673]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.486675]  process_one_work+0x165/0x410
[ 6021.486676]  worker_thread+0x137/0x4c0
[ 6021.486678]  kthread+0x101/0x140
[ 6021.486679]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.486680]  ? kthread_park+0x90/0x90
[ 6021.486682]  ret_from_fork+0x2c/0x40
[ 6021.490580] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.490582] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.490582] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.490584] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.490585] Call Trace:
[ 6021.490587]  dump_stack+0x63/0x87
[ 6021.490589]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.490590]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.490595]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.490598]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.490601]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.490604]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.490608]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.490610]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.490612]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.490614]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.490615]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.490617]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.490618]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.490620]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.490622]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.490624]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.490625]  process_one_work+0x165/0x410
[ 6021.490626]  worker_thread+0x137/0x4c0
[ 6021.490628]  kthread+0x101/0x140
[ 6021.490629]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.490630]  ? kthread_park+0x90/0x90
[ 6021.490632]  ret_from_fork+0x2c/0x40
[ 6021.494784] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.494785] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.494785] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.494788] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.494789] Call Trace:
[ 6021.494791]  dump_stack+0x63/0x87
[ 6021.494793]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.494794]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.494798]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.494802]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.494810]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.494812]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.494817]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.494819]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.494821]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.494823]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.494824]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.494826]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.494827]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.494829]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.494831]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.494833]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.494834]  process_one_work+0x165/0x410
[ 6021.494836]  worker_thread+0x137/0x4c0
[ 6021.494837]  kthread+0x101/0x140
[ 6021.494838]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.494840]  ? kthread_park+0x90/0x90
[ 6021.494841]  ret_from_fork+0x2c/0x40
[ 6021.500542] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.500543] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.500544] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.500546] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.500547] Call Trace:
[ 6021.500549]  dump_stack+0x63/0x87
[ 6021.500551]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.500552]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.500557]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.500560]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.500564]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.500566]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.500571]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.500573]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.500575]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.500577]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.500578]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.500580]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.500582]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.500584]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.500585]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.500587]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.500589]  process_one_work+0x165/0x410
[ 6021.500590]  worker_thread+0x137/0x4c0
[ 6021.500592]  kthread+0x101/0x140
[ 6021.500593]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.500594]  ? kthread_park+0x90/0x90
[ 6021.500596]  ret_from_fork+0x2c/0x40
[ 6021.504431] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.504432] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.504433] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.504435] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.504436] Call Trace:
[ 6021.504438]  dump_stack+0x63/0x87
[ 6021.504440]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.504441]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.504445]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.504449]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.504452]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.504454]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.504459]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.504461]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.504462]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.504464]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.504466]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.504467]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.504469]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.504471]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.504473]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.504475]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.504476]  process_one_work+0x165/0x410
[ 6021.504477]  worker_thread+0x137/0x4c0
[ 6021.504479]  kthread+0x101/0x140
[ 6021.504480]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.504482]  ? kthread_park+0x90/0x90
[ 6021.504483]  ret_from_fork+0x2c/0x40
[ 6021.508750] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.508752] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.508752] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.508754] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.508755] Call Trace:
[ 6021.508757]  dump_stack+0x63/0x87
[ 6021.508759]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.508760]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.508765]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.508768]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.508771]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.508774]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.508778]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.508780]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.508782]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.508784]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.508785]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.508787]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.508789]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.508791]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.508792]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.508794]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.508796]  process_one_work+0x165/0x410
[ 6021.508797]  worker_thread+0x137/0x4c0
[ 6021.508799]  kthread+0x101/0x140
[ 6021.508800]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.508801]  ? kthread_park+0x90/0x90
[ 6021.508803]  ret_from_fork+0x2c/0x40
[ 6021.512376] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.512377] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.512378] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.512380] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.512381] Call Trace:
[ 6021.512383]  dump_stack+0x63/0x87
[ 6021.512385]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.512386]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.512390]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.512394]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.512397]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.512400]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.512404]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.512406]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.512408]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.512410]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.512411]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.512412]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.512414]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.512416]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.512418]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.512420]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.512421]  process_one_work+0x165/0x410
[ 6021.512422]  worker_thread+0x137/0x4c0
[ 6021.512424]  kthread+0x101/0x140
[ 6021.512425]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.512427]  ? kthread_park+0x90/0x90
[ 6021.512428]  ret_from_fork+0x2c/0x40
[ 6021.554284] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.554286] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.554286] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.554293] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.554294] Call Trace:
[ 6021.554300]  dump_stack+0x63/0x87
[ 6021.554302]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.554305]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.554315]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.554318]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.554324]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.554327]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.554336]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.554339]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.554341]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.554344]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.554345]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.554347]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.554348]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.554351]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.554352]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.554354]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.554356]  process_one_work+0x165/0x410
[ 6021.554357]  worker_thread+0x137/0x4c0
[ 6021.554359]  kthread+0x101/0x140
[ 6021.554360]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.554361]  ? kthread_park+0x90/0x90
[ 6021.554364]  ret_from_fork+0x2c/0x40
[ 6021.559950] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.559952] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.559952] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.559955] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.559956] Call Trace:
[ 6021.559959]  dump_stack+0x63/0x87
[ 6021.559961]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.559962]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.559967]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.559971]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.559975]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.559978]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.559983]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.559985]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.559986]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.559988]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.559989]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.559991]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.559993]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.559995]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.559997]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.559998]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.560000]  process_one_work+0x165/0x410
[ 6021.560001]  worker_thread+0x137/0x4c0
[ 6021.560003]  kthread+0x101/0x140
[ 6021.560004]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.560005]  ? kthread_park+0x90/0x90
[ 6021.560007]  ret_from_fork+0x2c/0x40
[ 6021.564658] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.564660] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.564660] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.564662] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.564663] Call Trace:
[ 6021.564666]  dump_stack+0x63/0x87
[ 6021.564667]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.564669]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.564673]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.564677]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.564680]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.564683]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.564688]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.564690]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.564692]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.564694]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.564695]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.564696]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.564698]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.564700]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.564702]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.564704]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.564705]  process_one_work+0x165/0x410
[ 6021.564707]  worker_thread+0x137/0x4c0
[ 6021.564708]  kthread+0x101/0x140
[ 6021.564709]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.564711]  ? kthread_park+0x90/0x90
[ 6021.564712]  ret_from_fork+0x2c/0x40
[ 6021.569030] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.569031] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.569032] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.569034] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.569034] Call Trace:
[ 6021.569037]  dump_stack+0x63/0x87
[ 6021.569039]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.569040]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.569044]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.569048]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.569051]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.569054]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.569058]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.569060]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.569062]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.569064]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.569065]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.569067]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.569069]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.569071]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.569072]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.569074]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.569076]  process_one_work+0x165/0x410
[ 6021.569077]  worker_thread+0x137/0x4c0
[ 6021.569079]  kthread+0x101/0x140
[ 6021.569080]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.569081]  ? kthread_park+0x90/0x90
[ 6021.569083]  ret_from_fork+0x2c/0x40
[ 6021.573497] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.573499] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.573499] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.573502] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.573502] Call Trace:
[ 6021.573505]  dump_stack+0x63/0x87
[ 6021.573506]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.573508]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.573512]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.573515]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.573518]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.573521]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.573526]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.573528]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.573529]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.573531]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.573533]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.573534]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.573536]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.573538]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.573540]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.573542]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.573543]  process_one_work+0x165/0x410
[ 6021.573544]  worker_thread+0x137/0x4c0
[ 6021.573546]  kthread+0x101/0x140
[ 6021.573547]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.573549]  ? kthread_park+0x90/0x90
[ 6021.573550]  ret_from_fork+0x2c/0x40
[ 6021.577783] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.577784] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.577785] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.577788] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.577788] Call Trace:
[ 6021.577791]  dump_stack+0x63/0x87
[ 6021.577793]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.577795]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.577799]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.577803]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.577806]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.577809]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.577814]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.577816]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.577818]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.577820]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.577821]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.577823]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.577825]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.577827]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.577828]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.577830]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.577832]  process_one_work+0x165/0x410
[ 6021.577833]  worker_thread+0x137/0x4c0
[ 6021.577835]  kthread+0x101/0x140
[ 6021.577836]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.577837]  ? kthread_park+0x90/0x90
[ 6021.577839]  ret_from_fork+0x2c/0x40
[ 6021.582232] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.582233] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.582233] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.582236] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.582236] Call Trace:
[ 6021.582239]  dump_stack+0x63/0x87
[ 6021.582240]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.582242]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.582246]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.582249]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.582253]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.582255]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.582260]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.582262]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.582263]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.582265]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.582267]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.582268]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.582270]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.582272]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.582274]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.582275]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.582277]  process_one_work+0x165/0x410
[ 6021.582278]  worker_thread+0x137/0x4c0
[ 6021.582280]  kthread+0x101/0x140
[ 6021.582281]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.582283]  ? kthread_park+0x90/0x90
[ 6021.582284]  ret_from_fork+0x2c/0x40
[ 6021.588220] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.588222] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.588222] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.588225] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.588226] Call Trace:
[ 6021.588229]  dump_stack+0x63/0x87
[ 6021.588231]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.588232]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.588236]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.588240]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.588244]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.588247]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.588252]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.588254]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.588255]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.588257]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.588259]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.588261]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.588263]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.588265]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.588266]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.588268]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.588270]  process_one_work+0x165/0x410
[ 6021.588271]  worker_thread+0x137/0x4c0
[ 6021.588273]  kthread+0x101/0x140
[ 6021.588274]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.588275]  ? kthread_park+0x90/0x90
[ 6021.588276]  ret_from_fork+0x2c/0x40
[ 6021.593827] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.593828] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.593829] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.593831] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.593832] Call Trace:
[ 6021.593834]  dump_stack+0x63/0x87
[ 6021.593836]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.593837]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.593842]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.593845]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.593848]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.593851]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.593856]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.593858]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.593860]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.593862]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.593863]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.593865]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.593867]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.593869]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.593870]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.593872]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.593874]  process_one_work+0x165/0x410
[ 6021.593875]  worker_thread+0x137/0x4c0
[ 6021.593876]  kthread+0x101/0x140
[ 6021.593878]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.593879]  ? kthread_park+0x90/0x90
[ 6021.593881]  ret_from_fork+0x2c/0x40
[ 6021.595897] nvmet: adding queue 1 to ctrl 1061.
[ 6021.596096] nvmet: adding queue 2 to ctrl 1061.
[ 6021.601856] nvmet: adding queue 3 to ctrl 1061.
[ 6021.602078] nvmet: adding queue 4 to ctrl 1061.
[ 6021.602318] nvmet: adding queue 5 to ctrl 1061.
[ 6021.602497] nvmet: adding queue 6 to ctrl 1061.
[ 6021.602764] nvmet: adding queue 7 to ctrl 1061.
[ 6021.603052] nvmet: adding queue 8 to ctrl 1061.
[ 6021.603290] nvmet: adding queue 9 to ctrl 1061.
[ 6021.603644] nvmet: adding queue 10 to ctrl 1061.
[ 6021.603946] nvmet: adding queue 11 to ctrl 1061.
[ 6021.604241] nvmet: adding queue 12 to ctrl 1061.
[ 6021.622259] nvmet: adding queue 13 to ctrl 1061.
[ 6021.622573] nvmet: adding queue 14 to ctrl 1061.
[ 6021.622941] nvmet: adding queue 15 to ctrl 1061.
[ 6021.623275] nvmet: adding queue 16 to ctrl 1061.
[ 6021.676942] nvmet_rdma: freeing queue 18021
[ 6021.679059] nvmet_rdma: freeing queue 18022
[ 6021.727425] nvmet: creating controller 1062 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.731639] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.731641] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.731642] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.731645] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.731645] Call Trace:
[ 6021.731649]  dump_stack+0x63/0x87
[ 6021.731651]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.731652]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.731657]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.731660]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.731664]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.731667]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.731672]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.731674]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.731676]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.731678]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.731679]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.731681]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.731683]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.731685]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.731686]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.731688]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.731690]  process_one_work+0x165/0x410
[ 6021.731691]  worker_thread+0x137/0x4c0
[ 6021.731693]  kthread+0x101/0x140
[ 6021.731694]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.731695]  ? kthread_park+0x90/0x90
[ 6021.731697]  ret_from_fork+0x2c/0x40
[ 6021.737314] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.737315] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.737316] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.737318] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.737319] Call Trace:
[ 6021.737321]  dump_stack+0x63/0x87
[ 6021.737323]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.737325]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.737329]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.737332]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.737336]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.737338]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.737343]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.737345]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.737347]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.737349]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.737350]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.737352]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.737354]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.737356]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.737357]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.737359]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.737361]  process_one_work+0x165/0x410
[ 6021.737362]  worker_thread+0x137/0x4c0
[ 6021.737364]  kthread+0x101/0x140
[ 6021.737365]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.737366]  ? kthread_park+0x90/0x90
[ 6021.737368]  ret_from_fork+0x2c/0x40
[ 6021.742828] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.742829] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.742829] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.742832] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.742833] Call Trace:
[ 6021.742835]  dump_stack+0x63/0x87
[ 6021.742837]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.742838]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.742843]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.742847]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.742850]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.742853]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.742857]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.742859]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.742861]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.742863]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.742864]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.742866]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.742868]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.742870]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.742872]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.742873]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.742875]  process_one_work+0x165/0x410
[ 6021.742876]  worker_thread+0x137/0x4c0
[ 6021.742878]  kthread+0x101/0x140
[ 6021.742879]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.742880]  ? kthread_park+0x90/0x90
[ 6021.742882]  ret_from_fork+0x2c/0x40
[ 6021.748754] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.748755] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.748755] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.748758] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.748759] Call Trace:
[ 6021.748761]  dump_stack+0x63/0x87
[ 6021.748763]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.748764]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.748769]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.748772]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.748775]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.748778]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.748783]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.748785]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.748786]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.748788]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.748790]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.748792]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.748793]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.748795]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.748797]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.748799]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.748800]  process_one_work+0x165/0x410
[ 6021.748802]  worker_thread+0x137/0x4c0
[ 6021.748803]  kthread+0x101/0x140
[ 6021.748805]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.748806]  ? kthread_park+0x90/0x90
[ 6021.748807]  ret_from_fork+0x2c/0x40
[ 6021.754730] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.754732] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.754732] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.754735] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.754735] Call Trace:
[ 6021.754738]  dump_stack+0x63/0x87
[ 6021.754740]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.754741]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.754745]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.754749]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.754752]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.754755]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.754759]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.754762]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.754763]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.754765]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.754766]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.754768]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.754770]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.754772]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.754774]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.754776]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.754777]  process_one_work+0x165/0x410
[ 6021.754778]  worker_thread+0x137/0x4c0
[ 6021.754780]  kthread+0x101/0x140
[ 6021.754781]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.754783]  ? kthread_park+0x90/0x90
[ 6021.754784]  ret_from_fork+0x2c/0x40
[ 6021.760237] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.760238] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.760239] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.760241] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.760242] Call Trace:
[ 6021.760245]  dump_stack+0x63/0x87
[ 6021.760247]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.760248]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.760252]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.760256]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.760259]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.760262]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.760267]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.760269]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.760271]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.760273]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.760274]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.760276]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.760278]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.760280]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.760282]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.760284]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.760285]  process_one_work+0x165/0x410
[ 6021.760287]  worker_thread+0x137/0x4c0
[ 6021.760288]  kthread+0x101/0x140
[ 6021.760290]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.760291]  ? kthread_park+0x90/0x90
[ 6021.760293]  ret_from_fork+0x2c/0x40
[ 6021.765587] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.765588] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.765589] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.765591] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.765592] Call Trace:
[ 6021.765595]  dump_stack+0x63/0x87
[ 6021.765597]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.765598]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.765602]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.765606]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.765609]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.765612]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.765614]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[ 6021.765616]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.765621]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.765623]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.765625]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.765627]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.765628]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.765630]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.765632]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.765634]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.765635]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.765637]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.765639]  process_one_work+0x165/0x410
[ 6021.765640]  worker_thread+0x137/0x4c0
[ 6021.765642]  kthread+0x101/0x140
[ 6021.765643]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.765644]  ? kthread_park+0x90/0x90
[ 6021.765646]  ret_from_fork+0x2c/0x40
[ 6021.771643] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.771644] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.771645] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.771647] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.771648] Call Trace:
[ 6021.771650]  dump_stack+0x63/0x87
[ 6021.771652]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.771653]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.771658]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.771662]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.771664]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.771667]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.771672]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.771674]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.771676]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.771678]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.771679]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.771681]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.771683]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.771685]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.771687]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.771688]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.771690]  process_one_work+0x165/0x410
[ 6021.771691]  worker_thread+0x137/0x4c0
[ 6021.771693]  kthread+0x101/0x140
[ 6021.771694]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.771696]  ? kthread_park+0x90/0x90
[ 6021.771697]  ret_from_fork+0x2c/0x40
[ 6021.775924] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.775926] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.775926] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.775929] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.775930] Call Trace:
[ 6021.775933]  dump_stack+0x63/0x87
[ 6021.775935]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.775936]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.775941]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.775944]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.775948]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.775951]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.775956]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.775958]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.775960]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.775962]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.775963]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.775965]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.775967]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.775969]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.775971]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.775973]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.775974]  process_one_work+0x165/0x410
[ 6021.775976]  worker_thread+0x137/0x4c0
[ 6021.775977]  kthread+0x101/0x140
[ 6021.775979]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.775980]  ? kthread_park+0x90/0x90
[ 6021.775982]  ret_from_fork+0x2c/0x40
[ 6021.779888] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.779889] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.779890] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.779893] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.779893] Call Trace:
[ 6021.779896]  dump_stack+0x63/0x87
[ 6021.779898]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.779900]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.779904]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.779908]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.779911]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.779915]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.779920]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.779922]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.779923]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.779926]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.779927]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.779929]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.779931]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.779933]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.779934]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.779936]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.779938]  process_one_work+0x165/0x410
[ 6021.779939]  worker_thread+0x137/0x4c0
[ 6021.779941]  kthread+0x101/0x140
[ 6021.779942]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.779944]  ? kthread_park+0x90/0x90
[ 6021.779945]  ret_from_fork+0x2c/0x40
[ 6021.784247] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.784248] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.784249] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.784252] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.784252] Call Trace:
[ 6021.784255]  dump_stack+0x63/0x87
[ 6021.784257]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.784259]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.784263]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.784267]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.784270]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.784273]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.784278]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.784280]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.784282]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.784284]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.784285]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.784287]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.784289]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.784291]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.784292]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.784294]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.784296]  process_one_work+0x165/0x410
[ 6021.784297]  worker_thread+0x137/0x4c0
[ 6021.784299]  kthread+0x101/0x140
[ 6021.784300]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.784301]  ? kthread_park+0x90/0x90
[ 6021.784303]  ret_from_fork+0x2c/0x40
[ 6021.789458] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.789460] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.789460] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.789463] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.789463] Call Trace:
[ 6021.789466]  dump_stack+0x63/0x87
[ 6021.789468]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.789469]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.789473]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.789477]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.789480]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.789483]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.789487]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.789490]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.789491]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.789493]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.789494]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.789496]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.789498]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.789500]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.789502]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.789504]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.789505]  process_one_work+0x165/0x410
[ 6021.789506]  worker_thread+0x137/0x4c0
[ 6021.789508]  kthread+0x101/0x140
[ 6021.789509]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.789511]  ? kthread_park+0x90/0x90
[ 6021.789512]  ret_from_fork+0x2c/0x40
[ 6021.794462] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.794464] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.794464] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.794466] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.794467] Call Trace:
[ 6021.794469]  dump_stack+0x63/0x87
[ 6021.794471]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.794472]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.794477]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.794480]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.794483]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.794486]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.794491]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.794493]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.794494]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.794496]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.794498]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.794499]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.794501]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.794503]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.794505]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.794507]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.794508]  process_one_work+0x165/0x410
[ 6021.794509]  worker_thread+0x137/0x4c0
[ 6021.794511]  kthread+0x101/0x140
[ 6021.794512]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.794514]  ? kthread_park+0x90/0x90
[ 6021.794515]  ret_from_fork+0x2c/0x40
[ 6021.800220] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.800221] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.800222] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.800224] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.800225] Call Trace:
[ 6021.800227]  dump_stack+0x63/0x87
[ 6021.800229]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.800230]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.800235]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.800238]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.800242]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.800245]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.800250]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.800252]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.800253]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.800256]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.800257]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.800259]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.800261]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.800263]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.800264]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.800266]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.800268]  process_one_work+0x165/0x410
[ 6021.800269]  worker_thread+0x137/0x4c0
[ 6021.800271]  kthread+0x101/0x140
[ 6021.800272]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.800273]  ? kthread_park+0x90/0x90
[ 6021.800275]  ret_from_fork+0x2c/0x40
[ 6021.805461] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.805463] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.805463] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.805466] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.805466] Call Trace:
[ 6021.805469]  dump_stack+0x63/0x87
[ 6021.805471]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.805472]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.805477]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.805480]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.805484]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.805486]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.805491]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.805493]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.805495]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.805497]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.805498]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.805500]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.805502]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.805504]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.805506]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.805508]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.805509]  process_one_work+0x165/0x410
[ 6021.805511]  worker_thread+0x137/0x4c0
[ 6021.805513]  kthread+0x101/0x140
[ 6021.805514]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.805515]  ? kthread_park+0x90/0x90
[ 6021.805517]  ret_from_fork+0x2c/0x40
[ 6021.810822] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.810824] CPU: 4 PID: 6384 Comm: kworker/4:153 Not tainted 4.11.0-rc2 #6
[ 6021.810824] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.810828] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.810829] Call Trace:
[ 6021.810832]  dump_stack+0x63/0x87
[ 6021.810835]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.810836]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.810843]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.810846]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.810850]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.810853]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.810859]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.810862]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.810864]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.810866]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.810867]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.810869]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.810872]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.810874]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.810875]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.810877]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.810879]  process_one_work+0x165/0x410
[ 6021.810881]  worker_thread+0x137/0x4c0
[ 6021.810883]  kthread+0x101/0x140
[ 6021.810884]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.810885]  ? kthread_park+0x90/0x90
[ 6021.810887]  ret_from_fork+0x2c/0x40
[ 6021.812621] nvmet: adding queue 1 to ctrl 1062.
[ 6021.812804] nvmet: adding queue 2 to ctrl 1062.
[ 6021.813092] nvmet: adding queue 3 to ctrl 1062.
[ 6021.813265] nvmet: adding queue 4 to ctrl 1062.
[ 6021.813490] nvmet: adding queue 5 to ctrl 1062.
[ 6021.813615] nvmet: adding queue 6 to ctrl 1062.
[ 6021.813739] nvmet: adding queue 7 to ctrl 1062.
[ 6021.813850] nvmet: adding queue 8 to ctrl 1062.
[ 6021.813982] nvmet: adding queue 9 to ctrl 1062.
[ 6021.828342] nvmet: adding queue 10 to ctrl 1062.
[ 6021.828699] nvmet: adding queue 11 to ctrl 1062.
[ 6021.848059] nvmet: adding queue 12 to ctrl 1062.
[ 6021.848439] nvmet: adding queue 13 to ctrl 1062.
[ 6021.848815] nvmet: adding queue 14 to ctrl 1062.
[ 6021.849172] nvmet: adding queue 15 to ctrl 1062.
[ 6021.849518] nvmet: adding queue 16 to ctrl 1062.
[ 6021.900726] nvmet_rdma: freeing queue 18048
[ 6021.901911] nvmet_rdma: freeing queue 18049
[ 6021.903491] nvmet_rdma: freeing queue 18050
[ 6021.935901] nvmet: creating controller 1063 for subsystem nvme-subsystem-name for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:678ab29c-8057-4310-bb35-2683950e1f00.
[ 6021.939116] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 6021.939118] CPU: 16 PID: 4934 Comm: kworker/16:256 Not tainted 4.11.0-rc2 #6
[ 6021.939118] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6021.939121] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 6021.939122] Call Trace:
[ 6021.939125]  dump_stack+0x63/0x87
[ 6021.939127]  swiotlb_alloc_coherent+0x14a/0x160
[ 6021.939128]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 6021.939132]  mlx4_buf_direct_alloc.isra.5+0xb1/0x150 [mlx4_core]
[ 6021.939136]  mlx4_buf_alloc+0x16f/0x1c0 [mlx4_core]
[ 6021.939139]  create_qp_common.isra.34+0x53f/0xf50 [mlx4_ib]
[ 6021.939142]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 6021.939147]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 6021.939149]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 6021.939151]  nvmet_rdma_queue_connect+0x78d/0xc60 [nvmet_rdma]
[ 6021.939153]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 6021.939154]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 6021.939156]  nvmet_rdma_cm_handler+0x12f/0x313 [nvmet_rdma]
[ 6021.939158]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 6021.939160]  cm_process_work+0x25/0x120 [ib_cm]
[ 6021.939161]  cm_req_handler+0x964/0xc90 [ib_cm]
[ 6021.939163]  cm_work_handler+0x1bf/0x16a6 [ib_cm]
[ 6021.939165]  process_one_work+0x165/0x410
[ 6021.939166]  worker_thread+0x137/0x4c0
[ 6021.939168]  kthread+0x101/0x140
[ 6021.939169]  ? rescuer_thread+0x3b0/0x3b0
[ 6021.939170]  ? kthread_park+0x90/0x90
[ 6021.939172]  ret_from_fork+0x2c/0x40
[ 6023.983224] INFO: task kworker/3:0:30 blocked for more than 120 seconds.
[ 6023.983225]       Not tainted 4.11.0-rc2 #6
[ 6023.983226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983226] kworker/3:0     D    0    30      2 0x00000000
[ 6023.983231] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983232] Call Trace:
[ 6023.983235]  __schedule+0x289/0x8f0
[ 6023.983238]  ? sched_clock+0x9/0x10
[ 6023.983251]  schedule+0x36/0x80
[ 6023.983252]  schedule_timeout+0x249/0x300
[ 6023.983255]  ? console_trylock+0x12/0x50
[ 6023.983256]  ? vprintk_emit+0x2ca/0x370
[ 6023.983257]  wait_for_completion+0x121/0x180
[ 6023.983259]  ? wake_up_q+0x80/0x80
[ 6023.983272]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983273]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983275]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983276]  process_one_work+0x165/0x410
[ 6023.983278]  worker_thread+0x137/0x4c0
[ 6023.983280]  kthread+0x101/0x140
[ 6023.983281]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983282]  ? kthread_park+0x90/0x90
[ 6023.983284]  ret_from_fork+0x2c/0x40
[ 6023.983312] INFO: task kworker/1:1:206 blocked for more than 120 seconds.
[ 6023.983313]       Not tainted 4.11.0-rc2 #6
[ 6023.983313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983313] kworker/1:1     D    0   206      2 0x00000000
[ 6023.983316] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983316] Call Trace:
[ 6023.983317]  __schedule+0x289/0x8f0
[ 6023.983319]  ? sched_clock+0x9/0x10
[ 6023.983320]  schedule+0x36/0x80
[ 6023.983321]  schedule_timeout+0x249/0x300
[ 6023.983322]  ? console_trylock+0x12/0x50
[ 6023.983329]  ? vprintk_emit+0x2ca/0x370
[ 6023.983330]  wait_for_completion+0x121/0x180
[ 6023.983331]  ? wake_up_q+0x80/0x80
[ 6023.983333]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983334]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983336]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983337]  process_one_work+0x165/0x410
[ 6023.983338]  worker_thread+0x137/0x4c0
[ 6023.983340]  kthread+0x101/0x140
[ 6023.983341]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983342]  ? kthread_park+0x90/0x90
[ 6023.983343]  ret_from_fork+0x2c/0x40
[ 6023.983347] INFO: task kworker/21:1:223 blocked for more than 120 seconds.
[ 6023.983347]       Not tainted 4.11.0-rc2 #6
[ 6023.983348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983348] kworker/21:1    D    0   223      2 0x00000000
[ 6023.983350] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983350] Call Trace:
[ 6023.983352]  __schedule+0x289/0x8f0
[ 6023.983353]  ? sched_clock+0x9/0x10
[ 6023.983354]  schedule+0x36/0x80
[ 6023.983355]  schedule_timeout+0x249/0x300
[ 6023.983356]  ? console_trylock+0x12/0x50
[ 6023.983357]  ? vprintk_emit+0x2ca/0x370
[ 6023.983358]  wait_for_completion+0x121/0x180
[ 6023.983359]  ? wake_up_q+0x80/0x80
[ 6023.983361]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983362]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983363]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983364]  process_one_work+0x165/0x410
[ 6023.983366]  worker_thread+0x137/0x4c0
[ 6023.983367]  kthread+0x101/0x140
[ 6023.983368]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983369]  ? kthread_park+0x90/0x90
[ 6023.983371]  ret_from_fork+0x2c/0x40
[ 6023.983375] INFO: task kworker/0:2:308 blocked for more than 120 seconds.
[ 6023.983376]       Not tainted 4.11.0-rc2 #6
[ 6023.983376] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983376] kworker/0:2     D    0   308      2 0x00000000
[ 6023.983378] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983379] Call Trace:
[ 6023.983380]  __schedule+0x289/0x8f0
[ 6023.983381]  ? sched_clock+0x9/0x10
[ 6023.983382]  schedule+0x36/0x80
[ 6023.983383]  schedule_timeout+0x249/0x300
[ 6023.983384]  ? console_trylock+0x12/0x50
[ 6023.983385]  ? vprintk_emit+0x2ca/0x370
[ 6023.983386]  wait_for_completion+0x121/0x180
[ 6023.983387]  ? wake_up_q+0x80/0x80
[ 6023.983388]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983390]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983391]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983392]  process_one_work+0x165/0x410
[ 6023.983394]  worker_thread+0x137/0x4c0
[ 6023.983395]  kthread+0x101/0x140
[ 6023.983396]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983397]  ? kthread_park+0x90/0x90
[ 6023.983399]  ret_from_fork+0x2c/0x40
[ 6023.983401] INFO: task kworker/3:1:325 blocked for more than 120 seconds.
[ 6023.983401]       Not tainted 4.11.0-rc2 #6
[ 6023.983402] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983402] kworker/3:1     D    0   325      2 0x00000000
[ 6023.983404] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983404] Call Trace:
[ 6023.983406]  __schedule+0x289/0x8f0
[ 6023.983407]  ? sched_clock+0x9/0x10
[ 6023.983407]  schedule+0x36/0x80
[ 6023.983408]  schedule_timeout+0x249/0x300
[ 6023.983410]  ? console_trylock+0x12/0x50
[ 6023.983411]  ? vprintk_emit+0x2ca/0x370
[ 6023.983412]  wait_for_completion+0x121/0x180
[ 6023.983413]  ? wake_up_q+0x80/0x80
[ 6023.983414]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983416]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983417]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983418]  process_one_work+0x165/0x410
[ 6023.983419]  worker_thread+0x137/0x4c0
[ 6023.983421]  kthread+0x101/0x140
[ 6023.983422]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983423]  ? kthread_park+0x90/0x90
[ 6023.983424]  ret_from_fork+0x2c/0x40
[ 6023.983426] INFO: task kworker/5:1:329 blocked for more than 120 seconds.
[ 6023.983426]       Not tainted 4.11.0-rc2 #6
[ 6023.983427] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983427] kworker/5:1     D    0   329      2 0x00000000
[ 6023.983429] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983429] Call Trace:
[ 6023.983430]  __schedule+0x289/0x8f0
[ 6023.983432]  ? sched_clock+0x9/0x10
[ 6023.983432]  schedule+0x36/0x80
[ 6023.983433]  schedule_timeout+0x249/0x300
[ 6023.983434]  ? console_trylock+0x12/0x50
[ 6023.983435]  ? vprintk_emit+0x2ca/0x370
[ 6023.983436]  wait_for_completion+0x121/0x180
[ 6023.983437]  ? wake_up_q+0x80/0x80
[ 6023.983439]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983440]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983442]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983443]  process_one_work+0x165/0x410
[ 6023.983444]  worker_thread+0x137/0x4c0
[ 6023.983446]  kthread+0x101/0x140
[ 6023.983447]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983448]  ? kthread_park+0x90/0x90
[ 6023.983449]  ret_from_fork+0x2c/0x40
[ 6023.983450] INFO: task kworker/7:1:332 blocked for more than 120 seconds.
[ 6023.983451]       Not tainted 4.11.0-rc2 #6
[ 6023.983451] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983451] kworker/7:1     D    0   332      2 0x00000000
[ 6023.983453] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983453] Call Trace:
[ 6023.983455]  __schedule+0x289/0x8f0
[ 6023.983456]  ? sched_clock+0x9/0x10
[ 6023.983457]  schedule+0x36/0x80
[ 6023.983458]  schedule_timeout+0x249/0x300
[ 6023.983458]  ? console_trylock+0x12/0x50
[ 6023.983459]  ? vprintk_emit+0x2ca/0x370
[ 6023.983460]  wait_for_completion+0x121/0x180
[ 6023.983461]  ? wake_up_q+0x80/0x80
[ 6023.983463]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983464]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983466]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983467]  process_one_work+0x165/0x410
[ 6023.983468]  worker_thread+0x137/0x4c0
[ 6023.983469]  kthread+0x101/0x140
[ 6023.983470]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983472]  ? kthread_park+0x90/0x90
[ 6023.983473]  ret_from_fork+0x2c/0x40
[ 6023.983474] INFO: task kworker/18:1:333 blocked for more than 120 seconds.
[ 6023.983475]       Not tainted 4.11.0-rc2 #6
[ 6023.983475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983475] kworker/18:1    D    0   333      2 0x00000000
[ 6023.983477] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983478] Call Trace:
[ 6023.983479]  __schedule+0x289/0x8f0
[ 6023.983480]  ? sched_clock+0x9/0x10
[ 6023.983481]  schedule+0x36/0x80
[ 6023.983482]  schedule_timeout+0x249/0x300
[ 6023.983483]  ? console_trylock+0x12/0x50
[ 6023.983484]  ? vprintk_emit+0x2ca/0x370
[ 6023.983485]  wait_for_completion+0x121/0x180
[ 6023.983486]  ? wake_up_q+0x80/0x80
[ 6023.983487]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983489]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983490]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983491]  process_one_work+0x165/0x410
[ 6023.983492]  worker_thread+0x137/0x4c0
[ 6023.983494]  kthread+0x101/0x140
[ 6023.983495]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983496]  ? kthread_park+0x90/0x90
[ 6023.983497]  ret_from_fork+0x2c/0x40
[ 6023.983499] INFO: task kworker/19:1:334 blocked for more than 120 seconds.
[ 6023.983499]       Not tainted 4.11.0-rc2 #6
[ 6023.983500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983500] kworker/19:1    D    0   334      2 0x00000000
[ 6023.983502] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983502] Call Trace:
[ 6023.983504]  __schedule+0x289/0x8f0
[ 6023.983505]  ? sched_clock+0x9/0x10
[ 6023.983506]  schedule+0x36/0x80
[ 6023.983507]  schedule_timeout+0x249/0x300
[ 6023.983508]  ? console_trylock+0x12/0x50
[ 6023.983509]  ? vprintk_emit+0x2ca/0x370
[ 6023.983510]  wait_for_completion+0x121/0x180
[ 6023.983511]  ? wake_up_q+0x80/0x80
[ 6023.983512]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983513]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983515]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983516]  process_one_work+0x165/0x410
[ 6023.983517]  worker_thread+0x137/0x4c0
[ 6023.983519]  kthread+0x101/0x140
[ 6023.983520]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983521]  ? kthread_park+0x90/0x90
[ 6023.983522]  ret_from_fork+0x2c/0x40
[ 6023.983523] INFO: task kworker/22:1:336 blocked for more than 120 seconds.
[ 6023.983524]       Not tainted 4.11.0-rc2 #6
[ 6023.983524] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6023.983524] kworker/22:1    D    0   336      2 0x00000000
[ 6023.983526] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 6023.983527] Call Trace:
[ 6023.983528]  __schedule+0x289/0x8f0
[ 6023.983529]  ? sched_clock+0x9/0x10
[ 6023.983530]  schedule+0x36/0x80
[ 6023.983531]  schedule_timeout+0x249/0x300
[ 6023.983532]  ? console_trylock+0x12/0x50
[ 6023.983533]  ? vprintk_emit+0x2ca/0x370
[ 6023.983534]  wait_for_completion+0x121/0x180
[ 6023.983535]  ? wake_up_q+0x80/0x80
[ 6023.983536]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 6023.983538]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 6023.983539]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 6023.983540]  process_one_work+0x165/0x410
[ 6023.983541]  worker_thread+0x137/0x4c0
[ 6023.983543]  kthread+0x101/0x140
[ 6023.983544]  ? rescuer_thread+0x3b0/0x3b0
[ 6023.983545]  ? kthread_park+0x90/0x90
[ 6023.983546]  ret_from_fork+0x2c/0x40
[ 6025.263203] nvmet: ctrl 1007 keep-alive timer (15 seconds) expired!
[ 6025.263210] nvmet: ctrl 1007 fatal error occurred!
[ 6029.103135] nvmet: ctrl 1030 keep-alive timer (15 seconds) expired!
[ 6029.103137] nvmet: ctrl 1030 fatal error occurred!
[ 6032.303082] nvmet: ctrl 1046 keep-alive timer (15 seconds) expired!
[ 6032.303083] nvmet: ctrl 1046 fatal error occurred!
[ 6036.143015] nvmet: ctrl 1058 keep-alive timer (15 seconds) expired!
[ 6036.143017] nvmet: ctrl 1058 fatal error occurred!
[ 6041.102122] pgrep invoked oom-killer: gfp_mask=0x16040d0(GFP_TEMPORARY|__GFP_COMP|__GFP_NOTRACK), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.102124] pgrep cpuset=/ mems_allowed=0-1
[ 6041.102128] CPU: 9 PID: 6418 Comm: pgrep Not tainted 4.11.0-rc2 #6
[ 6041.102129] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.102129] Call Trace:
[ 6041.102137]  dump_stack+0x63/0x87
[ 6041.102139]  dump_header+0x9f/0x233
[ 6041.102143]  ? selinux_capable+0x20/0x30
[ 6041.102145]  ? security_capable_noaudit+0x45/0x60
[ 6041.102148]  oom_kill_process+0x21c/0x3f0
[ 6041.102149]  out_of_memory+0x114/0x4a0
[ 6041.102151]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.102154]  __alloc_pages_nodemask+0x240/0x260
[ 6041.102157]  alloc_pages_current+0x88/0x120
[ 6041.102159]  new_slab+0x41f/0x5b0
[ 6041.102160]  ___slab_alloc+0x33e/0x4b0
[ 6041.102163]  ? __d_alloc+0x25/0x1d0
[ 6041.102164]  ? __d_alloc+0x25/0x1d0
[ 6041.102165]  __slab_alloc+0x40/0x5c
[ 6041.102166]  kmem_cache_alloc+0x16d/0x1a0
[ 6041.102167]  ? __d_alloc+0x25/0x1d0
[ 6041.102168]  __d_alloc+0x25/0x1d0
[ 6041.102170]  d_alloc+0x22/0xc0
[ 6041.102171]  d_alloc_parallel+0x6c/0x500
[ 6041.102174]  ? __inode_permission+0x48/0xd0
[ 6041.102175]  ? lookup_fast+0x215/0x3d0
[ 6041.102176]  path_openat+0xc91/0x13c0
[ 6041.102178]  do_filp_open+0x91/0x100
[ 6041.102180]  ? __alloc_fd+0x46/0x170
[ 6041.102182]  do_sys_open+0x124/0x210
[ 6041.102185]  ? __audit_syscall_exit+0x209/0x290
[ 6041.102186]  SyS_open+0x1e/0x20
[ 6041.102189]  do_syscall_64+0x67/0x180
[ 6041.102192]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.102193] RIP: 0033:0x7f6caba59a10
[ 6041.102194] RSP: 002b:00007ffd316e1698 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[ 6041.102195] RAX: ffffffffffffffda RBX: 00007ffd316e16b0 RCX: 00007f6caba59a10
[ 6041.102196] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd316e16b0
[ 6041.102196] RBP: 00007f6cac149ab0 R08: 00007f6cab9b9938 R09: 0000000000000010
[ 6041.102197] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000006d7100
[ 6041.102197] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000000
[ 6041.102199] Mem-Info:
[ 6041.102204] active_anon:0 inactive_anon:0 isolated_anon:0
[ 6041.102204]  active_file:538 inactive_file:167 isolated_file:0
[ 6041.102204]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.102204]  slab_reclaimable:11389 slab_unreclaimable:140375
[ 6041.102204]  mapped:492 shmem:0 pagetables:1494 bounce:0
[ 6041.102204]  free:39252 free_pcp:4025 free_cma:0
[ 6041.102208] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:12kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.102213] Node 1 active_anon:0kB inactive_anon:0kB active_file:2148kB inactive_file:672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1956kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:899 all_unreclaimable? no
[ 6041.102214] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.102217] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.102219] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.102222] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.102223] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7304kB local_pcp:184kB free_cma:0kB
[ 6041.102226] lowmem_reserve[]: 0 0 0 0 0
[ 6041.102228] Node 1 Normal free:44892kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:2148kB inactive_file:672kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278224kB kernel_stack:18520kB pagetables:2868kB bounce:0kB free_pcp:6872kB local_pcp:400kB free_cma:0kB
[ 6041.102231] lowmem_reserve[]: 0 0 0 0 0
[ 6041.102232] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.102238] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.102244] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.102250] Node 1 Normal: 380*4kB (UMEH) 173*8kB (UMEH) 66*16kB (UMH) 219*32kB (UME) 146*64kB (UM) 101*128kB (UME) 36*256kB (UM) 3*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 43992kB
[ 6041.102256] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.102257] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.102258] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.102259] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.102259] 996 total pagecache pages
[ 6041.102260] 39 pages in swap cache
[ 6041.102261] Swap cache stats: add 40374, delete 40331, find 7034/12915
[ 6041.102261] Free swap  = 16387932kB
[ 6041.102262] Total swap = 16516092kB
[ 6041.102262] 8379718 pages RAM
[ 6041.102263] 0 pages HighMem/MovableOnly
[ 6041.102263] 153941 pages reserved
[ 6041.102263] 0 pages cma reserved
[ 6041.102263] 0 pages hwpoisoned
[ 6041.102264] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.102278] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.102280] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.102281] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.102284] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.102286] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.102287] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.102288] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.102289] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.102291] [ 1152]     0  1152     4889       23      14       3      147             0 irqbalance
[ 6041.102292] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.102293] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.102294] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.102296] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.102297] [ 1178]     0  1178    28814       17      11       3       66             0 ksmtuned
[ 6041.102298] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.102299] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.102300] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.102302] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.102303] [ 1968]     0  1968   138299      235      91       4     3231             0 tuned
[ 6041.102304] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.102305] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.102306] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.102308] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.102309] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.102310] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.102311] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.102312] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.102313] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.102316] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.102317] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.102318] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.102319] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.102320] [ 3376]     0  3376    90269        1      96       3     4723             0 beah-beaker-bac
[ 6041.102321] [ 3377]     0  3377    64652        1      84       4     3446             0 beah-srv
[ 6041.102322] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.102324] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.102325] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.102444] [ 6416]     0  6416    28814       17      11       3       64             0 ksmtuned
[ 6041.102445] [ 6417]     0  6417    28814       20      11       3       61             0 ksmtuned
[ 6041.102446] [ 6418]     0  6418    37150      153      28       3       73             0 pgrep
[ 6041.102447] Out of memory: Kill process 3376 (beah-beaker-bac) score 0 or sacrifice child
[ 6041.102453] Killed process 3376 (beah-beaker-bac) total-vm:361076kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.113686] oom_reaper: reaped process 3376 (beah-beaker-bac), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.123498] beah-beaker-bac invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.123500] beah-beaker-bac cpuset=/ mems_allowed=0-1
[ 6041.123503] CPU: 26 PID: 3401 Comm: beah-beaker-bac Not tainted 4.11.0-rc2 #6
[ 6041.123503] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.123503] Call Trace:
[ 6041.123507]  dump_stack+0x63/0x87
[ 6041.123508]  dump_header+0x9f/0x233
[ 6041.123510]  ? selinux_capable+0x20/0x30
[ 6041.123511]  ? security_capable_noaudit+0x45/0x60
[ 6041.123512]  oom_kill_process+0x21c/0x3f0
[ 6041.123513]  out_of_memory+0x114/0x4a0
[ 6041.123514]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.123516]  __alloc_pages_nodemask+0x240/0x260
[ 6041.123518]  alloc_pages_vma+0xa5/0x220
[ 6041.123521]  __read_swap_cache_async+0x148/0x1f0
[ 6041.123522]  read_swap_cache_async+0x26/0x60
[ 6041.123523]  swapin_readahead+0x16b/0x200
[ 6041.123525]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.123528]  ? find_get_entry+0x20/0x140
[ 6041.123529]  ? pagecache_get_page+0x2c/0x240
[ 6041.123531]  do_swap_page+0x2aa/0x780
[ 6041.123532]  __handle_mm_fault+0x6f0/0xe60
[ 6041.123536]  ? hrtimer_try_to_cancel+0xc9/0x120
[ 6041.123538]  handle_mm_fault+0xce/0x240
[ 6041.123541]  __do_page_fault+0x22a/0x4a0
[ 6041.123542]  do_page_fault+0x30/0x80
[ 6041.123544]  page_fault+0x28/0x30
[ 6041.123546] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.123547] RSP: 0018:ffffc90006c6bc28 EFLAGS: 00010287
[ 6041.123548] RAX: 00007f536b73c9e7 RBX: ffff880828ceec80 RCX: 00000000000002b0
[ 6041.123548] RDX: ffff880829182d00 RSI: ffff880828ceec80 RDI: ffff880829182d00
[ 6041.123549] RBP: ffffc90006c6bc78 R08: 000000000001f480 R09: ffff88082af74148
[ 6041.123549] R10: 000000002d827401 R11: ffff88082d820000 R12: ffff880829182d00
[ 6041.123550] R13: 00007f536b73c9e0 R14: ffff880829182d00 R15: ffff8808285299c0
[ 6041.123553]  ? exit_robust_list+0x37/0x120
[ 6041.123555]  mm_release+0x11a/0x130
[ 6041.123557]  do_exit+0x152/0xb80
[ 6041.123559]  ? __unqueue_futex+0x2f/0x60
[ 6041.123560]  do_group_exit+0x3f/0xb0
[ 6041.123562]  get_signal+0x1bf/0x5e0
[ 6041.123565]  do_signal+0x37/0x6a0
[ 6041.123566]  ? do_futex+0xfd/0x570
[ 6041.123568]  exit_to_usermode_loop+0x3f/0x85
[ 6041.123569]  do_syscall_64+0x165/0x180
[ 6041.123571]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.123572] RIP: 0033:0x7f537b92379b
[ 6041.123572] RSP: 002b:00007f536b73ae90 EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
[ 6041.123573] RAX: fffffffffffffe00 RBX: 00000000000000ca RCX: 00007f537b92379b
[ 6041.123574] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f53640028a0
[ 6041.123574] RBP: 00007f53640028a0 R08: 0000000000000000 R09: 00000000016739e0
[ 6041.123575] R10: 0000000000000000 R11: 0000000000000282 R12: fffffffeffffffff
[ 6041.123575] R13: 0000000000000000 R14: 0000000001f45670 R15: 0000000001ec2998
[ 6041.123576] Mem-Info:
[ 6041.123580] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.123580]  active_file:452 inactive_file:211 isolated_file:0
[ 6041.123580]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.123580]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.123580]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.123580]  free:39213 free_pcp:4164 free_cma:0
[ 6041.123585] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.123589] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:848kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1306 all_unreclaimable? no
[ 6041.123589] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.123592] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.123594] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.123597] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.123599] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7304kB local_pcp:152kB free_cma:0kB
[ 6041.123601] lowmem_reserve[]: 0 0 0 0 0
[ 6041.123603] Node 1 Normal free:44736kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:848kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:7428kB local_pcp:608kB free_cma:0kB
[ 6041.123605] lowmem_reserve[]: 0 0 0 0 0
[ 6041.123607] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.123612] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.123618] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB  writepending:0kB present:13631488kB managed:13364292kB mlocked4kB (UMH) 173*8kB (UMH) 66*16kB (UMH) 218*32kB (UM) 146*64kB (UM) 101*128kB (UM) 36*256kB (UM) 3*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 43960kB
[ 6041.123630] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.123630] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.123631] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.123631] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.123632] 870 total pagecache pages
[ 6041.123633] 39 pages in swap cache
[ 6041.123634] Swap cache stats: add 40375, delete 40332, find 7035/12918
[ 6041.123634] Free swap  = 16406620kB
[ 6041.123635] Total swap = 16516092kB
[ 6041.123635] 8379718 pages RAM
[ 6041.123635] 0 pages HighMem/MovableOnly
[ 6041.123636] 153941 pages reserved
[ 6041.123636] 0 pages cma reserved
[ 6041.123636] 0 pages hwpoisone1       3       82             0 systemd-journal
[ 6041.123651] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.123652] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.123655] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.123656] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.123657] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.123659] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.123660] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.123661] [ 1152]     0  1152     4889       22      14       3      147             0 irqbalance
[ 6041.123662] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.123663] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.123664] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.123665] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.123666] [ 1178]     0  1178    28814       17      11       3       66             0 ksmtuned
[ 6041.123667] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.123668] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.123669] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.123670] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.123672] [ 1968]     0  1968   138299      193      91       4     3231             0 tuned
[ 6041.12 40       4      785             0 rsyslogd
[ 6041.123675] [ 1987]     0  1987 677] [ 2047]     0  2047    20619        0      44       3      214         -100 2537    27511        1      12       3       32             0 agetty
[ 6041.123679] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.123680] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.123681] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.123683] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.123684] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.123685] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.123686] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.123688] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.123689] [ 3377]     0  3377    64652        1      84       4     3446             0 beah-srv
[ 6041.123690] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.123691] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.123693] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.123811] [ 6416]     0  6416    28814       17      11       3       64             0 ksmtuned
[ 6041.123812] [ 6417]     0  6417    28814       20      11       3       61             0 ksmtuned
[ 6041.123813] [ 6418]     0  6418    37150      144      28       3       73             0 pgrep
[ 6041.123814] Out of memory: Kill process 3377 (beah-srv) score 0 or sacrifice child
[ 6041.123818] Killed process 3377 (beah-srv) total-vm:258608kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.143543] systemd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.143545] systemd cpuset=/ mems_allowed=0-1
[ 6041.143547] CPU: 27 PID: 1 Comm: systemd Not tainted 4.11.0-rc2 #6
[ 6041.143548] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.143548] Call Trace:
[ 6041.143552]  dump_stack+0x63/0x87
[ 6041.143553]  dump_header+0x9f/0x233
[ 6041.143554]  ? selinux_capable+0x20/0x30
[ 6041.143555]  ? security_capable_noaudit+0x45/0x60
[ 6041.143557]  oom_kill_process+0x21c/0x3f0
[ 6041.143558]  out_of_memory+0x114/0x4a0
[ 6041.143559]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.143561]  __alloc_pages_nodemask+0x240/0x260
[ 6041.143562]  alloc_pages_vma+0xa5/0x220
[ 6041.143564]  __read_swap_cache_async+0x148/0x1f0
[ 6041.143565]  read_swap_cache_async+0x26/0x60
[ 6041.143566]  swapin_readahead+0x16b/0x200
[ 6041.143567]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.143569]  ? find_get_entry+0x20/0x140
[ 6041.143570]  ? pagecache_get_page+0x2c/0x240
[ 6041.143571]  do_swap_page+0x2aa/0x780
[ 6041.143572]  __handle_mm_fault+0x6f0/0xe60
[ 6041.143573]  ? do_anonymous_page+0x283/0x550
[ 6041.143575]  handle_mm_fault+0xce/0x240
[ 6041.143576]  __do_page_fault+0x22a/0x4a0
[ 6041.143577]  ? free_hot_cold_page+0x21f/0x280
[ 6041.143579]  do_page_fault+0x30/0x80
[ 6041.143580]  ? dequeue_entity+0xed/0x420
[ 6041.143582]  page_fault+0x28/0x30
[ 6041.143585] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.143586] RSP: 0018:ffffc90003147d88 EFLAGS: 00010246
[ 6041.143587] RAX: 0000000000000001 RBX: ffffc90003147e08 RCX: 00007ffcfa85b820
[ 6041.143587] RDX: 0000000000000000 RSI: ffff88042fcb3190 RDI: ffff8804be4f8808
[ 6041.143588] RBP: ffffc90003147de0 R08: ffff88042fcb0698 R09: cccccccccccccccd
[ 6041.143588] R10: 0000057e6104dc4a R11: 0000000000000008 R12: 0000000000000000
[ 6041.143589] R13: ffffc90003147ea0 R14: ffff88017d4d6a80 R15: ffff88042fcb0698
[ 6041.143591]  ? ep_send_events_proc+0x93/0x1e0
[ 6041.143592]  ? ep_poll+0x3c0/0x3c0
[ 6041.143593]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.143595]  ep_poll+0x195/0x3c0
[ 6041.143596]  ? wake_up_q+0x80/0x80
[ 6041.143598]  SyS_epoll_wait+0xbc/0xe0
[ 6041.143599]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 6041.143600] RIP: 0033:0x7f43b421bcf3
[ 6041.143601] RSP: 002b:00007ffcfa85b818 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.143602] RAX: ffffffffffffffda RBX: 000055c0f44c5e10 RCX: 00007f43b421bcf3
[ 6041.143602] RDX: 0000000000000029 RSI: 00007ffcfa85b820 RDI: 0000000000000004
[ 6041.143603] RBP: 0000000000000000 R08: 00000000000c9362 R09: 0000000000000000
[ 6041.143603] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 6041.143604] R13: 00007ffcfa859548 R14: 000000000000000c R15: 00007ffcfa859552
[ 6041.143605] Mem-Info:
[ 6041.143609] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.143609]  active_file:452 inactive_file:196 isolated_file:0
[ 6041.143609]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.143609]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.143609]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.143609]  free:39213 free_pcp:4378 free_cma:0
[ 6041.143614] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.143618] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:124 all_unreclaimable? no
[ 6041.143618] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.143621] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.143623] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.143626] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.143627] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7660kB local_pcp:100kB free_cma:0kB
[ 6041.143630] lowmem_reserve[]: 0 0 0 0 0
[ 6041.143632] Node 1 Normal free:44736kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:7928kB local_pcp:636kB free_cma:0kB
[ 6041.143634] lowmem_reserve[]: 0 0 0 0 0
[ 6041.143636] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.143641] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.143647] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.143653] Node 1 Normal: 531*4kB (UMH) 215*8kB (UMH) 73*16kB (UMH) 221*32kB (UM) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45044kB
[ 6041.143659] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.143660] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.143660] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.143661] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.143661] 579 total pagecache pages
[ 6041.143662] 27 pages in swap cache
[ 6041.143663] Swap cache stats: add 40386, delete 40355, find 7036/12923
[ 6041.143663] Free swap  = 16420444kB
[ 6041.143664] Total swap = 16516092kB
[ 6041.143664] 8379718 pages RAM
[ 6041.143664] 0 pages HighMem/MovableOnly
[ 6041.143665] 153941 pages reserved
[ 6041.143665] 0 pages cma reserved
[ 6041.143665] 0 pages hwpoisoned
[ 6041.143665] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.143678] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.143679] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.143680] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.143683] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.143684] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.143686] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.143687] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.143688] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.143689] [ 1152]     0  1152     4889       10      14       3      147             0 irqbalance
[ 6041.143690] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.143691] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.143692] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.143693] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.143694] [ 1178]     0  1178    28814        9      11       3       66             0 ksmtuned
[ 6041.143695] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.143696] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.143697] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.143699] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.143700] [ 1968]     0  1968   138299        0      91       4     3231             0 tuned
[ 6041.143701] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.143702] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.143703] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.143704] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.143705] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.143706] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.143707] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.143708] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.143710] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.143711] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.143712] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.143714] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.143715] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.143716] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.143717] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.143719] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.143720] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.143839] [ 6416]     0  6416    28814        9      11       3       64             0 ksmtuned
[ 6041.143840] [ 6417]     0  6417    28814       12      11       3       61             0 ksmtuned
[ 6041.143841] [ 6418]     0  6418    37150       81      28       3       85             0 pgrep
[ 6041.143842] Out of memory: Kill process 1968 (tuned) score 0 or sacrifice child
[ 6041.143852] Killed process 1968 (tuned) total-vm:553196kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.163655] oom_reaper: reaped process 1968 (tuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.173411] beah-fwd-backen invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.173414] beah-fwd-backen cpuset=/ mems_allowed=0-1
[ 6041.173416] CPU: 24 PID: 3374 Comm: beah-fwd-backen Not tainted 4.11.0-rc2 #6
[ 6041.173417] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.173417] Call Trace:
[ 6041.173420]  dump_stack+0x63/0x87
[ 6041.173422]  dump_header+0x9f/0x233
[ 6041.173423]  ? selinux_capable+0x20/0x30
[ 6041.173424]  ? security_capable_noaudit+0x45/0x60
[ 6041.173425]  oom_kill_process+0x21c/0x3f0
[ 6041.173426]  out_of_memory+0x114/0x4a0
[ 6041.173428]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.173463]  ? xfs_buf_trylock+0x1f/0xd0 [xfs]
[ 6041.173465]  __alloc_pages_nodemask+0x240/0x260
[ 6041.173466]  alloc_pages_vma+0xa5/0x220
[ 6041.173468]  __read_swap_cache_async+0x148/0x1f0
[ 6041.173469]  ? __compute_runnable_contrib+0x1c/0x20
[ 6041.173471]  read_swap_cache_async+0x26/0x60
[ 6041.173472]  swapin_readahead+0x16b/0x200
[ 6041.173473]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.173475]  ? find_get_entry+0x20/0x140
[ 6041.173476]  ? pagecache_get_page+0x2c/0x240
[ 6041.173477]  do_swap_page+0x2aa/0x780
[ 6041.173479]  __handle_mm_fault+0x6f0/0xe60
[ 6041.173481]  ? __block_commit_write.isra.29+0x7a/0xb0
[ 6041.173483]  handle_mm_fault+0xce/0x240
[ 6041.173484]  __do_page_fault+0x22a/0x4a0
[ 6041.173486]  do_page_fault+0x30/0x80
[ 6041.173487]  page_fault+0x28/0x30
[ 6041.173489] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.173489] RSP: 0018:ffffc900056f7d60 EFLAGS: 00010246
[ 6041.173490] RAX: 0000000000000011 RBX: ffffc900056f7de0 RCX: 000000000144afc0
[ 6041.173491] RDX: 0000000000000000 RSI: ffff8808268cf240 RDI: ffff88042eab7100
[ 6041.173491] RBP: ffffc900056f7db8 R08: ffff880829ce6498 R09: cccccccccccccccd
[ 6041.173492] R10: 0000057e5cc9b096 R11: 0000000000000008 R12: 0000000000000000
[ 6041.173493] R13: ffffc900056f7e78 R14: ffff88017db58e40 R15: ffff880829ce6498
[ 6041.173495]  ? ep_poll+0x3c0/0x3c0
[ 6041.173496]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.173497]  ? hrtimer_init+0x190/0x190
[ 6041.173498]  ep_poll+0x195/0x3c0
[ 6041.173500]  ? wake_up_q+0x80/0x80
[ 6041.173501]  SyS_epoll_wait+0xbc/0xe0
[ 6041.173502]  do_syscall_64+0x67/0x180
[ 6041.173504]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.173504] RIP: 0033:0x7fc583ffacf3
[ 6041.173505] RSP: 002b:00007ffc38c49708 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.173506] RAX: ffffffffffffffda RBX: 00007fc58513f210 RCX: 00007fc583ffacf3
[ 6041.173506] RDX: 0000000000000003 RSI: 000000000144afc0 RDI: 0000000000000006
[ 6041.173507] RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000024
[ 6041.173507] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000cac0a0
[ 6041.173508] R13: 000000000144afc0 R14: 000000000153f1f0 R15: 00000000014edab8
[ 6041.173509] Mem-Info:
[ 6041.173514] active_anon:0 inactive_anon:2 isolated_anon:0
[ 6041.173514]  active_file:452 inactive_file:196 isolated_file:0
[ 6041.173514]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.173514]  slab_reclaimable:11389 slab_unreclaimable:140377
[ 6041.173514]  mapped:468 shmem:0 pagetables:1501 bounce:0
[ 6041.173514]  free:39310 free_pcp:4606 free_cma:0
[ 6041.173519] Node 0 active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.173524] Node 1 active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1852kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:98 all_unreclaimable? yes
[ 6041.173525] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.173527] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.173529] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.173532] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.173534] Node 0 Normal free:35940kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:28kB active_file:4kB inactive_file:0kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15788kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:3108kB bounce:0kB free_pcp:7668kB local_pcp:120kB free_cma:0kB
[ 6041.173536] lowmem_reserve[]: 0 0 0 0 0
[ 6041.173538] Node 1 Normal free:45124kB min:45292kB low:61800kB high:78308kB active_anon:0kB inactive_anon:0kB active_file:1804kB inactive_file:788kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29672kB slab_unreclaimable:278232kB kernel_stack:18520kB pagetables:2896kB bounce:0kB free_pcp:8832kB local_pcp:468kB free_cma:0kB
[ 6041.173540] lowmem_reserve[]: 0 0 0 0 0
[ 6041.173542] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.173547] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.173554] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.173559] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.173565] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.173566] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.173567] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.173567] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.173568] 482 total pagecache pages
[ 6041.173569] 23 pages in swap cache
[ 6041.173569] Swap cache stats: add 40392, delete 40365, find 7038/12930
[ 6041.173570] Free swap  = 16433244kB
[ 6041.173570] Total swap = 16516092kB
[ 6041.173571] 8379718 pages RAM
[ 6041.173571] 0 pages HighMem/MovableOnly
[ 6041.173571] 153941 pages reserved
[ 6041.173572] 0 pages cma reserved
[ 6041.173572] 0 pages hwpoisoned
[ 6041.173572] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.173585] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.173586] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.173587] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.173590] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.173591] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.173592] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.173593] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.173594] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.173595] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.173596] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.173598] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.173599] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.173600] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.173601] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.173602] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.173603] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.173604] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.173606] [ 1897]     0  1897    28209        0      54       3     3122             0 dhclient
[ 6041.173607] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.173608] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.173609] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.173611] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.173612] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.173613] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.173614] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.173615] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.173616] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.173617] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.173619] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.173620] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.173621] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.173623] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.173624] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.173625] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.173627] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.173628] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.173748] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.173749] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.173750] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.173751] Out of memory: Kill process 1897 (dhclient) score 0 or sacrifice child
[ 6041.173756] Killed process 1897 (dhclient) total-vm:112836kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.203482] gmain invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.203484] gmain cpuset=/ mems_allowed=0-1
[ 6041.203487] CPU: 20 PID: 3080 Comm: gmain Not tainted 4.11.0-rc2 #6
[ 6041.203488] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.203488] Call Trace:
[ 6041.203492]  dump_stack+0x63/0x87
[ 6041.203495]  dump_header+0x9f/0x233
[ 6041.203497]  ? selinux_capable+0x20/0x30
[ 6041.203499]  ? security_capable_noaudit+0x45/0x60
[ 6041.203502]  oom_kill_process+0x21c/0x3f0
[ 6041.203503]  out_of_memory+0x114/0x4a0
[ 6041.203504]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.203507]  __alloc_pages_nodemask+0x240/0x260
[ 6041.203510]  alloc_pages_vma+0xa5/0x220
[ 6041.203512]  __read_swap_cache_async+0x148/0x1f0
[ 6041.203513]  read_swap_cache_async+0x26/0x60
[ 6041.203514]  swapin_readahead+0x16b/0x200
[ 6041.203516]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.203518]  ? find_get_entry+0x20/0x140
[ 6041.203519]  ? pagecache_get_page+0x2c/0x240
[ 6041.203521]  do_swap_page+0x2aa/0x780
[ 6041.203522]  __handle_mm_fault+0x6f0/0xe60
[ 6041.203524]  handle_mm_fault+0xce/0x240
[ 6041.203526]  __do_page_fault+0x22a/0x4a0
[ 6041.203527]  do_page_fault+0x30/0x80
[ 6041.203529]  page_fault+0x28/0x30
[ 6041.203532] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.203532] RSP: 0000:ffffc90006e9bad0 EFLAGS: 00010246
[ 6041.203533] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.203534] RDX: 0000000000000000 RSI: ffffc90006e9bb30 RDI: ffffc90006e9bb3c
[ 6041.203534] RBP: ffffc90006e9bee0 R08: 0000000000000000 R09: ffff880828d95280
[ 6041.203535] R10: 0000000000000040 R11: ffff880402286c38 R12: 0000000000000000
[ 6041.203536] R13: ffffc90006e9bb44 R14: 00000000fffffffc R15: 00007ff5700008e0
[ 6041.203538]  ? get_page_from_freelist+0x3e3/0xbe0
[ 6041.203539]  ? get_page_from_freelist+0x3e3/0xbe0
[ 6041.203541]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.203542]  ? __alloc_pages_nodemask+0xe3/0x260
[ 6041.203545]  ? mem_cgroup_commit_charge+0x89/0x120
[ 6041.203547]  ? lru_cache_add_active_or_unevictable+0x35/0xb0
[ 6041.203550]  ? eventfd_ctx_read+0x67/0x210
[ 6041.203551]  ? wake_up_q+0x80/0x80
[ 6041.203552]  ? eventfd_read+0x5d/0x90
[ 6041.203554]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.203555]  SyS_poll+0x74/0x100
[ 6041.203557]  do_syscall_64+0x67/0x180
[ 6041.203559]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.203559] RIP: 0033:0x7ff583029dfd
[ 6041.203560] RSP: 002b:00007ff5749f9e70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.203561] RAX: ffffffffffffffda RBX: 0000000001ed1e00 RCX: 00007ff583029dfd
[ 6041.203561] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007ff5700008e0
[ 6041.203562] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[ 6041.203563] R10: 0000000000000001 R11: 0000000000000293 R12: 00007ff5700008e0
[ 6041.203563] R13: 00000000ffffffff R14: 00007ff5774878b0 R15: 0000000000000001
[ 6041.203564] Mem-Info:
[ 6041.203569] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.203569]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.203569]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.203569]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.203569]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.203569]  free:39185 free_pcp:4665 free_cma:0
[ 6041.203574] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.203578] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:890 all_unreclaimable? yes
[ 6041.203579] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.203581] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.203583] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.203586] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.203588] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7676kB local_pcp:204kB free_cma:0kB
[ 6041.203591] lowmem_reserve[]: 0 0 0 0 0
[ 6041.203592] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9060kB local_pcp:256kB free_cma:0kB
[ 6041.203595] lowmem_reserve[]: 0 0 0 0 0
[ 6041.203596] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.203602] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.203608] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.203614] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.203621] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.203621] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.203622] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.203623] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.203623] 367 total pagecache pages
[ 6041.203626] 23 pages in swap cache
[ 6041.203627] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.203627] Free swap  = 16445788kB
[ 6041.203628] Total swap = 16516092kB
[ 6041.203628] 8379718 pages RAM
[ 6041.203629] 0 pages HighMem/MovableOnly
[ 6041.203629] 153941 pages reserved
[ 6041.203629] 0 pages cma reserved
[ 6041.203630] 0 pages hwpoisoned
[ 6041.203630] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.203644] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.203646] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.203647] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.203650] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.203651] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.203653] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.203654] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.203655] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.203656] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.203657] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.203658] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.203660] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.203661] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.203662] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.203663] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.203664] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.203665] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.203667] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.203668] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.203669] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.203670] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.203672] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.203673] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.203674] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.203675] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.203676] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.203677] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.203679] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.203681] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.203682] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.203683] [ 3374]     0  3374    60772        1      75       4     3100             0 beah-fwd-backen
[ 6041.203684] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.203685] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.203687] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.203688] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.203855] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.203856] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.203857] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.203858] Out of memory: Kill process 3374 (beah-fwd-backen) score 0 or sacrifice child
[ 6041.203862] Killed process 3374 (beah-fwd-backen) total-vm:243088kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.204562] oom_reaper: reaped process 3374 (beah-fwd-backen), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.222947] beah-fwd-backen: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.222973] beah-fwd-backen cpuset=/ mems_allowed=0-1
[ 6041.222976] CPU: 24 PID: 3374 Comm: beah-fwd-backen Not tainted 4.11.0-rc2 #6
[ 6041.222976] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.222977] Call Trace:
[ 6041.222981]  dump_stack+0x63/0x87
[ 6041.222982]  warn_alloc+0x114/0x1c0
[ 6041.222984]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.223007]  ? xfs_buf_trylock+0x1f/0xd0 [xfs]
[ 6041.223009]  __alloc_pages_nodemask+0x240/0x260
[ 6041.223011]  alloc_pages_vma+0xa5/0x220
[ 6041.223012]  __read_swap_cache_async+0x148/0x1f0
[ 6041.223014]  ? __compute_runnable_contrib+0x1c/0x20
[ 6041.223016]  read_swap_cache_async+0x26/0x60
[ 6041.223017]  swapin_readahead+0x16b/0x200
[ 6041.223018]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.223020]  ? find_get_entry+0x20/0x140
[ 6041.223021]  ? pagecache_get_page+0x2c/0x240
[ 6041.223034]  do_swap_page+0x2aa/0x780
[ 6041.223036]  __handle_mm_fault+0x6f0/0xe60
[ 6041.223037]  ? __block_commit_write.isra.29+0x7a/0xb0
[ 6041.223038]  handle_mm_fault+0xce/0x240
[ 6041.223040]  __do_page_fault+0x22a/0x4a0
[ 6041.223041]  do_page_fault+0x30/0x80
[ 6041.223043]  page_fault+0x28/0x30
[ 6041.223045] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.223045] RSP: 0018:ffffc900056f7d60 EFLAGS: 00010246
[ 6041.223046] RAX: 0000000000000011 RBX: ffffc900056f7de0 RCX: 000000000144afc0
[ 6041.223047] RDX: 0000000000000000 RSI: ffff8808268cf240 RDI: ffff88042eab7100
[ 6041.223048] RBP: ffffc900056f7db8 R08: ffff880829ce6498 R09: cccccccccccccccd
[ 6041.223049] R10: 0000057e5cc9b096 R11: 0000000000000008 R12: 0000000000000000
[ 6041.223049] R13: ffffc900056f7e78 R14: ffff88017db58e40 R15: ffff880829ce6498
[ 6041.223052]  ? ep_poll+0x3c0/0x3c0
[ 6041.223053]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.223054]  ? hrtimer_init+0x190/0x190
[ 6041.223056]  ep_poll+0x195/0x3c0
[ 6041.223057]  ? wake_up_q+0x80/0x80
[ 6041.223059]  SyS_epoll_wait+0xbc/0xe0
[ 6041.223060]  do_syscall_64+0x67/0x180
[ 6041.223062]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.223063] RIP: 0033:0x7fc583ffacf3
[ 6041.223063] RSP: 002b:00007ffc38c49708 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.223064] RAX: ffffffffffffffda RBX: 00007fc58513f210 RCX: 00007fc583ffacf3
[ 6041.223065] RDX: 0000000000000003 RSI: 000000000144afc0 RDI: 0000000000000006
[ 6041.223065] RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000024
[ 6041.223066] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000cac0a0
[ 6041.223067] R13: 000000000144afc0 R14: 000000000153f1f0 R15: 00000000014edab8
[ 6041.223068] Mem-Info:
[ 6041.223073] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.223073]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.223073]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.223073]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.223073]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.223073]  free:39185 free_pcp:4665 free_cma:0
[ 6041.223078] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.223084] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:991 all_unreclaimable? yes
[ 6041.223084] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.223087] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.223089] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.223092] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.223094] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7676kB local_pcp:120kB free_cma:0kB
[ 6041.223097] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223098] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9060kB local_pcp:468kB free_cma:0kB
[ 6041.223101] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223103] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.223109] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.223115] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.223122] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.223128] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223129] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223130] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223131] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223131] 367 total pagecache pages
[ 6041.223133] 23 pages in swap cache
[ 6041.223133] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.223134] Free swap  = 16458332kB
[ 6041.223134] Total swap = 16516092kB
[ 6041.223135] 8379718 pages RAM
[ 6041.223135] 0 pages HighMem/MovableOnly
[ 6041.223135] 153941 pages reserved
[ 6041.223136] 0 pages cma reserved
[ 6041.223136] 0 pages hwpoisoned
[ 6041.223431] tuned invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.223433] tuned cpuset=/ mems_allowed=0-1
[ 6041.223435] CPU: 23 PID: 3082 Comm: tuned Not tainted 4.11.0-rc2 #6
[ 6041.223436] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.223436] Call Trace:
[ 6041.223439]  dump_stack+0x63/0x87
[ 6041.223441]  dump_header+0x9f/0x233
[ 6041.223442]  ? selinux_capable+0x20/0x30
[ 6041.223443]  ? security_capable_noaudit+0x45/0x60
[ 6041.223445]  oom_kill_process+0x21c/0x3f0
[ 6041.223446]  out_of_memory+0x114/0x4a0
[ 6041.223447]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.223450]  ? hrtimer_try_to_cancel+0xc9/0x120
[ 6041.223452]  __alloc_pages_nodemask+0x240/0x260
[ 6041.223453]  alloc_pages_vma+0xa5/0x220
[ 6041.223455]  __read_swap_cache_async+0x148/0x1f0
[ 6041.223456]  read_swap_cache_async+0x26/0x60
[ 6041.223457]  swapin_readahead+0x16b/0x200
[ 6041.223458]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.223460]  ? find_get_entry+0x20/0x140
[ 6041.223461]  ? pagecache_get_page+0x2c/0x240
[ 6041.223462]  do_swap_page+0x2aa/0x780
[ 6041.223463]  __handle_mm_fault+0x6f0/0xe60
[ 6041.223465]  handle_mm_fault+0xce/0x240
[ 6041.223466]  __do_page_fault+0x22a/0x4a0
[ 6041.223468]  do_page_fault+0x30/0x80
[ 6041.223469]  page_fault+0x28/0x30
[ 6041.223471] RIP: 0010:copy_user_generic_string+0x2c/0x40
[ 6041.223472] RSP: 0018:ffffc90006eabe48 EFLAGS: 00010246
[ 6041.223472] RAX: 0000000000000010 RBX: 00000000fffffdfe RCX: 0000000000000002
[ 6041.223473] RDX: 0000000000000000 RSI: ffffc90006eabe80 RDI: 00007ff56f7fcdd0
[ 6041.223474] RBP: ffffc90006eabe50 R08: 00007ffffffff000 R09: 0000000000000000
[ 6041.223474] R10: ffff88042f9d4760 R11: 0000000000000049 R12: ffffc90006eabed0
[ 6041.223475] R13: 00007ff56f7fcdd0 R14: 0000000000000001 R15: 0000000000000000
[ 6041.223477]  ? _copy_to_user+0x2d/0x40
[ 6041.223478]  poll_select_copy_remaining+0xfb/0x150
[ 6041.223480]  SyS_select+0xcc/0x110
[ 6041.223481]  do_syscall_64+0x67/0x180
[ 6041.223482]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.223483] RIP: 0033:0x7ff58302bba3
[ 6041.223484] RSP: 002b:00007ff56f7fcda0 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[ 6041.223485] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff58302bba3
[ 6041.223485] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 6041.223486] RBP: 00000000021c2400 R08: 00007ff56f7fcdd0 R09: 00007ff56f7fcb80
[ 6041.223486] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ff57b785810
[ 6041.223487] R13: 0000000000000001 R14: 00007ff56000dda0 R15: 00007ff584089ef0
[ 6041.223488] Mem-Info:
[ 6041.223503] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.223503]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.223503]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.223503]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.223503]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.223503]  free:39185 free_pcp:4746 free_cma:0
[ 6041.223508] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.223512] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1196 all_unreclaimable? yes
[ 6041.223513] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.223515] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.223517] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.223520] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.223522] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7868kB local_pcp:96kB free_cma:0kB
[ 6041.223525] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223526] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:296kB free_cma:0kB
[ 6041.223529] lowmem_reserve[]: 0 0 0 0 0
[ 6041.223530] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.223536] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.223542] Node 0 Normal: 97*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.223548] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.223555] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223555] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223556] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.223557] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.223557] 367 total pagecache pages
[ 6041.223558] 23 pages in swap cache
[ 6041.223559] Swap cache stats: add 40394, delete 40367, find 7040/12934
[ 6041.223559] Free swap  = 16458332kB
[ 6041.223559] Total swap = 16516092kB
[ 6041.223560] 8379718 pages RAM
[ 6041.223560] 0 pages HighMem/MovableOnly
[ 6041.223561] 153941 pages reserved
[ 6041.223561] 0 pages cma reserved
[ 6041.223561] 0 pages hwpoisoned
[ 6041.223562] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.223574] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.223576] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.223577] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.223580] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.223581] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.223583] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.223584] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.223585] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.223586] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.223587] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.223588] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.223589] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.223590] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.223591] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.223592] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.223593] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.223594] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.223596] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.223597] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.223598] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.223599] [ 1987]     0  1987   154722        1     148       3     2116             0 libvirtd
[ 6041.223600] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.223601] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.223602] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.223603] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.223604] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.223605] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.223607] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.223608] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.223609] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.223611] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.223612] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.223613] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.223614] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.223786] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.223787] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.223788] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.223789] Out of memory: Kill process 1987 (libvirtd) score 0 or sacrifice child
[ 6041.223841] Killed process 1987 (libvirtd) total-vm:618888kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.224657] oom_reaper: reaped process 1987 (libvirtd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.243393] tuned invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.243395] tuned cpuset=/ mems_allowed=0-1
[ 6041.243399] CPU: 16 PID: 3081 Comm: tuned Not tainted 4.11.0-rc2 #6
[ 6041.243400] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.243400] Call Trace:
[ 6041.243405]  dump_stack+0x63/0x87
[ 6041.243407]  dump_header+0x9f/0x233
[ 6041.243409]  ? selinux_capable+0x20/0x30
[ 6041.243411]  ? security_capable_noaudit+0x45/0x60
[ 6041.243413]  oom_kill_process+0x21c/0x3f0
[ 6041.243414]  out_of_memory+0x114/0x4a0
[ 6041.243416]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.243419]  __alloc_pages_nodemask+0x240/0x260
[ 6041.243421]  alloc_pages_vma+0xa5/0x220
[ 6041.243423]  __read_swap_cache_async+0x148/0x1f0
[ 6041.243425]  read_swap_cache_async+0x26/0x60
[ 6041.243427]  swapin_readahead+0x16b/0x200
[ 6041.243429]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.243431]  ? find_get_entry+0x20/0x140
[ 6041.243433]  ? pagecache_get_page+0x2c/0x240
[ 6041.243435]  do_swap_page+0x2aa/0x780
[ 6041.243436]  __handle_mm_fault+0x6f0/0xe60
[ 6041.243437]  ? update_load_avg+0x809/0x950
[ 6041.243439]  handle_mm_fault+0xce/0x240
[ 6041.243440]  __do_page_fault+0x22a/0x4a0
[ 6041.243442]  do_page_fault+0x30/0x80
[ 6041.243444]  page_fault+0x28/0x30
[ 6041.243446] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.243446] RSP: 0018:ffffc90006ea3ad0 EFLAGS: 00010246
[ 6041.243447] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.243460] RDX: 0000000000000000 RSI: ffffc90006ea3b30 RDI: ffffc90006ea3b3c
[ 6041.243460] RBP: ffffc90006ea3ee0 R08: 0000000000000000 R09: ffff880828d95280
[ 6041.243461] R10: 0000000000000030 R11: ffff880402286938 R12: 0000000000000000
[ 6041.243462] R13: ffffc90006ea3b4c R14: 00000000fffffffc R15: 00007ff568001b80
[ 6041.243464]  ? dequeue_entity+0xed/0x420
[ 6041.243466]  ? select_idle_sibling+0x29/0x3d0
[ 6041.243467]  ? pick_next_task_fair+0x11f/0x540
[ 6041.243469]  ? account_entity_enqueue+0xd8/0x100
[ 6041.243470]  ? __enqueue_entity+0x6c/0x70
[ 6041.243471]  ? enqueue_entity+0x1eb/0x700
[ 6041.243473]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.243474]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.243475]  ? try_to_wake_up+0x59/0x450
[ 6041.243476]  ? wake_up_q+0x4f/0x80
[ 6041.243478]  ? futex_wake+0x90/0x180
[ 6041.243480]  ? do_futex+0x11c/0x570
[ 6041.243482]  ? __vfs_read+0x37/0x150
[ 6041.243483]  ? security_file_permission+0x9d/0xc0
[ 6041.243484]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.243486]  SyS_poll+0x74/0x100
[ 6041.243487]  do_syscall_64+0x67/0x180
[ 6041.243489]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.243489] RIP: 0033:0x7ff583029dfd
[ 6041.243490] RSP: 002b:00007ff56fffdeb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.243491] RAX: ffffffffffffffda RBX: 0000000002128750 RCX: 00007ff583029dfd
[ 6041.243491] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007ff568001b80
[ 6041.243492] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[ 6041.243493] R10: 0000000000000001 R11: 0000000000000293 R12: 00007ff568001b80
[ 6041.243493] R13: 00000000ffffffff R14: 00007ff5774878b0 R15: 0000000000000002
[ 6041.243494] Mem-Info:
[ 6041.243499] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.243499]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.243499]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.243499]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.243499]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.243499]  free:39185 free_pcp:4775 free_cma:0
[ 6041.243522] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.243527] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1806 all_unreclaimable? yes
[ 6041.243527] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.243530] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.243532] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:184kB free_cma:0kB
[ 6041.243535] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.243537] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7984kB local_pcp:788kB free_cma:0kB
[ 6041.243539] lowmem_reserve[]: 0 0 0 0 0
[ 6041.243541] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:688kB free_cma:0kB
[ 6041.243543] lowmem_reserve[]: 0 0 0 0 0
[ 6041.243545] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.243550] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.243557] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.243563] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.243574] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.243574] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.243575] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.243575] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.243576] 367 total pagecache pages
[ 6041.243577] 23 pages in swap cache
[ 6041.243578] Swap cache stats: add 40396, delete 40369, find 7041/12951
[ 6041.243578] Free swap  = 16466780kB
[ 6041.243578] Total swap = 16516092kB
[ 6041.243579] 8379718 pages RAM
[ 6041.243579] 0 pages HighMem/MovableOnly
[ 6041.243580] 153941 pages reserved
[ 6041.243580] 0 pages cma reserved
[ 6041.243580] 0 pages hwpoisoned
[ 6041.243580] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.243593] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.243595] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.243596] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.243599] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.243600] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.243601] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.243602] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.243603] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.243604] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.243606] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.243607] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.243608] [ 1161]   998  1161   132401        0      57       4     1872             0 polkitd
[ 6041.243609] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.243610] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.243611] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.243612] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.243613] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.243615] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.243616] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.243617] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.243618] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.243619] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.243620] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.243621] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.243622] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.243623] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.243624] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.243626] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.243627] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.243628] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.243630] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.243631] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.243633] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.243641] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.243817] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.243818] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.243819] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.243820] Out of memory: Kill process 1161 (polkitd) score 0 or sacrifice child
[ 6041.243845] Killed process 1161 (polkitd) total-vm:529604kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.244458] oom_reaper: reaped process 1161 (polkitd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.253520] libvirtd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.253522] libvirtd cpuset=/ mems_allowed=0-1
[ 6041.253526] CPU: 1 PID: 3196 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.253527] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.253527] Call Trace:
[ 6041.253530]  dump_stack+0x63/0x87
[ 6041.253532]  dump_header+0x9f/0x233
[ 6041.253533]  ? selinux_capable+0x20/0x30
[ 6041.253535]  ? security_capable_noaudit+0x45/0x60
[ 6041.253536]  oom_kill_process+0x21c/0x3f0
[ 6041.253538]  out_of_memory+0x114/0x4a0
[ 6041.253539]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.253541]  __alloc_pages_nodemask+0x240/0x260
[ 6041.253543]  alloc_pages_vma+0xa5/0x220
[ 6041.253545]  __read_swap_cache_async+0x148/0x1f0
[ 6041.253546]  read_swap_cache_async+0x26/0x60
[ 6041.253548]  swapin_readahead+0x16b/0x200
[ 6041.253550]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.253552]  ? find_get_entry+0x20/0x140
[ 6041.253554]  ? pagecache_get_page+0x2c/0x240
[ 6041.253555]  do_swap_page+0x2aa/0x780
[ 6041.253556]  __handle_mm_fault+0x6f0/0xe60
[ 6041.253559]  ? mls_context_isvalid+0x2b/0xa0
[ 6041.253560]  handle_mm_fault+0xce/0x240
[ 6041.253562]  __do_page_fault+0x22a/0x4a0
[ 6041.253563]  do_page_fault+0x30/0x80
[ 6041.253565]  page_fault+0x28/0x30
[ 6041.253567] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.253568] RSP: 0018:ffffc9000547fc28 EFLAGS: 00010287
[ 6041.253569] RAX: 00007fbe0fd9c9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.253570] RDX: ffff880827191680 RSI: ffff88041395e4c0 RDI: ffff880827191680
[ 6041.253570] RBP: ffffc9000547fc78 R08: 0000000000000101 R09: 000000018020001f
[ 6041.253571] R10: 0000000000000001 R11: ffff880827347400 R12: ffff880827191680
[ 6041.253572] R13: 00007fbe0fd9c9e0 R14: ffff880827191680 R15: ffff8808284ab280
[ 6041.253574]  ? exit_robust_list+0x37/0x120
[ 6041.253576]  mm_release+0x11a/0x130
[ 6041.253577]  do_exit+0x152/0xb80
[ 6041.253578]  ? __unqueue_futex+0x2f/0x60
[ 6041.253580]  do_group_exit+0x3f/0xb0
[ 6041.253581]  get_signal+0x1bf/0x5e0
[ 6041.253584]  do_signal+0x37/0x6a0
[ 6041.253585]  ? do_futex+0xfd/0x570
[ 6041.253588]  exit_to_usermode_loop+0x3f/0x85
[ 6041.253589]  do_syscall_64+0x165/0x180
[ 6041.253591]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.253591] RIP: 0033:0x7fbe2a8576d5
[ 6041.253592] RSP: 002b:00007fbe0fd9bcf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.253593] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.253594] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7d47ec
[ 6041.253594] RBP: 000055c46b7d4848 R08: 000055c46b7d4700 R09: 0000000000000000
[ 6041.253595] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7d4860
[ 6041.253596] R13: 000055c46b7d47c0 R14: 000055c46b7d47e8 R15: 000055c46b7d4780
[ 6041.253597] Mem-Info:
[ 6041.253602] active_anon:2 inactive_anon:27 isolated_anon:0
[ 6041.253602]  active_file:316 inactive_file:171 isolated_file:0
[ 6041.253602]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.253602]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.253602]  mapped:359 shmem:0 pagetables:1364 bounce:0
[ 6041.253602]  free:39185 free_pcp:4773 free_cma:0
[ 6041.253608] Node 0 active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:20kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.253614] Node 1 active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1416kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:2213 all_unreclaimable? yes
[ 6041.253615] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.253618] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.253621] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.253624] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.253626] Node 0 Normal free:35844kB min:36664kB low:50028kB high:63392kB active_anon:0kB inactive_anon:24kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2772kB bounce:0kB free_pcp:7976kB local_pcp:0kB free_cma:0kB
[ 6041.253629] lowmem_reserve[]: 0 0 0 0 0
[ 6041.253631] Node 1 Normal free:44720kB min:45292kB low:61800kB high:78308kB active_anon:20kB inactive_anon:84kB active_file:1260kB inactive_file:680kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2684kB bounce:0kB free_pcp:9192kB local_pcp:0kB free_cma:0kB
[ 6041.253634] lowmem_reserve[]: 0 0 0 0 0
[ 6041.253636] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.253643] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.253651] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.253658] Node 1 Normal: 555*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45292kB
[ 6041.253665] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.253666] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.253667] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.253667] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.253668] 367 total pagecache pages
[ 6041.253669] 23 pages in swap cache
[ 6041.253670] Swap cache stats: add 40398, delete 40371, find 7042/12959
[ 6041.253670] Free swap  = 16474204kB
[ 6041.253670] Total swap = 16516092kB
[ 6041.253671] 8379718 pages RAM
[ 6041.253672] 0 pages HighMem/MovableOnly
[ 6041.253672] 153941 pages reserved
[ 6041.253672] 0 pages cma reserved
[ 6041.253672] 0 pages hwpoisoned
[ 6041.253673] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.253686] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.253688] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.253689] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.253692] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.253694] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.253696] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.253697] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.253698] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.253699] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.253701] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.253702] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.253703] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.253705] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.253706] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.253707] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.253709] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.253710] [ 1296]     0  1296   637906        0      85       6      601             0 opensm
[ 6041.253712] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.253713] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.253714] [ 1977]     0  1977    55479        0      40       4      785             0 rsyslogd
[ 6041.253716] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.253717] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.253718] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.253719] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.253721] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.253722] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.253723] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.253726] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.253727] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.253728] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.253730] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.253731] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.253733] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.253735] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.253900] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.253902] [ 6417]     0  6417    28814        3      11       3       61             0 ksmtuned
[ 6041.253903] [ 6418]     0  6418    37150        4      28       3       85             0 pgrep
[ 6041.253904] Out of memory: Kill process 1977 (rsyslogd) score 0 or sacrifice child
[ 6041.253914] Killed process 1977 (rsyslogd) total-vm:221916kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.283216] oom_reaper: reaped process 1977 (rsyslogd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.283411] kworker/u130:2 invoked oom-killer: gfp_mask=0x17002c2(GFP_KERNEL_ACCOUNT|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_NOTRACK), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.283413] kworker/u130:2 cpuset=/ mems_allowed=0-1
[ 6041.283416] CPU: 15 PID: 1115 Comm: kworker/u130:2 Not tainted 4.11.0-rc2 #6
[ 6041.283417] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.283420] Workqueue: events_unbound call_usermodehelper_exec_work
[ 6041.283421] Call Trace:
[ 6041.283424]  dump_stack+0x63/0x87
[ 6041.283425]  dump_header+0x9f/0x233
[ 6041.283427]  ? selinux_capable+0x20/0x30
[ 6041.283428]  ? security_capable_noaudit+0x45/0x60
[ 6041.283429]  oom_kill_process+0x21c/0x3f0
[ 6041.283431]  out_of_memory+0x114/0x4a0
[ 6041.283432]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.283434]  __alloc_pages_nodemask+0x240/0x260
[ 6041.283436]  alloc_pages_current+0x88/0x120
[ 6041.283437]  __vmalloc_node_range+0x1bb/0x2a0
[ 6041.283438]  ? _do_fork+0xed/0x390
[ 6041.283440]  ? kmem_cache_alloc_node+0x1c4/0x1f0
[ 6041.283441]  copy_process.part.34+0x658/0x1d10
[ 6041.283442]  ? _do_fork+0xed/0x390
[ 6041.283443]  ? call_usermodehelper_exec_work+0xd0/0xd0
[ 6041.283444]  _do_fork+0xed/0x390
[ 6041.283446]  ? __switch_to+0x229/0x450
[ 6041.283447]  kernel_thread+0x29/0x30
[ 6041.283448]  call_usermodehelper_exec_work+0x3a/0xd0
[ 6041.283450]  process_one_work+0x165/0x410
[ 6041.283451]  worker_thread+0x137/0x4c0
[ 6041.283463]  kthread+0x101/0x140
[ 6041.283464]  ? rescuer_thread+0x3b0/0x3b0
[ 6041.283466]  ? kthread_park+0x90/0x90
[ 6041.283467]  ret_from_fork+0x2c/0x40
[ 6041.283468] Mem-Info:
[ 6041.283473] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.283473]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.283473]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.283473]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.283473]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.283473]  free:39030 free_pcp:4818 free_cma:0
[ 6041.283478] Node 0 active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:130 all_unreclaimable? yes
[ 6041.283483] Node 1 active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1488kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:3325 all_unreclaimable? yes
[ 6041.283484] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.283487] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.283489] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.283503] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.283504] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2780kB bounce:0kB free_pcp:7996kB local_pcp:352kB free_cma:0kB
[ 6041.283507] lowmem_reserve[]: 0 0 0 0 0
[ 6041.283509] Node 1 Normal free:44348kB min:45292kB low:61800kB high:78308kB active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2692kB bounce:0kB free_pcp:9352kB local_pcp:164kB free_cma:0kB
[ 6041.283511] lowmem_reserve[]: 0 0 0 0 0
[ 6041.283513] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.283526] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.283532] Node 0 Normal: 66*4kB (MH) 47*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35472kB
[ 6041.283538] Node 1 Normal: 524*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45168kB
[ 6041.283545] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.283545] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.283546] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.283546] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.283547] 429 total pagecache pages
[ 6041.283548] 18 pages in swap cache
[ 6041.283549] Swap cache stats: add 40409, delete 40387, find 7044/12965
[ 6041.283549] Free swap  = 16477276kB
[ 6041.283549] Total swap = 16516092kB
[ 6041.283550] 8379718 pages RAM
[ 6041.283550] 0 pages HighMem/MovableOnly
[ 6041.283551] 153941 pages reserved
[ 6041.283551] 0 pages cma reserved
[ 6041.283551] 0 pages hwpoisoned
[ 6041.283552] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.283564] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.283565] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.283567] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.283570] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.283571] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.283572] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.283573] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.283575] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.283576] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.283577] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.283587] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.283588] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.283589] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.283590] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.283591] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.283592] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.283593] [ 1296]     0  1296   637906        0      85       6      605             0 opensm
[ 6041.283595] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.283596] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.283597] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.283599] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.283600] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.283601] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.283602] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.283603] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.283615] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.283616] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.283618] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.283619] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.283620] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.283622] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.283623] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.283625] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.283626] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.283746] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.283747] [ 6417]     0  6417    28814        2      11       3       62             0 ksmtuned
[ 6041.283748] [ 6418]     0  6418    37150        0      28       3       90             0 pgrep
[ 6041.283749] Out of memory: Kill process 1296 (opensm) score 0 or sacrifice child
[ 6041.283831] Killed process 1296 (opensm) total-vm:2551624kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.303267] oom_reaper: reaped process 1296 (opensm), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.303530] runaway-killer- invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.303533] runaway-killer- cpuset=/ mems_allowed=0-1
[ 6041.303537] CPU: 1 PID: 1289 Comm: runaway-killer- Not tainted 4.11.0-rc2 #6
[ 6041.303538] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.303538] Call Trace:
[ 6041.303542]  dump_stack+0x63/0x87
[ 6041.303543]  dump_header+0x9f/0x233
[ 6041.303545]  ? selinux_capable+0x20/0x30
[ 6041.303546]  ? security_capable_noaudit+0x45/0x60
[ 6041.303548]  oom_kill_process+0x21c/0x3f0
[ 6041.303549]  out_of_memory+0x114/0x4a0
[ 6041.303551]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.303553]  __alloc_pages_nodemask+0x240/0x260
[ 6041.303555]  alloc_pages_vma+0xa5/0x220
[ 6041.303557]  __read_swap_cache_async+0x148/0x1f0
[ 6041.303559]  read_swap_cache_async+0x26/0x60
[ 6041.303560]  swapin_readahead+0x16b/0x200
[ 6041.303561]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.303563]  ? find_get_entry+0x20/0x140
[ 6041.303565]  ? pagecache_get_page+0x2c/0x240
[ 6041.303567]  do_swap_page+0x2aa/0x780
[ 6041.303568]  __handle_mm_fault+0x6f0/0xe60
[ 6041.303570]  handle_mm_fault+0xce/0x240
[ 6041.303572]  __do_page_fault+0x22a/0x4a0
[ 6041.303574]  do_page_fault+0x30/0x80
[ 6041.303576]  page_fault+0x28/0x30
[ 6041.303578] RIP: 0010:do_sys_poll+0x475/0x510
[ 6041.303578] RSP: 0018:ffffc90005a9fad0 EFLAGS: 00010246
[ 6041.303580] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6041.303581] RDX: 0000000000000000 RSI: ffffc90005a9fb30 RDI: ffffc90005a9fb3c
[ 6041.303581] RBP: ffffc90005a9fee0 R08: 0000000000000000 R09: ffff880828fda940
[ 6041.303582] R10: 0000000000000048 R11: ffff88042a64ee38 R12: 0000000000000000
[ 6041.303583] R13: ffffc90005a9fb44 R14: 00000000fffffffc R15: 00007f9640001220
[ 6041.303586]  ? select_idle_sibling+0x29/0x3d0
[ 6041.303588]  ? select_task_rq_fair+0x942/0xa70
[ 6041.303590]  ? __vma_adjust+0x4a7/0x700
[ 6041.303591]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.303593]  ? sched_clock+0x9/0x10
[ 6041.303595]  ? sched_clock_cpu+0x11/0xb0
[ 6041.303596]  ? try_to_wake_up+0x59/0x450
[ 6041.303599]  ? plist_del+0x62/0xb0
[ 6041.303600]  ? wake_up_q+0x4f/0x80
[ 6041.303602]  ? eventfd_ctx_read+0x67/0x210
[ 6041.303604]  ? futex_wake+0x90/0x180
[ 6041.303605]  ? wake_up_q+0x80/0x80
[ 6041.303607]  ? eventfd_read+0x4c/0x90
[ 6041.303608]  ? __vfs_read+0x37/0x150
[ 6041.303610]  ? security_file_permission+0x9d/0xc0
[ 6041.303611]  ? __audit_syscall_entry+0xaf/0x100
[ 6041.303613]  SyS_poll+0x74/0x100
[ 6041.303615]  do_syscall_64+0x67/0x180
[ 6041.303616]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.303618] RIP: 0033:0x7f9656e64dfd
[ 6041.303618] RSP: 002b:00007f96511fed10 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 6041.303619] RAX: ffffffffffffffda RBX: 00007f96400008c0 RCX: 00007f9656e64dfd
[ 6041.303620] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f9640001220
[ 6041.303621] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[ 6041.303621] R10: 0000000000000001 R11: 0000000000000293 R12: 00007f9640001220
[ 6041.303622] R13: 00000000ffffffff R14: 00007f9657bbc8b0 R15: 0000000000000001
[ 6041.303623] Mem-Info:
[ 6041.303630] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.303630]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.303630]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.303630]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.303630]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.303630]  free:39030 free_pcp:4795 free_cma:0
[ 6041.303636] Node 0 active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4 all_unreclaimable? yes
[ 6041.303643] Node 1 active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1488kB dirty:0kB writeback:4kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4171 all_unreclaimable? yes
[ 6041.303644] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.303649] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.303651] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:0kB free_cma:0kB
[ 6041.303655] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.303657] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:4kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19256kB pagetables:2780kB bounce:0kB free_pcp:7888kB local_pcp:24kB free_cma:0kB
[ 6041.303660] lowmem_reserve[]: 0 0 0 0 0
[ 6041.303663] Node 1 Normal free:44348kB min:45292kB low:61800kB high:78308kB active_anon:36kB inactive_anon:76kB active_file:1260kB inactive_file:908kB unevictable:0kB writepending:4kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29704kB slab_unreclaimable:278232kB kernel_stack:18504kB pagetables:2692kB bounce:0kB free_pcp:9368kB local_pcp:0kB free_cma:0kB
[ 6041.303666] lowmem_reserve[]: 0 0 0 0 0
[ 6041.303668] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.303675] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.303684] Node 0 Normal: 93*4kB (UMH) 49*8kB (MH) 83*16kB (UMH) 155*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35596kB
[ 6041.303692] Node 1 Normal: 524*4kB (UMEH) 220*8kB (UMH) 78*16kB (UMEH) 222*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 45168kB
[ 6041.303701] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.303702] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.303703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.303703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.303704] 429 total pagecache pages
[ 6041.303705] 12 pages in swap cache
[ 6041.303706] Swap cache stats: add 40421, delete 40405, find 7046/13000
[ 6041.303706] Free swap  = 16477948kB
[ 6041.303707] Total swap = 16516092kB
[ 6041.303708] 8379718 pages RAM
[ 6041.303708] 0 pages HighMem/MovableOnly
[ 6041.303708] 153941 pages reserved
[ 6041.303709] 0 pages cma reserved
[ 6041.303709] 0 pages hwpoisoned
[ 6041.303709] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.303723] [  779]     0   779     9206        1      21       3       82             0 systemd-journal
[ 6041.303725] [  805]     0   805    30349        0      28       4      375             0 lvmetad
[ 6041.303727] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.303730] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.303731] [ 1118]     0  1118    53133        0      57       3      410             0 abrtd
[ 6041.303733] [ 1121]    81  1121     8714        1      18       3      128          -900 dbus-daemon
[ 6041.303734] [ 1123]   997  1123     5672        1      17       3       60             0 chronyd
[ 6041.303735] [ 1146]     0  1146    52551        1      55       4      336             0 abrt-watch-log
[ 6041.303737] [ 1152]     0  1152     4889        1      14       3      147             0 irqbalance
[ 6041.303738] [ 1155]   994  1155     2133        0      10       3       43             0 lsmd
[ 6041.303740] [ 1156]     0  1156    31969        1      21       4      134             0 smartd
[ 6041.303741] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.303743] [ 1163]     0  1163     6050        1      16       3       78             0 systemd-logind
[ 6041.303744] [ 1178]     0  1178    28814        0      11       3       66             0 ksmtuned
[ 6041.303746] [ 1220]     0  1220    50305        0      39       3      125             0 gssproxy
[ 6041.303747] [ 1295]     0  1295    28813        0      11       3       53             0 opensm-launch
[ 6041.303749] [ 1323]     0  1296   637906        0      85       6       26             0 opensm
[ 6041.303751] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.303752] [ 1976]     0  1976    28337        1      13       4       39             0 rhsmcertd
[ 6041.303753] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.303755] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.303757] [ 1991]     0  1991     6463        0      19       3       51             0 atd
[ 6041.303758] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.303759] [ 2537]     0  2537    27511        1      12       3       32             0 agetty
[ 6041.303761] [ 2540]     0  2540    27511        1      10       3       33             0 agetty
[ 6041.303762] [ 3062]     0  3062    22767        1      46       3      258             0 master
[ 6041.303764] [ 3086]    89  3086    22810        1      46       3      255             0 qmgr
[ 6041.303766] [ 3339]    99  3339     3888        0      12       3       59             0 dnsmasq
[ 6041.303768] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 6041.303769] [ 3373]     0  3373    31557        1      20       3      159             0 crond
[ 6041.303771] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.303773] [ 3381]     0  3381    26973        1       7       3       24             0 rhnsd
[ 6041.303775] [ 4181]     0  4181    35220        1      72       3      317             0 sshd
[ 6041.303776] [ 4185]     0  4185    29148        1      16       3      385             0 bash
[ 6041.303940] [ 6416]     0  6416    28814        0      11       3       64             0 ksmtuned
[ 6041.303941] [ 6417]     0  6417    28814        0      11       3       64             0 ksmtuned
[ 6041.303943] [ 6418]     0  6418    37150        0      28       3       91             0 pgrep
[ 6041.303956] Out of memory: Kill process 1118 (abrtd) score 0 or sacrifice child
[ 6041.303963] Killed process 1118 (abrtd) total-vm:212532kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.304370] Out of memory: Kill process 1146 (abrt-watch-log) score 0 or sacrifice child
[ 6041.304377] Killed process 1146 (abrt-watch-log) total-vm:210204kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.323549] Out of memory: Kill process 805 (lvmetad) score 0 or sacrifice child
[ 6041.323555] Killed process 805 (lvmetad) total-vm:121396kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.353395] Out of memory: Kill process 4185 (bash) score 0 or sacrifice child
[ 6041.353400] Killed process 4185 (bash) total-vm:116592kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.354059] Out of memory: Kill process 4181 (sshd) score 0 or sacrifice child
[ 6041.354061] Killed process 4181 (sshd) total-vm:140880kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.354445] oom_reaper: reaped process 4181 (sshd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.354694] Out of memory: Kill process 3062 (master) score 0 or sacrifice child
[ 6041.354699] Killed process 3086 (qmgr) total-vm:91240kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.355354] Out of memory: Kill process 3062 (master) score 0 or sacrifice child
[ 6041.355356] Killed process 3062 (master) total-vm:91068kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.355700] oom_reaper: reaped process 3062 (master), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.356005] Out of memory: Kill process 3373 (crond) score 0 or sacrifice child
[ 6041.356008] Killed process 3373 (crond) total-vm:126228kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.356652] Out of memory: Kill process 1220 (gssproxy) score 0 or sacrifice child
[ 6041.356676] Killed process 1220 (gssproxy) total-vm:201220kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.356960] oom_reaper: reaped process 1220 (gssproxy), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.357203] Out of memory: Kill process 1152 (irqbalance) score 0 or sacrifice child
[ 6041.357210] Killed process 1152 (irqbalance) total-vm:19556kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.372960] sshd: 
[ 6041.372962] master: 
[ 6041.372963] page allocation failure: order:0
[ 6041.372964] page allocation failure: order:0
[ 6041.372966] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.372967] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.372968] (null)
[ 6041.372968] (null)
[ 6041.372968] sshd cpuset=
[ 6041.372969] master cpuset=
[ 6041.372969] / mems_allowed=0-1
[ 6041.372971] / mems_allowed=0-1
[ 6041.372973] CPU: 28 PID: 4181 Comm: sshd Not tainted 4.11.0-rc2 #6
[ 6041.372974] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.372974] Call Trace:
[ 6041.372978]  dump_stack+0x63/0x87
[ 6041.372980]  warn_alloc+0x114/0x1c0
[ 6041.372982]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.372984]  __alloc_pages_nodemask+0x240/0x260
[ 6041.372985]  alloc_pages_vma+0xa5/0x220
[ 6041.372987]  __read_swap_cache_async+0x148/0x1f0
[ 6041.372989]  read_swap_cache_async+0x26/0x60
[ 6041.372990]  swapin_readahead+0x16b/0x200
[ 6041.372991]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.372993]  ? find_get_entry+0x20/0x140
[ 6041.372995]  ? pagecache_get_page+0x2c/0x240
[ 6041.372996]  do_swap_page+0x2aa/0x780
[ 6041.372997]  __handle_mm_fault+0x6f0/0xe60
[ 6041.372999]  handle_mm_fault+0xce/0x240
[ 6041.373001]  __do_page_fault+0x22a/0x4a0
[ 6041.373002]  do_page_fault+0x30/0x80
[ 6041.373004]  page_fault+0x28/0x30
[ 6041.373006] RIP: 0010:copy_user_generic_string+0x2c/0x40
[ 6041.373006] RSP: 0018:ffffc900083a7d20 EFLAGS: 00010246
[ 6041.373007] RAX: 0000000000000008 RBX: 0000555561846560 RCX: 0000000000000001
[ 6041.373008] RDX: 0000000000000000 RSI: ffffc900083a7da0 RDI: 0000555561846560
[ 6041.373009] RBP: ffffc900083a7d28 R08: ffffc900083a7b98 R09: ffff88042ac29400
[ 6041.373009] R10: 0000000000000010 R11: 0000000000000114 R12: ffffc900083a7d88
[ 6041.373010] R13: 0000000000000001 R14: 000000000000000d R15: ffffc900083a7d88
[ 6041.373012]  ? set_fd_set+0x21/0x30
[ 6041.373014]  core_sys_select+0x1f3/0x2f0
[ 6041.373016]  SyS_select+0xba/0x110
[ 6041.373018]  do_syscall_64+0x67/0x180
[ 6041.373019]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.373020] RIP: 0033:0x7effdb4e2b83
[ 6041.373021] RSP: 002b:00007ffd3a4d8698 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[ 6041.373022] RAX: ffffffffffffffda RBX: 00007ffd3a4d8738 RCX: 00007effdb4e2b83
[ 6041.373022] RDX: 00005555618474c0 RSI: 0000555561846560 RDI: 000000000000000d
[ 6041.373023] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 6041.373023] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd3a4d8740
[ 6041.373024] R13: 00007ffd3a4d8730 R14: 00007ffd3a4d8734 R15: 0000555561846560
[ 6041.373026] CPU: 15 PID: 3062 Comm: master Not tainted 4.11.0-rc2 #6
[ 6041.373027] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.373027] Call Trace:
[ 6041.373031]  dump_stack+0x63/0x87
[ 6041.373032]  warn_alloc+0x114/0x1c0
[ 6041.373034]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.373036]  __alloc_pages_nodemask+0x240/0x260
[ 6041.373038]  alloc_pages_vma+0xa5/0x220
[ 6041.373040]  __read_swap_cache_async+0x148/0x1f0
[ 6041.373041]  ? update_sd_lb_stats+0x180/0x620
[ 6041.373043]  read_swap_cache_async+0x26/0x60
[ 6041.373044]  swapin_readahead+0x16b/0x200
[ 6041.373045]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.373047]  ? find_get_entry+0x20/0x140
[ 6041.373049]  ? pagecache_get_page+0x2c/0x240
[ 6041.373050]  do_swap_page+0x2aa/0x780
[ 6041.373051]  __handle_mm_fault+0x6f0/0xe60
[ 6041.373053]  handle_mm_fault+0xce/0x240
[ 6041.373055]  __do_page_fault+0x22a/0x4a0
[ 6041.373056]  do_page_fault+0x30/0x80
[ 6041.373058]  page_fault+0x28/0x30
[ 6041.373060] RIP: 0010:__clear_user+0x25/0x50
[ 6041.373060] RSP: 0018:ffffc90006b2bda0 EFLAGS: 00010202
[ 6041.373061] RAX: 0000000000000000 RBX: 00007fff9c6e4680 RCX: 0000000000000008
[ 6041.373062] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007fff9c6e4880
[ 6041.373063] RBP: ffffc90006b2bda0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.373063] R10: 0000000028c6b701 R11: 00007fff9c6e4680 R12: 00007fff9c6e4680
[ 6041.373064] R13: ffff88082a408000 R14: 0000000000000000 R15: 0000000000000000
[ 6041.373067]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.373069]  do_signal+0x516/0x6a0
[ 6041.373071]  exit_to_usermode_loop+0x3f/0x85
[ 6041.373073]  do_syscall_64+0x165/0x180
[ 6041.373074]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.373075] RIP: 0033:0x7fe4e2dfdcf3
[ 6041.373075] RSP: 002b:00007fff9c6e4a48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.373076] RAX: fffffffffffffffc RBX: 00007fff9c6e4a50 RCX: 00007fe4e2dfdcf3
[ 6041.373077] RDX: 0000000000000064 RSI: 00007fff9c6e4a50 RDI: 000000000000000f
[ 6041.373078] RBP: 0000000000000038 R08: 0000000000000000 R09: 0000000000000000
[ 6041.373078] R10: 000000000000dac0 R11: 0000000000000246 R12: 000055ae43cd36e4
[ 6041.373079] R13: 000055ae43cd3660 R14: 000055ae43cd49c8 R15: 000055ae4480db50
[ 6041.373415] Out of memory: Kill process 1156 (smartd) score 0 or sacrifice child
[ 6041.373425] Killed process 1156 (smartd) total-vm:127876kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.393400] Out of memory: Kill process 6418 (pgrep) score 0 or sacrifice child
[ 6041.393403] Killed process 6418 (pgrep) total-vm:148600kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.393741] oom_reaper: reaped process 6418 (pgrep), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.394087] Out of memory: Kill process 779 (systemd-journal) score 0 or sacrifice child
[ 6041.394090] Killed process 779 (systemd-journal) total-vm:36824kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.394354] oom_reaper: reaped process 779 (systemd-journal), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.394719] Out of memory: Kill process 1163 (systemd-logind) score 0 or sacrifice child
[ 6041.394722] Killed process 1163 (systemd-logind) total-vm:24200kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.394984] oom_reaper: reaped process 1163 (systemd-logind), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.395357] Out of memory: Kill process 1123 (chronyd) score 0 or sacrifice child
[ 6041.395362] Killed process 1123 (chronyd) total-vm:22688kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.396025] Out of memory: Kill process 1178 (ksmtuned) score 0 or sacrifice child
[ 6041.396028] Killed process 6416 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.396604] Out of memory: Kill process 1178 (ksmtuned) score 0 or sacrifice child
[ 6041.396607] Killed process 1178 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.396744] ksmtuned: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.396746] ksmtuned cpuset=/ mems_allowed=0-1
[ 6041.396748] CPU: 31 PID: 1178 Comm: ksmtuned Not tainted 4.11.0-rc2 #6
[ 6041.396749] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.396749] Call Trace:
[ 6041.396753]  dump_stack+0x63/0x87
[ 6041.396754]  warn_alloc+0x114/0x1c0
[ 6041.396755]  ? out_of_memory+0x11e/0x4a0
[ 6041.396757]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.396759]  __alloc_pages_nodemask+0x240/0x260
[ 6041.396760]  alloc_pages_vma+0xa5/0x220
[ 6041.396762]  __read_swap_cache_async+0x148/0x1f0
[ 6041.396763]  read_swap_cache_async+0x26/0x60
[ 6041.396764]  swapin_readahead+0x16b/0x200
[ 6041.396765]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.396767]  ? find_get_entry+0x20/0x140
[ 6041.396768]  ? pagecache_get_page+0x2c/0x240
[ 6041.396770]  do_swap_page+0x2aa/0x780
[ 6041.396771]  __handle_mm_fault+0x6f0/0xe60
[ 6041.396772]  handle_mm_fault+0xce/0x240
[ 6041.396774]  __do_page_fault+0x22a/0x4a0
[ 6041.396775]  do_page_fault+0x30/0x80
[ 6041.396777]  page_fault+0x28/0x30
[ 6041.396778] RIP: 0010:__clear_user+0x25/0x50
[ 6041.396779] RSP: 0018:ffffc90005d3fda0 EFLAGS: 00010202
[ 6041.396780] RAX: 0000000000000000 RBX: 00007fff89b0f000 RCX: 0000000000000008
[ 6041.396780] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007fff89b0f200
[ 6041.396781] RBP: ffffc90005d3fda0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.396781] R10: 0000000028d8bc01 R11: 00007fff89b0f000 R12: 00007fff89b0f000
[ 6041.396782] R13: ffff880826b14380 R14: 0000000000000000 R15: 0000000000000000
[ 6041.396785]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.396786]  do_signal+0x516/0x6a0
[ 6041.396788]  exit_to_usermode_loop+0x3f/0x85
[ 6041.396789]  do_syscall_64+0x165/0x180
[ 6041.396791]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.396791] RIP: 0033:0x7fe23a73bc00
[ 6041.396792] RSP: 002b:00007fff89b0f3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 6041.396793] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 00007fe23a73bc00
[ 6041.396793] RDX: 0000000000000080 RSI: 00007fff89b0f470 RDI: 0000000000000003
[ 6041.396794] RBP: 0000000000000080 R08: 00007fff89b0f380 R09: 00007fff89b0f230
[ 6041.396794] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff89b0f470
[ 6041.396795] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000001
[ 6041.396798] oom_reaper: reaped process 1178 (ksmtuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.402965] systemd-journal: page allocation failure: order:0
[ 6041.402968] pgrep: 
[ 6041.402969] , mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=
[ 6041.402971] page allocation failure: order:0
[ 6041.402971] (null)
[ 6041.402973] , mode:0x16040d0(GFP_TEMPORARY|__GFP_COMP|__GFP_NOTRACK), nodemask=
[ 6041.402973] systemd-journal cpuset=
[ 6041.402974] (null)
[ 6041.402974] /
[ 6041.402975] pgrep cpuset=
[ 6041.402976]  mems_allowed=0-1
[ 6041.402977] /
[ 6041.402979] CPU: 10 PID: 779 Comm: systemd-journal Not tainted 4.11.0-rc2 #6
[ 6041.402980]  mems_allowed=0-1
[ 6041.402980] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.402981] Call Trace:
[ 6041.402985]  dump_stack+0x63/0x87
[ 6041.402987]  warn_alloc+0x114/0x1c0
[ 6041.402989]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.402992]  __alloc_pages_nodemask+0x240/0x260
[ 6041.402994]  alloc_pages_vma+0xa5/0x220
[ 6041.402997]  __read_swap_cache_async+0x148/0x1f0
[ 6041.402998]  ? select_task_rq_fair+0x942/0xa70
[ 6041.403000]  read_swap_cache_async+0x26/0x60
[ 6041.403002]  swapin_readahead+0x16b/0x200
[ 6041.403004]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.403006]  ? find_get_entry+0x20/0x140
[ 6041.403008]  ? pagecache_get_page+0x2c/0x240
[ 6041.403009]  do_swap_page+0x2aa/0x780
[ 6041.403011]  __handle_mm_fault+0x6f0/0xe60
[ 6041.403013]  handle_mm_fault+0xce/0x240
[ 6041.403015]  __do_page_fault+0x22a/0x4a0
[ 6041.403018]  do_page_fault+0x30/0x80
[ 6041.403019]  ? dequeue_entity+0xed/0x420
[ 6041.403021]  page_fault+0x28/0x30
[ 6041.403023] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.403024] RSP: 0018:ffffc90005093d88 EFLAGS: 00010246
[ 6041.403026] RAX: 0000000000000011 RBX: ffffc90005093e08 RCX: 00007ffddc3838d0
[ 6041.403027] RDX: 0000000000000000 RSI: ffff88082f2f8f80 RDI: ffff880827246700
[ 6041.403028] RBP: ffffc90005093de0 R08: ffff880829d62718 R09: cccccccccccccccd
[ 6041.403029] R10: 0000057e5ecdb8d3 R11: 0000000000000008 R12: 0000000000000000
[ 6041.403030] R13: ffffc90005093ea0 R14: ffff8804297dab40 R15: ffff880829d62718
[ 6041.403032]  ? ep_send_events_proc+0x93/0x1e0
[ 6041.403034]  ? ep_poll+0x3c0/0x3c0
[ 6041.403036]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.403038]  ep_poll+0x195/0x3c0
[ 6041.403040]  ? wake_up_q+0x80/0x80
[ 6041.403042]  SyS_epoll_wait+0xbc/0xe0
[ 6041.403044]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 6041.403046] RIP: 0033:0x7ff643546cf3
[ 6041.403046] RSP: 002b:00007ffddc3838c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.403048] RAX: ffffffffffffffda RBX: 000000000000001b RCX: 00007ff643546cf3
[ 6041.403049] RDX: 000000000000001b RSI: 00007ffddc3838d0 RDI: 0000000000000007
[ 6041.403050] RBP: 00007ff64492a6a0 R08: 000000000007923c R09: 0000000000000001
[ 6041.403051] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
[ 6041.403052] R13: 000000000000001b R14: 00007ffddc384f7d R15: 00005592ded50190
[ 6041.403056] CPU: 25 PID: 6418 Comm: pgrep Not tainted 4.11.0-rc2 #6
[ 6041.403056] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.403057] Call Trace:
[ 6041.403061]  dump_stack+0x63/0x87
[ 6041.403063]  warn_alloc+0x114/0x1c0
[ 6041.403066]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.403068]  __alloc_pages_nodemask+0x240/0x260
[ 6041.403070]  alloc_pages_current+0x88/0x120
[ 6041.403072]  new_slab+0x41f/0x5b0
[ 6041.403074]  ___slab_alloc+0x33e/0x4b0
[ 6041.403076]  ? __d_alloc+0x25/0x1d0
[ 6041.403078]  ? __d_alloc+0x25/0x1d0
[ 6041.403079]  __slab_alloc+0x40/0x5c
[ 6041.403081]  kmem_cache_alloc+0x16d/0x1a0
[ 6041.403082]  ? __d_alloc+0x25/0x1d0
[ 6041.403084]  __d_alloc+0x25/0x1d0
[ 6041.403086]  d_alloc+0x22/0xc0
[ 6041.403088]  d_alloc_parallel+0x6c/0x500
[ 6041.403091]  ? __inode_permission+0x48/0xd0
[ 6041.403093]  ? lookup_fast+0x215/0x3d0
[ 6041.403095]  path_openat+0xc91/0x13c0
[ 6041.403097]  do_filp_open+0x91/0x100
[ 6041.403099]  ? __alloc_fd+0x46/0x170
[ 6041.403101]  do_sys_open+0x124/0x210
[ 6041.403102]  ? __audit_syscall_exit+0x209/0x290
[ 6041.403104]  SyS_open+0x1e/0x20
[ 6041.403106]  do_syscall_64+0x67/0x180
[ 6041.403108]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.403110] RIP: 0033:0x7f6caba59a10
[ 6041.403111] RSP: 002b:00007ffd316e1698 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[ 6041.403112] RAX: ffffffffffffffda RBX: 00007ffd316e16b0 RCX: 00007f6caba59a10
[ 6041.403113] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd316e16b0
[ 6041.403114] RBP: 00007f6cac149ab0 R08: 00007f6cab9b9938 R09: 0000000000000010
[ 6041.403115] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000006d7100
[ 6041.403116] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000000
[ 6041.403120] SLUB: Unable to allocate memory on node -1, gfp=0x14000c0(GFP_KERNEL)
[ 6041.403121]   cache: dentry, object size: 192, buffer size: 192, default order: 1, min order: 0
[ 6041.403122]   node 0: slabs: 463, objs: 19425, free: 0
[ 6041.403123]   node 1: slabs: 884, objs: 35112, free: 0
[ 6041.403514] Out of memory: Kill process 6417 (ksmtuned) score 0 or sacrifice child
[ 6041.403517] Killed process 6417 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.412951] systemd-logind: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.412971] systemd-logind cpuset=/ mems_allowed=0-1
[ 6041.412974] CPU: 24 PID: 1163 Comm: systemd-logind Not tainted 4.11.0-rc2 #6
[ 6041.412974] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.412975] Call Trace:
[ 6041.412978]  dump_stack+0x63/0x87
[ 6041.412980]  warn_alloc+0x114/0x1c0
[ 6041.412981]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.412984]  __alloc_pages_nodemask+0x240/0x260
[ 6041.412985]  alloc_pages_vma+0xa5/0x220
[ 6041.412987]  __read_swap_cache_async+0x148/0x1f0
[ 6041.412988]  read_swap_cache_async+0x26/0x60
[ 6041.412990]  swapin_readahead+0x16b/0x200
[ 6041.412991]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.412993]  ? find_get_entry+0x20/0x140
[ 6041.412994]  ? pagecache_get_page+0x2c/0x240
[ 6041.412996]  do_swap_page+0x2aa/0x780
[ 6041.412997]  __handle_mm_fault+0x6f0/0xe60
[ 6041.412999]  handle_mm_fault+0xce/0x240
[ 6041.413000]  __do_page_fault+0x22a/0x4a0
[ 6041.413002]  do_page_fault+0x30/0x80
[ 6041.413004]  page_fault+0x28/0x30
[ 6041.413005] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 6041.413006] RSP: 0018:ffffc90005ce7d60 EFLAGS: 00010246
[ 6041.413007] RAX: 0000000000000010 RBX: ffffc90005ce7de0 RCX: 00007ffc58e36210
[ 6041.413008] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000002
[ 6041.413008] RBP: ffffc90005ce7db8 R08: ffff88042e222d18 R09: cccccccccccccccd
[ 6041.413009] R10: 0000057e6b9137a4 R11: 0000000000000018 R12: 0000000000000000
[ 6041.413009] R13: ffffc90005ce7e78 R14: ffff8804bd9f5440 R15: ffff88042e222d18
[ 6041.413012]  ? ep_poll+0x3c0/0x3c0
[ 6041.413013]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 6041.413015]  ep_poll+0x195/0x3c0
[ 6041.413016]  ? wake_up_q+0x80/0x80
[ 6041.413018]  SyS_epoll_wait+0xbc/0xe0
[ 6041.413019]  do_syscall_64+0x67/0x180
[ 6041.413021]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.413021] RIP: 0033:0x7f751d498cf3
[ 6041.413022] RSP: 002b:00007ffc58e36208 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 6041.413023] RAX: ffffffffffffffda RBX: 00007ffc58e36210 RCX: 00007f751d498cf3
[ 6041.413023] RDX: 000000000000000b RSI: 00007ffc58e36210 RDI: 0000000000000004
[ 6041.413024] RBP: 00007ffc58e36390 R08: 000000000000000e R09: 0000000000000001
[ 6041.413025] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000001
[ 6041.413025] R13: ffffffffffffffff R14: 00007ffc58e363f0 R15: 00005581334e9260
[ 6041.423461] ksmtuned: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.423465] ksmtuned cpuset=/ mems_allowed=0-1
[ 6041.423469] CPU: 12 PID: 6417 Comm: ksmtuned Not tainted 4.11.0-rc2 #6
[ 6041.423470] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.423471] Call Trace:
[ 6041.423475]  dump_stack+0x63/0x87
[ 6041.423477]  warn_alloc+0x114/0x1c0
[ 6041.423480]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.423482]  ? schedule_timeout+0x249/0x300
[ 6041.423485]  __alloc_pages_nodemask+0x240/0x260
[ 6041.423487]  alloc_pages_vma+0xa5/0x220
[ 6041.423490]  __read_swap_cache_async+0x148/0x1f0
[ 6041.423491]  read_swap_cache_async+0x26/0x60
[ 6041.423493]  swapin_readahead+0x16b/0x200
[ 6041.423494]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.423497]  ? find_get_entry+0x20/0x140
[ 6041.423499]  ? pagecache_get_page+0x2c/0x240
[ 6041.423500]  do_swap_page+0x2aa/0x780
[ 6041.423502]  __handle_mm_fault+0x6f0/0xe60
[ 6041.423504]  handle_mm_fault+0xce/0x240
[ 6041.423506]  __do_page_fault+0x22a/0x4a0
[ 6041.423508]  do_page_fault+0x30/0x80
[ 6041.423510]  page_fault+0x28/0x30
[ 6041.423512] RIP: 0010:__put_user_4+0x1c/0x30
[ 6041.423513] RSP: 0018:ffffc900082a7dc8 EFLAGS: 00010297
[ 6041.423515] RAX: 0000000000000009 RBX: 00007fffffffeffd RCX: 00007fff89b0e590
[ 6041.423516] RDX: ffff8808291bee80 RSI: 0000000000000009 RDI: ffff880828fe41c8
[ 6041.423517] RBP: ffffc900082a7e38 R08: 0000000000000000 R09: 0000000000000219
[ 6041.423518] R10: 0000000000000000 R11: 000000000003de7d R12: ffff880823278000
[ 6041.423519] R13: ffffc900082a7ea0 R14: 0000000000000010 R15: 0000000000001912
[ 6041.423522]  ? wait_consider_task+0x46c/0xb40
[ 6041.423524]  ? sched_clock_cpu+0x11/0xb0
[ 6041.423525]  do_wait+0xf4/0x240
[ 6041.423527]  SyS_wait4+0x80/0x100
[ 6041.423529]  ? task_stopped_code+0x50/0x50
[ 6041.423531]  do_syscall_64+0x67/0x180
[ 6041.423533]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.423535] RIP: 0033:0x7fe23a71127c
[ 6041.423535] RSP: 002b:00007fff89b0e568 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
[ 6041.423537] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe23a71127c
[ 6041.423538] RDX: 0000000000000000 RSI: 00007fff89b0e590 RDI: ffffffffffffffff
[ 6041.423539] RBP: 0000000000bb4d50 R08: 0000000000bb4d50 R09: 0000000000000000
[ 6041.423540] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 6041.423541] R13: 0000000000000001 R14: 0000000000bb48c0 R15: 0000000000000000
[ 6041.433391] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 6041.433397] Killed process 3340 (dnsmasq) total-vm:15524kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434032] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 6041.434034] Killed process 3339 (dnsmasq) total-vm:15552kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434300] oom_reaper: reaped process 3339 (dnsmasq), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.434658] Out of memory: Kill process 1991 (atd) score 0 or sacrifice child
[ 6041.434662] Killed process 1991 (atd) total-vm:25852kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.435291] Out of memory: Kill process 1295 (opensm-launch) score 0 or sacrifice child
[ 6041.435295] Killed process 1295 (opensm-launch) total-vm:115252kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.435912] Out of memory: Kill process 1976 (rhsmcertd) score 0 or sacrifice child
[ 6041.435917] Killed process 1976 (rhsmcertd) total-vm:113348kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.436542] Out of memory: Kill process 1155 (lsmd) score 0 or sacrifice child
[ 6041.436546] Killed process 1155 (lsmd) total-vm:8532kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.437170] Out of memory: Kill process 2537 (agetty) score 0 or sacrifice child
[ 6041.437173] Killed process 2537 (agetty) total-vm:110044kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.437782] Out of memory: Kill process 2540 (agetty) score 0 or sacrifice child
[ 6041.437785] Killed process 2540 (agetty) total-vm:110044kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.438391] Out of memory: Kill process 3381 (rhnsd) score 0 or sacrifice child
[ 6041.438395] Killed process 3381 (rhnsd) total-vm:107892kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.438950] Out of memory: Kill process 1121 (dbus-daemon) score 0 or sacrifice child
[ 6041.438957] Killed process 1121 (dbus-daemon) total-vm:34856kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 6041.452934] dnsmasq: page allocation failure: order:0, mode:0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null)
[ 6041.452938] dnsmasq cpuset=/ mems_allowed=0-1
[ 6041.452942] CPU: 31 PID: 3339 Comm: dnsmasq Not tainted 4.11.0-rc2 #6
[ 6041.452943] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.452943] Call Trace:
[ 6041.452948]  dump_stack+0x63/0x87
[ 6041.452950]  warn_alloc+0x114/0x1c0
[ 6041.452952]  __alloc_pages_slowpath+0x8de/0xb90
[ 6041.452954]  ? __switch_to+0x229/0x450
[ 6041.452957]  __alloc_pages_nodemask+0x240/0x260
[ 6041.452959]  alloc_pages_vma+0xa5/0x220
[ 6041.452961]  __read_swap_cache_async+0x148/0x1f0
[ 6041.452963]  read_swap_cache_async+0x26/0x60
[ 6041.452965]  swapin_readahead+0x16b/0x200
[ 6041.452966]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.452969]  ? find_get_entry+0x20/0x140
[ 6041.452971]  ? pagecache_get_page+0x2c/0x240
[ 6041.452973]  do_swap_page+0x2aa/0x780
[ 6041.452974]  ? poll_select_copy_remaining+0x150/0x150
[ 6041.452976]  __handle_mm_fault+0x6f0/0xe60
[ 6041.452978]  handle_mm_fault+0xce/0x240
[ 6041.452980]  __do_page_fault+0x22a/0x4a0
[ 6041.452982]  do_page_fault+0x30/0x80
[ 6041.452984]  page_fault+0x28/0x30
[ 6041.452987] RIP: 0010:__clear_user+0x25/0x50
[ 6041.452987] RSP: 0018:ffffc90005817da0 EFLAGS: 00010202
[ 6041.452989] RAX: 0000000000000000 RBX: 00007ffe6a725dc0 RCX: 0000000000000008
[ 6041.452990] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00007ffe6a725fc0
[ 6041.452991] RBP: ffffc90005817da0 R08: 0000000000000011 R09: 0000000000000000
[ 6041.452992] R10: 0000000028d1b901 R11: 00007ffe6a725dc0 R12: 00007ffe6a725dc0
[ 6041.452993] R13: ffff880829239680 R14: 0000000000000000 R15: 0000000000000000
[ 6041.452996]  copy_fpstate_to_sigframe+0x98/0x1e0
[ 6041.452998]  do_signal+0x516/0x6a0
[ 6041.453001]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453003]  do_syscall_64+0x165/0x180
[ 6041.453005]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453006] RIP: 0033:0x7f26144f2b83
[ 6041.453007] RSP: 002b:00007ffe6a7261a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[ 6041.453009] RAX: fffffffffffffffc RBX: 0000559eb9450560 RCX: 00007f26144f2b83
[ 6041.453010] RDX: 00007ffe6a7262b0 RSI: 00007ffe6a726230 RDI: 0000000000000008
[ 6041.453010] RBP: 00007ffe6a726230 R08: 0000000000000000 R09: 0000000000000000
[ 6041.453011] R10: 00007ffe6a726330 R11: 0000000000000246 R12: 00007ffe6a7261ec
[ 6041.453012] R13: 0000000000000000 R14: 0000000058c8ce9e R15: 00007ffe6a7262b0
[ 6041.453021] oom_reaper: reaped process 1121 (dbus-daemon), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 6041.453344] libvirtd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null),  order=0, oom_score_adj=0
[ 6041.453346] libvirtd cpuset=/ mems_allowed=0-1
[ 6041.453349] CPU: 16 PID: 2731 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.453349] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.453350] Call Trace:
[ 6041.453353]  dump_stack+0x63/0x87
[ 6041.453355]  dump_header+0x9f/0x233
[ 6041.453356]  ? oom_unkillable_task+0x9e/0xc0
[ 6041.453357]  ? find_lock_task_mm+0x3b/0x80
[ 6041.453359]  ? cpuset_mems_allowed_intersects+0x21/0x30
[ 6041.453360]  ? oom_unkillable_task+0x9e/0xc0
[ 6041.453361]  out_of_memory+0x39f/0x4a0
[ 6041.453362]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.453364]  __alloc_pages_nodemask+0x240/0x260
[ 6041.453366]  alloc_pages_vma+0xa5/0x220
[ 6041.453368]  __read_swap_cache_async+0x148/0x1f0
[ 6041.453369]  read_swap_cache_async+0x26/0x60
[ 6041.453370]  swapin_readahead+0x16b/0x200
[ 6041.453372]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.453373]  ? find_get_entry+0x20/0x140
[ 6041.453375]  ? pagecache_get_page+0x2c/0x240
[ 6041.453376]  do_swap_page+0x2aa/0x780
[ 6041.453377]  __handle_mm_fault+0x6f0/0xe60
[ 6041.453379]  handle_mm_fault+0xce/0x240
[ 6041.453381]  __do_page_fault+0x22a/0x4a0
[ 6041.453382]  do_page_fault+0x30/0x80
[ 6041.453384]  page_fault+0x28/0x30
[ 6041.453386] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.453386] RSP: 0018:ffffc900069dbc28 EFLAGS: 00010287
[ 6041.453388] RAX: 00007fbe1cfef9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.453388] RDX: ffff8804285fc380 RSI: ffff88041395e4c0 RDI: ffff8804285fc380
[ 6041.453389] RBP: ffffc900069dbc78 R08: ffff88042f79b940 R09: 0000000000000000
[ 6041.453389] R10: 0000000001afcc01 R11: ffff880401afec00 R12: ffff8804285fc380
[ 6041.453390] R13: 00007fbe1cfef9e0 R14: ffff8804285fc380 R15: ffff8808284ab280
[ 6041.453392]  ? exit_robust_list+0x37/0x120
[ 6041.453394]  mm_release+0x11a/0x130
[ 6041.453395]  do_exit+0x152/0xb80
[ 6041.453396]  ? __unqueue_futex+0x2f/0x60
[ 6041.453397]  do_group_exit+0x3f/0xb0
[ 6041.453399]  get_signal+0x1bf/0x5e0
[ 6041.453401]  do_signal+0x37/0x6a0
[ 6041.453402]  ? do_futex+0xfd/0x570
[ 6041.453404]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453405]  do_syscall_64+0x165/0x180
[ 6041.453407]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453408] RIP: 0033:0x7fbe2a8576d5
[ 6041.453408] RSP: 002b:00007fbe1cfeecf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.453409] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.453410] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7be5ac
[ 6041.453411] RBP: 000055c46b7be608 R08: 000055c46b7be500 R09: 0000000000000000
[ 6041.453411] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7be620
[ 6041.453412] R13: 000055c46b7be580 R14: 000055c46b7be5a8 R15: 000055c46b7be540
[ 6041.453413] Mem-Info:
[ 6041.453418] active_anon:10 inactive_anon:28 isolated_anon:0
[ 6041.453418]  active_file:316 inactive_file:228 isolated_file:0
[ 6041.453418]  unevictable:0 dirty:0 writeback:1 unstable:0
[ 6041.453418]  slab_reclaimable:11421 slab_unreclaimable:140377
[ 6041.453418]  mapped:378 shmem:0 pagetables:1368 bounce:0
[ 6041.453418]  free:39224 free_pcp:5492 free_cma:0
[ 6041.453423] Node 0 active_anon:8kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:24kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:4 all_unreclaimable? yes
[ 6041.453428] Node 1 active_anon:48kB inactive_anon:76kB active_file:1260kB inactive_file:996kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1552kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? yes
[ 6041.453428] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6041.453431] lowmem_reserve[]: 0 2886 15937 15937 15937
[ 6041.453433] Node 0 DMA32 free:60296kB min:8108kB low:11060kB high:14012kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013336kB mlocked:0kB slab_reclaimable:96kB slab_unreclaimable:38768kB kernel_stack:2320kB pagetables:0kB bounce:0kB free_pcp:1924kB local_pcp:184kB free_cma:0kB
[ 6041.453436] lowmem_reserve[]: 0 0 13051 13051 13051
[ 6041.453451] Node 0 Normal free:35596kB min:36664kB low:50028kB high:63392kB active_anon:8kB inactive_anon:36kB active_file:4kB inactive_file:4kB unevictable:0kB writepending:0kB present:13631488kB managed:13364292kB mlocked:0kB slab_reclaimable:15884kB slab_unreclaimable:244492kB kernel_stack:19240kB pagetables:2780kB bounce:0kB free_pcp:9820kB local_pcp:680kB free_cma:0kB
[ 6041.453454] lowmem_reserve[]: 0 0 0 0 0
[ 6041.453456] Node 1 Normal free:44968kB min:45292kB low:61800kB high:78308kB active_anon:48kB inactive_anon:76kB active_file:1260kB inactive_file:996kB unevictable:0kB writepending:0kB present:16777212kB managed:16509584kB mlocked:0kB slab_reclaimable:29740kB slab_unreclaimable:278232kB kernel_stack:18488kB pagetables:2512kB bounce:0kB free_pcp:10224kB local_pcp:688kB free_cma:0kB
[ 6041.453458] lowmem_reserve[]: 0 0 0 0 0
[ 6041.453460] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 6041.453472] Node 0 DMA32: 2*4kB (UM) 2*8kB (U) 13*16kB (U) 7*32kB (UE) 5*64kB (U) 3*128kB (UME) 1*256kB (E) 5*512kB (ME) 5*1024kB (UME) 1*2048kB (E) 12*4096kB (M) = 60296kB
[ 6041.453478] Node 0 Normal: 29*4kB (UMH) 57*8kB (UMH) 64*16kB (UMH) 156*32kB (UMEH) 90*64kB (UME) 56*128kB (UMEH) 31*256kB (MEH) 15*512kB (MH) 0*1024kB 0*2048kB 0*4096kB = 35132kB
[ 6041.453484] Node 1 Normal: 628*4kB (UMEH) 266*8kB (UMEH) 91*16kB (UMEH) 223*32kB (UME) 147*64kB (UM) 102*128kB (UM) 37*256kB (UM) 2*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 46192kB
[ 6041.453491] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.453491] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.453492] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 6041.453493] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 6041.453493] 451 total pagecache pages
[ 6041.453495] 0 pages in swap cache
[ 6041.453495] Swap cache stats: add 40461, delete 40457, find 7065/13053
[ 6041.453496] Free swap  = 16492028kB
[ 6041.453496] Total swap = 16516092kB
[ 6041.453497] 8379718 pages RAM
[ 6041.453497] 0 pages HighMem/MovableOnly
[ 6041.453497] 153941 pages reserved
[ 6041.453498] 0 pages cma reserved
[ 6041.453498] 0 pages hwpoisoned
[ 6041.453498] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 6041.453522] [  824]     0   824    11810        1      23       3      664         -1000 systemd-udevd
[ 6041.453533] [ 1073]     0  1073    13856        0      28       3      110         -1000 auditd
[ 6041.453535] [ 1144]    81  1121     8714        0      18       3        0          -900 dbus-daemon
[ 6041.453536] [ 1276]   998  1161   132401        0      57       4        0             0 gmain
[ 6041.453538] [ 1269]     0  1220    50305        0      39       3        0             0 gssproxy
[ 6041.453539] [ 1323]     0  1296   637906        0      85       6       26             0 opensm
[ 6041.453541] [ 3080]     0  1968   138299        0      91       4       20             0 gmain
[ 6041.453542] [ 2109]     0  1977    55479        0      40       4        0             0 in:imjournal
[ 6041.453543] [ 2729]     0  1987   154722        0     148       3        0             0 libvirtd
[ 6041.453544] [ 2047]     0  2047    20619        0      44       3      214         -1000 sshd
[ 6041.453548] [ 3401]     0  3376    90269        0      96       3        0             0 beah-beaker-bac
[ 6041.453695] Kernel panic - not syncing: Out of memory and no killable processes...
[ 6041.453695] 
[ 6041.453697] CPU: 16 PID: 2731 Comm: libvirtd Not tainted 4.11.0-rc2 #6
[ 6041.453697] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 6041.453697] Call Trace:
[ 6041.453699]  dump_stack+0x63/0x87
[ 6041.453700]  panic+0xeb/0x239
[ 6041.453702]  out_of_memory+0x3ad/0x4a0
[ 6041.453703]  __alloc_pages_slowpath+0x7f0/0xb90
[ 6041.453705]  __alloc_pages_nodemask+0x240/0x260
[ 6041.453706]  alloc_pages_vma+0xa5/0x220
[ 6041.453707]  __read_swap_cache_async+0x148/0x1f0
[ 6041.453709]  read_swap_cache_async+0x26/0x60
[ 6041.453710]  swapin_readahead+0x16b/0x200
[ 6041.453711]  ? radix_tree_lookup_slot+0x22/0x50
[ 6041.453712]  ? find_get_entry+0x20/0x140
[ 6041.453713]  ? pagecache_get_page+0x2c/0x240
[ 6041.453714]  do_swap_page+0x2aa/0x780
[ 6041.453716]  __handle_mm_fault+0x6f0/0xe60
[ 6041.453717]  handle_mm_fault+0xce/0x240
[ 6041.453718]  __do_page_fault+0x22a/0x4a0
[ 6041.453720]  do_page_fault+0x30/0x80
[ 6041.453721]  page_fault+0x28/0x30
[ 6041.453722] RIP: 0010:__get_user_8+0x1b/0x25
[ 6041.453723] RSP: 0018:ffffc900069dbc28 EFLAGS: 00010287
[ 6041.453724] RAX: 00007fbe1cfef9e7 RBX: ffff88041395e4c0 RCX: 00000000000002b0
[ 6041.453724] RDX: ffff8804285fc380 RSI: ffff88041395e4c0 RDI: ffff8804285fc380
[ 6041.453725] RBP: ffffc900069dbc78 R08: ffff88042f79b940 R09: 0000000000000000
[ 6041.453725] R10: 0000000001afcc01 R11: ffff880401afec00 R12: ffff8804285fc380
[ 6041.453726] R13: 00007fbe1cfef9e0 R14: ffff8804285fc380 R15: ffff8808284ab280
[ 6041.453727]  ? exit_robust_list+0x37/0x120
[ 6041.453728]  mm_release+0x11a/0x130
[ 6041.453730]  do_exit+0x152/0xb80
[ 6041.453731]  ? __unqueue_futex+0x2f/0x60
[ 6041.453732]  do_group_exit+0x3f/0xb0
[ 6041.453733]  get_signal+0x1bf/0x5e0
[ 6041.453735]  do_signal+0x37/0x6a0
[ 6041.453736]  ? do_futex+0xfd/0x570
[ 6041.453737]  exit_to_usermode_loop+0x3f/0x85
[ 6041.453739]  do_syscall_64+0x165/0x180
[ 6041.453740]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6041.453740] RIP: 0033:0x7fbe2a8576d5
[ 6041.453741] RSP: 002b:00007fbe1cfeecf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 6041.453742] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007fbe2a8576d5
[ 6041.453742] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 000055c46b7be5ac
[ 6041.453743] RBP: 000055c46b7be608 R08: 000055c46b7be500 R09: 0000000000000000
[ 6041.453743] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c46b7be620
[ 6041.453744] R13: 000055c46b7be580 R14: 000055c46b7be5a8 R15: 000055c46b7be540
[ 6041.464876] Kernel Offset: disabled


--------------DAB4B59A52D1CC2208C1CC73--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
