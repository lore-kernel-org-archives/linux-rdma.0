From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Fri, 25 Aug 2017 20:10:17 +0800
Message-ID: <39bb8b67-4018-09bd-9d7d-a8f8534084a7@redhat.com>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
 <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
 <20170425180630.GU14088@mtr-leonro.local>
 <cbc43d35-27c9-331d-b345-b09530477d74@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cbc43d35-27c9-331d-b345-b09530477d74-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 08/24/2017 08:11 PM, Max Gurtovoy wrote:
>
>
> On 4/25/2017 9:06 PM, Leon Romanovsky wrote:
>> On Thu, Apr 20, 2017 at 07:21:29PM +0300, Sagi Grimberg wrote:
>>>
>>>> [1]
>>>> [ 5968.515237] DMAR: DRHD: handling fault status reg 2
>>>> [ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
>>>> [ 5968.519450] 00000000 00000000 00000000 00000000
>>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>>> [ 5968.519452] 00000000 02005104 00000316 a71710e3
>>>
>>> Max, Can you decode this for us?
>>
>> I'm not Max and maybe he will shed more light on it. I didn't find such
>> error in our documentation.
>
>
> Sorry for the late response.
>
> Yi Zhang,
> Is it still repro ?
>
Hi Max
The good news is the NULL pointer cannot be reproduced any more with 
4.13.0-rc6.

But I found bellow error on target and client side during the test.
Client side:
rdma-virt-03 login: [  927.033550] print_req_error: I/O error, dev 
nvme0n1, sector 140477384
[  927.033577] print_req_error: I/O error, dev nvme0n1, sector 271251016
[  927.033579] Buffer I/O error on dev nvme0n1, logical block 33906377, 
lost async page write
[  927.033583] Buffer I/O error on dev nvme0n1, logical block 33906378, 
lost async page write
[  927.033584] Buffer I/O error on dev nvme0n1, logical block 33906379, 
lost async page write
[  927.033585] Buffer I/O error on dev nvme0n1, logical block 33906380, 
lost async page write
[  927.033586] Buffer I/O error on dev nvme0n1, logical block 33906381, 
lost async page write
[  927.033586] Buffer I/O error on dev nvme0n1, logical block 33906382, 
lost async page write
[  927.033587] Buffer I/O error on dev nvme0n1, logical block 33906383, 
lost async page write
[  927.033588] Buffer I/O error on dev nvme0n1, logical block 33906384, 
lost async page write
[  927.033591] print_req_error: I/O error, dev nvme0n1, sector 271299456
[  927.033592] Buffer I/O error on dev nvme0n1, logical block 33912432, 
lost async page write
[  927.033593] Buffer I/O error on dev nvme0n1, logical block 33912433, 
lost async page write
[  927.033600] print_req_error: I/O error, dev nvme0n1, sector 271299664
[  927.033606] print_req_error: I/O error, dev nvme0n1, sector 271300200
[  927.033610] print_req_error: I/O error, dev nvme0n1, sector 271198824
[  927.033617] print_req_error: I/O error, dev nvme0n1, sector 271201256
[  927.033621] print_req_error: I/O error, dev nvme0n1, sector 271251224
[  927.033624] print_req_error: I/O error, dev nvme0n1, sector 271251280
[  927.033632] print_req_error: I/O error, dev nvme0n1, sector 271251696
[  957.561764] print_req_error: 243 callbacks suppressed
[  957.567643] print_req_error: I/O error, dev nvme0n1, sector 140682256
[  957.575049] buffer_io_error: 1965 callbacks suppressed
[  957.581006] Buffer I/O error on dev nvme0n1, logical block 17585282, 
lost async page write
[  957.590477] Buffer I/O error on dev nvme0n1, logical block 17585283, 
lost async page write
[  957.599946] Buffer I/O error on dev nvme0n1, logical block 17585284, 
lost async page write
[  957.609406] Buffer I/O error on dev nvme0n1, logical block 17585285, 
lost async page write
[  957.618874] Buffer I/O error on dev nvme0n1, logical block 17585286, 
lost async page write
[  957.628345] print_req_error: I/O error, dev nvme0n1, sector 140692416
[  957.635788] Buffer I/O error on dev nvme0n1, logical block 17586552, 
lost async page write
[  957.645290] Buffer I/O error on dev nvme0n1, logical block 17586553, 
lost async page write
[  957.654790] Buffer I/O error on dev nvme0n1, logical block 17586554, 
lost async page write
[  957.664292] print_req_error: I/O error, dev nvme0n1, sector 140693744
[  957.671767] Buffer I/O error on dev nvme0n1, logical block 17586718, 
lost async page write
[  957.681299] Buffer I/O error on dev nvme0n1, logical block 17586719, 
lost async page write
[  957.690833] print_req_error: I/O error, dev nvme0n1, sector 140697416
[  957.698345] print_req_error: I/O error, dev nvme0n1, sector 140697664
[  957.705855] print_req_error: I/O error, dev nvme0n1, sector 140698576
[  957.713367] print_req_error: I/O error, dev nvme0n1, sector 140699656
[  957.720877] print_req_error: I/O error, dev nvme0n1, sector 140701768
[  957.728390] print_req_error: I/O error, dev nvme0n1, sector 140702728
[  957.735902] print_req_error: I/O error, dev nvme0n1, sector 140705304
[  957.744235] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.750308] nvme nvme0: nvme_rdma_post_send failed with error code -12
[  957.757941] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.764030] nvme nvme0: Queueing INV WR for rkey 0x1a1d9f failed (-12)
[  957.771687] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.777799] nvme nvme0: nvme_rdma_post_send failed with error code -12
[  957.785465] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.791587] nvme nvme0: Queueing INV WR for rkey 0x1a1da0 failed (-12)
[  957.799262] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
[  957.805391] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.805396] nvme nvme0: nvme_rdma_post_send failed with error code -12
[  957.819307] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
[  957.819318] nvme nvme0: nvme_rdma_post_send failed with error code -12
[  957.833260] mlx5_2:mlx5_ib_post_send:3846:(pid 1007):
[  957.833268] nvme nvme0: Queueing INV WR for rkey 0x1a1da1 failed (-12)
[  957.847263] nvme nvme0: Queueing INV WR for rkey 0x1a1fa1 failed (-12)
[  957.855006] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
[  957.861254] nvme nvme0: nvme_rdma_post_send failed with error code -12
[  957.869004] mlx5_2:mlx5_ib_post_send:3846:(pid 1254):
[  957.875192] nvme nvme0: Queueing INV WR for rkey 0x1a1da2 failed (-12)
[  987.962014] print_req_error: 244 callbacks suppressed
[  987.968150] print_req_error: I/O error, dev nvme0n1, sector 140819704
[  987.975829] buffer_io_error: 1826 callbacks suppressed
[  987.982058] Buffer I/O error on dev nvme0n1, logical block 17602463, 
lost async page write
[  987.991803] Buffer I/O error on dev nvme0n1, logical block 17602464, 
lost async page write
[  988.001547] Buffer I/O error on dev nvme0n1, logical block 17602465, 
lost async page write

Target side:
[  875.657497] nvmet: creating controller 1 for subsystem testnqn for 
NQN 
nqn.2014-08.org.nvmexpress:NVMf:uuid:00000000-0000-0000-0000-000000000000.
[  878.243392] nvmet: adding queue 1 to ctrl 1.
[  878.248488] nvmet: adding queue 2 to ctrl 1.
[  878.253483] nvmet: adding queue 3 to ctrl 1.
[  878.258474] nvmet: adding queue 4 to ctrl 1.
[  878.263470] nvmet: adding queue 5 to ctrl 1.
[  878.268458] nvmet: adding queue 6 to ctrl 1.
[  878.273451] nvmet: adding queue 7 to ctrl 1.
[  878.278433] nvmet: adding queue 8 to ctrl 1.
[  878.283413] nvmet: adding queue 9 to ctrl 1.
[  878.288391] nvmet: adding queue 10 to ctrl 1.
[  878.293465] nvmet: adding queue 11 to ctrl 1.
[  878.298541] nvmet: adding queue 12 to ctrl 1.
[  878.303624] nvmet: adding queue 13 to ctrl 1.
[  878.308708] nvmet: adding queue 14 to ctrl 1.
[  878.313789] nvmet: adding queue 15 to ctrl 1.
[  878.318865] nvmet: adding queue 16 to ctrl 1.
[  878.323946] nvmet: adding queue 17 to ctrl 1.
[  878.329017] nvmet: adding queue 18 to ctrl 1.
[  878.334092] nvmet: adding queue 19 to ctrl 1.
[  878.339162] nvmet: adding queue 20 to ctrl 1.
[  878.344233] nvmet: adding queue 21 to ctrl 1.
[  878.349305] nvmet: adding queue 22 to ctrl 1.
[  878.354373] nvmet: adding queue 23 to ctrl 1.
[  878.359445] nvmet: adding queue 24 to ctrl 1.
[  878.364512] nvmet: adding queue 25 to ctrl 1.
[  878.369586] nvmet: adding queue 26 to ctrl 1.
[  878.374658] nvmet: adding queue 27 to ctrl 1.
[  878.379730] nvmet: adding queue 28 to ctrl 1.
[  878.384795] nvmet: adding queue 29 to ctrl 1.
[  878.389868] nvmet: adding queue 30 to ctrl 1.
[  878.394941] nvmet: adding queue 31 to ctrl 1.
[  878.400012] nvmet: adding queue 32 to ctrl 1.
[  878.405080] nvmet: adding queue 33 to ctrl 1.
[  878.410149] nvmet: adding queue 34 to ctrl 1.
[  878.415225] nvmet: adding queue 35 to ctrl 1.
[  878.420295] nvmet: adding queue 36 to ctrl 1.
[  878.425370] nvmet: adding queue 37 to ctrl 1.
[  878.430447] nvmet: adding queue 38 to ctrl 1.
[  878.435519] nvmet: adding queue 39 to ctrl 1.
[  878.440591] nvmet: adding queue 40 to ctrl 1.
[  890.970767] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
[  890.977684] nvmet: ctrl 1 fatal error occurred!
[  890.983943] nvmet_rdma: freeing queue 0
[  890.988444] nvmet_rdma: freeing queue 1
[  890.992945] nvmet_rdma: freeing queue 2
[  890.997433] nvmet_rdma: freeing queue 3
[  891.001901] nvmet_rdma: freeing queue 4
[  891.006348] nvmet_rdma: freeing queue 5
[  891.010775] nvmet_rdma: freeing queue 6
[  891.015221] nvmet_rdma: freeing queue 7
[  891.019660] nvmet_rdma: freeing queue 8
[  891.024114] nvmet_rdma: freeing queue 9
[  891.028583] nvmet_rdma: freeing queue 10
[  891.033136] nvmet_rdma: freeing queue 11
[  891.037713] nvmet_rdma: freeing queue 12
[  891.042274] nvmet_rdma: freeing queue 13
[  891.046891] nvmet_rdma: freeing queue 14
[  891.051468] nvmet_rdma: freeing queue 15
[  891.056208] nvmet_rdma: freeing queue 16
[  891.060840] nvmet_rdma: freeing queue 17
[  891.065587] nvmet_rdma: freeing queue 18
[  891.070148] nvmet_rdma: freeing queue 19
[  891.075200] nvmet_rdma: freeing queue 20
[  891.079790] nvmet_rdma: freeing queue 21
[  891.102153] nvmet_rdma: freeing queue 22
[  891.106731] nvmet_rdma: freeing queue 23
[  891.111296] nvmet_rdma: freeing queue 24
[  891.116936] nvmet_rdma: freeing queue 25
[  891.121504] nvmet_rdma: freeing queue 26
[  891.126070] nvmet_rdma: freeing queue 27
[  891.130611] nvmet_rdma: freeing queue 28
[  891.135161] nvmet_rdma: freeing queue 29
[  891.140823] nvmet_rdma: freeing queue 30
[  891.145380] nvmet_rdma: freeing queue 31
[  891.149952] nvmet_rdma: freeing queue 32
[  891.154499] nvmet_rdma: freeing queue 33
[  891.159070] nvmet_rdma: freeing queue 34
[  891.163620] nvmet_rdma: freeing queue 35
[  891.168175] nvmet_rdma: freeing queue 36
[  891.173410] nvmet_rdma: freeing queue 37
[  891.177949] nvmet_rdma: freeing queue 38
[  891.182508] nvmet_rdma: freeing queue 39
[  891.187055] nvmet_rdma: freeing queue 40

> -Max.
>
>>
>> Thanks
>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
