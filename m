From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Sat, 26 Aug 2017 01:57:09 +0300
Message-ID: <7ceef67d-4424-97d5-02f5-7569a1f5a20e@mellanox.com>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
 <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
 <20170425180630.GU14088@mtr-leonro.local>
 <cbc43d35-27c9-331d-b345-b09530477d74@mellanox.com>
 <39bb8b67-4018-09bd-9d7d-a8f8534084a7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <39bb8b67-4018-09bd-9d7d-a8f8534084a7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 8/25/2017 3:10 PM, Yi Zhang wrote:
>
>
> On 08/24/2017 08:11 PM, Max Gurtovoy wrote:
>>
>>
>> On 4/25/2017 9:06 PM, Leon Romanovsky wrote:
>>> On Thu, Apr 20, 2017 at 07:21:29PM +0300, Sagi Grimberg wrote:
>>>>
>>>>> [1]
>>>>> [ 5968.515237] DMAR: DRHD: handling fault status reg 2
>>>>> [ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
>>>>> [ 5968.519450] 00000000 00000000 00000000 00000000
>>>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>>>> [ 5968.519452] 00000000 02005104 00000316 a71710e3
>>>>
>>>> Max, Can you decode this for us?
>>>
>>> I'm not Max and maybe he will shed more light on it. I didn't find such
>>> error in our documentation.
>>
>>
>> Sorry for the late response.
>>
>> Yi Zhang,
>> Is it still repro ?
>>
> Hi Max
> The good news is the NULL pointer cannot be reproduced any more with
> 4.13.0-rc6.
>
> But I found bellow error on target and client side during the test.
> Client side:
> rdma-virt-03 login: [  927.033550] print_req_error: I/O error, dev
> nvme0n1, sector 140477384
> [  927.033577] print_req_error: I/O error, dev nvme0n1, sector 271251016
> [  927.033579] Buffer I/O error on dev nvme0n1, logical block 33906377,
> lost async page write
> [  927.033583] Buffer I/O error on dev nvme0n1, logical block 33906378,
> lost async page write
> [  927.033584] Buffer I/O error on dev nvme0n1, logical block 33906379,
> lost async page write
> [  927.033585] Buffer I/O error on dev nvme0n1, logical block 33906380,
> lost async page write
> [  927.033586] Buffer I/O error on dev nvme0n1, logical block 33906381,
> lost async page write
> [  927.033586] Buffer I/O error on dev nvme0n1, logical block 33906382,
> lost async page write
> [  927.033587] Buffer I/O error on dev nvme0n1, logical block 33906383,
> lost async page write
> [  927.033588] Buffer I/O error on dev nvme0n1, logical block 33906384,
> lost async page write
> [  927.033591] print_req_error: I/O error, dev nvme0n1, sector 271299456
> [  927.033592] Buffer I/O error on dev nvme0n1, logical block 33912432,
> lost async page write
> [  927.033593] Buffer I/O error on dev nvme0n1, logical block 33912433,
> lost async page write
> [  927.033600] print_req_error: I/O error, dev nvme0n1, sector 271299664
> [  927.033606] print_req_error: I/O error, dev nvme0n1, sector 271300200
> [  927.033610] print_req_error: I/O error, dev nvme0n1, sector 271198824
> [  927.033617] print_req_error: I/O error, dev nvme0n1, sector 271201256
> [  927.033621] print_req_error: I/O error, dev nvme0n1, sector 271251224
> [  927.033624] print_req_error: I/O error, dev nvme0n1, sector 271251280
> [  927.033632] print_req_error: I/O error, dev nvme0n1, sector 271251696
> [  957.561764] print_req_error: 243 callbacks suppressed
> [  957.567643] print_req_error: I/O error, dev nvme0n1, sector 140682256
> [  957.575049] buffer_io_error: 1965 callbacks suppressed
> [  957.581006] Buffer I/O error on dev nvme0n1, logical block 17585282,
> lost async page write
> [  957.590477] Buffer I/O error on dev nvme0n1, logical block 17585283,
> lost async page write
> [  957.599946] Buffer I/O error on dev nvme0n1, logical block 17585284,
> lost async page write
> [  957.609406] Buffer I/O error on dev nvme0n1, logical block 17585285,
> lost async page write
> [  957.618874] Buffer I/O error on dev nvme0n1, logical block 17585286,
> lost async page write
> [  957.628345] print_req_error: I/O error, dev nvme0n1, sector 140692416
> [  957.635788] Buffer I/O error on dev nvme0n1, logical block 17586552,
> lost async page write
> [  957.645290] Buffer I/O error on dev nvme0n1, logical block 17586553,
> lost async page write
> [  957.654790] Buffer I/O error on dev nvme0n1, logical block 17586554,
> lost async page write
> [  957.664292] print_req_error: I/O error, dev nvme0n1, sector 140693744
> [  957.671767] Buffer I/O error on dev nvme0n1, logical block 17586718,
> lost async page write
> [  957.681299] Buffer I/O error on dev nvme0n1, logical block 17586719,
> lost async page write
> [  957.690833] print_req_error: I/O error, dev nvme0n1, sector 140697416
> [  957.698345] print_req_error: I/O error, dev nvme0n1, sector 140697664
> [  957.705855] print_req_error: I/O error, dev nvme0n1, sector 140698576
> [  957.713367] print_req_error: I/O error, dev nvme0n1, sector 140699656
> [  957.720877] print_req_error: I/O error, dev nvme0n1, sector 140701768
> [  957.728390] print_req_error: I/O error, dev nvme0n1, sector 140702728
> [  957.735902] print_req_error: I/O error, dev nvme0n1, sector 140705304
> [  957.744235] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.750308] nvme nvme0: nvme_rdma_post_send failed with error code -12
> [  957.757941] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.764030] nvme nvme0: Queueing INV WR for rkey 0x1a1d9f failed (-12)
> [  957.771687] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.777799] nvme nvme0: nvme_rdma_post_send failed with error code -12
> [  957.785465] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.791587] nvme nvme0: Queueing INV WR for rkey 0x1a1da0 failed (-12)
> [  957.799262] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
> [  957.805391] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.805396] nvme nvme0: nvme_rdma_post_send failed with error code -12
> [  957.819307] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
> [  957.819318] nvme nvme0: nvme_rdma_post_send failed with error code -12
> [  957.833260] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
> [  957.833268] nvme nvme0: Queueing INV WR for rkey 0x1a1da1 failed (-12)
> [  957.847263] nvme nvme0: Queueing INV WR for rkey 0x1a1fa1 failed (-12)
> [  957.855006] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
> [  957.861254] nvme nvme0: nvme_rdma_post_send failed with error code -12
> [  957.869004] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
> [  957.875192] nvme nvme0: Queueing INV WR for rkey 0x1a1da2 failed (-12)
> [  987.962014] print_req_error: 244 callbacks suppressed
> [  987.968150] print_req_error: I/O error, dev nvme0n1, sector 140819704
> [  987.975829] buffer_io_error: 1826 callbacks suppressed
> [  987.982058] Buffer I/O error on dev nvme0n1, logical block 17602463,
> lost async page write
> [  987.991803] Buffer I/O error on dev nvme0n1, logical block 17602464,
> lost async page write
> [  988.001547] Buffer I/O error on dev nvme0n1, logical block 17602465,
> lost async page write

I couldn't repro it, but for some reason you got an overflow in the QP 
send queue.
seems like something might be wrong with the calculation (probably 
signaling calculation).

please supply more details:
1. link layer ?
2. HCA type + FW versions on target/host sides ?
3. B2B connection ?

try this one as a first step:

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 82fcb07..1437306 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -88,6 +88,7 @@ struct nvme_rdma_queue {
         struct nvme_rdma_qe     *rsp_ring;
         atomic_t                sig_count;
         int                     queue_size;
+       int                     limit_mask;
         size_t                  cmnd_capsule_len;
         struct nvme_rdma_ctrl   *ctrl;
         struct nvme_rdma_device *device;
@@ -521,6 +522,7 @@ static int nvme_rdma_init_queue(struct 
nvme_rdma_ctrl *ctrl,

         queue->queue_size = queue_size;
         atomic_set(&queue->sig_count, 0);
+       queue->limit_mask = (min(32, 1 << ilog2((queue->queue_size + 1) 
/ 2))) - 1;

         queue->cm_id = rdma_create_id(&init_net, nvme_rdma_cm_handler, 
queue,
                         RDMA_PS_TCP, IB_QPT_RC);
@@ -1009,9 +1011,7 @@ static void nvme_rdma_send_done(struct ib_cq *cq, 
struct ib_wc *wc)
   */
  static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue 
*queue)
  {
-       int limit = 1 << ilog2((queue->queue_size + 1) / 2);
-
-       return (atomic_inc_return(&queue->sig_count) & (limit - 1)) == 0;
+       return (atomic_inc_return(&queue->sig_count) & 
(queue->limit_mask)) == 0;
  }

  static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
