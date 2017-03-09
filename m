From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Thu, 9 Mar 2017 18:33:58 +0800
Message-ID: <e4a9ba2d-6ccd-53bc-1c0d-f6ad6c2c8ce3@redhat.com>
References: <1908657724.31179983.1488539944957.JavaMail.zimbra@redhat.com>
 <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <20170305081206.GI14379@mtr-leonro.local>
 <20170309084641.GY14379@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------573D2BC0FFF58B2526243DF5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309084641.GY14379-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------573D2BC0FFF58B2526243DF5
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


>> + Christoph and Sagi.
> +Tariq and Yishai.
>
> How can we know from this log which memory order failed?
>
> It can be one of two: memory leak (most probably) or/and fragmented
> memory.

I have tried to enable memleak and retest, didn't found any kmemleak 
reported from kernel.
Just as I said from previous mail: before the OOM occurred, most of the 
log are  about "adding queue", and after the OOM occurred, most of the 
log are about "nvmet_rdma: freeing queue".
I guess the release work: "schedule_work(&queue->release_work);" not 
executed timely that caused this issue, correct me if I'm wrong.

As the attachment size limit I have to cut to 500KB, pls check the 
attached file for more log.
>>>
>>> Best Regards,
>>>    Yi Zhang
>>>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme


--------------573D2BC0FFF58B2526243DF5
Content-Type: text/x-log;
 name="oom.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="oom.log"

[ 1635.414372] nvmet: adding queue 5 to ctrl 783.
[ 1635.414565] nvmet: adding queue 6 to ctrl 783.
[ 1635.414753] nvmet: adding queue 7 to ctrl 783.
[ 1635.414954] nvmet: adding queue 8 to ctrl 783.
[ 1635.415167] nvmet: adding queue 9 to ctrl 783.
[ 1635.415390] nvmet: adding queue 10 to ctrl 783.
[ 1635.415582] nvmet: adding queue 11 to ctrl 783.
[ 1635.415840] nvmet: adding queue 12 to ctrl 783.
[ 1635.416040] nvmet: adding queue 13 to ctrl 783.
[ 1635.416235] nvmet: adding queue 14 to ctrl 783.
[ 1635.416490] nvmet: adding queue 15 to ctrl 783.
[ 1635.416722] nvmet: adding queue 16 to ctrl 783.
[ 1635.531280] nvmet: creating controller 784 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1635.597227] nvmet: adding queue 1 to ctrl 784.
[ 1635.597401] nvmet: adding queue 2 to ctrl 784.
[ 1635.597705] nvmet: adding queue 3 to ctrl 784.
[ 1635.597935] nvmet: adding queue 4 to ctrl 784.
[ 1635.598142] nvmet: adding queue 5 to ctrl 784.
[ 1635.598417] nvmet: adding queue 6 to ctrl 784.
[ 1635.598624] nvmet: adding queue 7 to ctrl 784.
[ 1635.598870] nvmet: adding queue 8 to ctrl 784.
[ 1635.599191] nvmet: adding queue 9 to ctrl 784.
[ 1635.599556] nvmet: adding queue 10 to ctrl 784.
[ 1635.599902] nvmet: adding queue 11 to ctrl 784.
[ 1635.600178] nvmet: adding queue 12 to ctrl 784.
[ 1635.600390] nvmet: adding queue 13 to ctrl 784.
[ 1635.600567] nvmet: adding queue 14 to ctrl 784.
[ 1635.600808] nvmet: adding queue 15 to ctrl 784.
[ 1635.601017] nvmet: adding queue 16 to ctrl 784.
[ 1635.701231] nvmet: creating controller 785 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1635.754082] nvmet: adding queue 1 to ctrl 785.
[ 1635.754224] nvmet: adding queue 2 to ctrl 785.
[ 1635.763942] nvmet: adding queue 3 to ctrl 785.
[ 1635.764155] nvmet: adding queue 4 to ctrl 785.
[ 1635.764364] nvmet: adding queue 5 to ctrl 785.
[ 1635.764569] nvmet: adding queue 6 to ctrl 785.
[ 1635.764725] nvmet: adding queue 7 to ctrl 785.
[ 1635.764925] nvmet: adding queue 8 to ctrl 785.
[ 1635.765147] nvmet: adding queue 9 to ctrl 785.
[ 1635.765375] nvmet: adding queue 10 to ctrl 785.
[ 1635.765603] nvmet: adding queue 11 to ctrl 785.
[ 1635.765792] nvmet: adding queue 12 to ctrl 785.
[ 1635.765955] nvmet: adding queue 13 to ctrl 785.
[ 1635.766125] nvmet: adding queue 14 to ctrl 785.
[ 1635.784340] nvmet: adding queue 15 to ctrl 785.
[ 1635.784622] nvmet: adding queue 16 to ctrl 785.
[ 1635.867635] nvmet_rdma: freeing queue 13338
[ 1635.869196] nvmet_rdma: freeing queue 13339
[ 1635.870397] nvmet_rdma: freeing queue 13340
[ 1635.872080] nvmet_rdma: freeing queue 13341
[ 1635.873626] nvmet_rdma: freeing queue 13342
[ 1635.877020] nvmet_rdma: freeing queue 13344
[ 1635.878207] nvmet_rdma: freeing queue 13328
[ 1635.890032] nvmet: creating controller 786 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1635.944993] nvmet: adding queue 1 to ctrl 786.
[ 1635.945197] nvmet: adding queue 2 to ctrl 786.
[ 1635.945389] nvmet: adding queue 3 to ctrl 786.
[ 1635.945599] nvmet: adding queue 4 to ctrl 786.
[ 1635.945796] nvmet: adding queue 5 to ctrl 786.
[ 1635.945958] nvmet: adding queue 6 to ctrl 786.
[ 1635.955558] nvmet: adding queue 7 to ctrl 786.
[ 1635.955761] nvmet: adding queue 8 to ctrl 786.
[ 1635.976719] nvmet: adding queue 9 to ctrl 786.
[ 1635.977023] nvmet: adding queue 10 to ctrl 786.
[ 1635.996614] nvmet: adding queue 11 to ctrl 786.
[ 1635.996883] nvmet: adding queue 12 to ctrl 786.
[ 1635.997103] nvmet: adding queue 13 to ctrl 786.
[ 1635.997361] nvmet: adding queue 14 to ctrl 786.
[ 1635.997614] nvmet: adding queue 15 to ctrl 786.
[ 1635.997876] nvmet: adding queue 16 to ctrl 786.
[ 1636.063848] nvmet_rdma: freeing queue 13346
[ 1636.065851] nvmet_rdma: freeing queue 13347
[ 1636.067520] nvmet_rdma: freeing queue 13348
[ 1636.069117] nvmet_rdma: freeing queue 13349
[ 1636.070478] nvmet_rdma: freeing queue 13350
[ 1636.071917] nvmet_rdma: freeing queue 13351
[ 1636.073496] nvmet_rdma: freeing queue 13352
[ 1636.074913] nvmet_rdma: freeing queue 13353
[ 1636.076529] nvmet_rdma: freeing queue 13354
[ 1636.078524] nvmet_rdma: freeing queue 13355
[ 1636.079719] nvmet_rdma: freeing queue 13356
[ 1636.081172] nvmet_rdma: freeing queue 13357
[ 1636.083795] nvmet_rdma: freeing queue 13359
[ 1636.101049] nvmet: creating controller 787 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1636.154363] nvmet: adding queue 1 to ctrl 787.
[ 1636.154562] nvmet: adding queue 2 to ctrl 787.
[ 1636.154811] nvmet: adding queue 3 to ctrl 787.
[ 1636.155085] nvmet: adding queue 4 to ctrl 787.
[ 1636.155243] nvmet: adding queue 5 to ctrl 787.
[ 1636.155515] nvmet: adding queue 6 to ctrl 787.
[ 1636.155788] nvmet: adding queue 7 to ctrl 787.
[ 1636.155975] nvmet: adding queue 8 to ctrl 787.
[ 1636.156145] nvmet: adding queue 9 to ctrl 787.
[ 1636.156394] nvmet: adding queue 10 to ctrl 787.
[ 1636.165538] nvmet: adding queue 11 to ctrl 787.
[ 1636.217034] nvmet: adding queue 12 to ctrl 787.
[ 1636.217257] nvmet: adding queue 13 to ctrl 787.
[ 1636.217513] nvmet: adding queue 14 to ctrl 787.
[ 1636.217857] nvmet: adding queue 15 to ctrl 787.
[ 1636.218134] nvmet: adding queue 16 to ctrl 787.
[ 1636.320529] nvmet: creating controller 788 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1636.373758] nvmet: adding queue 1 to ctrl 788.
[ 1636.374024] nvmet: adding queue 2 to ctrl 788.
[ 1636.374254] nvmet: adding queue 3 to ctrl 788.
[ 1636.374539] nvmet: adding queue 4 to ctrl 788.
[ 1636.374813] nvmet: adding queue 5 to ctrl 788.
[ 1636.374998] nvmet: adding queue 6 to ctrl 788.
[ 1636.375152] nvmet: adding queue 7 to ctrl 788.
[ 1636.375368] nvmet: adding queue 8 to ctrl 788.
[ 1636.375579] nvmet: adding queue 9 to ctrl 788.
[ 1636.375808] nvmet: adding queue 10 to ctrl 788.
[ 1636.376053] nvmet: adding queue 11 to ctrl 788.
[ 1636.376319] nvmet: adding queue 12 to ctrl 788.
[ 1636.376580] nvmet: adding queue 13 to ctrl 788.
[ 1636.379203] nvmet: adding queue 14 to ctrl 788.
[ 1636.379467] nvmet: adding queue 15 to ctrl 788.
[ 1636.379689] nvmet: adding queue 16 to ctrl 788.
[ 1636.386179] nvmet: ctrl 709 keep-alive timer (15 seconds) expired!
[ 1636.386181] nvmet: ctrl 709 fatal error occurred!
[ 1636.457883] nvmet_rdma: freeing queue 13389
[ 1636.462409] nvmet_rdma: freeing queue 13392
[ 1636.480543] nvmet: creating controller 789 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1636.534304] nvmet: adding queue 1 to ctrl 789.
[ 1636.534574] nvmet: adding queue 2 to ctrl 789.
[ 1636.534831] nvmet: adding queue 3 to ctrl 789.
[ 1636.535024] nvmet: adding queue 4 to ctrl 789.
[ 1636.535189] nvmet: adding queue 5 to ctrl 789.
[ 1636.535364] nvmet: adding queue 6 to ctrl 789.
[ 1636.535552] nvmet: adding queue 7 to ctrl 789.
[ 1636.535734] nvmet: adding queue 8 to ctrl 789.
[ 1636.541283] nvmet: adding queue 9 to ctrl 789.
[ 1636.541488] nvmet: adding queue 10 to ctrl 789.
[ 1636.559687] nvmet: adding queue 11 to ctrl 789.
[ 1636.559966] nvmet: adding queue 12 to ctrl 789.
[ 1636.560208] nvmet: adding queue 13 to ctrl 789.
[ 1636.560429] nvmet: adding queue 14 to ctrl 789.
[ 1636.560709] nvmet: adding queue 15 to ctrl 789.
[ 1636.561014] nvmet: adding queue 16 to ctrl 789.
[ 1636.660837] nvmet: creating controller 790 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1636.729146] nvmet: adding queue 1 to ctrl 790.
[ 1636.729422] nvmet: adding queue 2 to ctrl 790.
[ 1636.749075] nvmet: adding queue 3 to ctrl 790.
[ 1636.749334] nvmet: adding queue 4 to ctrl 790.
[ 1636.769017] nvmet: adding queue 5 to ctrl 790.
[ 1636.769262] nvmet: adding queue 6 to ctrl 790.
[ 1636.769561] nvmet: adding queue 7 to ctrl 790.
[ 1636.769873] nvmet: adding queue 8 to ctrl 790.
[ 1636.770156] nvmet: adding queue 9 to ctrl 790.
[ 1636.770403] nvmet: adding queue 10 to ctrl 790.
[ 1636.770644] nvmet: adding queue 11 to ctrl 790.
[ 1636.770947] nvmet: adding queue 12 to ctrl 790.
[ 1636.771203] nvmet: adding queue 13 to ctrl 790.
[ 1636.771420] nvmet: adding queue 14 to ctrl 790.
[ 1636.771693] nvmet: adding queue 15 to ctrl 790.
[ 1636.771943] nvmet: adding queue 16 to ctrl 790.
[ 1636.880124] nvmet: creating controller 791 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1636.933477] nvmet: adding queue 1 to ctrl 791.
[ 1636.933670] nvmet: adding queue 2 to ctrl 791.
[ 1636.933846] nvmet: adding queue 3 to ctrl 791.
[ 1636.934071] nvmet: adding queue 4 to ctrl 791.
[ 1636.949591] nvmet: adding queue 5 to ctrl 791.
[ 1636.970852] nvmet: adding queue 6 to ctrl 791.
[ 1636.971101] nvmet: adding queue 7 to ctrl 791.
[ 1636.971381] nvmet: adding queue 8 to ctrl 791.
[ 1636.971600] nvmet: adding queue 9 to ctrl 791.
[ 1636.971862] nvmet: adding queue 10 to ctrl 791.
[ 1636.972158] nvmet: adding queue 11 to ctrl 791.
[ 1636.972416] nvmet: adding queue 12 to ctrl 791.
[ 1636.972619] nvmet: adding queue 13 to ctrl 791.
[ 1636.972792] nvmet: adding queue 14 to ctrl 791.
[ 1636.973165] nvmet: adding queue 15 to ctrl 791.
[ 1636.973449] nvmet: adding queue 16 to ctrl 791.
[ 1637.090076] nvmet: creating controller 792 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1637.143628] nvmet: adding queue 1 to ctrl 792.
[ 1637.143778] nvmet: adding queue 2 to ctrl 792.
[ 1637.143966] nvmet: adding queue 3 to ctrl 792.
[ 1637.144139] nvmet: adding queue 4 to ctrl 792.
[ 1637.144350] nvmet: adding queue 5 to ctrl 792.
[ 1637.144602] nvmet: adding queue 6 to ctrl 792.
[ 1637.144864] nvmet: adding queue 7 to ctrl 792.
[ 1637.147714] nvmet: adding queue 8 to ctrl 792.
[ 1637.147923] nvmet: adding queue 9 to ctrl 792.
[ 1637.148108] nvmet: adding queue 10 to ctrl 792.
[ 1637.148371] nvmet: adding queue 11 to ctrl 792.
[ 1637.148637] nvmet: adding queue 12 to ctrl 792.
[ 1637.148850] nvmet: adding queue 13 to ctrl 792.
[ 1637.149080] nvmet: adding queue 14 to ctrl 792.
[ 1637.149362] nvmet: adding queue 15 to ctrl 792.
[ 1637.149629] nvmet: adding queue 16 to ctrl 792.
[ 1637.193991] nvmet_rdma: freeing queue 13448
[ 1637.196023] nvmet_rdma: freeing queue 13449
[ 1637.231151] nvmet: creating controller 793 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1637.284611] nvmet: adding queue 1 to ctrl 793.
[ 1637.284797] nvmet: adding queue 2 to ctrl 793.
[ 1637.304606] nvmet: adding queue 3 to ctrl 793.
[ 1637.304846] nvmet: adding queue 4 to ctrl 793.
[ 1637.324703] nvmet: adding queue 5 to ctrl 793.
[ 1637.325013] nvmet: adding queue 6 to ctrl 793.
[ 1637.325257] nvmet: adding queue 7 to ctrl 793.
[ 1637.325568] nvmet: adding queue 8 to ctrl 793.
[ 1637.325850] nvmet: adding queue 9 to ctrl 793.
[ 1637.326095] nvmet: adding queue 10 to ctrl 793.
[ 1637.326405] nvmet: adding queue 11 to ctrl 793.
[ 1637.344695] nvmet: adding queue 12 to ctrl 793.
[ 1637.344948] nvmet: adding queue 13 to ctrl 793.
[ 1637.364588] nvmet: adding queue 14 to ctrl 793.
[ 1637.364940] nvmet: adding queue 15 to ctrl 793.
[ 1637.384483] nvmet: adding queue 16 to ctrl 793.
[ 1637.432265] nvmet_rdma: freeing queue 13470
[ 1637.434016] nvmet_rdma: freeing queue 13471
[ 1637.435048] nvmet_rdma: freeing queue 13472
[ 1637.460720] nvmet: creating controller 794 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1637.514121] nvmet: adding queue 1 to ctrl 794.
[ 1637.514386] nvmet: adding queue 2 to ctrl 794.
[ 1637.514575] nvmet: adding queue 3 to ctrl 794.
[ 1637.514757] nvmet: adding queue 4 to ctrl 794.
[ 1637.514975] nvmet: adding queue 5 to ctrl 794.
[ 1637.515164] nvmet: adding queue 6 to ctrl 794.
[ 1637.515380] nvmet: adding queue 7 to ctrl 794.
[ 1637.515551] nvmet: adding queue 8 to ctrl 794.
[ 1637.515765] nvmet: adding queue 9 to ctrl 794.
[ 1637.516017] nvmet: adding queue 10 to ctrl 794.
[ 1637.516241] nvmet: adding queue 11 to ctrl 794.
[ 1637.516460] nvmet: adding queue 12 to ctrl 794.
[ 1637.516712] nvmet: adding queue 13 to ctrl 794.
[ 1637.516996] nvmet: adding queue 14 to ctrl 794.
[ 1637.517277] nvmet: adding queue 15 to ctrl 794.
[ 1637.527083] nvmet: adding queue 16 to ctrl 794.
[ 1637.650701] nvmet: creating controller 795 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1637.703742] nvmet: adding queue 1 to ctrl 795.
[ 1637.703942] nvmet: adding queue 2 to ctrl 795.
[ 1637.704135] nvmet: adding queue 3 to ctrl 795.
[ 1637.704353] nvmet: adding queue 4 to ctrl 795.
[ 1637.704543] nvmet: adding queue 5 to ctrl 795.
[ 1637.704706] nvmet: adding queue 6 to ctrl 795.
[ 1637.704850] nvmet: adding queue 7 to ctrl 795.
[ 1637.705065] nvmet: adding queue 8 to ctrl 795.
[ 1637.705292] nvmet: adding queue 9 to ctrl 795.
[ 1637.705560] nvmet: adding queue 10 to ctrl 795.
[ 1637.705779] nvmet: adding queue 11 to ctrl 795.
[ 1637.706030] nvmet: adding queue 12 to ctrl 795.
[ 1637.706252] nvmet: adding queue 13 to ctrl 795.
[ 1637.706455] nvmet: adding queue 14 to ctrl 795.
[ 1637.706677] nvmet: adding queue 15 to ctrl 795.
[ 1637.706924] nvmet: adding queue 16 to ctrl 795.
[ 1637.764835] nvmet_rdma: freeing queue 13506
[ 1637.789727] nvmet: creating controller 796 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1637.844243] nvmet: adding queue 1 to ctrl 796.
[ 1637.846557] nvmet: adding queue 2 to ctrl 796.
[ 1637.846741] nvmet: adding queue 3 to ctrl 796.
[ 1637.847007] nvmet: adding queue 4 to ctrl 796.
[ 1637.847194] nvmet: adding queue 5 to ctrl 796.
[ 1637.847381] nvmet: adding queue 6 to ctrl 796.
[ 1637.847574] nvmet: adding queue 7 to ctrl 796.
[ 1637.847780] nvmet: adding queue 8 to ctrl 796.
[ 1637.847993] nvmet: adding queue 9 to ctrl 796.
[ 1637.848210] nvmet: adding queue 10 to ctrl 796.
[ 1637.848450] nvmet: adding queue 11 to ctrl 796.
[ 1637.848771] nvmet: adding queue 12 to ctrl 796.
[ 1637.848940] nvmet: adding queue 13 to ctrl 796.
[ 1637.867221] nvmet: adding queue 14 to ctrl 796.
[ 1637.867500] nvmet: adding queue 15 to ctrl 796.
[ 1637.887883] nvmet: adding queue 16 to ctrl 796.
[ 1637.999981] nvmet: creating controller 797 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1638.052739] nvmet: adding queue 1 to ctrl 797.
[ 1638.052994] nvmet: adding queue 2 to ctrl 797.
[ 1638.053222] nvmet: adding queue 3 to ctrl 797.
[ 1638.053417] nvmet: adding queue 4 to ctrl 797.
[ 1638.053600] nvmet: adding queue 5 to ctrl 797.
[ 1638.060445] nvmet: adding queue 6 to ctrl 797.
[ 1638.060667] nvmet: adding queue 7 to ctrl 797.
[ 1638.080345] nvmet: adding queue 8 to ctrl 797.
[ 1638.080620] nvmet: adding queue 9 to ctrl 797.
[ 1638.100259] nvmet: adding queue 10 to ctrl 797.
[ 1638.100520] nvmet: adding queue 11 to ctrl 797.
[ 1638.100785] nvmet: adding queue 12 to ctrl 797.
[ 1638.101022] nvmet: adding queue 13 to ctrl 797.
[ 1638.101251] nvmet: adding queue 14 to ctrl 797.
[ 1638.101485] nvmet: adding queue 15 to ctrl 797.
[ 1638.101712] nvmet: adding queue 16 to ctrl 797.
[ 1638.143953] nvmet_rdma: freeing queue 13533
[ 1638.146409] nvmet_rdma: freeing queue 13534
[ 1638.147796] nvmet_rdma: freeing queue 13535
[ 1638.149179] nvmet_rdma: freeing queue 13536
[ 1638.150525] nvmet_rdma: freeing queue 13537
[ 1638.152305] nvmet_rdma: freeing queue 13538
[ 1638.153610] nvmet_rdma: freeing queue 13539
[ 1638.154923] nvmet_rdma: freeing queue 13540
[ 1638.156370] nvmet_rdma: freeing queue 13541
[ 1638.157801] nvmet_rdma: freeing queue 13542
[ 1638.159096] nvmet_rdma: freeing queue 13543
[ 1638.160400] nvmet_rdma: freeing queue 13544
[ 1638.162186] nvmet_rdma: freeing queue 13545
[ 1638.163748] nvmet_rdma: freeing queue 13546
[ 1638.164771] nvmet_rdma: freeing queue 13547
[ 1638.168012] nvmet_rdma: freeing queue 13532
[ 1638.180177] nvmet: creating controller 798 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1638.233783] nvmet: adding queue 1 to ctrl 798.
[ 1638.233929] nvmet: adding queue 2 to ctrl 798.
[ 1638.234148] nvmet: adding queue 3 to ctrl 798.
[ 1638.234414] nvmet: adding queue 4 to ctrl 798.
[ 1638.234674] nvmet: adding queue 5 to ctrl 798.
[ 1638.234859] nvmet: adding queue 6 to ctrl 798.
[ 1638.235030] nvmet: adding queue 7 to ctrl 798.
[ 1638.235227] nvmet: adding queue 8 to ctrl 798.
[ 1638.235429] nvmet: adding queue 9 to ctrl 798.
[ 1638.248253] nvmet: adding queue 10 to ctrl 798.
[ 1638.268579] nvmet: adding queue 11 to ctrl 798.
[ 1638.268851] nvmet: adding queue 12 to ctrl 798.
[ 1638.269056] nvmet: adding queue 13 to ctrl 798.
[ 1638.269295] nvmet: adding queue 14 to ctrl 798.
[ 1638.269617] nvmet: adding queue 15 to ctrl 798.
[ 1638.269903] nvmet: adding queue 16 to ctrl 798.
[ 1638.370314] nvmet: creating controller 799 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1638.423368] nvmet: adding queue 1 to ctrl 799.
[ 1638.423569] nvmet: adding queue 2 to ctrl 799.
[ 1638.423833] nvmet: adding queue 3 to ctrl 799.
[ 1638.424026] nvmet: adding queue 4 to ctrl 799.
[ 1638.424298] nvmet: adding queue 5 to ctrl 799.
[ 1638.424493] nvmet: adding queue 6 to ctrl 799.
[ 1638.424702] nvmet: adding queue 7 to ctrl 799.
[ 1638.424878] nvmet: adding queue 8 to ctrl 799.
[ 1638.425048] nvmet: adding queue 9 to ctrl 799.
[ 1638.425279] nvmet: adding queue 10 to ctrl 799.
[ 1638.425570] nvmet: adding queue 11 to ctrl 799.
[ 1638.425777] nvmet: adding queue 12 to ctrl 799.
[ 1638.440574] nvmet: adding queue 13 to ctrl 799.
[ 1638.440821] nvmet: adding queue 14 to ctrl 799.
[ 1638.441084] nvmet: adding queue 15 to ctrl 799.
[ 1638.441379] nvmet: adding queue 16 to ctrl 799.
[ 1638.550794] nvmet: creating controller 800 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1638.604102] nvmet: adding queue 1 to ctrl 800.
[ 1638.604381] nvmet: adding queue 2 to ctrl 800.
[ 1638.604653] nvmet: adding queue 3 to ctrl 800.
[ 1638.604840] nvmet: adding queue 4 to ctrl 800.
[ 1638.605078] nvmet: adding queue 5 to ctrl 800.
[ 1638.605251] nvmet: adding queue 6 to ctrl 800.
[ 1638.605428] nvmet: adding queue 7 to ctrl 800.
[ 1638.622076] nvmet: adding queue 8 to ctrl 800.
[ 1638.622297] nvmet: adding queue 9 to ctrl 800.
[ 1638.642429] nvmet: adding queue 10 to ctrl 800.
[ 1638.642748] nvmet: adding queue 11 to ctrl 800.
[ 1638.643047] nvmet: adding queue 12 to ctrl 800.
[ 1638.643339] nvmet: adding queue 13 to ctrl 800.
[ 1638.643615] nvmet: adding queue 14 to ctrl 800.
[ 1638.643910] nvmet: adding queue 15 to ctrl 800.
[ 1638.644255] nvmet: adding queue 16 to ctrl 800.
[ 1638.756708] nvmet_rdma: freeing queue 13592
[ 1638.758372] nvmet_rdma: freeing queue 13593
[ 1638.761153] nvmet_rdma: freeing queue 13595
[ 1638.781031] nvmet: creating controller 801 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1638.833786] nvmet: adding queue 1 to ctrl 801.
[ 1638.838979] nvmet: adding queue 2 to ctrl 801.
[ 1638.839143] nvmet: adding queue 3 to ctrl 801.
[ 1638.859028] nvmet: adding queue 4 to ctrl 801.
[ 1638.859333] nvmet: adding queue 5 to ctrl 801.
[ 1638.859632] nvmet: adding queue 6 to ctrl 801.
[ 1638.859938] nvmet: adding queue 7 to ctrl 801.
[ 1638.860127] nvmet: adding queue 8 to ctrl 801.
[ 1638.860286] nvmet: adding queue 9 to ctrl 801.
[ 1638.860525] nvmet: adding queue 10 to ctrl 801.
[ 1638.860797] nvmet: adding queue 11 to ctrl 801.
[ 1638.861034] nvmet: adding queue 12 to ctrl 801.
[ 1638.861269] nvmet: adding queue 13 to ctrl 801.
[ 1638.861455] nvmet: adding queue 14 to ctrl 801.
[ 1638.861758] nvmet: adding queue 15 to ctrl 801.
[ 1638.862018] nvmet: adding queue 16 to ctrl 801.
[ 1638.917625] nvmet_rdma: freeing queue 13603
[ 1638.919175] nvmet_rdma: freeing queue 13604
[ 1638.920405] nvmet_rdma: freeing queue 13605
[ 1638.923388] nvmet_rdma: freeing queue 13607
[ 1638.924630] nvmet_rdma: freeing queue 13608
[ 1638.950677] nvmet: creating controller 802 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.005189] nvmet: adding queue 1 to ctrl 802.
[ 1639.005362] nvmet: adding queue 2 to ctrl 802.
[ 1639.005587] nvmet: adding queue 3 to ctrl 802.
[ 1639.022710] nvmet: adding queue 4 to ctrl 802.
[ 1639.043039] nvmet: adding queue 5 to ctrl 802.
[ 1639.043279] nvmet: adding queue 6 to ctrl 802.
[ 1639.043602] nvmet: adding queue 7 to ctrl 802.
[ 1639.043899] nvmet: adding queue 8 to ctrl 802.
[ 1639.044138] nvmet: adding queue 9 to ctrl 802.
[ 1639.044441] nvmet: adding queue 10 to ctrl 802.
[ 1639.044773] nvmet: adding queue 11 to ctrl 802.
[ 1639.045080] nvmet: adding queue 12 to ctrl 802.
[ 1639.045343] nvmet: adding queue 13 to ctrl 802.
[ 1639.045613] nvmet: adding queue 14 to ctrl 802.
[ 1639.045855] nvmet: adding queue 15 to ctrl 802.
[ 1639.046137] nvmet: adding queue 16 to ctrl 802.
[ 1639.130632] nvmet: creating controller 803 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.185930] nvmet: adding queue 1 to ctrl 803.
[ 1639.186099] nvmet: adding queue 2 to ctrl 803.
[ 1639.186289] nvmet: adding queue 3 to ctrl 803.
[ 1639.186471] nvmet: adding queue 4 to ctrl 803.
[ 1639.186650] nvmet: adding queue 5 to ctrl 803.
[ 1639.186820] nvmet: adding queue 6 to ctrl 803.
[ 1639.195879] nvmet: adding queue 7 to ctrl 803.
[ 1639.196107] nvmet: adding queue 8 to ctrl 803.
[ 1639.196307] nvmet: adding queue 9 to ctrl 803.
[ 1639.196546] nvmet: adding queue 10 to ctrl 803.
[ 1639.196758] nvmet: adding queue 11 to ctrl 803.
[ 1639.197070] nvmet: adding queue 12 to ctrl 803.
[ 1639.197266] nvmet: adding queue 13 to ctrl 803.
[ 1639.197463] nvmet: adding queue 14 to ctrl 803.
[ 1639.197719] nvmet: adding queue 15 to ctrl 803.
[ 1639.197971] nvmet: adding queue 16 to ctrl 803.
[ 1639.266073] nvmet_rdma: freeing queue 13636
[ 1639.270805] nvmet_rdma: freeing queue 13639
[ 1639.272462] nvmet_rdma: freeing queue 13640
[ 1639.273776] nvmet_rdma: freeing queue 13641
[ 1639.275207] nvmet_rdma: freeing queue 13642
[ 1639.276634] nvmet_rdma: freeing queue 13643
[ 1639.278241] nvmet_rdma: freeing queue 13644
[ 1639.279399] nvmet_rdma: freeing queue 13645
[ 1639.280886] nvmet_rdma: freeing queue 13646
[ 1639.282320] nvmet_rdma: freeing queue 13647
[ 1639.283829] nvmet_rdma: freeing queue 13648
[ 1639.285340] nvmet_rdma: freeing queue 13649
[ 1639.288423] nvmet_rdma: freeing queue 13634
[ 1639.300729] nvmet: creating controller 804 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.353583] nvmet: adding queue 1 to ctrl 804.
[ 1639.365020] nvmet: adding queue 2 to ctrl 804.
[ 1639.365291] nvmet: adding queue 3 to ctrl 804.
[ 1639.417379] nvmet: adding queue 4 to ctrl 804.
[ 1639.417648] nvmet: adding queue 5 to ctrl 804.
[ 1639.417906] nvmet: adding queue 6 to ctrl 804.
[ 1639.418234] nvmet: adding queue 7 to ctrl 804.
[ 1639.418516] nvmet: adding queue 8 to ctrl 804.
[ 1639.418759] nvmet: adding queue 9 to ctrl 804.
[ 1639.419102] nvmet: adding queue 10 to ctrl 804.
[ 1639.437735] nvmet: adding queue 11 to ctrl 804.
[ 1639.438042] nvmet: adding queue 12 to ctrl 804.
[ 1639.457761] nvmet: adding queue 13 to ctrl 804.
[ 1639.458022] nvmet: adding queue 14 to ctrl 804.
[ 1639.477722] nvmet: adding queue 15 to ctrl 804.
[ 1639.478016] nvmet: adding queue 16 to ctrl 804.
[ 1639.569492] nvmet: creating controller 805 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.586051] nvmet: ctrl 725 keep-alive timer (15 seconds) expired!
[ 1639.586053] nvmet: ctrl 725 fatal error occurred!
[ 1639.623395] nvmet: adding queue 1 to ctrl 805.
[ 1639.623602] nvmet: adding queue 2 to ctrl 805.
[ 1639.623764] nvmet: adding queue 3 to ctrl 805.
[ 1639.623975] nvmet: adding queue 4 to ctrl 805.
[ 1639.624187] nvmet: adding queue 5 to ctrl 805.
[ 1639.624342] nvmet: adding queue 6 to ctrl 805.
[ 1639.624538] nvmet: adding queue 7 to ctrl 805.
[ 1639.624731] nvmet: adding queue 8 to ctrl 805.
[ 1639.624951] nvmet: adding queue 9 to ctrl 805.
[ 1639.625221] nvmet: adding queue 10 to ctrl 805.
[ 1639.625487] nvmet: adding queue 11 to ctrl 805.
[ 1639.625736] nvmet: adding queue 12 to ctrl 805.
[ 1639.625883] nvmet: adding queue 13 to ctrl 805.
[ 1639.626095] nvmet: adding queue 14 to ctrl 805.
[ 1639.638198] nvmet: adding queue 15 to ctrl 805.
[ 1639.658514] nvmet: adding queue 16 to ctrl 805.
[ 1639.770677] nvmet: creating controller 806 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.825369] nvmet: adding queue 1 to ctrl 806.
[ 1639.825543] nvmet: adding queue 2 to ctrl 806.
[ 1639.825746] nvmet: adding queue 3 to ctrl 806.
[ 1639.825921] nvmet: adding queue 4 to ctrl 806.
[ 1639.826118] nvmet: adding queue 5 to ctrl 806.
[ 1639.826310] nvmet: adding queue 6 to ctrl 806.
[ 1639.826521] nvmet: adding queue 7 to ctrl 806.
[ 1639.826824] nvmet: adding queue 8 to ctrl 806.
[ 1639.827055] nvmet: adding queue 9 to ctrl 806.
[ 1639.827310] nvmet: adding queue 10 to ctrl 806.
[ 1639.827522] nvmet: adding queue 11 to ctrl 806.
[ 1639.827763] nvmet: adding queue 12 to ctrl 806.
[ 1639.827956] nvmet: adding queue 13 to ctrl 806.
[ 1639.828122] nvmet: adding queue 14 to ctrl 806.
[ 1639.828359] nvmet: adding queue 15 to ctrl 806.
[ 1639.828588] nvmet: adding queue 16 to ctrl 806.
[ 1639.930417] nvmet: creating controller 807 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1639.997753] nvmet: adding queue 1 to ctrl 807.
[ 1639.998046] nvmet: adding queue 2 to ctrl 807.
[ 1639.998255] nvmet: adding queue 3 to ctrl 807.
[ 1639.998483] nvmet: adding queue 4 to ctrl 807.
[ 1639.998739] nvmet: adding queue 5 to ctrl 807.
[ 1639.998965] nvmet: adding queue 6 to ctrl 807.
[ 1639.999139] nvmet: adding queue 7 to ctrl 807.
[ 1639.999443] nvmet: adding queue 8 to ctrl 807.
[ 1639.999703] nvmet: adding queue 9 to ctrl 807.
[ 1639.999977] nvmet: adding queue 10 to ctrl 807.
[ 1640.000293] nvmet: adding queue 11 to ctrl 807.
[ 1640.000573] nvmet: adding queue 12 to ctrl 807.
[ 1640.018945] nvmet: adding queue 13 to ctrl 807.
[ 1640.019153] nvmet: adding queue 14 to ctrl 807.
[ 1640.040532] nvmet: adding queue 15 to ctrl 807.
[ 1640.040843] nvmet: adding queue 16 to ctrl 807.
[ 1640.119279] nvmet_rdma: freeing queue 13713
[ 1640.120719] nvmet_rdma: freeing queue 13714
[ 1640.122153] nvmet_rdma: freeing queue 13715
[ 1640.123637] nvmet_rdma: freeing queue 13716
[ 1640.125009] nvmet_rdma: freeing queue 13717
[ 1640.126676] nvmet_rdma: freeing queue 13718
[ 1640.140673] nvmet: creating controller 808 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1640.195179] nvmet: adding queue 1 to ctrl 808.
[ 1640.195445] nvmet: adding queue 2 to ctrl 808.
[ 1640.195720] nvmet: adding queue 3 to ctrl 808.
[ 1640.195907] nvmet: adding queue 4 to ctrl 808.
[ 1640.217232] nvmet: adding queue 5 to ctrl 808.
[ 1640.217547] nvmet: adding queue 6 to ctrl 808.
[ 1640.226041] nvmet: ctrl 730 keep-alive timer (15 seconds) expired!
[ 1640.226043] nvmet: ctrl 730 fatal error occurred!
[ 1640.226278] nvmet: ctrl 728 keep-alive timer (15 seconds) expired!
[ 1640.226280] nvmet: ctrl 728 fatal error occurred!
[ 1640.271476] nvmet: adding queue 7 to ctrl 808.
[ 1640.271755] nvmet: adding queue 8 to ctrl 808.
[ 1640.291386] nvmet: adding queue 9 to ctrl 808.
[ 1640.291654] nvmet: adding queue 10 to ctrl 808.
[ 1640.291923] nvmet: adding queue 11 to ctrl 808.
[ 1640.292161] nvmet: adding queue 12 to ctrl 808.
[ 1640.292355] nvmet: adding queue 13 to ctrl 808.
[ 1640.292534] nvmet: adding queue 14 to ctrl 808.
[ 1640.292898] nvmet: adding queue 15 to ctrl 808.
[ 1640.293194] nvmet: adding queue 16 to ctrl 808.
[ 1640.380597] nvmet_rdma: freeing queue 13731
[ 1640.382089] nvmet_rdma: freeing queue 13732
[ 1640.383715] nvmet_rdma: freeing queue 13733
[ 1640.384873] nvmet_rdma: freeing queue 13734
[ 1640.386457] nvmet_rdma: freeing queue 13735
[ 1640.400545] nvmet: creating controller 809 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1640.454185] nvmet: adding queue 1 to ctrl 809.
[ 1640.454455] nvmet: adding queue 2 to ctrl 809.
[ 1640.454644] nvmet: adding queue 3 to ctrl 809.
[ 1640.454913] nvmet: adding queue 4 to ctrl 809.
[ 1640.455044] nvmet: adding queue 5 to ctrl 809.
[ 1640.455275] nvmet: adding queue 6 to ctrl 809.
[ 1640.455426] nvmet: adding queue 7 to ctrl 809.
[ 1640.455642] nvmet: adding queue 8 to ctrl 809.
[ 1640.472153] nvmet: adding queue 9 to ctrl 809.
[ 1640.492408] nvmet: adding queue 10 to ctrl 809.
[ 1640.492647] nvmet: adding queue 11 to ctrl 809.
[ 1640.492846] nvmet: adding queue 12 to ctrl 809.
[ 1640.493112] nvmet: adding queue 13 to ctrl 809.
[ 1640.493467] nvmet: adding queue 14 to ctrl 809.
[ 1640.493723] nvmet: adding queue 15 to ctrl 809.
[ 1640.493980] nvmet: adding queue 16 to ctrl 809.
[ 1640.608145] nvmet_rdma: freeing queue 13736
[ 1640.620450] nvmet: creating controller 810 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1640.678232] nvmet: adding queue 1 to ctrl 810.
[ 1640.678388] nvmet: adding queue 2 to ctrl 810.
[ 1640.678605] nvmet: adding queue 3 to ctrl 810.
[ 1640.678808] nvmet: adding queue 4 to ctrl 810.
[ 1640.678983] nvmet: adding queue 5 to ctrl 810.
[ 1640.679188] nvmet: adding queue 6 to ctrl 810.
[ 1640.679370] nvmet: adding queue 7 to ctrl 810.
[ 1640.679569] nvmet: adding queue 8 to ctrl 810.
[ 1640.679805] nvmet: adding queue 9 to ctrl 810.
[ 1640.680038] nvmet: adding queue 10 to ctrl 810.
[ 1640.680231] nvmet: adding queue 11 to ctrl 810.
[ 1640.687604] nvmet: adding queue 12 to ctrl 810.
[ 1640.687765] nvmet: adding queue 13 to ctrl 810.
[ 1640.687945] nvmet: adding queue 14 to ctrl 810.
[ 1640.688308] nvmet: adding queue 15 to ctrl 810.
[ 1640.688538] nvmet: adding queue 16 to ctrl 810.
[ 1640.763821] nvmet_rdma: freeing queue 13754
[ 1640.768780] nvmet_rdma: freeing queue 13757
[ 1640.770437] nvmet_rdma: freeing queue 13758
[ 1640.771979] nvmet_rdma: freeing queue 13759
[ 1640.773324] nvmet_rdma: freeing queue 13760
[ 1640.800195] nvmet: creating controller 811 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1640.853744] nvmet: adding queue 1 to ctrl 811.
[ 1640.853958] nvmet: adding queue 2 to ctrl 811.
[ 1640.854143] nvmet: adding queue 3 to ctrl 811.
[ 1640.854344] nvmet: adding queue 4 to ctrl 811.
[ 1640.854524] nvmet: adding queue 5 to ctrl 811.
[ 1640.854696] nvmet: adding queue 6 to ctrl 811.
[ 1640.859187] nvmet: adding queue 7 to ctrl 811.
[ 1640.859389] nvmet: adding queue 8 to ctrl 811.
[ 1640.877594] nvmet: adding queue 9 to ctrl 811.
[ 1640.877863] nvmet: adding queue 10 to ctrl 811.
[ 1640.878095] nvmet: adding queue 11 to ctrl 811.
[ 1640.878373] nvmet: adding queue 12 to ctrl 811.
[ 1640.878611] nvmet: adding queue 13 to ctrl 811.
[ 1640.878826] nvmet: adding queue 14 to ctrl 811.
[ 1640.879079] nvmet: adding queue 15 to ctrl 811.
[ 1640.895915] nvmet: adding queue 16 to ctrl 811.
[ 1640.969347] nvmet_rdma: freeing queue 13781
[ 1640.970737] nvmet_rdma: freeing queue 13782
[ 1640.972136] nvmet_rdma: freeing queue 13783
[ 1640.973592] nvmet_rdma: freeing queue 13784
[ 1640.975172] nvmet_rdma: freeing queue 13785
[ 1640.978611] nvmet_rdma: freeing queue 13770
[ 1640.990660] nvmet: creating controller 812 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1641.045882] nvmet: adding queue 1 to ctrl 812.
[ 1641.046106] nvmet: adding queue 2 to ctrl 812.
[ 1641.065841] nvmet: adding queue 3 to ctrl 812.
[ 1641.066089] nvmet: adding queue 4 to ctrl 812.
[ 1641.066400] nvmet: adding queue 5 to ctrl 812.
[ 1641.066693] nvmet: adding queue 6 to ctrl 812.
[ 1641.067027] nvmet: adding queue 7 to ctrl 812.
[ 1641.067279] nvmet: adding queue 8 to ctrl 812.
[ 1641.067515] nvmet: adding queue 9 to ctrl 812.
[ 1641.067843] nvmet: adding queue 10 to ctrl 812.
[ 1641.068146] nvmet: adding queue 11 to ctrl 812.
[ 1641.068390] nvmet: adding queue 12 to ctrl 812.
[ 1641.068639] nvmet: adding queue 13 to ctrl 812.
[ 1641.068815] nvmet: adding queue 14 to ctrl 812.
[ 1641.069104] nvmet: adding queue 15 to ctrl 812.
[ 1641.069340] nvmet: adding queue 16 to ctrl 812.
[ 1641.123635] nvmet_rdma: freeing queue 13788
[ 1641.125831] nvmet_rdma: freeing queue 13789
[ 1641.160708] nvmet: creating controller 813 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1641.214583] nvmet: adding queue 1 to ctrl 813.
[ 1641.214763] nvmet: adding queue 2 to ctrl 813.
[ 1641.229842] nvmet: adding queue 3 to ctrl 813.
[ 1641.252317] nvmet: adding queue 4 to ctrl 813.
[ 1641.252622] nvmet: adding queue 5 to ctrl 813.
[ 1641.252941] nvmet: adding queue 6 to ctrl 813.
[ 1641.253296] nvmet: adding queue 7 to ctrl 813.
[ 1641.253561] nvmet: adding queue 8 to ctrl 813.
[ 1641.253836] nvmet: adding queue 9 to ctrl 813.
[ 1641.254229] nvmet: adding queue 10 to ctrl 813.
[ 1641.254504] nvmet: adding queue 11 to ctrl 813.
[ 1641.254839] nvmet: adding queue 12 to ctrl 813.
[ 1641.255113] nvmet: adding queue 13 to ctrl 813.
[ 1641.255383] nvmet: adding queue 14 to ctrl 813.
[ 1641.255646] nvmet: adding queue 15 to ctrl 813.
[ 1641.255899] nvmet: adding queue 16 to ctrl 813.
[ 1641.323876] nvmet_rdma: freeing queue 13805
[ 1641.325906] nvmet_rdma: freeing queue 13806
[ 1641.327901] nvmet_rdma: freeing queue 13807
[ 1641.346765] nvmet_rdma: freeing queue 13820
[ 1641.348215] nvmet_rdma: freeing queue 13804
[ 1641.360849] nvmet: creating controller 814 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1641.413135] nvmet: adding queue 1 to ctrl 814.
[ 1641.413319] nvmet: adding queue 2 to ctrl 814.
[ 1641.413541] nvmet: adding queue 3 to ctrl 814.
[ 1641.413743] nvmet: adding queue 4 to ctrl 814.
[ 1641.414005] nvmet: adding queue 5 to ctrl 814.
[ 1641.425353] nvmet: adding queue 6 to ctrl 814.
[ 1641.425555] nvmet: adding queue 7 to ctrl 814.
[ 1641.425847] nvmet: adding queue 8 to ctrl 814.
[ 1641.426072] nvmet: adding queue 9 to ctrl 814.
[ 1641.426342] nvmet: adding queue 10 to ctrl 814.
[ 1641.426602] nvmet: adding queue 11 to ctrl 814.
[ 1641.426834] nvmet: adding queue 12 to ctrl 814.
[ 1641.427065] nvmet: adding queue 13 to ctrl 814.
[ 1641.427249] nvmet: adding queue 14 to ctrl 814.
[ 1641.427532] nvmet: adding queue 15 to ctrl 814.
[ 1641.427752] nvmet: adding queue 16 to ctrl 814.
[ 1641.550205] nvmet: creating controller 815 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1641.608246] nvmet: adding queue 1 to ctrl 815.
[ 1641.608447] nvmet: adding queue 2 to ctrl 815.
[ 1641.628412] nvmet: adding queue 3 to ctrl 815.
[ 1641.628710] nvmet: adding queue 4 to ctrl 815.
[ 1641.628950] nvmet: adding queue 5 to ctrl 815.
[ 1641.629216] nvmet: adding queue 6 to ctrl 815.
[ 1641.629582] nvmet: adding queue 7 to ctrl 815.
[ 1641.629779] nvmet: adding queue 8 to ctrl 815.
[ 1641.630026] nvmet: adding queue 9 to ctrl 815.
[ 1641.648690] nvmet: adding queue 10 to ctrl 815.
[ 1641.648997] nvmet: adding queue 11 to ctrl 815.
[ 1641.669000] nvmet: adding queue 12 to ctrl 815.
[ 1641.669282] nvmet: adding queue 13 to ctrl 815.
[ 1641.687308] nvmet: adding queue 14 to ctrl 815.
[ 1641.687561] nvmet: adding queue 15 to ctrl 815.
[ 1641.687873] nvmet: adding queue 16 to ctrl 815.
[ 1641.773713] nvmet_rdma: freeing queue 13839
[ 1641.775739] nvmet_rdma: freeing queue 13840
[ 1641.777741] nvmet_rdma: freeing queue 13841
[ 1641.778963] nvmet_rdma: freeing queue 13842
[ 1641.780468] nvmet_rdma: freeing queue 13843
[ 1641.781883] nvmet_rdma: freeing queue 13844
[ 1641.792222] nvmet_rdma: freeing queue 13851
[ 1641.793356] nvmet_rdma: freeing queue 13852
[ 1641.795490] nvmet_rdma: freeing queue 13853
[ 1641.796922] nvmet_rdma: freeing queue 13854
[ 1641.810892] nvmet: creating controller 816 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1641.864684] nvmet: adding queue 1 to ctrl 816.
[ 1641.864836] nvmet: adding queue 2 to ctrl 816.
[ 1641.865024] nvmet: adding queue 3 to ctrl 816.
[ 1641.865203] nvmet: adding queue 4 to ctrl 816.
[ 1641.865344] nvmet: adding queue 5 to ctrl 816.
[ 1641.865538] nvmet: adding queue 6 to ctrl 816.
[ 1641.865734] nvmet: adding queue 7 to ctrl 816.
[ 1641.865904] nvmet: adding queue 8 to ctrl 816.
[ 1641.866150] nvmet: adding queue 9 to ctrl 816.
[ 1641.866356] nvmet: adding queue 10 to ctrl 816.
[ 1641.866562] nvmet: adding queue 11 to ctrl 816.
[ 1641.866764] nvmet: adding queue 12 to ctrl 816.
[ 1641.866983] nvmet: adding queue 13 to ctrl 816.
[ 1641.884001] nvmet: adding queue 14 to ctrl 816.
[ 1641.903844] nvmet: adding queue 15 to ctrl 816.
[ 1641.904148] nvmet: adding queue 16 to ctrl 816.
[ 1642.009646] nvmet: creating controller 817 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.063628] nvmet: adding queue 1 to ctrl 817.
[ 1642.063901] nvmet: adding queue 2 to ctrl 817.
[ 1642.064087] nvmet: adding queue 3 to ctrl 817.
[ 1642.064288] nvmet: adding queue 4 to ctrl 817.
[ 1642.064455] nvmet: adding queue 5 to ctrl 817.
[ 1642.064631] nvmet: adding queue 6 to ctrl 817.
[ 1642.064849] nvmet: adding queue 7 to ctrl 817.
[ 1642.065035] nvmet: adding queue 8 to ctrl 817.
[ 1642.065223] nvmet: adding queue 9 to ctrl 817.
[ 1642.065492] nvmet: adding queue 10 to ctrl 817.
[ 1642.065720] nvmet: adding queue 11 to ctrl 817.
[ 1642.065967] nvmet: adding queue 12 to ctrl 817.
[ 1642.066143] nvmet: adding queue 13 to ctrl 817.
[ 1642.066384] nvmet: adding queue 14 to ctrl 817.
[ 1642.066575] nvmet: adding queue 15 to ctrl 817.
[ 1642.066804] nvmet: adding queue 16 to ctrl 817.
[ 1642.156346] nvmet_rdma: freeing queue 13881
[ 1642.157827] nvmet_rdma: freeing queue 13882
[ 1642.160562] nvmet_rdma: freeing queue 13884
[ 1642.179974] nvmet: creating controller 818 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.233538] nvmet: adding queue 1 to ctrl 818.
[ 1642.233716] nvmet: adding queue 2 to ctrl 818.
[ 1642.233908] nvmet: adding queue 3 to ctrl 818.
[ 1642.234087] nvmet: adding queue 4 to ctrl 818.
[ 1642.234294] nvmet: adding queue 5 to ctrl 818.
[ 1642.234490] nvmet: adding queue 6 to ctrl 818.
[ 1642.234661] nvmet: adding queue 7 to ctrl 818.
[ 1642.234849] nvmet: adding queue 8 to ctrl 818.
[ 1642.235008] nvmet: adding queue 9 to ctrl 818.
[ 1642.235252] nvmet: adding queue 10 to ctrl 818.
[ 1642.235469] nvmet: adding queue 11 to ctrl 818.
[ 1642.239663] nvmet: adding queue 12 to ctrl 818.
[ 1642.239892] nvmet: adding queue 13 to ctrl 818.
[ 1642.264388] nvmet: adding queue 14 to ctrl 818.
[ 1642.264744] nvmet: adding queue 15 to ctrl 818.
[ 1642.264987] nvmet: adding queue 16 to ctrl 818.
[ 1642.350497] nvmet_rdma: freeing queue 13901
[ 1642.351733] nvmet_rdma: freeing queue 13902
[ 1642.353537] nvmet_rdma: freeing queue 13903
[ 1642.354860] nvmet_rdma: freeing queue 13904
[ 1642.370593] nvmet: creating controller 819 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.426270] nvmet: adding queue 1 to ctrl 819.
[ 1642.426463] nvmet: adding queue 2 to ctrl 819.
[ 1642.426626] nvmet: adding queue 3 to ctrl 819.
[ 1642.428701] nvmet: adding queue 4 to ctrl 819.
[ 1642.428934] nvmet: adding queue 5 to ctrl 819.
[ 1642.449204] nvmet: adding queue 6 to ctrl 819.
[ 1642.449522] nvmet: adding queue 7 to ctrl 819.
[ 1642.499925] nvmet: adding queue 8 to ctrl 819.
[ 1642.500140] nvmet: adding queue 9 to ctrl 819.
[ 1642.500436] nvmet: adding queue 10 to ctrl 819.
[ 1642.500696] nvmet: adding queue 11 to ctrl 819.
[ 1642.500981] nvmet: adding queue 12 to ctrl 819.
[ 1642.501155] nvmet: adding queue 13 to ctrl 819.
[ 1642.501383] nvmet: adding queue 14 to ctrl 819.
[ 1642.501717] nvmet: adding queue 15 to ctrl 819.
[ 1642.502001] nvmet: adding queue 16 to ctrl 819.
[ 1642.589742] nvmet: creating controller 820 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.643475] nvmet: adding queue 1 to ctrl 820.
[ 1642.643689] nvmet: adding queue 2 to ctrl 820.
[ 1642.643892] nvmet: adding queue 3 to ctrl 820.
[ 1642.644115] nvmet: adding queue 4 to ctrl 820.
[ 1642.644323] nvmet: adding queue 5 to ctrl 820.
[ 1642.644514] nvmet: adding queue 6 to ctrl 820.
[ 1642.644678] nvmet: adding queue 7 to ctrl 820.
[ 1642.659020] nvmet: adding queue 8 to ctrl 820.
[ 1642.678900] nvmet: adding queue 9 to ctrl 820.
[ 1642.679190] nvmet: adding queue 10 to ctrl 820.
[ 1642.679463] nvmet: adding queue 11 to ctrl 820.
[ 1642.679802] nvmet: adding queue 12 to ctrl 820.
[ 1642.680040] nvmet: adding queue 13 to ctrl 820.
[ 1642.680255] nvmet: adding queue 14 to ctrl 820.
[ 1642.680568] nvmet: adding queue 15 to ctrl 820.
[ 1642.680836] nvmet: adding queue 16 to ctrl 820.
[ 1642.769800] nvmet: creating controller 821 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.795930] nvmet: ctrl 741 keep-alive timer (15 seconds) expired!
[ 1642.795932] nvmet: ctrl 741 fatal error occurred!
[ 1642.823223] nvmet: adding queue 1 to ctrl 821.
[ 1642.823421] nvmet: adding queue 2 to ctrl 821.
[ 1642.823715] nvmet: adding queue 3 to ctrl 821.
[ 1642.823933] nvmet: adding queue 4 to ctrl 821.
[ 1642.824087] nvmet: adding queue 5 to ctrl 821.
[ 1642.824280] nvmet: adding queue 6 to ctrl 821.
[ 1642.824434] nvmet: adding queue 7 to ctrl 821.
[ 1642.824734] nvmet: adding queue 8 to ctrl 821.
[ 1642.825004] nvmet: adding queue 9 to ctrl 821.
[ 1642.825229] nvmet: adding queue 10 to ctrl 821.
[ 1642.826742] nvmet: adding queue 11 to ctrl 821.
[ 1642.827024] nvmet: adding queue 12 to ctrl 821.
[ 1642.827271] nvmet: adding queue 13 to ctrl 821.
[ 1642.827475] nvmet: adding queue 14 to ctrl 821.
[ 1642.827745] nvmet: adding queue 15 to ctrl 821.
[ 1642.828039] nvmet: adding queue 16 to ctrl 821.
[ 1642.875834] nvmet_rdma: freeing queue 13942
[ 1642.877621] nvmet_rdma: freeing queue 13943
[ 1642.909425] nvmet: creating controller 822 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1642.961556] nvmet: adding queue 1 to ctrl 822.
[ 1642.961825] nvmet: adding queue 2 to ctrl 822.
[ 1642.962084] nvmet: adding queue 3 to ctrl 822.
[ 1642.962309] nvmet: adding queue 4 to ctrl 822.
[ 1642.962468] nvmet: adding queue 5 to ctrl 822.
[ 1642.975340] nvmet: adding queue 6 to ctrl 822.
[ 1642.975647] nvmet: adding queue 7 to ctrl 822.
[ 1642.995364] nvmet: adding queue 8 to ctrl 822.
[ 1642.995631] nvmet: adding queue 9 to ctrl 822.
[ 1642.995866] nvmet: adding queue 10 to ctrl 822.
[ 1642.996218] nvmet: adding queue 11 to ctrl 822.
[ 1642.996506] nvmet: adding queue 12 to ctrl 822.
[ 1642.996756] nvmet: adding queue 13 to ctrl 822.
[ 1642.997029] nvmet: adding queue 14 to ctrl 822.
[ 1643.015244] nvmet: adding queue 15 to ctrl 822.
[ 1643.015651] nvmet: adding queue 16 to ctrl 822.
[ 1643.102017] nvmet_rdma: freeing queue 13970
[ 1643.103595] nvmet_rdma: freeing queue 13971
[ 1643.105204] nvmet_rdma: freeing queue 13972
[ 1643.120193] nvmet: creating controller 823 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1643.172860] nvmet: adding queue 1 to ctrl 823.
[ 1643.178272] nvmet: adding queue 2 to ctrl 823.
[ 1643.178464] nvmet: adding queue 3 to ctrl 823.
[ 1643.178673] nvmet: adding queue 4 to ctrl 823.
[ 1643.178884] nvmet: adding queue 5 to ctrl 823.
[ 1643.179033] nvmet: adding queue 6 to ctrl 823.
[ 1643.179217] nvmet: adding queue 7 to ctrl 823.
[ 1643.179421] nvmet: adding queue 8 to ctrl 823.
[ 1643.179652] nvmet: adding queue 9 to ctrl 823.
[ 1643.179906] nvmet: adding queue 10 to ctrl 823.
[ 1643.180133] nvmet: adding queue 11 to ctrl 823.
[ 1643.180436] nvmet: adding queue 12 to ctrl 823.
[ 1643.180653] nvmet: adding queue 13 to ctrl 823.
[ 1643.180864] nvmet: adding queue 14 to ctrl 823.
[ 1643.181130] nvmet: adding queue 15 to ctrl 823.
[ 1643.181362] nvmet: adding queue 16 to ctrl 823.
[ 1643.289983] nvmet: creating controller 824 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1643.342375] nvmet: adding queue 1 to ctrl 824.
[ 1643.352797] nvmet: adding queue 2 to ctrl 824.
[ 1643.372710] nvmet: adding queue 3 to ctrl 824.
[ 1643.372944] nvmet: adding queue 4 to ctrl 824.
[ 1643.373237] nvmet: adding queue 5 to ctrl 824.
[ 1643.373522] nvmet: adding queue 6 to ctrl 824.
[ 1643.373807] nvmet: adding queue 7 to ctrl 824.
[ 1643.374085] nvmet: adding queue 8 to ctrl 824.
[ 1643.374347] nvmet: adding queue 9 to ctrl 824.
[ 1643.374605] nvmet: adding queue 10 to ctrl 824.
[ 1643.374854] nvmet: adding queue 11 to ctrl 824.
[ 1643.375180] nvmet: adding queue 12 to ctrl 824.
[ 1643.375398] nvmet: adding queue 13 to ctrl 824.
[ 1643.375596] nvmet: adding queue 14 to ctrl 824.
[ 1643.376011] nvmet: adding queue 15 to ctrl 824.
[ 1643.376244] nvmet: adding queue 16 to ctrl 824.
[ 1643.500462] nvmet: creating controller 825 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1643.554334] nvmet: adding queue 1 to ctrl 825.
[ 1643.554518] nvmet: adding queue 2 to ctrl 825.
[ 1643.554726] nvmet: adding queue 3 to ctrl 825.
[ 1643.554991] nvmet: adding queue 4 to ctrl 825.
[ 1643.563877] nvmet: adding queue 5 to ctrl 825.
[ 1643.564085] nvmet: adding queue 6 to ctrl 825.
[ 1643.564352] nvmet: adding queue 7 to ctrl 825.
[ 1643.564571] nvmet: adding queue 8 to ctrl 825.
[ 1643.564801] nvmet: adding queue 9 to ctrl 825.
[ 1643.565069] nvmet: adding queue 10 to ctrl 825.
[ 1643.565343] nvmet: adding queue 11 to ctrl 825.
[ 1643.565559] nvmet: adding queue 12 to ctrl 825.
[ 1643.565702] nvmet: adding queue 13 to ctrl 825.
[ 1643.565890] nvmet: adding queue 14 to ctrl 825.
[ 1643.566198] nvmet: adding queue 15 to ctrl 825.
[ 1643.566517] nvmet: adding queue 16 to ctrl 825.
[ 1643.640336] nvmet_rdma: freeing queue 14013
[ 1643.641867] nvmet_rdma: freeing queue 14014
[ 1643.643290] nvmet_rdma: freeing queue 14015
[ 1643.644628] nvmet_rdma: freeing queue 14016
[ 1643.650872] nvmet_rdma: freeing queue 14020
[ 1643.653593] nvmet_rdma: freeing queue 14022
[ 1643.654851] nvmet_rdma: freeing queue 14023
[ 1643.669987] nvmet: creating controller 826 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1643.725321] nvmet: adding queue 1 to ctrl 826.
[ 1643.742514] nvmet: adding queue 2 to ctrl 826.
[ 1643.742797] nvmet: adding queue 3 to ctrl 826.
[ 1643.743082] nvmet: adding queue 4 to ctrl 826.
[ 1643.743361] nvmet: adding queue 5 to ctrl 826.
[ 1643.743665] nvmet: adding queue 6 to ctrl 826.
[ 1643.743959] nvmet: adding queue 7 to ctrl 826.
[ 1643.744265] nvmet: adding queue 8 to ctrl 826.
[ 1643.764167] nvmet: adding queue 9 to ctrl 826.
[ 1643.764535] nvmet: adding queue 10 to ctrl 826.
[ 1643.788451] nvmet: adding queue 11 to ctrl 826.
[ 1643.788720] nvmet: adding queue 12 to ctrl 826.
[ 1643.810281] nvmet: adding queue 13 to ctrl 826.
[ 1643.810501] nvmet: adding queue 14 to ctrl 826.
[ 1643.810803] nvmet: adding queue 15 to ctrl 826.
[ 1643.811047] nvmet: adding queue 16 to ctrl 826.
[ 1643.876227] nvmet_rdma: freeing queue 14027
[ 1643.877635] nvmet_rdma: freeing queue 14028
[ 1643.879176] nvmet_rdma: freeing queue 14029
[ 1643.880672] nvmet_rdma: freeing queue 14030
[ 1643.884862] nvmet_rdma: freeing queue 14033
[ 1643.892623] nvmet_rdma: freeing queue 14038
[ 1643.893675] nvmet_rdma: freeing queue 14039
[ 1643.910255] nvmet: creating controller 827 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1643.964415] nvmet: adding queue 1 to ctrl 827.
[ 1643.964624] nvmet: adding queue 2 to ctrl 827.
[ 1643.964824] nvmet: adding queue 3 to ctrl 827.
[ 1643.965002] nvmet: adding queue 4 to ctrl 827.
[ 1643.965206] nvmet: adding queue 5 to ctrl 827.
[ 1643.965380] nvmet: adding queue 6 to ctrl 827.
[ 1643.965548] nvmet: adding queue 7 to ctrl 827.
[ 1643.965751] nvmet: adding queue 8 to ctrl 827.
[ 1643.965957] nvmet: adding queue 9 to ctrl 827.
[ 1643.966215] nvmet: adding queue 10 to ctrl 827.
[ 1643.966474] nvmet: adding queue 11 to ctrl 827.
[ 1643.966773] nvmet: adding queue 12 to ctrl 827.
[ 1643.978641] nvmet: adding queue 13 to ctrl 827.
[ 1643.999967] nvmet: adding queue 14 to ctrl 827.
[ 1644.000278] nvmet: adding queue 15 to ctrl 827.
[ 1644.000541] nvmet: adding queue 16 to ctrl 827.
[ 1644.065857] nvmet: ctrl 750 keep-alive timer (15 seconds) expired!
[ 1644.065859] nvmet: ctrl 750 fatal error occurred!
[ 1644.065873] nvmet: ctrl 748 keep-alive timer (15 seconds) expired!
[ 1644.065876] nvmet: ctrl 748 fatal error occurred!
[ 1644.066136] nvmet: ctrl 747 keep-alive timer (15 seconds) expired!
[ 1644.066138] nvmet: ctrl 747 fatal error occurred!
[ 1644.070529] nvmet_rdma: freeing queue 14054
[ 1644.073506] nvmet_rdma: freeing queue 14056
[ 1644.074895] nvmet_rdma: freeing queue 14057
[ 1644.078349] nvmet_rdma: freeing queue 14042
[ 1644.090745] nvmet: creating controller 828 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1644.143147] nvmet: adding queue 1 to ctrl 828.
[ 1644.143333] nvmet: adding queue 2 to ctrl 828.
[ 1644.143563] nvmet: adding queue 3 to ctrl 828.
[ 1644.143761] nvmet: adding queue 4 to ctrl 828.
[ 1644.143930] nvmet: adding queue 5 to ctrl 828.
[ 1644.144148] nvmet: adding queue 6 to ctrl 828.
[ 1644.144406] nvmet: adding queue 7 to ctrl 828.
[ 1644.144588] nvmet: adding queue 8 to ctrl 828.
[ 1644.144778] nvmet: adding queue 9 to ctrl 828.
[ 1644.145042] nvmet: adding queue 10 to ctrl 828.
[ 1644.145308] nvmet: adding queue 11 to ctrl 828.
[ 1644.145538] nvmet: adding queue 12 to ctrl 828.
[ 1644.145748] nvmet: adding queue 13 to ctrl 828.
[ 1644.146002] nvmet: adding queue 14 to ctrl 828.
[ 1644.146229] nvmet: adding queue 15 to ctrl 828.
[ 1644.158685] nvmet: adding queue 16 to ctrl 828.
[ 1644.250241] nvmet: creating controller 829 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1644.305380] nvmet: adding queue 1 to ctrl 829.
[ 1644.305585] nvmet: adding queue 2 to ctrl 829.
[ 1644.305742] nvmet: adding queue 3 to ctrl 829.
[ 1644.305961] nvmet: adding queue 4 to ctrl 829.
[ 1644.306181] nvmet: adding queue 5 to ctrl 829.
[ 1644.306319] nvmet: adding queue 6 to ctrl 829.
[ 1644.306475] nvmet: adding queue 7 to ctrl 829.
[ 1644.306670] nvmet: adding queue 8 to ctrl 829.
[ 1644.306836] nvmet: adding queue 9 to ctrl 829.
[ 1644.307047] nvmet: adding queue 10 to ctrl 829.
[ 1644.316601] nvmet: adding queue 11 to ctrl 829.
[ 1644.316849] nvmet: adding queue 12 to ctrl 829.
[ 1644.337407] nvmet: adding queue 13 to ctrl 829.
[ 1644.337659] nvmet: adding queue 14 to ctrl 829.
[ 1644.337920] nvmet: adding queue 15 to ctrl 829.
[ 1644.338225] nvmet: adding queue 16 to ctrl 829.
[ 1644.383638] nvmet_rdma: freeing queue 14077
[ 1644.390514] nvmet_rdma: freeing queue 14081
[ 1644.392890] nvmet_rdma: freeing queue 14083
[ 1644.400335] nvmet_rdma: freeing queue 14088
[ 1644.403193] nvmet_rdma: freeing queue 14090
[ 1644.404427] nvmet_rdma: freeing queue 14091
[ 1644.407689] nvmet_rdma: freeing queue 14076
[ 1644.420035] nvmet: creating controller 830 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1644.473670] nvmet: adding queue 1 to ctrl 830.
[ 1644.473933] nvmet: adding queue 2 to ctrl 830.
[ 1644.484038] nvmet: adding queue 3 to ctrl 830.
[ 1644.484260] nvmet: adding queue 4 to ctrl 830.
[ 1644.504943] nvmet: adding queue 5 to ctrl 830.
[ 1644.505258] nvmet: adding queue 6 to ctrl 830.
[ 1644.526263] nvmet: adding queue 7 to ctrl 830.
[ 1644.526540] nvmet: adding queue 8 to ctrl 830.
[ 1644.526818] nvmet: adding queue 9 to ctrl 830.
[ 1644.527130] nvmet: adding queue 10 to ctrl 830.
[ 1644.527545] nvmet: adding queue 11 to ctrl 830.
[ 1644.527815] nvmet: adding queue 12 to ctrl 830.
[ 1644.528142] nvmet: adding queue 13 to ctrl 830.
[ 1644.528481] nvmet: adding queue 14 to ctrl 830.
[ 1644.528731] nvmet: adding queue 15 to ctrl 830.
[ 1644.528981] nvmet: adding queue 16 to ctrl 830.
[ 1644.610585] nvmet: creating controller 831 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1644.663667] nvmet: adding queue 1 to ctrl 831.
[ 1644.663886] nvmet: adding queue 2 to ctrl 831.
[ 1644.664108] nvmet: adding queue 3 to ctrl 831.
[ 1644.664416] nvmet: adding queue 4 to ctrl 831.
[ 1644.664610] nvmet: adding queue 5 to ctrl 831.
[ 1644.664813] nvmet: adding queue 6 to ctrl 831.
[ 1644.685078] nvmet: adding queue 7 to ctrl 831.
[ 1644.705866] nvmet: adding queue 8 to ctrl 831.
[ 1644.706098] nvmet: adding queue 9 to ctrl 831.
[ 1644.706378] nvmet: adding queue 10 to ctrl 831.
[ 1644.706689] nvmet: adding queue 11 to ctrl 831.
[ 1644.706981] nvmet: adding queue 12 to ctrl 831.
[ 1644.707227] nvmet: adding queue 13 to ctrl 831.
[ 1644.707476] nvmet: adding queue 14 to ctrl 831.
[ 1644.707727] nvmet: adding queue 15 to ctrl 831.
[ 1644.708009] nvmet: adding queue 16 to ctrl 831.
[ 1644.809260] nvmet: creating controller 832 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1644.864038] nvmet: adding queue 1 to ctrl 832.
[ 1644.864233] nvmet: adding queue 2 to ctrl 832.
[ 1644.864422] nvmet: adding queue 3 to ctrl 832.
[ 1644.864659] nvmet: adding queue 4 to ctrl 832.
[ 1644.864845] nvmet: adding queue 5 to ctrl 832.
[ 1644.865009] nvmet: adding queue 6 to ctrl 832.
[ 1644.865197] nvmet: adding queue 7 to ctrl 832.
[ 1644.865410] nvmet: adding queue 8 to ctrl 832.
[ 1644.865608] nvmet: adding queue 9 to ctrl 832.
[ 1644.884933] nvmet: adding queue 10 to ctrl 832.
[ 1644.885169] nvmet: adding queue 11 to ctrl 832.
[ 1644.885475] nvmet: adding queue 12 to ctrl 832.
[ 1644.885717] nvmet: adding queue 13 to ctrl 832.
[ 1644.885984] nvmet: adding queue 14 to ctrl 832.
[ 1644.886267] nvmet: adding queue 15 to ctrl 832.
[ 1644.886537] nvmet: adding queue 16 to ctrl 832.
[ 1644.938574] nvmet_rdma: freeing queue 14131
[ 1644.940136] nvmet_rdma: freeing queue 14132
[ 1644.945749] nvmet_rdma: freeing queue 14136
[ 1644.952065] nvmet_rdma: freeing queue 14140
[ 1644.954654] nvmet_rdma: freeing queue 14142
[ 1644.956223] nvmet_rdma: freeing queue 14143
[ 1644.957684] nvmet_rdma: freeing queue 14127
[ 1644.969994] nvmet: creating controller 833 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1645.023879] nvmet: adding queue 1 to ctrl 833.
[ 1645.024080] nvmet: adding queue 2 to ctrl 833.
[ 1645.024312] nvmet: adding queue 3 to ctrl 833.
[ 1645.024506] nvmet: adding queue 4 to ctrl 833.
[ 1645.033968] nvmet: adding queue 5 to ctrl 833.
[ 1645.034107] nvmet: adding queue 6 to ctrl 833.
[ 1645.087147] nvmet: adding queue 7 to ctrl 833.
[ 1645.087421] nvmet: adding queue 8 to ctrl 833.
[ 1645.087637] nvmet: adding queue 9 to ctrl 833.
[ 1645.087929] nvmet: adding queue 10 to ctrl 833.
[ 1645.088203] nvmet: adding queue 11 to ctrl 833.
[ 1645.088496] nvmet: adding queue 12 to ctrl 833.
[ 1645.088744] nvmet: adding queue 13 to ctrl 833.
[ 1645.108667] nvmet: adding queue 14 to ctrl 833.
[ 1645.108993] nvmet: adding queue 15 to ctrl 833.
[ 1645.129508] nvmet: adding queue 16 to ctrl 833.
[ 1645.250684] nvmet: creating controller 834 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1645.320221] nvmet: adding queue 1 to ctrl 834.
[ 1645.320406] nvmet: adding queue 2 to ctrl 834.
[ 1645.320611] nvmet: adding queue 3 to ctrl 834.
[ 1645.320794] nvmet: adding queue 4 to ctrl 834.
[ 1645.320937] nvmet: adding queue 5 to ctrl 834.
[ 1645.321135] nvmet: adding queue 6 to ctrl 834.
[ 1645.321352] nvmet: adding queue 7 to ctrl 834.
[ 1645.321601] nvmet: adding queue 8 to ctrl 834.
[ 1645.321859] nvmet: adding queue 9 to ctrl 834.
[ 1645.322118] nvmet: adding queue 10 to ctrl 834.
[ 1645.322375] nvmet: adding queue 11 to ctrl 834.
[ 1645.322704] nvmet: adding queue 12 to ctrl 834.
[ 1645.322961] nvmet: adding queue 13 to ctrl 834.
[ 1645.323217] nvmet: adding queue 14 to ctrl 834.
[ 1645.323541] nvmet: adding queue 15 to ctrl 834.
[ 1645.323847] nvmet: adding queue 16 to ctrl 834.
[ 1645.345824] nvmet: ctrl 757 keep-alive timer (15 seconds) expired!
[ 1645.345826] nvmet: ctrl 756 keep-alive timer (15 seconds) expired!
[ 1645.345827] nvmet: ctrl 757 fatal error occurred!
[ 1645.345829] nvmet: ctrl 756 fatal error occurred!
[ 1645.459884] nvmet: creating controller 835 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1645.525324] nvmet: adding queue 1 to ctrl 835.
[ 1645.546119] nvmet: adding queue 2 to ctrl 835.
[ 1645.546386] nvmet: adding queue 3 to ctrl 835.
[ 1645.546685] nvmet: adding queue 4 to ctrl 835.
[ 1645.546985] nvmet: adding queue 5 to ctrl 835.
[ 1645.547280] nvmet: adding queue 6 to ctrl 835.
[ 1645.547551] nvmet: adding queue 7 to ctrl 835.
[ 1645.547843] nvmet: adding queue 8 to ctrl 835.
[ 1645.548055] nvmet: adding queue 9 to ctrl 835.
[ 1645.548305] nvmet: adding queue 10 to ctrl 835.
[ 1645.548576] nvmet: adding queue 11 to ctrl 835.
[ 1645.548819] nvmet: adding queue 12 to ctrl 835.
[ 1645.549002] nvmet: adding queue 13 to ctrl 835.
[ 1645.549280] nvmet: adding queue 14 to ctrl 835.
[ 1645.549589] nvmet: adding queue 15 to ctrl 835.
[ 1645.549838] nvmet: adding queue 16 to ctrl 835.
[ 1645.608624] nvmet_rdma: freeing queue 14182
[ 1645.612993] nvmet_rdma: freeing queue 14185
[ 1645.614606] nvmet_rdma: freeing queue 14186
[ 1645.615828] nvmet_rdma: freeing queue 14187
[ 1645.639848] nvmet: creating controller 836 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1645.694165] nvmet: adding queue 1 to ctrl 836.
[ 1645.694390] nvmet: adding queue 2 to ctrl 836.
[ 1645.694544] nvmet: adding queue 3 to ctrl 836.
[ 1645.713503] nvmet: adding queue 4 to ctrl 836.
[ 1645.713777] nvmet: adding queue 5 to ctrl 836.
[ 1645.714069] nvmet: adding queue 6 to ctrl 836.
[ 1645.714411] nvmet: adding queue 7 to ctrl 836.
[ 1645.714687] nvmet: adding queue 8 to ctrl 836.
[ 1645.714969] nvmet: adding queue 9 to ctrl 836.
[ 1645.715255] nvmet: adding queue 10 to ctrl 836.
[ 1645.715496] nvmet: adding queue 11 to ctrl 836.
[ 1645.715715] nvmet: adding queue 12 to ctrl 836.
[ 1645.715951] nvmet: adding queue 13 to ctrl 836.
[ 1645.716139] nvmet: adding queue 14 to ctrl 836.
[ 1645.716400] nvmet: adding queue 15 to ctrl 836.
[ 1645.734885] nvmet: adding queue 16 to ctrl 836.
[ 1645.860157] nvmet: creating controller 837 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1645.915680] nvmet: adding queue 1 to ctrl 837.
[ 1645.915879] nvmet: adding queue 2 to ctrl 837.
[ 1645.916064] nvmet: adding queue 3 to ctrl 837.
[ 1645.916298] nvmet: adding queue 4 to ctrl 837.
[ 1645.916566] nvmet: adding queue 5 to ctrl 837.
[ 1645.916820] nvmet: adding queue 6 to ctrl 837.
[ 1645.917033] nvmet: adding queue 7 to ctrl 837.
[ 1645.936346] nvmet: adding queue 8 to ctrl 837.
[ 1645.936564] nvmet: adding queue 9 to ctrl 837.
[ 1645.956765] nvmet: adding queue 10 to ctrl 837.
[ 1645.957067] nvmet: adding queue 11 to ctrl 837.
[ 1645.977371] nvmet: adding queue 12 to ctrl 837.
[ 1645.977589] nvmet: adding queue 13 to ctrl 837.
[ 1645.977869] nvmet: adding queue 14 to ctrl 837.
[ 1645.978137] nvmet: adding queue 15 to ctrl 837.
[ 1645.978444] nvmet: adding queue 16 to ctrl 837.
[ 1646.080094] nvmet: creating controller 838 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1646.132686] nvmet: adding queue 1 to ctrl 838.
[ 1646.132874] nvmet: adding queue 2 to ctrl 838.
[ 1646.133047] nvmet: adding queue 3 to ctrl 838.
[ 1646.133248] nvmet: adding queue 4 to ctrl 838.
[ 1646.133438] nvmet: adding queue 5 to ctrl 838.
[ 1646.133617] nvmet: adding queue 6 to ctrl 838.
[ 1646.133816] nvmet: adding queue 7 to ctrl 838.
[ 1646.134050] nvmet: adding queue 8 to ctrl 838.
[ 1646.134329] nvmet: adding queue 9 to ctrl 838.
[ 1646.134557] nvmet: adding queue 10 to ctrl 838.
[ 1646.134811] nvmet: adding queue 11 to ctrl 838.
[ 1646.147310] nvmet: adding queue 12 to ctrl 838.
[ 1646.170280] nvmet: adding queue 13 to ctrl 838.
[ 1646.170542] nvmet: adding queue 14 to ctrl 838.
[ 1646.170787] nvmet: adding queue 15 to ctrl 838.
[ 1646.171095] nvmet: adding queue 16 to ctrl 838.
[ 1646.261026] nvmet: creating controller 839 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1646.315187] nvmet: adding queue 1 to ctrl 839.
[ 1646.315379] nvmet: adding queue 2 to ctrl 839.
[ 1646.315541] nvmet: adding queue 3 to ctrl 839.
[ 1646.315748] nvmet: adding queue 4 to ctrl 839.
[ 1646.315979] nvmet: adding queue 5 to ctrl 839.
[ 1646.316163] nvmet: adding queue 6 to ctrl 839.
[ 1646.316363] nvmet: adding queue 7 to ctrl 839.
[ 1646.316546] nvmet: adding queue 8 to ctrl 839.
[ 1646.316804] nvmet: adding queue 9 to ctrl 839.
[ 1646.317009] nvmet: adding queue 10 to ctrl 839.
[ 1646.317237] nvmet: adding queue 11 to ctrl 839.
[ 1646.317495] nvmet: adding queue 12 to ctrl 839.
[ 1646.317733] nvmet: adding queue 13 to ctrl 839.
[ 1646.317934] nvmet: adding queue 14 to ctrl 839.
[ 1646.333869] nvmet: adding queue 15 to ctrl 839.
[ 1646.334136] nvmet: adding queue 16 to ctrl 839.
[ 1646.440146] nvmet: creating controller 840 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1646.495664] nvmet: adding queue 1 to ctrl 840.
[ 1646.495894] nvmet: adding queue 2 to ctrl 840.
[ 1646.496174] nvmet: adding queue 3 to ctrl 840.
[ 1646.496455] nvmet: adding queue 4 to ctrl 840.
[ 1646.496593] nvmet: adding queue 5 to ctrl 840.
[ 1646.496738] nvmet: adding queue 6 to ctrl 840.
[ 1646.496944] nvmet: adding queue 7 to ctrl 840.
[ 1646.497146] nvmet: adding queue 8 to ctrl 840.
[ 1646.497364] nvmet: adding queue 9 to ctrl 840.
[ 1646.510746] nvmet: adding queue 10 to ctrl 840.
[ 1646.510985] nvmet: adding queue 11 to ctrl 840.
[ 1646.530088] nvmet: adding queue 12 to ctrl 840.
[ 1646.530331] nvmet: adding queue 13 to ctrl 840.
[ 1646.530572] nvmet: adding queue 14 to ctrl 840.
[ 1646.530790] nvmet: adding queue 15 to ctrl 840.
[ 1646.531074] nvmet: adding queue 16 to ctrl 840.
[ 1646.640333] nvmet: creating controller 841 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1646.645770] nvmet: ctrl 762 keep-alive timer (15 seconds) expired!
[ 1646.645772] nvmet: ctrl 762 fatal error occurred!
[ 1646.694018] nvmet: adding queue 1 to ctrl 841.
[ 1646.702487] nvmet: adding queue 2 to ctrl 841.
[ 1646.702764] nvmet: adding queue 3 to ctrl 841.
[ 1646.723194] nvmet: adding queue 4 to ctrl 841.
[ 1646.723509] nvmet: adding queue 5 to ctrl 841.
[ 1646.744649] nvmet: adding queue 6 to ctrl 841.
[ 1646.744928] nvmet: adding queue 7 to ctrl 841.
[ 1646.745213] nvmet: adding queue 8 to ctrl 841.
[ 1646.745451] nvmet: adding queue 9 to ctrl 841.
[ 1646.745754] nvmet: adding queue 10 to ctrl 841.
[ 1646.745995] nvmet: adding queue 11 to ctrl 841.
[ 1646.746317] nvmet: adding queue 12 to ctrl 841.
[ 1646.746596] nvmet: adding queue 13 to ctrl 841.
[ 1646.746861] nvmet: adding queue 14 to ctrl 841.
[ 1646.747143] nvmet: adding queue 15 to ctrl 841.
[ 1646.747415] nvmet: adding queue 16 to ctrl 841.
[ 1646.855407] nvmet_rdma: freeing queue 14289
[ 1646.879069] nvmet: creating controller 842 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1646.933826] nvmet: adding queue 1 to ctrl 842.
[ 1646.934060] nvmet: adding queue 2 to ctrl 842.
[ 1646.934264] nvmet: adding queue 3 to ctrl 842.
[ 1646.934452] nvmet: adding queue 4 to ctrl 842.
[ 1646.934646] nvmet: adding queue 5 to ctrl 842.
[ 1646.939355] nvmet: adding queue 6 to ctrl 842.
[ 1646.960767] nvmet: adding queue 7 to ctrl 842.
[ 1646.961030] nvmet: adding queue 8 to ctrl 842.
[ 1646.961251] nvmet: adding queue 9 to ctrl 842.
[ 1646.961519] nvmet: adding queue 10 to ctrl 842.
[ 1646.961739] nvmet: adding queue 11 to ctrl 842.
[ 1646.962026] nvmet: adding queue 12 to ctrl 842.
[ 1646.962217] nvmet: adding queue 13 to ctrl 842.
[ 1646.962365] nvmet: adding queue 14 to ctrl 842.
[ 1646.962617] nvmet: adding queue 15 to ctrl 842.
[ 1646.962913] nvmet: adding queue 16 to ctrl 842.
[ 1647.060214] nvmet: creating controller 843 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1647.113998] nvmet: adding queue 1 to ctrl 843.
[ 1647.114188] nvmet: adding queue 2 to ctrl 843.
[ 1647.114430] nvmet: adding queue 3 to ctrl 843.
[ 1647.114618] nvmet: adding queue 4 to ctrl 843.
[ 1647.114775] nvmet: adding queue 5 to ctrl 843.
[ 1647.115005] nvmet: adding queue 6 to ctrl 843.
[ 1647.115231] nvmet: adding queue 7 to ctrl 843.
[ 1647.115408] nvmet: adding queue 8 to ctrl 843.
[ 1647.118712] nvmet: adding queue 9 to ctrl 843.
[ 1647.119002] nvmet: adding queue 10 to ctrl 843.
[ 1647.119280] nvmet: adding queue 11 to ctrl 843.
[ 1647.119525] nvmet: adding queue 12 to ctrl 843.
[ 1647.119755] nvmet: adding queue 13 to ctrl 843.
[ 1647.119976] nvmet: adding queue 14 to ctrl 843.
[ 1647.120241] nvmet: adding queue 15 to ctrl 843.
[ 1647.120500] nvmet: adding queue 16 to ctrl 843.
[ 1647.251843] nvmet: creating controller 844 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1647.265724] nvmet: ctrl 766 keep-alive timer (15 seconds) expired!
[ 1647.265726] nvmet: ctrl 766 fatal error occurred!
[ 1647.305540] nvmet: adding queue 1 to ctrl 844.
[ 1647.305709] nvmet: adding queue 2 to ctrl 844.
[ 1647.305914] nvmet: adding queue 3 to ctrl 844.
[ 1647.308088] nvmet: adding queue 4 to ctrl 844.
[ 1647.308241] nvmet: adding queue 5 to ctrl 844.
[ 1647.329324] nvmet: adding queue 6 to ctrl 844.
[ 1647.329594] nvmet: adding queue 7 to ctrl 844.
[ 1647.329853] nvmet: adding queue 8 to ctrl 844.
[ 1647.330102] nvmet: adding queue 9 to ctrl 844.
[ 1647.330387] nvmet: adding queue 10 to ctrl 844.
[ 1647.330622] nvmet: adding queue 11 to ctrl 844.
[ 1647.330927] nvmet: adding queue 12 to ctrl 844.
[ 1647.352401] nvmet: adding queue 13 to ctrl 844.
[ 1647.352691] nvmet: adding queue 14 to ctrl 844.
[ 1647.377375] nvmet: adding queue 15 to ctrl 844.
[ 1647.377728] nvmet: adding queue 16 to ctrl 844.
[ 1647.489672] nvmet: creating controller 845 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1647.541913] nvmet: adding queue 1 to ctrl 845.
[ 1647.542111] nvmet: adding queue 2 to ctrl 845.
[ 1647.542322] nvmet: adding queue 3 to ctrl 845.
[ 1647.542514] nvmet: adding queue 4 to ctrl 845.
[ 1647.542682] nvmet: adding queue 5 to ctrl 845.
[ 1647.542896] nvmet: adding queue 6 to ctrl 845.
[ 1647.543063] nvmet: adding queue 7 to ctrl 845.
[ 1647.543229] nvmet: adding queue 8 to ctrl 845.
[ 1647.543457] nvmet: adding queue 9 to ctrl 845.
[ 1647.543707] nvmet: adding queue 10 to ctrl 845.
[ 1647.543999] nvmet: adding queue 11 to ctrl 845.
[ 1647.544215] nvmet: adding queue 12 to ctrl 845.
[ 1647.544451] nvmet: adding queue 13 to ctrl 845.
[ 1647.544643] nvmet: adding queue 14 to ctrl 845.
[ 1647.544887] nvmet: adding queue 15 to ctrl 845.
[ 1647.545116] nvmet: adding queue 16 to ctrl 845.
[ 1647.639262] nvmet: creating controller 846 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1647.702912] nvmet: adding queue 1 to ctrl 846.
[ 1647.703084] nvmet: adding queue 2 to ctrl 846.
[ 1647.703310] nvmet: adding queue 3 to ctrl 846.
[ 1647.703581] nvmet: adding queue 4 to ctrl 846.
[ 1647.703777] nvmet: adding queue 5 to ctrl 846.
[ 1647.703982] nvmet: adding queue 6 to ctrl 846.
[ 1647.704188] nvmet: adding queue 7 to ctrl 846.
[ 1647.704371] nvmet: adding queue 8 to ctrl 846.
[ 1647.704583] nvmet: adding queue 9 to ctrl 846.
[ 1647.704871] nvmet: adding queue 10 to ctrl 846.
[ 1647.705141] nvmet: adding queue 11 to ctrl 846.
[ 1647.705374] nvmet: adding queue 12 to ctrl 846.
[ 1647.705611] nvmet: adding queue 13 to ctrl 846.
[ 1647.705825] nvmet: adding queue 14 to ctrl 846.
[ 1647.706040] nvmet: adding queue 15 to ctrl 846.
[ 1647.706262] nvmet: adding queue 16 to ctrl 846.
[ 1647.810550] nvmet: creating controller 847 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1647.864107] nvmet: adding queue 1 to ctrl 847.
[ 1647.864251] nvmet: adding queue 2 to ctrl 847.
[ 1647.864484] nvmet: adding queue 3 to ctrl 847.
[ 1647.864685] nvmet: adding queue 4 to ctrl 847.
[ 1647.864870] nvmet: adding queue 5 to ctrl 847.
[ 1647.865036] nvmet: adding queue 6 to ctrl 847.
[ 1647.865257] nvmet: adding queue 7 to ctrl 847.
[ 1647.865456] nvmet: adding queue 8 to ctrl 847.
[ 1647.865709] nvmet: adding queue 9 to ctrl 847.
[ 1647.865978] nvmet: adding queue 10 to ctrl 847.
[ 1647.866205] nvmet: adding queue 11 to ctrl 847.
[ 1647.866429] nvmet: adding queue 12 to ctrl 847.
[ 1647.866632] nvmet: adding queue 13 to ctrl 847.
[ 1647.866795] nvmet: adding queue 14 to ctrl 847.
[ 1647.884525] nvmet: adding queue 15 to ctrl 847.
[ 1647.884749] nvmet: adding queue 16 to ctrl 847.
[ 1647.905775] nvmet: ctrl 768 keep-alive timer (15 seconds) expired!
[ 1647.905777] nvmet: ctrl 768 fatal error occurred!
[ 1647.990775] nvmet: creating controller 848 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1648.043958] nvmet: adding queue 1 to ctrl 848.
[ 1648.044127] nvmet: adding queue 2 to ctrl 848.
[ 1648.044375] nvmet: adding queue 3 to ctrl 848.
[ 1648.044569] nvmet: adding queue 4 to ctrl 848.
[ 1648.044811] nvmet: adding queue 5 to ctrl 848.
[ 1648.045009] nvmet: adding queue 6 to ctrl 848.
[ 1648.059545] nvmet: adding queue 7 to ctrl 848.
[ 1648.059893] nvmet: adding queue 8 to ctrl 848.
[ 1648.078617] nvmet: adding queue 9 to ctrl 848.
[ 1648.078895] nvmet: adding queue 10 to ctrl 848.
[ 1648.131875] nvmet: adding queue 11 to ctrl 848.
[ 1648.132166] nvmet: adding queue 12 to ctrl 848.
[ 1648.132336] nvmet: adding queue 13 to ctrl 848.
[ 1648.132646] nvmet: adding queue 14 to ctrl 848.
[ 1648.132936] nvmet: adding queue 15 to ctrl 848.
[ 1648.133224] nvmet: adding queue 16 to ctrl 848.
[ 1648.219864] nvmet: creating controller 849 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1648.274469] nvmet: adding queue 1 to ctrl 849.
[ 1648.274667] nvmet: adding queue 2 to ctrl 849.
[ 1648.274884] nvmet: adding queue 3 to ctrl 849.
[ 1648.275083] nvmet: adding queue 4 to ctrl 849.
[ 1648.275209] nvmet: adding queue 5 to ctrl 849.
[ 1648.275405] nvmet: adding queue 6 to ctrl 849.
[ 1648.275580] nvmet: adding queue 7 to ctrl 849.
[ 1648.275836] nvmet: adding queue 8 to ctrl 849.
[ 1648.276042] nvmet: adding queue 9 to ctrl 849.
[ 1648.276303] nvmet: adding queue 10 to ctrl 849.
[ 1648.277462] nvmet: adding queue 11 to ctrl 849.
[ 1648.298024] nvmet: adding queue 12 to ctrl 849.
[ 1648.298275] nvmet: adding queue 13 to ctrl 849.
[ 1648.298536] nvmet: adding queue 14 to ctrl 849.
[ 1648.298847] nvmet: adding queue 15 to ctrl 849.
[ 1648.299134] nvmet: adding queue 16 to ctrl 849.
[ 1648.373376] nvmet_rdma: freeing queue 14417
[ 1648.410566] nvmet: creating controller 850 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1648.463818] nvmet: adding queue 1 to ctrl 850.
[ 1648.463987] nvmet: adding queue 2 to ctrl 850.
[ 1648.464225] nvmet: adding queue 3 to ctrl 850.
[ 1648.464443] nvmet: adding queue 4 to ctrl 850.
[ 1648.464715] nvmet: adding queue 5 to ctrl 850.
[ 1648.464924] nvmet: adding queue 6 to ctrl 850.
[ 1648.465136] nvmet: adding queue 7 to ctrl 850.
[ 1648.465349] nvmet: adding queue 8 to ctrl 850.
[ 1648.465557] nvmet: adding queue 9 to ctrl 850.
[ 1648.465798] nvmet: adding queue 10 to ctrl 850.
[ 1648.466010] nvmet: adding queue 11 to ctrl 850.
[ 1648.466269] nvmet: adding queue 12 to ctrl 850.
[ 1648.466457] nvmet: adding queue 13 to ctrl 850.
[ 1648.470662] nvmet: adding queue 14 to ctrl 850.
[ 1648.470914] nvmet: adding queue 15 to ctrl 850.
[ 1648.471131] nvmet: adding queue 16 to ctrl 850.
[ 1648.579583] nvmet: creating controller 851 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1648.633118] nvmet: adding queue 1 to ctrl 851.
[ 1648.633312] nvmet: adding queue 2 to ctrl 851.
[ 1648.633537] nvmet: adding queue 3 to ctrl 851.
[ 1648.633772] nvmet: adding queue 4 to ctrl 851.
[ 1648.633940] nvmet: adding queue 5 to ctrl 851.
[ 1648.634095] nvmet: adding queue 6 to ctrl 851.
[ 1648.634305] nvmet: adding queue 7 to ctrl 851.
[ 1648.634486] nvmet: adding queue 8 to ctrl 851.
[ 1648.657578] nvmet: adding queue 9 to ctrl 851.
[ 1648.657802] nvmet: adding queue 10 to ctrl 851.
[ 1648.678188] nvmet: adding queue 11 to ctrl 851.
[ 1648.678457] nvmet: adding queue 12 to ctrl 851.
[ 1648.678681] nvmet: adding queue 13 to ctrl 851.
[ 1648.678944] nvmet: adding queue 14 to ctrl 851.
[ 1648.679280] nvmet: adding queue 15 to ctrl 851.
[ 1648.679655] nvmet: adding queue 16 to ctrl 851.
[ 1648.780118] nvmet: creating controller 852 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1648.844214] nvmet: adding queue 1 to ctrl 852.
[ 1648.844433] nvmet: adding queue 2 to ctrl 852.
[ 1648.864868] nvmet: adding queue 3 to ctrl 852.
[ 1648.865135] nvmet: adding queue 4 to ctrl 852.
[ 1648.886093] nvmet: adding queue 5 to ctrl 852.
[ 1648.886397] nvmet: adding queue 6 to ctrl 852.
[ 1648.886707] nvmet: adding queue 7 to ctrl 852.
[ 1648.886985] nvmet: adding queue 8 to ctrl 852.
[ 1648.887247] nvmet: adding queue 9 to ctrl 852.
[ 1648.887505] nvmet: adding queue 10 to ctrl 852.
[ 1648.887800] nvmet: adding queue 11 to ctrl 852.
[ 1648.888057] nvmet: adding queue 12 to ctrl 852.
[ 1648.888304] nvmet: adding queue 13 to ctrl 852.
[ 1648.888508] nvmet: adding queue 14 to ctrl 852.
[ 1648.888727] nvmet: adding queue 15 to ctrl 852.
[ 1648.888942] nvmet: adding queue 16 to ctrl 852.
[ 1648.980524] nvmet: creating controller 853 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.035276] nvmet: adding queue 1 to ctrl 853.
[ 1649.035469] nvmet: adding queue 2 to ctrl 853.
[ 1649.035658] nvmet: adding queue 3 to ctrl 853.
[ 1649.035831] nvmet: adding queue 4 to ctrl 853.
[ 1649.054063] nvmet: adding queue 5 to ctrl 853.
[ 1649.073283] nvmet: adding queue 6 to ctrl 853.
[ 1649.073602] nvmet: adding queue 7 to ctrl 853.
[ 1649.073901] nvmet: adding queue 8 to ctrl 853.
[ 1649.074161] nvmet: adding queue 9 to ctrl 853.
[ 1649.074476] nvmet: adding queue 10 to ctrl 853.
[ 1649.074765] nvmet: adding queue 11 to ctrl 853.
[ 1649.075038] nvmet: adding queue 12 to ctrl 853.
[ 1649.075293] nvmet: adding queue 13 to ctrl 853.
[ 1649.075485] nvmet: adding queue 14 to ctrl 853.
[ 1649.075802] nvmet: adding queue 15 to ctrl 853.
[ 1649.076120] nvmet: adding queue 16 to ctrl 853.
[ 1649.178940] nvmet: creating controller 854 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.231300] nvmet: adding queue 1 to ctrl 854.
[ 1649.231502] nvmet: adding queue 2 to ctrl 854.
[ 1649.231683] nvmet: adding queue 3 to ctrl 854.
[ 1649.231952] nvmet: adding queue 4 to ctrl 854.
[ 1649.232150] nvmet: adding queue 5 to ctrl 854.
[ 1649.232318] nvmet: adding queue 6 to ctrl 854.
[ 1649.232494] nvmet: adding queue 7 to ctrl 854.
[ 1649.246439] nvmet: adding queue 8 to ctrl 854.
[ 1649.246808] nvmet: adding queue 9 to ctrl 854.
[ 1649.247094] nvmet: adding queue 10 to ctrl 854.
[ 1649.247352] nvmet: adding queue 11 to ctrl 854.
[ 1649.247657] nvmet: adding queue 12 to ctrl 854.
[ 1649.247913] nvmet: adding queue 13 to ctrl 854.
[ 1649.248088] nvmet: adding queue 14 to ctrl 854.
[ 1649.248297] nvmet: adding queue 15 to ctrl 854.
[ 1649.248593] nvmet: adding queue 16 to ctrl 854.
[ 1649.339528] nvmet: creating controller 855 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.392594] nvmet: adding queue 1 to ctrl 855.
[ 1649.392768] nvmet: adding queue 2 to ctrl 855.
[ 1649.400351] nvmet: adding queue 3 to ctrl 855.
[ 1649.400507] nvmet: adding queue 4 to ctrl 855.
[ 1649.423329] nvmet: adding queue 5 to ctrl 855.
[ 1649.423713] nvmet: adding queue 6 to ctrl 855.
[ 1649.423951] nvmet: adding queue 7 to ctrl 855.
[ 1649.424216] nvmet: adding queue 8 to ctrl 855.
[ 1649.424478] nvmet: adding queue 9 to ctrl 855.
[ 1649.424781] nvmet: adding queue 10 to ctrl 855.
[ 1649.425078] nvmet: adding queue 11 to ctrl 855.
[ 1649.448019] nvmet: adding queue 12 to ctrl 855.
[ 1649.448299] nvmet: adding queue 13 to ctrl 855.
[ 1649.468300] nvmet: adding queue 14 to ctrl 855.
[ 1649.468596] nvmet: adding queue 15 to ctrl 855.
[ 1649.488202] nvmet: adding queue 16 to ctrl 855.
[ 1649.523215] nvmet_rdma: freeing queue 14519
[ 1649.525575] nvmet_rdma: freeing queue 14520
[ 1649.526901] nvmet_rdma: freeing queue 14521
[ 1649.540422] nvmet_rdma: freeing queue 14530
[ 1649.542059] nvmet_rdma: freeing queue 14531
[ 1649.543524] nvmet_rdma: freeing queue 14532
[ 1649.546381] nvmet_rdma: freeing queue 14534
[ 1649.560216] nvmet: creating controller 856 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.613252] nvmet: adding queue 1 to ctrl 856.
[ 1649.613548] nvmet: adding queue 2 to ctrl 856.
[ 1649.613719] nvmet: adding queue 3 to ctrl 856.
[ 1649.613901] nvmet: adding queue 4 to ctrl 856.
[ 1649.614059] nvmet: adding queue 5 to ctrl 856.
[ 1649.614257] nvmet: adding queue 6 to ctrl 856.
[ 1649.614426] nvmet: adding queue 7 to ctrl 856.
[ 1649.614620] nvmet: adding queue 8 to ctrl 856.
[ 1649.614886] nvmet: adding queue 9 to ctrl 856.
[ 1649.615158] nvmet: adding queue 10 to ctrl 856.
[ 1649.615430] nvmet: adding queue 11 to ctrl 856.
[ 1649.615716] nvmet: adding queue 12 to ctrl 856.
[ 1649.615983] nvmet: adding queue 13 to ctrl 856.
[ 1649.616245] nvmet: adding queue 14 to ctrl 856.
[ 1649.616524] nvmet: adding queue 15 to ctrl 856.
[ 1649.631432] nvmet: adding queue 16 to ctrl 856.
[ 1649.699584] nvmet: creating controller 857 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.753572] nvmet: adding queue 1 to ctrl 857.
[ 1649.753733] nvmet: adding queue 2 to ctrl 857.
[ 1649.753940] nvmet: adding queue 3 to ctrl 857.
[ 1649.754185] nvmet: adding queue 4 to ctrl 857.
[ 1649.754368] nvmet: adding queue 5 to ctrl 857.
[ 1649.754584] nvmet: adding queue 6 to ctrl 857.
[ 1649.754755] nvmet: adding queue 7 to ctrl 857.
[ 1649.754964] nvmet: adding queue 8 to ctrl 857.
[ 1649.755180] nvmet: adding queue 9 to ctrl 857.
[ 1649.755496] nvmet: adding queue 10 to ctrl 857.
[ 1649.755767] nvmet: adding queue 11 to ctrl 857.
[ 1649.756050] nvmet: adding queue 12 to ctrl 857.
[ 1649.756311] nvmet: adding queue 13 to ctrl 857.
[ 1649.756493] nvmet: adding queue 14 to ctrl 857.
[ 1649.756712] nvmet: adding queue 15 to ctrl 857.
[ 1649.756956] nvmet: adding queue 16 to ctrl 857.
[ 1649.815636] nvmet: ctrl 779 keep-alive timer (15 seconds) expired!
[ 1649.815638] nvmet: ctrl 779 fatal error occurred!
[ 1649.818597] nvmet_rdma: freeing queue 14556
[ 1649.820349] nvmet_rdma: freeing queue 14557
[ 1649.821720] nvmet_rdma: freeing queue 14558
[ 1649.823030] nvmet_rdma: freeing queue 14559
[ 1649.825116] nvmet_rdma: freeing queue 14560
[ 1649.826286] nvmet_rdma: freeing queue 14561
[ 1649.827729] nvmet_rdma: freeing queue 14562
[ 1649.850683] nvmet: creating controller 858 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1649.902717] nvmet: adding queue 1 to ctrl 858.
[ 1649.909200] nvmet: adding queue 2 to ctrl 858.
[ 1649.909434] nvmet: adding queue 3 to ctrl 858.
[ 1649.909659] nvmet: adding queue 4 to ctrl 858.
[ 1649.909856] nvmet: adding queue 5 to ctrl 858.
[ 1649.910047] nvmet: adding queue 6 to ctrl 858.
[ 1649.910211] nvmet: adding queue 7 to ctrl 858.
[ 1649.910418] nvmet: adding queue 8 to ctrl 858.
[ 1649.910659] nvmet: adding queue 9 to ctrl 858.
[ 1649.910912] nvmet: adding queue 10 to ctrl 858.
[ 1649.911182] nvmet: adding queue 11 to ctrl 858.
[ 1649.911432] nvmet: adding queue 12 to ctrl 858.
[ 1649.911627] nvmet: adding queue 13 to ctrl 858.
[ 1649.967397] nvmet: adding queue 14 to ctrl 858.
[ 1649.967645] nvmet: adding queue 15 to ctrl 858.
[ 1649.995136] nvmet: adding queue 16 to ctrl 858.
[ 1650.110279] nvmet: creating controller 859 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1650.163199] nvmet: adding queue 1 to ctrl 859.
[ 1650.163433] nvmet: adding queue 2 to ctrl 859.
[ 1650.163667] nvmet: adding queue 3 to ctrl 859.
[ 1650.163911] nvmet: adding queue 4 to ctrl 859.
[ 1650.164101] nvmet: adding queue 5 to ctrl 859.
[ 1650.177701] nvmet: adding queue 6 to ctrl 859.
[ 1650.177918] nvmet: adding queue 7 to ctrl 859.
[ 1650.197610] nvmet: adding queue 8 to ctrl 859.
[ 1650.197861] nvmet: adding queue 9 to ctrl 859.
[ 1650.217940] nvmet: adding queue 10 to ctrl 859.
[ 1650.218208] nvmet: adding queue 11 to ctrl 859.
[ 1650.218525] nvmet: adding queue 12 to ctrl 859.
[ 1650.218764] nvmet: adding queue 13 to ctrl 859.
[ 1650.219000] nvmet: adding queue 14 to ctrl 859.
[ 1650.219305] nvmet: adding queue 15 to ctrl 859.
[ 1650.219560] nvmet: adding queue 16 to ctrl 859.
[ 1650.340626] nvmet: creating controller 860 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1650.391834] nvmet: adding queue 1 to ctrl 860.
[ 1650.392022] nvmet: adding queue 2 to ctrl 860.
[ 1650.392346] nvmet: adding queue 3 to ctrl 860.
[ 1650.392654] nvmet: adding queue 4 to ctrl 860.
[ 1650.392818] nvmet: adding queue 5 to ctrl 860.
[ 1650.393017] nvmet: adding queue 6 to ctrl 860.
[ 1650.393332] nvmet: adding queue 7 to ctrl 860.
[ 1650.393509] nvmet: adding queue 8 to ctrl 860.
[ 1650.393730] nvmet: adding queue 9 to ctrl 860.
[ 1650.395378] nvmet: adding queue 10 to ctrl 860.
[ 1650.413897] nvmet: adding queue 11 to ctrl 860.
[ 1650.414187] nvmet: adding queue 12 to ctrl 860.
[ 1650.414427] nvmet: adding queue 13 to ctrl 860.
[ 1650.414691] nvmet: adding queue 14 to ctrl 860.
[ 1650.414965] nvmet: adding queue 15 to ctrl 860.
[ 1650.415293] nvmet: adding queue 16 to ctrl 860.
[ 1650.530173] nvmet: creating controller 861 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1650.583244] nvmet: adding queue 1 to ctrl 861.
[ 1650.583453] nvmet: adding queue 2 to ctrl 861.
[ 1650.583684] nvmet: adding queue 3 to ctrl 861.
[ 1650.583873] nvmet: adding queue 4 to ctrl 861.
[ 1650.584067] nvmet: adding queue 5 to ctrl 861.
[ 1650.584242] nvmet: adding queue 6 to ctrl 861.
[ 1650.584422] nvmet: adding queue 7 to ctrl 861.
[ 1650.584585] nvmet: adding queue 8 to ctrl 861.
[ 1650.584780] nvmet: adding queue 9 to ctrl 861.
[ 1650.585004] nvmet: adding queue 10 to ctrl 861.
[ 1650.585222] nvmet: adding queue 11 to ctrl 861.
[ 1650.585442] nvmet: adding queue 12 to ctrl 861.
[ 1650.603463] nvmet: adding queue 13 to ctrl 861.
[ 1650.603716] nvmet: adding queue 14 to ctrl 861.
[ 1650.603998] nvmet: adding queue 15 to ctrl 861.
[ 1650.604297] nvmet: adding queue 16 to ctrl 861.
[ 1650.690951] nvmet: creating controller 862 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1650.742584] nvmet: adding queue 1 to ctrl 862.
[ 1650.742770] nvmet: adding queue 2 to ctrl 862.
[ 1650.743007] nvmet: adding queue 3 to ctrl 862.
[ 1650.743218] nvmet: adding queue 4 to ctrl 862.
[ 1650.743391] nvmet: adding queue 5 to ctrl 862.
[ 1650.743584] nvmet: adding queue 6 to ctrl 862.
[ 1650.743772] nvmet: adding queue 7 to ctrl 862.
[ 1650.754308] nvmet: adding queue 8 to ctrl 862.
[ 1650.754489] nvmet: adding queue 9 to ctrl 862.
[ 1650.774264] nvmet: adding queue 10 to ctrl 862.
[ 1650.774541] nvmet: adding queue 11 to ctrl 862.
[ 1650.774827] nvmet: adding queue 12 to ctrl 862.
[ 1650.775057] nvmet: adding queue 13 to ctrl 862.
[ 1650.775332] nvmet: adding queue 14 to ctrl 862.
[ 1650.775649] nvmet: adding queue 15 to ctrl 862.
[ 1650.776005] nvmet: adding queue 16 to ctrl 862.
[ 1650.842938] nvmet_rdma: freeing queue 14644
[ 1650.870363] nvmet: creating controller 863 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1650.921991] nvmet: adding queue 1 to ctrl 863.
[ 1650.935031] nvmet: adding queue 2 to ctrl 863.
[ 1650.935302] nvmet: adding queue 3 to ctrl 863.
[ 1650.955886] nvmet: adding queue 4 to ctrl 863.
[ 1650.956173] nvmet: adding queue 5 to ctrl 863.
[ 1650.956455] nvmet: adding queue 6 to ctrl 863.
[ 1650.956727] nvmet: adding queue 7 to ctrl 863.
[ 1650.957034] nvmet: adding queue 8 to ctrl 863.
[ 1650.957264] nvmet: adding queue 9 to ctrl 863.
[ 1650.957527] nvmet: adding queue 10 to ctrl 863.
[ 1650.957836] nvmet: adding queue 11 to ctrl 863.
[ 1650.958159] nvmet: adding queue 12 to ctrl 863.
[ 1650.958380] nvmet: adding queue 13 to ctrl 863.
[ 1650.958592] nvmet: adding queue 14 to ctrl 863.
[ 1650.958810] nvmet: adding queue 15 to ctrl 863.
[ 1650.959053] nvmet: adding queue 16 to ctrl 863.
[ 1650.995186] nvmet_rdma: freeing queue 14656
[ 1650.996958] nvmet_rdma: freeing queue 14657
[ 1650.998791] nvmet_rdma: freeing queue 14658
[ 1651.000195] nvmet_rdma: freeing queue 14659
[ 1651.001465] nvmet_rdma: freeing queue 14660
[ 1651.002850] nvmet_rdma: freeing queue 14661
[ 1651.004555] nvmet_rdma: freeing queue 14662
[ 1651.012191] nvmet_rdma: freeing queue 14667
[ 1651.013603] nvmet_rdma: freeing queue 14668
[ 1651.014884] nvmet_rdma: freeing queue 14669
[ 1651.016287] nvmet_rdma: freeing queue 14670
[ 1651.017999] nvmet_rdma: freeing queue 14654
[ 1651.030177] nvmet: creating controller 864 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1651.081992] nvmet: adding queue 1 to ctrl 864.
[ 1651.082204] nvmet: adding queue 2 to ctrl 864.
[ 1651.082471] nvmet: adding queue 3 to ctrl 864.
[ 1651.108066] nvmet: adding queue 4 to ctrl 864.
[ 1651.127965] nvmet: adding queue 5 to ctrl 864.
[ 1651.128259] nvmet: adding queue 6 to ctrl 864.
[ 1651.128592] nvmet: adding queue 7 to ctrl 864.
[ 1651.128890] nvmet: adding queue 8 to ctrl 864.
[ 1651.129184] nvmet: adding queue 9 to ctrl 864.
[ 1651.129518] nvmet: adding queue 10 to ctrl 864.
[ 1651.129739] nvmet: adding queue 11 to ctrl 864.
[ 1651.129995] nvmet: adding queue 12 to ctrl 864.
[ 1651.130198] nvmet: adding queue 13 to ctrl 864.
[ 1651.130417] nvmet: adding queue 14 to ctrl 864.
[ 1651.130764] nvmet: adding queue 15 to ctrl 864.
[ 1651.130993] nvmet: adding queue 16 to ctrl 864.
[ 1651.200469] nvmet_rdma: freeing queue 14683
[ 1651.203376] nvmet_rdma: freeing queue 14685
[ 1651.204640] nvmet_rdma: freeing queue 14686
[ 1651.208035] nvmet_rdma: freeing queue 14671
[ 1651.220461] nvmet: creating controller 865 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1651.273046] nvmet: adding queue 1 to ctrl 865.
[ 1651.273258] nvmet: adding queue 2 to ctrl 865.
[ 1651.273423] nvmet: adding queue 3 to ctrl 865.
[ 1651.273650] nvmet: adding queue 4 to ctrl 865.
[ 1651.273869] nvmet: adding queue 5 to ctrl 865.
[ 1651.274062] nvmet: adding queue 6 to ctrl 865.
[ 1651.288622] nvmet: adding queue 7 to ctrl 865.
[ 1651.288939] nvmet: adding queue 8 to ctrl 865.
[ 1651.289206] nvmet: adding queue 9 to ctrl 865.
[ 1651.289440] nvmet: adding queue 10 to ctrl 865.
[ 1651.289722] nvmet: adding queue 11 to ctrl 865.
[ 1651.289970] nvmet: adding queue 12 to ctrl 865.
[ 1651.290208] nvmet: adding queue 13 to ctrl 865.
[ 1651.290454] nvmet: adding queue 14 to ctrl 865.
[ 1651.290708] nvmet: adding queue 15 to ctrl 865.
[ 1651.290980] nvmet: adding queue 16 to ctrl 865.
[ 1651.353360] nvmet_rdma: freeing queue 14689
[ 1651.359871] nvmet_rdma: freeing queue 14693
[ 1651.361434] nvmet_rdma: freeing queue 14694
[ 1651.363371] nvmet_rdma: freeing queue 14695
[ 1651.364510] nvmet_rdma: freeing queue 14696
[ 1651.365821] nvmet_rdma: freeing queue 14697
[ 1651.367346] nvmet_rdma: freeing queue 14698
[ 1651.369121] nvmet_rdma: freeing queue 14699
[ 1651.370660] nvmet_rdma: freeing queue 14700
[ 1651.373408] nvmet_rdma: freeing queue 14702
[ 1651.375016] nvmet_rdma: freeing queue 14703
[ 1651.390424] nvmet: creating controller 866 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1651.443268] nvmet: adding queue 1 to ctrl 866.
[ 1651.448976] nvmet: adding queue 2 to ctrl 866.
[ 1651.449189] nvmet: adding queue 3 to ctrl 866.
[ 1651.469159] nvmet: adding queue 4 to ctrl 866.
[ 1651.469465] nvmet: adding queue 5 to ctrl 866.
[ 1651.469722] nvmet: adding queue 6 to ctrl 866.
[ 1651.469934] nvmet: adding queue 7 to ctrl 866.
[ 1651.470132] nvmet: adding queue 8 to ctrl 866.
[ 1651.470304] nvmet: adding queue 9 to ctrl 866.
[ 1651.470540] nvmet: adding queue 10 to ctrl 866.
[ 1651.525353] nvmet: adding queue 11 to ctrl 866.
[ 1651.525629] nvmet: adding queue 12 to ctrl 866.
[ 1651.545323] nvmet: adding queue 13 to ctrl 866.
[ 1651.545561] nvmet: adding queue 14 to ctrl 866.
[ 1651.565376] nvmet: adding queue 15 to ctrl 866.
[ 1651.565653] nvmet: adding queue 16 to ctrl 866.
[ 1651.623461] nvmet_rdma: freeing queue 14706
[ 1651.637220] nvmet_rdma: freeing queue 14715
[ 1651.638541] nvmet_rdma: freeing queue 14716
[ 1651.640438] nvmet_rdma: freeing queue 14717
[ 1651.643042] nvmet_rdma: freeing queue 14719
[ 1651.659769] nvmet: creating controller 867 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1651.713807] nvmet: adding queue 1 to ctrl 867.
[ 1651.713989] nvmet: adding queue 2 to ctrl 867.
[ 1651.714193] nvmet: adding queue 3 to ctrl 867.
[ 1651.714353] nvmet: adding queue 4 to ctrl 867.
[ 1651.714577] nvmet: adding queue 5 to ctrl 867.
[ 1651.714773] nvmet: adding queue 6 to ctrl 867.
[ 1651.714946] nvmet: adding queue 7 to ctrl 867.
[ 1651.715224] nvmet: adding queue 8 to ctrl 867.
[ 1651.715397] nvmet: adding queue 9 to ctrl 867.
[ 1651.715691] nvmet: adding queue 10 to ctrl 867.
[ 1651.715972] nvmet: adding queue 11 to ctrl 867.
[ 1651.716306] nvmet: adding queue 12 to ctrl 867.
[ 1651.716549] nvmet: adding queue 13 to ctrl 867.
[ 1651.716726] nvmet: adding queue 14 to ctrl 867.
[ 1651.725979] nvmet: adding queue 15 to ctrl 867.
[ 1651.746314] nvmet: adding queue 16 to ctrl 867.
[ 1651.869915] nvmet: creating controller 868 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1651.923827] nvmet: adding queue 1 to ctrl 868.
[ 1651.924034] nvmet: adding queue 2 to ctrl 868.
[ 1651.924259] nvmet: adding queue 3 to ctrl 868.
[ 1651.924496] nvmet: adding queue 4 to ctrl 868.
[ 1651.924673] nvmet: adding queue 5 to ctrl 868.
[ 1651.924843] nvmet: adding queue 6 to ctrl 868.
[ 1651.925025] nvmet: adding queue 7 to ctrl 868.
[ 1651.925219] nvmet: adding queue 8 to ctrl 868.
[ 1651.925400] nvmet: adding queue 9 to ctrl 868.
[ 1651.925693] nvmet: adding queue 10 to ctrl 868.
[ 1651.925963] nvmet: adding queue 11 to ctrl 868.
[ 1651.926240] nvmet: adding queue 12 to ctrl 868.
[ 1651.926428] nvmet: adding queue 13 to ctrl 868.
[ 1651.926638] nvmet: adding queue 14 to ctrl 868.
[ 1651.926833] nvmet: adding queue 15 to ctrl 868.
[ 1651.927108] nvmet: adding queue 16 to ctrl 868.
[ 1651.988186] nvmet_rdma: freeing queue 14743
[ 1652.019822] nvmet: creating controller 869 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1652.076478] nvmet: adding queue 1 to ctrl 869.
[ 1652.076687] nvmet: adding queue 2 to ctrl 869.
[ 1652.076998] nvmet: adding queue 3 to ctrl 869.
[ 1652.077219] nvmet: adding queue 4 to ctrl 869.
[ 1652.077433] nvmet: adding queue 5 to ctrl 869.
[ 1652.077615] nvmet: adding queue 6 to ctrl 869.
[ 1652.077791] nvmet: adding queue 7 to ctrl 869.
[ 1652.078009] nvmet: adding queue 8 to ctrl 869.
[ 1652.078232] nvmet: adding queue 9 to ctrl 869.
[ 1652.078508] nvmet: adding queue 10 to ctrl 869.
[ 1652.078735] nvmet: adding queue 11 to ctrl 869.
[ 1652.078944] nvmet: adding queue 12 to ctrl 869.
[ 1652.094828] nvmet: adding queue 13 to ctrl 869.
[ 1652.094998] nvmet: adding queue 14 to ctrl 869.
[ 1652.113188] nvmet: adding queue 15 to ctrl 869.
[ 1652.113482] nvmet: adding queue 16 to ctrl 869.
[ 1652.185875] nvmet_rdma: freeing queue 14765
[ 1652.209818] nvmet: creating controller 870 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1652.265545] nvmet: adding queue 1 to ctrl 870.
[ 1652.265801] nvmet: adding queue 2 to ctrl 870.
[ 1652.266069] nvmet: adding queue 3 to ctrl 870.
[ 1652.266289] nvmet: adding queue 4 to ctrl 870.
[ 1652.283623] nvmet: adding queue 5 to ctrl 870.
[ 1652.283912] nvmet: adding queue 6 to ctrl 870.
[ 1652.303267] nvmet: adding queue 7 to ctrl 870.
[ 1652.303551] nvmet: adding queue 8 to ctrl 870.
[ 1652.322886] nvmet: adding queue 9 to ctrl 870.
[ 1652.323141] nvmet: adding queue 10 to ctrl 870.
[ 1652.323452] nvmet: adding queue 11 to ctrl 870.
[ 1652.323759] nvmet: adding queue 12 to ctrl 870.
[ 1652.324026] nvmet: adding queue 13 to ctrl 870.
[ 1652.324219] nvmet: adding queue 14 to ctrl 870.
[ 1652.324539] nvmet: adding queue 15 to ctrl 870.
[ 1652.324865] nvmet: adding queue 16 to ctrl 870.
[ 1652.410061] nvmet: creating controller 871 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1652.463233] nvmet: adding queue 1 to ctrl 871.
[ 1652.463428] nvmet: adding queue 2 to ctrl 871.
[ 1652.463699] nvmet: adding queue 3 to ctrl 871.
[ 1652.463907] nvmet: adding queue 4 to ctrl 871.
[ 1652.464098] nvmet: adding queue 5 to ctrl 871.
[ 1652.464322] nvmet: adding queue 6 to ctrl 871.
[ 1652.464523] nvmet: adding queue 7 to ctrl 871.
[ 1652.464692] nvmet: adding queue 8 to ctrl 871.
[ 1652.485685] nvmet: adding queue 9 to ctrl 871.
[ 1652.508450] nvmet: adding queue 10 to ctrl 871.
[ 1652.508681] nvmet: adding queue 11 to ctrl 871.
[ 1652.508956] nvmet: adding queue 12 to ctrl 871.
[ 1652.509211] nvmet: adding queue 13 to ctrl 871.
[ 1652.509466] nvmet: adding queue 14 to ctrl 871.
[ 1652.509713] nvmet: adding queue 15 to ctrl 871.
[ 1652.509981] nvmet: adding queue 16 to ctrl 871.
[ 1652.629596] nvmet: creating controller 872 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1652.682685] nvmet: adding queue 1 to ctrl 872.
[ 1652.682911] nvmet: adding queue 2 to ctrl 872.
[ 1652.683113] nvmet: adding queue 3 to ctrl 872.
[ 1652.683343] nvmet: adding queue 4 to ctrl 872.
[ 1652.683552] nvmet: adding queue 5 to ctrl 872.
[ 1652.683715] nvmet: adding queue 6 to ctrl 872.
[ 1652.683878] nvmet: adding queue 7 to ctrl 872.
[ 1652.684087] nvmet: adding queue 8 to ctrl 872.
[ 1652.684323] nvmet: adding queue 9 to ctrl 872.
[ 1652.684683] nvmet: adding queue 10 to ctrl 872.
[ 1652.684912] nvmet: adding queue 11 to ctrl 872.
[ 1652.689968] nvmet: adding queue 12 to ctrl 872.
[ 1652.690268] nvmet: adding queue 13 to ctrl 872.
[ 1652.690480] nvmet: adding queue 14 to ctrl 872.
[ 1652.690706] nvmet: adding queue 15 to ctrl 872.
[ 1652.690999] nvmet: adding queue 16 to ctrl 872.
[ 1652.810230] nvmet: creating controller 873 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1652.863431] nvmet: adding queue 1 to ctrl 873.
[ 1652.863673] nvmet: adding queue 2 to ctrl 873.
[ 1652.863889] nvmet: adding queue 3 to ctrl 873.
[ 1652.864066] nvmet: adding queue 4 to ctrl 873.
[ 1652.864245] nvmet: adding queue 5 to ctrl 873.
[ 1652.864420] nvmet: adding queue 6 to ctrl 873.
[ 1652.869456] nvmet: adding queue 7 to ctrl 873.
[ 1652.869651] nvmet: adding queue 8 to ctrl 873.
[ 1652.889709] nvmet: adding queue 9 to ctrl 873.
[ 1652.890031] nvmet: adding queue 10 to ctrl 873.
[ 1652.890244] nvmet: adding queue 11 to ctrl 873.
[ 1652.890541] nvmet: adding queue 12 to ctrl 873.
[ 1652.890802] nvmet: adding queue 13 to ctrl 873.
[ 1652.891016] nvmet: adding queue 14 to ctrl 873.
[ 1652.891268] nvmet: adding queue 15 to ctrl 873.
[ 1652.909976] nvmet: adding queue 16 to ctrl 873.
[ 1652.963429] nvmet_rdma: freeing queue 14825
[ 1652.979142] nvmet_rdma: freeing queue 14835
[ 1653.000329] nvmet: creating controller 874 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1653.076390] nvmet: adding queue 1 to ctrl 874.
[ 1653.076675] nvmet: adding queue 2 to ctrl 874.
[ 1653.099289] nvmet: adding queue 3 to ctrl 874.
[ 1653.099561] nvmet: adding queue 4 to ctrl 874.
[ 1653.099851] nvmet: adding queue 5 to ctrl 874.
[ 1653.100452] nvmet: adding queue 6 to ctrl 874.
[ 1653.100776] nvmet: adding queue 7 to ctrl 874.
[ 1653.100972] nvmet: adding queue 8 to ctrl 874.
[ 1653.101230] nvmet: adding queue 9 to ctrl 874.
[ 1653.101504] nvmet: adding queue 10 to ctrl 874.
[ 1653.101816] nvmet: adding queue 11 to ctrl 874.
[ 1653.102088] nvmet: adding queue 12 to ctrl 874.
[ 1653.102355] nvmet: adding queue 13 to ctrl 874.
[ 1653.102626] nvmet: adding queue 14 to ctrl 874.
[ 1653.102880] nvmet: adding queue 15 to ctrl 874.
[ 1653.103133] nvmet: adding queue 16 to ctrl 874.
[ 1653.180548] nvmet_rdma: freeing queue 14853
[ 1653.183284] nvmet_rdma: freeing queue 14855
[ 1653.184781] nvmet_rdma: freeing queue 14856
[ 1653.200255] nvmet: creating controller 875 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1653.253733] nvmet: adding queue 1 to ctrl 875.
[ 1653.253940] nvmet: adding queue 2 to ctrl 875.
[ 1653.262714] nvmet: adding queue 3 to ctrl 875.
[ 1653.283044] nvmet: adding queue 4 to ctrl 875.
[ 1653.283307] nvmet: adding queue 5 to ctrl 875.
[ 1653.283602] nvmet: adding queue 6 to ctrl 875.
[ 1653.283923] nvmet: adding queue 7 to ctrl 875.
[ 1653.284214] nvmet: adding queue 8 to ctrl 875.
[ 1653.284487] nvmet: adding queue 9 to ctrl 875.
[ 1653.284783] nvmet: adding queue 10 to ctrl 875.
[ 1653.285108] nvmet: adding queue 11 to ctrl 875.
[ 1653.285384] nvmet: adding queue 12 to ctrl 875.
[ 1653.285639] nvmet: adding queue 13 to ctrl 875.
[ 1653.285842] nvmet: adding queue 14 to ctrl 875.
[ 1653.286129] nvmet: adding queue 15 to ctrl 875.
[ 1653.286421] nvmet: adding queue 16 to ctrl 875.
[ 1653.353322] nvmet_rdma: freeing queue 14859
[ 1653.389495] nvmet: creating controller 876 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1653.443059] nvmet: adding queue 1 to ctrl 876.
[ 1653.443240] nvmet: adding queue 2 to ctrl 876.
[ 1653.443457] nvmet: adding queue 3 to ctrl 876.
[ 1653.443730] nvmet: adding queue 4 to ctrl 876.
[ 1653.443896] nvmet: adding queue 5 to ctrl 876.
[ 1653.455333] nvmet: adding queue 6 to ctrl 876.
[ 1653.455554] nvmet: adding queue 7 to ctrl 876.
[ 1653.455835] nvmet: adding queue 8 to ctrl 876.
[ 1653.456102] nvmet: adding queue 9 to ctrl 876.
[ 1653.456332] nvmet: adding queue 10 to ctrl 876.
[ 1653.456592] nvmet: adding queue 11 to ctrl 876.
[ 1653.456894] nvmet: adding queue 12 to ctrl 876.
[ 1653.457100] nvmet: adding queue 13 to ctrl 876.
[ 1653.457298] nvmet: adding queue 14 to ctrl 876.
[ 1653.457547] nvmet: adding queue 15 to ctrl 876.
[ 1653.457823] nvmet: adding queue 16 to ctrl 876.
[ 1653.529837] nvmet_rdma: freeing queue 14880
[ 1653.531672] nvmet_rdma: freeing queue 14881
[ 1653.533282] nvmet_rdma: freeing queue 14882
[ 1653.534196] nvmet_rdma: freeing queue 14883
[ 1653.535787] nvmet_rdma: freeing queue 14884
[ 1653.559327] nvmet: creating controller 877 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1653.620286] nvmet: adding queue 1 to ctrl 877.
[ 1653.620466] nvmet: adding queue 2 to ctrl 877.
[ 1653.640172] nvmet: adding queue 3 to ctrl 877.
[ 1653.640444] nvmet: adding queue 4 to ctrl 877.
[ 1653.640610] nvmet: adding queue 5 to ctrl 877.
[ 1653.640836] nvmet: adding queue 6 to ctrl 877.
[ 1653.641137] nvmet: adding queue 7 to ctrl 877.
[ 1653.641398] nvmet: adding queue 8 to ctrl 877.
[ 1653.641633] nvmet: adding queue 9 to ctrl 877.
[ 1653.660515] nvmet: adding queue 10 to ctrl 877.
[ 1653.660823] nvmet: adding queue 11 to ctrl 877.
[ 1653.665472] nvmet: ctrl 798 keep-alive timer (15 seconds) expired!
[ 1653.665474] nvmet: ctrl 798 fatal error occurred!
[ 1653.680795] nvmet: adding queue 12 to ctrl 877.
[ 1653.681087] nvmet: adding queue 13 to ctrl 877.
[ 1653.701659] nvmet: adding queue 14 to ctrl 877.
[ 1653.701926] nvmet: adding queue 15 to ctrl 877.
[ 1653.702197] nvmet: adding queue 16 to ctrl 877.
[ 1653.779542] nvmet_rdma: freeing queue 14897
[ 1653.785420] nvmet_rdma: freeing queue 14901
[ 1653.809486] nvmet: creating controller 878 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1653.864053] nvmet: adding queue 1 to ctrl 878.
[ 1653.864215] nvmet: adding queue 2 to ctrl 878.
[ 1653.864415] nvmet: adding queue 3 to ctrl 878.
[ 1653.864599] nvmet: adding queue 4 to ctrl 878.
[ 1653.864784] nvmet: adding queue 5 to ctrl 878.
[ 1653.864977] nvmet: adding queue 6 to ctrl 878.
[ 1653.865199] nvmet: adding queue 7 to ctrl 878.
[ 1653.865367] nvmet: adding queue 8 to ctrl 878.
[ 1653.865571] nvmet: adding queue 9 to ctrl 878.
[ 1653.865781] nvmet: adding queue 10 to ctrl 878.
[ 1653.866092] nvmet: adding queue 11 to ctrl 878.
[ 1653.866298] nvmet: adding queue 12 to ctrl 878.
[ 1653.866523] nvmet: adding queue 13 to ctrl 878.
[ 1653.874005] nvmet: adding queue 14 to ctrl 878.
[ 1653.894110] nvmet: adding queue 15 to ctrl 878.
[ 1653.894402] nvmet: adding queue 16 to ctrl 878.
[ 1653.999226] nvmet: creating controller 879 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.053257] nvmet: adding queue 1 to ctrl 879.
[ 1654.053460] nvmet: adding queue 2 to ctrl 879.
[ 1654.053671] nvmet: adding queue 3 to ctrl 879.
[ 1654.053863] nvmet: adding queue 4 to ctrl 879.
[ 1654.054012] nvmet: adding queue 5 to ctrl 879.
[ 1654.054200] nvmet: adding queue 6 to ctrl 879.
[ 1654.054371] nvmet: adding queue 7 to ctrl 879.
[ 1654.054586] nvmet: adding queue 8 to ctrl 879.
[ 1654.054766] nvmet: adding queue 9 to ctrl 879.
[ 1654.054955] nvmet: adding queue 10 to ctrl 879.
[ 1654.055196] nvmet: adding queue 11 to ctrl 879.
[ 1654.055442] nvmet: adding queue 12 to ctrl 879.
[ 1654.055647] nvmet: adding queue 13 to ctrl 879.
[ 1654.055817] nvmet: adding queue 14 to ctrl 879.
[ 1654.056021] nvmet: adding queue 15 to ctrl 879.
[ 1654.056265] nvmet: adding queue 16 to ctrl 879.
[ 1654.191694] nvmet_rdma: freeing queue 14939
[ 1654.194713] nvmet_rdma: freeing queue 14941
[ 1654.196344] nvmet_rdma: freeing queue 14942
[ 1654.210024] nvmet: creating controller 880 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.263112] nvmet: adding queue 1 to ctrl 880.
[ 1654.263388] nvmet: adding queue 2 to ctrl 880.
[ 1654.263576] nvmet: adding queue 3 to ctrl 880.
[ 1654.263819] nvmet: adding queue 4 to ctrl 880.
[ 1654.264018] nvmet: adding queue 5 to ctrl 880.
[ 1654.264218] nvmet: adding queue 6 to ctrl 880.
[ 1654.264364] nvmet: adding queue 7 to ctrl 880.
[ 1654.264600] nvmet: adding queue 8 to ctrl 880.
[ 1654.264798] nvmet: adding queue 9 to ctrl 880.
[ 1654.265068] nvmet: adding queue 10 to ctrl 880.
[ 1654.265227] nvmet: adding queue 11 to ctrl 880.
[ 1654.277031] nvmet: adding queue 12 to ctrl 880.
[ 1654.277222] nvmet: adding queue 13 to ctrl 880.
[ 1654.296990] nvmet: adding queue 14 to ctrl 880.
[ 1654.297280] nvmet: adding queue 15 to ctrl 880.
[ 1654.297513] nvmet: adding queue 16 to ctrl 880.
[ 1654.389902] nvmet: creating controller 881 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.443518] nvmet: adding queue 1 to ctrl 881.
[ 1654.443795] nvmet: adding queue 2 to ctrl 881.
[ 1654.443990] nvmet: adding queue 3 to ctrl 881.
[ 1654.459542] nvmet: adding queue 4 to ctrl 881.
[ 1654.459740] nvmet: adding queue 5 to ctrl 881.
[ 1654.479889] nvmet: adding queue 6 to ctrl 881.
[ 1654.480165] nvmet: adding queue 7 to ctrl 881.
[ 1654.500143] nvmet: adding queue 8 to ctrl 881.
[ 1654.500371] nvmet: adding queue 9 to ctrl 881.
[ 1654.500648] nvmet: adding queue 10 to ctrl 881.
[ 1654.500898] nvmet: adding queue 11 to ctrl 881.
[ 1654.501112] nvmet: adding queue 12 to ctrl 881.
[ 1654.501294] nvmet: adding queue 13 to ctrl 881.
[ 1654.501527] nvmet: adding queue 14 to ctrl 881.
[ 1654.501816] nvmet: adding queue 15 to ctrl 881.
[ 1654.502029] nvmet: adding queue 16 to ctrl 881.
[ 1654.553034] nvmet_rdma: freeing queue 14961
[ 1654.555231] nvmet_rdma: freeing queue 14962
[ 1654.556781] nvmet_rdma: freeing queue 14963
[ 1654.558381] nvmet_rdma: freeing queue 14964
[ 1654.559715] nvmet_rdma: freeing queue 14965
[ 1654.561233] nvmet_rdma: freeing queue 14966
[ 1654.562690] nvmet_rdma: freeing queue 14967
[ 1654.564246] nvmet_rdma: freeing queue 14968
[ 1654.565625] nvmet_rdma: freeing queue 14969
[ 1654.573058] nvmet_rdma: freeing queue 14974
[ 1654.576018] nvmet_rdma: freeing queue 14976
[ 1654.589769] nvmet: creating controller 882 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.644240] nvmet: adding queue 1 to ctrl 882.
[ 1654.644440] nvmet: adding queue 2 to ctrl 882.
[ 1654.644659] nvmet: adding queue 3 to ctrl 882.
[ 1654.644973] nvmet: adding queue 4 to ctrl 882.
[ 1654.645108] nvmet: adding queue 5 to ctrl 882.
[ 1654.645284] nvmet: adding queue 6 to ctrl 882.
[ 1654.645566] nvmet: adding queue 7 to ctrl 882.
[ 1654.650861] nvmet: adding queue 8 to ctrl 882.
[ 1654.669184] nvmet: adding queue 9 to ctrl 882.
[ 1654.669428] nvmet: adding queue 10 to ctrl 882.
[ 1654.669722] nvmet: adding queue 11 to ctrl 882.
[ 1654.669972] nvmet: adding queue 12 to ctrl 882.
[ 1654.670170] nvmet: adding queue 13 to ctrl 882.
[ 1654.670385] nvmet: adding queue 14 to ctrl 882.
[ 1654.670671] nvmet: adding queue 15 to ctrl 882.
[ 1654.671005] nvmet: adding queue 16 to ctrl 882.
[ 1654.723213] nvmet_rdma: freeing queue 14978
[ 1654.725708] nvmet_rdma: freeing queue 14979
[ 1654.735865] nvmet_rdma: freeing queue 14986
[ 1654.737414] nvmet_rdma: freeing queue 14987
[ 1654.738932] nvmet_rdma: freeing queue 14988
[ 1654.760002] nvmet: creating controller 883 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.813495] nvmet: adding queue 1 to ctrl 883.
[ 1654.813674] nvmet: adding queue 2 to ctrl 883.
[ 1654.813937] nvmet: adding queue 3 to ctrl 883.
[ 1654.814165] nvmet: adding queue 4 to ctrl 883.
[ 1654.814373] nvmet: adding queue 5 to ctrl 883.
[ 1654.814546] nvmet: adding queue 6 to ctrl 883.
[ 1654.814736] nvmet: adding queue 7 to ctrl 883.
[ 1654.814929] nvmet: adding queue 8 to ctrl 883.
[ 1654.815137] nvmet: adding queue 9 to ctrl 883.
[ 1654.815365] nvmet: adding queue 10 to ctrl 883.
[ 1654.818970] nvmet: adding queue 11 to ctrl 883.
[ 1654.819194] nvmet: adding queue 12 to ctrl 883.
[ 1654.819399] nvmet: adding queue 13 to ctrl 883.
[ 1654.819610] nvmet: adding queue 14 to ctrl 883.
[ 1654.819871] nvmet: adding queue 15 to ctrl 883.
[ 1654.820128] nvmet: adding queue 16 to ctrl 883.
[ 1654.903397] nvmet_rdma: freeing queue 14995
[ 1654.905168] nvmet_rdma: freeing queue 14996
[ 1654.906727] nvmet_rdma: freeing queue 14997
[ 1654.909512] nvmet_rdma: freeing queue 14999
[ 1654.914087] nvmet_rdma: freeing queue 15002
[ 1654.915301] nvmet_rdma: freeing queue 15003
[ 1654.916828] nvmet_rdma: freeing queue 15004
[ 1654.918784] nvmet_rdma: freeing queue 15005
[ 1654.921109] nvmet_rdma: freeing queue 15007
[ 1654.922555] nvmet_rdma: freeing queue 15008
[ 1654.924014] nvmet_rdma: freeing queue 15009
[ 1654.939456] nvmet: creating controller 884 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1654.992255] nvmet: adding queue 1 to ctrl 884.
[ 1654.992663] nvmet: adding queue 2 to ctrl 884.
[ 1654.992922] nvmet: adding queue 3 to ctrl 884.
[ 1654.993159] nvmet: adding queue 4 to ctrl 884.
[ 1654.993302] nvmet: adding queue 5 to ctrl 884.
[ 1654.999921] nvmet: adding queue 6 to ctrl 884.
[ 1655.000114] nvmet: adding queue 7 to ctrl 884.
[ 1655.020255] nvmet: adding queue 8 to ctrl 884.
[ 1655.020502] nvmet: adding queue 9 to ctrl 884.
[ 1655.020715] nvmet: adding queue 10 to ctrl 884.
[ 1655.021014] nvmet: adding queue 11 to ctrl 884.
[ 1655.021315] nvmet: adding queue 12 to ctrl 884.
[ 1655.021506] nvmet: adding queue 13 to ctrl 884.
[ 1655.021693] nvmet: adding queue 14 to ctrl 884.
[ 1655.040180] nvmet: adding queue 15 to ctrl 884.
[ 1655.040486] nvmet: adding queue 16 to ctrl 884.
[ 1655.128959] nvmet: creating controller 885 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1655.181994] nvmet: adding queue 1 to ctrl 885.
[ 1655.196413] nvmet: adding queue 2 to ctrl 885.
[ 1655.196694] nvmet: adding queue 3 to ctrl 885.
[ 1655.197022] nvmet: adding queue 4 to ctrl 885.
[ 1655.197320] nvmet: adding queue 5 to ctrl 885.
[ 1655.197613] nvmet: adding queue 6 to ctrl 885.
[ 1655.197767] nvmet: adding queue 7 to ctrl 885.
[ 1655.197997] nvmet: adding queue 8 to ctrl 885.
[ 1655.198242] nvmet: adding queue 9 to ctrl 885.
[ 1655.198595] nvmet: adding queue 10 to ctrl 885.
[ 1655.198899] nvmet: adding queue 11 to ctrl 885.
[ 1655.199125] nvmet: adding queue 12 to ctrl 885.
[ 1655.199330] nvmet: adding queue 13 to ctrl 885.
[ 1655.199563] nvmet: adding queue 14 to ctrl 885.
[ 1655.199813] nvmet: adding queue 15 to ctrl 885.
[ 1655.200124] nvmet: adding queue 16 to ctrl 885.
[ 1655.277842] nvmet_rdma: freeing queue 15028
[ 1655.290192] nvmet: creating controller 886 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1655.343318] nvmet: adding queue 1 to ctrl 886.
[ 1655.359037] nvmet: adding queue 2 to ctrl 886.
[ 1655.379348] nvmet: adding queue 3 to ctrl 886.
[ 1655.379655] nvmet: adding queue 4 to ctrl 886.
[ 1655.379960] nvmet: adding queue 5 to ctrl 886.
[ 1655.380165] nvmet: adding queue 6 to ctrl 886.
[ 1655.380370] nvmet: adding queue 7 to ctrl 886.
[ 1655.380558] nvmet: adding queue 8 to ctrl 886.
[ 1655.380795] nvmet: adding queue 9 to ctrl 886.
[ 1655.381081] nvmet: adding queue 10 to ctrl 886.
[ 1655.381314] nvmet: adding queue 11 to ctrl 886.
[ 1655.381554] nvmet: adding queue 12 to ctrl 886.
[ 1655.381766] nvmet: adding queue 13 to ctrl 886.
[ 1655.381964] nvmet: adding queue 14 to ctrl 886.
[ 1655.382346] nvmet: adding queue 15 to ctrl 886.
[ 1655.382629] nvmet: adding queue 16 to ctrl 886.
[ 1655.499564] nvmet: creating controller 887 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1655.552242] nvmet: adding queue 1 to ctrl 887.
[ 1655.552422] nvmet: adding queue 2 to ctrl 887.
[ 1655.552638] nvmet: adding queue 3 to ctrl 887.
[ 1655.552900] nvmet: adding queue 4 to ctrl 887.
[ 1655.572831] nvmet: adding queue 5 to ctrl 887.
[ 1655.573136] nvmet: adding queue 6 to ctrl 887.
[ 1655.573425] nvmet: adding queue 7 to ctrl 887.
[ 1655.573720] nvmet: adding queue 8 to ctrl 887.
[ 1655.573978] nvmet: adding queue 9 to ctrl 887.
[ 1655.574279] nvmet: adding queue 10 to ctrl 887.
[ 1655.574566] nvmet: adding queue 11 to ctrl 887.
[ 1655.574839] nvmet: adding queue 12 to ctrl 887.
[ 1655.575013] nvmet: adding queue 13 to ctrl 887.
[ 1655.575215] nvmet: adding queue 14 to ctrl 887.
[ 1655.575392] nvmet: ctrl 809 keep-alive timer (15 seconds) expired!
[ 1655.575394] nvmet: ctrl 809 fatal error occurred!
[ 1655.575597] nvmet: adding queue 15 to ctrl 887.
[ 1655.575882] nvmet: adding queue 16 to ctrl 887.
[ 1655.643082] nvmet_rdma: freeing queue 15063
[ 1655.644908] nvmet_rdma: freeing queue 15064
[ 1655.648521] nvmet_rdma: freeing queue 15066
[ 1655.650134] nvmet_rdma: freeing queue 15067
[ 1655.657696] nvmet_rdma: freeing queue 15072
[ 1655.662083] nvmet_rdma: freeing queue 15075
[ 1655.679682] nvmet: creating controller 888 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1655.732836] nvmet: adding queue 1 to ctrl 888.
[ 1655.738193] nvmet: adding queue 2 to ctrl 888.
[ 1655.738485] nvmet: adding queue 3 to ctrl 888.
[ 1655.738660] nvmet: adding queue 4 to ctrl 888.
[ 1655.738848] nvmet: adding queue 5 to ctrl 888.
[ 1655.739047] nvmet: adding queue 6 to ctrl 888.
[ 1655.739241] nvmet: adding queue 7 to ctrl 888.
[ 1655.739506] nvmet: adding queue 8 to ctrl 888.
[ 1655.759318] nvmet: adding queue 9 to ctrl 888.
[ 1655.759588] nvmet: adding queue 10 to ctrl 888.
[ 1655.779408] nvmet: adding queue 11 to ctrl 888.
[ 1655.779791] nvmet: adding queue 12 to ctrl 888.
[ 1655.799403] nvmet: adding queue 13 to ctrl 888.
[ 1655.799660] nvmet: adding queue 14 to ctrl 888.
[ 1655.800027] nvmet: adding queue 15 to ctrl 888.
[ 1655.800284] nvmet: adding queue 16 to ctrl 888.
[ 1655.909302] nvmet: creating controller 889 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1655.963612] nvmet: adding queue 1 to ctrl 889.
[ 1655.963882] nvmet: adding queue 2 to ctrl 889.
[ 1655.964161] nvmet: adding queue 3 to ctrl 889.
[ 1655.964371] nvmet: adding queue 4 to ctrl 889.
[ 1655.964586] nvmet: adding queue 5 to ctrl 889.
[ 1655.964813] nvmet: adding queue 6 to ctrl 889.
[ 1655.965002] nvmet: adding queue 7 to ctrl 889.
[ 1655.965223] nvmet: adding queue 8 to ctrl 889.
[ 1655.965418] nvmet: adding queue 9 to ctrl 889.
[ 1655.965677] nvmet: adding queue 10 to ctrl 889.
[ 1655.965930] nvmet: adding queue 11 to ctrl 889.
[ 1655.966189] nvmet: adding queue 12 to ctrl 889.
[ 1655.981697] nvmet: adding queue 13 to ctrl 889.
[ 1656.001684] nvmet: adding queue 14 to ctrl 889.
[ 1656.001969] nvmet: adding queue 15 to ctrl 889.
[ 1656.002293] nvmet: adding queue 16 to ctrl 889.
[ 1656.119579] nvmet: creating controller 890 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1656.173183] nvmet: adding queue 1 to ctrl 890.
[ 1656.173371] nvmet: adding queue 2 to ctrl 890.
[ 1656.173610] nvmet: adding queue 3 to ctrl 890.
[ 1656.173831] nvmet: adding queue 4 to ctrl 890.
[ 1656.174012] nvmet: adding queue 5 to ctrl 890.
[ 1656.174184] nvmet: adding queue 6 to ctrl 890.
[ 1656.174385] nvmet: adding queue 7 to ctrl 890.
[ 1656.174615] nvmet: adding queue 8 to ctrl 890.
[ 1656.174814] nvmet: adding queue 9 to ctrl 890.
[ 1656.175070] nvmet: adding queue 10 to ctrl 890.
[ 1656.175263] nvmet: adding queue 11 to ctrl 890.
[ 1656.175505] nvmet: adding queue 12 to ctrl 890.
[ 1656.175717] nvmet: adding queue 13 to ctrl 890.
[ 1656.175933] nvmet: adding queue 14 to ctrl 890.
[ 1656.176167] nvmet: adding queue 15 to ctrl 890.
[ 1656.189879] nvmet: adding queue 16 to ctrl 890.
[ 1656.308683] nvmet: creating controller 891 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1656.361774] nvmet: adding queue 1 to ctrl 891.
[ 1656.361966] nvmet: adding queue 2 to ctrl 891.
[ 1656.362251] nvmet: adding queue 3 to ctrl 891.
[ 1656.362463] nvmet: adding queue 4 to ctrl 891.
[ 1656.362668] nvmet: adding queue 5 to ctrl 891.
[ 1656.362864] nvmet: adding queue 6 to ctrl 891.
[ 1656.363077] nvmet: adding queue 7 to ctrl 891.
[ 1656.363277] nvmet: adding queue 8 to ctrl 891.
[ 1656.363519] nvmet: adding queue 9 to ctrl 891.
[ 1656.363841] nvmet: adding queue 10 to ctrl 891.
[ 1656.366308] nvmet: adding queue 11 to ctrl 891.
[ 1656.366504] nvmet: adding queue 12 to ctrl 891.
[ 1656.387077] nvmet: adding queue 13 to ctrl 891.
[ 1656.387361] nvmet: adding queue 14 to ctrl 891.
[ 1656.387615] nvmet: adding queue 15 to ctrl 891.
[ 1656.387912] nvmet: adding queue 16 to ctrl 891.
[ 1656.479442] nvmet: creating controller 892 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1656.534181] nvmet: adding queue 1 to ctrl 892.
[ 1656.534390] nvmet: adding queue 2 to ctrl 892.
[ 1656.552039] nvmet: adding queue 3 to ctrl 892.
[ 1656.552354] nvmet: adding queue 4 to ctrl 892.
[ 1656.572335] nvmet: adding queue 5 to ctrl 892.
[ 1656.572604] nvmet: adding queue 6 to ctrl 892.
[ 1656.594586] nvmet: adding queue 7 to ctrl 892.
[ 1656.594868] nvmet: adding queue 8 to ctrl 892.
[ 1656.595151] nvmet: adding queue 9 to ctrl 892.
[ 1656.595505] nvmet: adding queue 10 to ctrl 892.
[ 1656.595789] nvmet: adding queue 11 to ctrl 892.
[ 1656.596069] nvmet: adding queue 12 to ctrl 892.
[ 1656.596336] nvmet: adding queue 13 to ctrl 892.
[ 1656.596691] nvmet: adding queue 14 to ctrl 892.
[ 1656.596985] nvmet: adding queue 15 to ctrl 892.
[ 1656.597296] nvmet: adding queue 16 to ctrl 892.
[ 1656.693899] nvmet_rdma: freeing queue 15155
[ 1656.719179] nvmet: creating controller 893 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1656.772228] nvmet: adding queue 1 to ctrl 893.
[ 1656.772445] nvmet: adding queue 2 to ctrl 893.
[ 1656.772629] nvmet: adding queue 3 to ctrl 893.
[ 1656.772812] nvmet: adding queue 4 to ctrl 893.
[ 1656.773018] nvmet: adding queue 5 to ctrl 893.
[ 1656.773209] nvmet: adding queue 6 to ctrl 893.
[ 1656.792780] nvmet: adding queue 7 to ctrl 893.
[ 1656.812809] nvmet: adding queue 8 to ctrl 893.
[ 1656.813046] nvmet: adding queue 9 to ctrl 893.
[ 1656.813348] nvmet: adding queue 10 to ctrl 893.
[ 1656.813624] nvmet: adding queue 11 to ctrl 893.
[ 1656.813942] nvmet: adding queue 12 to ctrl 893.
[ 1656.814190] nvmet: adding queue 13 to ctrl 893.
[ 1656.814425] nvmet: adding queue 14 to ctrl 893.
[ 1656.814753] nvmet: adding queue 15 to ctrl 893.
[ 1656.815115] nvmet: adding queue 16 to ctrl 893.
[ 1656.889962] nvmet: creating controller 894 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1656.942096] nvmet: adding queue 1 to ctrl 894.
[ 1656.942366] nvmet: adding queue 2 to ctrl 894.
[ 1656.942648] nvmet: adding queue 3 to ctrl 894.
[ 1656.942847] nvmet: adding queue 4 to ctrl 894.
[ 1656.943020] nvmet: adding queue 5 to ctrl 894.
[ 1656.943155] nvmet: adding queue 6 to ctrl 894.
[ 1656.943310] nvmet: adding queue 7 to ctrl 894.
[ 1656.943600] nvmet: adding queue 8 to ctrl 894.
[ 1656.943794] nvmet: adding queue 9 to ctrl 894.
[ 1656.951405] nvmet: adding queue 10 to ctrl 894.
[ 1656.951698] nvmet: adding queue 11 to ctrl 894.
[ 1656.951892] nvmet: adding queue 12 to ctrl 894.
[ 1656.952150] nvmet: adding queue 13 to ctrl 894.
[ 1656.952398] nvmet: adding queue 14 to ctrl 894.
[ 1656.952750] nvmet: adding queue 15 to ctrl 894.
[ 1656.953013] nvmet: adding queue 16 to ctrl 894.
[ 1657.059368] nvmet: creating controller 895 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1657.113496] nvmet: adding queue 1 to ctrl 895.
[ 1657.113667] nvmet: adding queue 2 to ctrl 895.
[ 1657.113880] nvmet: adding queue 3 to ctrl 895.
[ 1657.114190] nvmet: adding queue 4 to ctrl 895.
[ 1657.129672] nvmet: adding queue 5 to ctrl 895.
[ 1657.129805] nvmet: adding queue 6 to ctrl 895.
[ 1657.150470] nvmet: adding queue 7 to ctrl 895.
[ 1657.150795] nvmet: adding queue 8 to ctrl 895.
[ 1657.150967] nvmet: adding queue 9 to ctrl 895.
[ 1657.151209] nvmet: adding queue 10 to ctrl 895.
[ 1657.151432] nvmet: adding queue 11 to ctrl 895.
[ 1657.151676] nvmet: adding queue 12 to ctrl 895.
[ 1657.151905] nvmet: adding queue 13 to ctrl 895.
[ 1657.170373] nvmet: adding queue 14 to ctrl 895.
[ 1657.170691] nvmet: adding queue 15 to ctrl 895.
[ 1657.190292] nvmet: adding queue 16 to ctrl 895.
[ 1657.269172] nvmet: creating controller 896 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1657.332436] nvmet: adding queue 1 to ctrl 896.
[ 1657.332690] nvmet: adding queue 2 to ctrl 896.
[ 1657.333004] nvmet: adding queue 3 to ctrl 896.
[ 1657.333210] nvmet: adding queue 4 to ctrl 896.
[ 1657.333391] nvmet: adding queue 5 to ctrl 896.
[ 1657.333577] nvmet: adding queue 6 to ctrl 896.
[ 1657.333774] nvmet: adding queue 7 to ctrl 896.
[ 1657.333962] nvmet: adding queue 8 to ctrl 896.
[ 1657.334101] nvmet: adding queue 9 to ctrl 896.
[ 1657.334320] nvmet: adding queue 10 to ctrl 896.
[ 1657.334561] nvmet: adding queue 11 to ctrl 896.
[ 1657.334825] nvmet: adding queue 12 to ctrl 896.
[ 1657.335006] nvmet: adding queue 13 to ctrl 896.
[ 1657.335199] nvmet: adding queue 14 to ctrl 896.
[ 1657.335424] nvmet: adding queue 15 to ctrl 896.
[ 1657.335704] nvmet: adding queue 16 to ctrl 896.
[ 1657.459457] nvmet: creating controller 897 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1657.524725] nvmet: adding queue 1 to ctrl 897.
[ 1657.544614] nvmet: adding queue 2 to ctrl 897.
[ 1657.544872] nvmet: adding queue 3 to ctrl 897.
[ 1657.545187] nvmet: adding queue 4 to ctrl 897.
[ 1657.545511] nvmet: adding queue 5 to ctrl 897.
[ 1657.545790] nvmet: adding queue 6 to ctrl 897.
[ 1657.546068] nvmet: adding queue 7 to ctrl 897.
[ 1657.546439] nvmet: adding queue 8 to ctrl 897.
[ 1657.546665] nvmet: adding queue 9 to ctrl 897.
[ 1657.546936] nvmet: adding queue 10 to ctrl 897.
[ 1657.547207] nvmet: adding queue 11 to ctrl 897.
[ 1657.547497] nvmet: adding queue 12 to ctrl 897.
[ 1657.547719] nvmet: adding queue 13 to ctrl 897.
[ 1657.547921] nvmet: adding queue 14 to ctrl 897.
[ 1657.548146] nvmet: adding queue 15 to ctrl 897.
[ 1657.548385] nvmet: adding queue 16 to ctrl 897.
[ 1657.659359] nvmet: creating controller 898 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1657.713161] nvmet: adding queue 1 to ctrl 898.
[ 1657.713365] nvmet: adding queue 2 to ctrl 898.
[ 1657.713552] nvmet: adding queue 3 to ctrl 898.
[ 1657.730477] nvmet: adding queue 4 to ctrl 898.
[ 1657.730754] nvmet: adding queue 5 to ctrl 898.
[ 1657.730944] nvmet: adding queue 6 to ctrl 898.
[ 1657.731212] nvmet: adding queue 7 to ctrl 898.
[ 1657.731376] nvmet: adding queue 8 to ctrl 898.
[ 1657.731610] nvmet: adding queue 9 to ctrl 898.
[ 1657.731874] nvmet: adding queue 10 to ctrl 898.
[ 1657.732174] nvmet: adding queue 11 to ctrl 898.
[ 1657.732401] nvmet: adding queue 12 to ctrl 898.
[ 1657.732632] nvmet: adding queue 13 to ctrl 898.
[ 1657.732857] nvmet: adding queue 14 to ctrl 898.
[ 1657.733106] nvmet: adding queue 15 to ctrl 898.
[ 1657.750729] nvmet: adding queue 16 to ctrl 898.
[ 1657.850027] nvmet: creating controller 899 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1657.922852] nvmet: adding queue 1 to ctrl 899.
[ 1657.923172] nvmet: adding queue 2 to ctrl 899.
[ 1657.923414] nvmet: adding queue 3 to ctrl 899.
[ 1657.923728] nvmet: adding queue 4 to ctrl 899.
[ 1657.924047] nvmet: adding queue 5 to ctrl 899.
[ 1657.924348] nvmet: adding queue 6 to ctrl 899.
[ 1657.924668] nvmet: adding queue 7 to ctrl 899.
[ 1657.941175] nvmet: adding queue 8 to ctrl 899.
[ 1657.941433] nvmet: adding queue 9 to ctrl 899.
[ 1657.959511] nvmet: adding queue 10 to ctrl 899.
[ 1657.959859] nvmet: adding queue 11 to ctrl 899.
[ 1657.977926] nvmet: adding queue 12 to ctrl 899.
[ 1657.978162] nvmet: adding queue 13 to ctrl 899.
[ 1657.978412] nvmet: adding queue 14 to ctrl 899.
[ 1657.978705] nvmet: adding queue 15 to ctrl 899.
[ 1657.978970] nvmet: adding queue 16 to ctrl 899.
[ 1658.049239] nvmet: creating controller 900 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1658.106734] nvmet: adding queue 1 to ctrl 900.
[ 1658.106916] nvmet: adding queue 2 to ctrl 900.
[ 1658.107184] nvmet: adding queue 3 to ctrl 900.
[ 1658.107410] nvmet: adding queue 4 to ctrl 900.
[ 1658.107670] nvmet: adding queue 5 to ctrl 900.
[ 1658.107830] nvmet: adding queue 6 to ctrl 900.
[ 1658.108039] nvmet: adding queue 7 to ctrl 900.
[ 1658.108319] nvmet: adding queue 8 to ctrl 900.
[ 1658.108501] nvmet: adding queue 9 to ctrl 900.
[ 1658.108699] nvmet: adding queue 10 to ctrl 900.
[ 1658.108969] nvmet: adding queue 11 to ctrl 900.
[ 1658.143021] nvmet: adding queue 12 to ctrl 900.
[ 1658.165031] nvmet: adding queue 13 to ctrl 900.
[ 1658.165295] nvmet: adding queue 14 to ctrl 900.
[ 1658.165594] nvmet: adding queue 15 to ctrl 900.
[ 1658.165905] nvmet: adding queue 16 to ctrl 900.
[ 1658.269366] nvmet: creating controller 901 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1658.323912] nvmet: adding queue 1 to ctrl 901.
[ 1658.324133] nvmet: adding queue 2 to ctrl 901.
[ 1658.324338] nvmet: adding queue 3 to ctrl 901.
[ 1658.324608] nvmet: adding queue 4 to ctrl 901.
[ 1658.324782] nvmet: adding queue 5 to ctrl 901.
[ 1658.324954] nvmet: adding queue 6 to ctrl 901.
[ 1658.325141] nvmet: adding queue 7 to ctrl 901.
[ 1658.325359] nvmet: adding queue 8 to ctrl 901.
[ 1658.325606] nvmet: adding queue 9 to ctrl 901.
[ 1658.325844] nvmet: adding queue 10 to ctrl 901.
[ 1658.326043] nvmet: adding queue 11 to ctrl 901.
[ 1658.326303] nvmet: adding queue 12 to ctrl 901.
[ 1658.326570] nvmet: adding queue 13 to ctrl 901.
[ 1658.326834] nvmet: adding queue 14 to ctrl 901.
[ 1658.328880] nvmet: adding queue 15 to ctrl 901.
[ 1658.329112] nvmet: adding queue 16 to ctrl 901.
[ 1658.419960] nvmet: creating controller 902 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1658.474351] nvmet: adding queue 1 to ctrl 902.
[ 1658.474534] nvmet: adding queue 2 to ctrl 902.
[ 1658.474725] nvmet: adding queue 3 to ctrl 902.
[ 1658.474964] nvmet: adding queue 4 to ctrl 902.
[ 1658.475175] nvmet: adding queue 5 to ctrl 902.
[ 1658.475352] nvmet: adding queue 6 to ctrl 902.
[ 1658.475753] nvmet: adding queue 7 to ctrl 902.
[ 1658.475970] nvmet: adding queue 8 to ctrl 902.
[ 1658.476175] nvmet: adding queue 9 to ctrl 902.
[ 1658.522185] nvmet: adding queue 10 to ctrl 902.
[ 1658.522431] nvmet: adding queue 11 to ctrl 902.
[ 1658.542231] nvmet: adding queue 12 to ctrl 902.
[ 1658.542489] nvmet: adding queue 13 to ctrl 902.
[ 1658.542720] nvmet: adding queue 14 to ctrl 902.
[ 1658.543053] nvmet: adding queue 15 to ctrl 902.
[ 1658.543374] nvmet: adding queue 16 to ctrl 902.
[ 1658.660406] nvmet: creating controller 903 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1658.714879] nvmet: adding queue 1 to ctrl 903.
[ 1658.726901] nvmet: adding queue 2 to ctrl 903.
[ 1658.727192] nvmet: adding queue 3 to ctrl 903.
[ 1658.747214] nvmet: adding queue 4 to ctrl 903.
[ 1658.747511] nvmet: adding queue 5 to ctrl 903.
[ 1658.767628] nvmet: adding queue 6 to ctrl 903.
[ 1658.767895] nvmet: adding queue 7 to ctrl 903.
[ 1658.768122] nvmet: adding queue 8 to ctrl 903.
[ 1658.768361] nvmet: adding queue 9 to ctrl 903.
[ 1658.768627] nvmet: adding queue 10 to ctrl 903.
[ 1658.768912] nvmet: adding queue 11 to ctrl 903.
[ 1658.769203] nvmet: adding queue 12 to ctrl 903.
[ 1658.769423] nvmet: adding queue 13 to ctrl 903.
[ 1658.769618] nvmet: adding queue 14 to ctrl 903.
[ 1658.769869] nvmet: adding queue 15 to ctrl 903.
[ 1658.770169] nvmet: adding queue 16 to ctrl 903.
[ 1658.775243] nvmet: ctrl 826 keep-alive timer (15 seconds) expired!
[ 1658.775245] nvmet: ctrl 826 fatal error occurred!
[ 1658.849357] nvmet: creating controller 904 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1658.902361] nvmet: adding queue 1 to ctrl 904.
[ 1658.902575] nvmet: adding queue 2 to ctrl 904.
[ 1658.902808] nvmet: adding queue 3 to ctrl 904.
[ 1658.903004] nvmet: adding queue 4 to ctrl 904.
[ 1658.903219] nvmet: adding queue 5 to ctrl 904.
[ 1658.920409] nvmet: adding queue 6 to ctrl 904.
[ 1658.940348] nvmet: adding queue 7 to ctrl 904.
[ 1658.940597] nvmet: adding queue 8 to ctrl 904.
[ 1658.940847] nvmet: adding queue 9 to ctrl 904.
[ 1658.941100] nvmet: adding queue 10 to ctrl 904.
[ 1658.941325] nvmet: adding queue 11 to ctrl 904.
[ 1658.941573] nvmet: adding queue 12 to ctrl 904.
[ 1658.941774] nvmet: adding queue 13 to ctrl 904.
[ 1658.941908] nvmet: adding queue 14 to ctrl 904.
[ 1658.942209] nvmet: adding queue 15 to ctrl 904.
[ 1658.942531] nvmet: adding queue 16 to ctrl 904.
[ 1659.059607] nvmet: creating controller 905 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1659.113319] nvmet: adding queue 1 to ctrl 905.
[ 1659.113545] nvmet: adding queue 2 to ctrl 905.
[ 1659.113795] nvmet: adding queue 3 to ctrl 905.
[ 1659.113993] nvmet: adding queue 4 to ctrl 905.
[ 1659.114194] nvmet: adding queue 5 to ctrl 905.
[ 1659.114361] nvmet: adding queue 6 to ctrl 905.
[ 1659.114542] nvmet: adding queue 7 to ctrl 905.
[ 1659.114722] nvmet: adding queue 8 to ctrl 905.
[ 1659.120257] nvmet: adding queue 9 to ctrl 905.
[ 1659.120503] nvmet: adding queue 10 to ctrl 905.
[ 1659.120796] nvmet: adding queue 11 to ctrl 905.
[ 1659.121050] nvmet: adding queue 12 to ctrl 905.
[ 1659.121226] nvmet: adding queue 13 to ctrl 905.
[ 1659.121444] nvmet: adding queue 14 to ctrl 905.
[ 1659.121687] nvmet: adding queue 15 to ctrl 905.
[ 1659.121881] nvmet: adding queue 16 to ctrl 905.
[ 1659.255424] nvmet_rdma: freeing queue 15384
[ 1659.257389] nvmet_rdma: freeing queue 15368
[ 1659.269995] nvmet: creating controller 906 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1659.324326] nvmet: adding queue 1 to ctrl 906.
[ 1659.324530] nvmet: adding queue 2 to ctrl 906.
[ 1659.324797] nvmet: adding queue 3 to ctrl 906.
[ 1659.341099] nvmet: adding queue 4 to ctrl 906.
[ 1659.341286] nvmet: adding queue 5 to ctrl 906.
[ 1659.362516] nvmet: adding queue 6 to ctrl 906.
[ 1659.362789] nvmet: adding queue 7 to ctrl 906.
[ 1659.363068] nvmet: adding queue 8 to ctrl 906.
[ 1659.363401] nvmet: adding queue 9 to ctrl 906.
[ 1659.363718] nvmet: adding queue 10 to ctrl 906.
[ 1659.364058] nvmet: adding queue 11 to ctrl 906.
[ 1659.364372] nvmet: adding queue 12 to ctrl 906.
[ 1659.383351] nvmet: adding queue 13 to ctrl 906.
[ 1659.383581] nvmet: adding queue 14 to ctrl 906.
[ 1659.404743] nvmet: adding queue 15 to ctrl 906.
[ 1659.405075] nvmet: adding queue 16 to ctrl 906.
[ 1659.425234] nvmet: ctrl 830 keep-alive timer (15 seconds) expired!
[ 1659.425237] nvmet: ctrl 830 fatal error occurred!
[ 1659.499503] nvmet: creating controller 907 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1659.552930] nvmet: adding queue 1 to ctrl 907.
[ 1659.553139] nvmet: adding queue 2 to ctrl 907.
[ 1659.553340] nvmet: adding queue 3 to ctrl 907.
[ 1659.553542] nvmet: adding queue 4 to ctrl 907.
[ 1659.553711] nvmet: adding queue 5 to ctrl 907.
[ 1659.553913] nvmet: adding queue 6 to ctrl 907.
[ 1659.554100] nvmet: adding queue 7 to ctrl 907.
[ 1659.554268] nvmet: adding queue 8 to ctrl 907.
[ 1659.554469] nvmet: adding queue 9 to ctrl 907.
[ 1659.554748] nvmet: adding queue 10 to ctrl 907.
[ 1659.554952] nvmet: adding queue 11 to ctrl 907.
[ 1659.555200] nvmet: adding queue 12 to ctrl 907.
[ 1659.555409] nvmet: adding queue 13 to ctrl 907.
[ 1659.555603] nvmet: adding queue 14 to ctrl 907.
[ 1659.555836] nvmet: adding queue 15 to ctrl 907.
[ 1659.556061] nvmet: adding queue 16 to ctrl 907.
[ 1659.648161] nvmet_rdma: freeing queue 15413
[ 1659.649664] nvmet_rdma: freeing queue 15414
[ 1659.651179] nvmet_rdma: freeing queue 15415
[ 1659.654126] nvmet_rdma: freeing queue 15417
[ 1659.657256] nvmet_rdma: freeing queue 15402
[ 1659.669115] nvmet: creating controller 908 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1659.735940] nvmet: adding queue 1 to ctrl 908.
[ 1659.736227] nvmet: adding queue 2 to ctrl 908.
[ 1659.736570] nvmet: adding queue 3 to ctrl 908.
[ 1659.736804] nvmet: adding queue 4 to ctrl 908.
[ 1659.737015] nvmet: adding queue 5 to ctrl 908.
[ 1659.737210] nvmet: adding queue 6 to ctrl 908.
[ 1659.737413] nvmet: adding queue 7 to ctrl 908.
[ 1659.737678] nvmet: adding queue 8 to ctrl 908.
[ 1659.737924] nvmet: adding queue 9 to ctrl 908.
[ 1659.738191] nvmet: adding queue 10 to ctrl 908.
[ 1659.738446] nvmet: adding queue 11 to ctrl 908.
[ 1659.738741] nvmet: adding queue 12 to ctrl 908.
[ 1659.738951] nvmet: adding queue 13 to ctrl 908.
[ 1659.739201] nvmet: adding queue 14 to ctrl 908.
[ 1659.739432] nvmet: adding queue 15 to ctrl 908.
[ 1659.739744] nvmet: adding queue 16 to ctrl 908.
[ 1659.859883] nvmet: creating controller 909 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1659.912830] nvmet: adding queue 1 to ctrl 909.
[ 1659.912995] nvmet: adding queue 2 to ctrl 909.
[ 1659.924079] nvmet: adding queue 3 to ctrl 909.
[ 1659.924294] nvmet: adding queue 4 to ctrl 909.
[ 1659.924633] nvmet: adding queue 5 to ctrl 909.
[ 1659.924869] nvmet: adding queue 6 to ctrl 909.
[ 1659.925069] nvmet: adding queue 7 to ctrl 909.
[ 1659.925359] nvmet: adding queue 8 to ctrl 909.
[ 1659.925558] nvmet: adding queue 9 to ctrl 909.
[ 1659.925816] nvmet: adding queue 10 to ctrl 909.
[ 1659.926074] nvmet: adding queue 11 to ctrl 909.
[ 1659.926352] nvmet: adding queue 12 to ctrl 909.
[ 1659.926564] nvmet: adding queue 13 to ctrl 909.
[ 1659.926779] nvmet: adding queue 14 to ctrl 909.
[ 1659.945407] nvmet: adding queue 15 to ctrl 909.
[ 1659.945748] nvmet: adding queue 16 to ctrl 909.
[ 1660.029737] nvmet: creating controller 910 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1660.055193] nvmet: ctrl 833 keep-alive timer (15 seconds) expired!
[ 1660.055195] nvmet: ctrl 833 fatal error occurred!
[ 1660.082136] nvmet: adding queue 1 to ctrl 910.
[ 1660.082308] nvmet: adding queue 2 to ctrl 910.
[ 1660.082534] nvmet: adding queue 3 to ctrl 910.
[ 1660.082732] nvmet: adding queue 4 to ctrl 910.
[ 1660.082937] nvmet: adding queue 5 to ctrl 910.
[ 1660.083105] nvmet: adding queue 6 to ctrl 910.
[ 1660.085209] nvmet: adding queue 7 to ctrl 910.
[ 1660.085442] nvmet: adding queue 8 to ctrl 910.
[ 1660.104529] nvmet: adding queue 9 to ctrl 910.
[ 1660.104869] nvmet: adding queue 10 to ctrl 910.
[ 1660.123837] nvmet: adding queue 11 to ctrl 910.
[ 1660.124090] nvmet: adding queue 12 to ctrl 910.
[ 1660.124345] nvmet: adding queue 13 to ctrl 910.
[ 1660.124575] nvmet: adding queue 14 to ctrl 910.
[ 1660.124887] nvmet: adding queue 15 to ctrl 910.
[ 1660.125185] nvmet: adding queue 16 to ctrl 910.
[ 1660.238652] nvmet: creating controller 911 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1660.292270] nvmet: adding queue 1 to ctrl 911.
[ 1660.292446] nvmet: adding queue 2 to ctrl 911.
[ 1660.292688] nvmet: adding queue 3 to ctrl 911.
[ 1660.292909] nvmet: adding queue 4 to ctrl 911.
[ 1660.293069] nvmet: adding queue 5 to ctrl 911.
[ 1660.293249] nvmet: adding queue 6 to ctrl 911.
[ 1660.293439] nvmet: adding queue 7 to ctrl 911.
[ 1660.293637] nvmet: adding queue 8 to ctrl 911.
[ 1660.293867] nvmet: adding queue 9 to ctrl 911.
[ 1660.294161] nvmet: adding queue 10 to ctrl 911.
[ 1660.307010] nvmet: adding queue 11 to ctrl 911.
[ 1660.328020] nvmet: adding queue 12 to ctrl 911.
[ 1660.328274] nvmet: adding queue 13 to ctrl 911.
[ 1660.328525] nvmet: adding queue 14 to ctrl 911.
[ 1660.328814] nvmet: adding queue 15 to ctrl 911.
[ 1660.329077] nvmet: adding queue 16 to ctrl 911.
[ 1660.404477] nvmet_rdma: freeing queue 15472
[ 1660.406676] nvmet_rdma: freeing queue 15473
[ 1660.408151] nvmet_rdma: freeing queue 15474
[ 1660.409904] nvmet_rdma: freeing queue 15475
[ 1660.412822] nvmet_rdma: freeing queue 15477
[ 1660.439745] nvmet: creating controller 912 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1660.493594] nvmet: adding queue 1 to ctrl 912.
[ 1660.493756] nvmet: adding queue 2 to ctrl 912.
[ 1660.493959] nvmet: adding queue 3 to ctrl 912.
[ 1660.494157] nvmet: adding queue 4 to ctrl 912.
[ 1660.494325] nvmet: adding queue 5 to ctrl 912.
[ 1660.494593] nvmet: adding queue 6 to ctrl 912.
[ 1660.494865] nvmet: adding queue 7 to ctrl 912.
[ 1660.495089] nvmet: adding queue 8 to ctrl 912.
[ 1660.495264] nvmet: adding queue 9 to ctrl 912.
[ 1660.495489] nvmet: adding queue 10 to ctrl 912.
[ 1660.495750] nvmet: adding queue 11 to ctrl 912.
[ 1660.496033] nvmet: adding queue 12 to ctrl 912.
[ 1660.496236] nvmet: adding queue 13 to ctrl 912.
[ 1660.516448] nvmet: adding queue 14 to ctrl 912.
[ 1660.516752] nvmet: adding queue 15 to ctrl 912.
[ 1660.517014] nvmet: adding queue 16 to ctrl 912.
[ 1660.609912] nvmet: creating controller 913 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1660.663165] nvmet: adding queue 1 to ctrl 913.
[ 1660.663376] nvmet: adding queue 2 to ctrl 913.
[ 1660.663583] nvmet: adding queue 3 to ctrl 913.
[ 1660.663808] nvmet: adding queue 4 to ctrl 913.
[ 1660.663986] nvmet: adding queue 5 to ctrl 913.
[ 1660.664176] nvmet: adding queue 6 to ctrl 913.
[ 1660.664356] nvmet: adding queue 7 to ctrl 913.
[ 1660.664557] nvmet: adding queue 8 to ctrl 913.
[ 1660.673008] nvmet: adding queue 9 to ctrl 913.
[ 1660.673255] nvmet: adding queue 10 to ctrl 913.
[ 1660.695473] nvmet: adding queue 11 to ctrl 913.
[ 1660.695786] nvmet: adding queue 12 to ctrl 913.
[ 1660.696006] nvmet: adding queue 13 to ctrl 913.
[ 1660.696259] nvmet: adding queue 14 to ctrl 913.
[ 1660.696520] nvmet: adding queue 15 to ctrl 913.
[ 1660.696831] nvmet: adding queue 16 to ctrl 913.
[ 1660.757943] nvmet_rdma: freeing queue 15508
[ 1660.759728] nvmet_rdma: freeing queue 15509
[ 1660.789514] nvmet: creating controller 914 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1660.846486] nvmet: adding queue 1 to ctrl 914.
[ 1660.846694] nvmet: adding queue 2 to ctrl 914.
[ 1660.867701] nvmet: adding queue 3 to ctrl 914.
[ 1660.868041] nvmet: adding queue 4 to ctrl 914.
[ 1660.888590] nvmet: adding queue 5 to ctrl 914.
[ 1660.888862] nvmet: adding queue 6 to ctrl 914.
[ 1660.889193] nvmet: adding queue 7 to ctrl 914.
[ 1660.889529] nvmet: adding queue 8 to ctrl 914.
[ 1660.889755] nvmet: adding queue 9 to ctrl 914.
[ 1660.889970] nvmet: adding queue 10 to ctrl 914.
[ 1660.890220] nvmet: adding queue 11 to ctrl 914.
[ 1660.890549] nvmet: adding queue 12 to ctrl 914.
[ 1660.890816] nvmet: adding queue 13 to ctrl 914.
[ 1660.891084] nvmet: adding queue 14 to ctrl 914.
[ 1660.891350] nvmet: adding queue 15 to ctrl 914.
[ 1660.891617] nvmet: adding queue 16 to ctrl 914.
[ 1660.999324] nvmet: creating controller 915 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1661.054026] nvmet: adding queue 1 to ctrl 915.
[ 1661.054246] nvmet: adding queue 2 to ctrl 915.
[ 1661.054424] nvmet: adding queue 3 to ctrl 915.
[ 1661.054642] nvmet: adding queue 4 to ctrl 915.
[ 1661.067695] nvmet: adding queue 5 to ctrl 915.
[ 1661.088380] nvmet: adding queue 6 to ctrl 915.
[ 1661.088664] nvmet: adding queue 7 to ctrl 915.
[ 1661.088963] nvmet: adding queue 8 to ctrl 915.
[ 1661.089223] nvmet: adding queue 9 to ctrl 915.
[ 1661.089496] nvmet: adding queue 10 to ctrl 915.
[ 1661.089810] nvmet: adding queue 11 to ctrl 915.
[ 1661.090080] nvmet: adding queue 12 to ctrl 915.
[ 1661.090267] nvmet: adding queue 13 to ctrl 915.
[ 1661.090481] nvmet: adding queue 14 to ctrl 915.
[ 1661.090771] nvmet: adding queue 15 to ctrl 915.
[ 1661.091044] nvmet: adding queue 16 to ctrl 915.
[ 1661.198579] nvmet: creating controller 916 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1661.250622] nvmet: adding queue 1 to ctrl 916.
[ 1661.250811] nvmet: adding queue 2 to ctrl 916.
[ 1661.251023] nvmet: adding queue 3 to ctrl 916.
[ 1661.251303] nvmet: adding queue 4 to ctrl 916.
[ 1661.251499] nvmet: adding queue 5 to ctrl 916.
[ 1661.251708] nvmet: adding queue 6 to ctrl 916.
[ 1661.251944] nvmet: adding queue 7 to ctrl 916.
[ 1661.260872] nvmet: adding queue 8 to ctrl 916.
[ 1661.261094] nvmet: adding queue 9 to ctrl 916.
[ 1661.261344] nvmet: adding queue 10 to ctrl 916.
[ 1661.261599] nvmet: adding queue 11 to ctrl 916.
[ 1661.261852] nvmet: adding queue 12 to ctrl 916.
[ 1661.262070] nvmet: adding queue 13 to ctrl 916.
[ 1661.262271] nvmet: adding queue 14 to ctrl 916.
[ 1661.262504] nvmet: adding queue 15 to ctrl 916.
[ 1661.262728] nvmet: adding queue 16 to ctrl 916.
[ 1661.389188] nvmet: creating controller 917 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1661.441796] nvmet: adding queue 1 to ctrl 917.
[ 1661.442189] nvmet: adding queue 2 to ctrl 917.
[ 1661.462007] nvmet: adding queue 3 to ctrl 917.
[ 1661.462268] nvmet: adding queue 4 to ctrl 917.
[ 1661.482860] nvmet: adding queue 5 to ctrl 917.
[ 1661.483124] nvmet: adding queue 6 to ctrl 917.
[ 1661.483385] nvmet: adding queue 7 to ctrl 917.
[ 1661.483678] nvmet: adding queue 8 to ctrl 917.
[ 1661.483928] nvmet: adding queue 9 to ctrl 917.
[ 1661.484242] nvmet: adding queue 10 to ctrl 917.
[ 1661.484629] nvmet: adding queue 11 to ctrl 917.
[ 1661.503796] nvmet: adding queue 12 to ctrl 917.
[ 1661.504062] nvmet: adding queue 13 to ctrl 917.
[ 1661.524663] nvmet: adding queue 14 to ctrl 917.
[ 1661.524924] nvmet: adding queue 15 to ctrl 917.
[ 1661.545462] nvmet: adding queue 16 to ctrl 917.
[ 1661.649044] nvmet: creating controller 918 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1661.701443] nvmet: adding queue 1 to ctrl 918.
[ 1661.701662] nvmet: adding queue 2 to ctrl 918.
[ 1661.701842] nvmet: adding queue 3 to ctrl 918.
[ 1661.702107] nvmet: adding queue 4 to ctrl 918.
[ 1661.702261] nvmet: adding queue 5 to ctrl 918.
[ 1661.702429] nvmet: adding queue 6 to ctrl 918.
[ 1661.702589] nvmet: adding queue 7 to ctrl 918.
[ 1661.702823] nvmet: adding queue 8 to ctrl 918.
[ 1661.703049] nvmet: adding queue 9 to ctrl 918.
[ 1661.703336] nvmet: adding queue 10 to ctrl 918.
[ 1661.703601] nvmet: adding queue 11 to ctrl 918.
[ 1661.703848] nvmet: adding queue 12 to ctrl 918.
[ 1661.704056] nvmet: adding queue 13 to ctrl 918.
[ 1661.704277] nvmet: adding queue 14 to ctrl 918.
[ 1661.704535] nvmet: adding queue 15 to ctrl 918.
[ 1661.714149] nvmet: adding queue 16 to ctrl 918.
[ 1661.819546] nvmet: creating controller 919 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1661.872268] nvmet: adding queue 1 to ctrl 919.
[ 1661.872477] nvmet: adding queue 2 to ctrl 919.
[ 1661.872673] nvmet: adding queue 3 to ctrl 919.
[ 1661.872858] nvmet: adding queue 4 to ctrl 919.
[ 1661.873043] nvmet: adding queue 5 to ctrl 919.
[ 1661.873257] nvmet: adding queue 6 to ctrl 919.
[ 1661.873400] nvmet: adding queue 7 to ctrl 919.
[ 1661.873627] nvmet: adding queue 8 to ctrl 919.
[ 1661.873812] nvmet: adding queue 9 to ctrl 919.
[ 1661.874071] nvmet: adding queue 10 to ctrl 919.
[ 1661.874322] nvmet: adding queue 11 to ctrl 919.
[ 1661.874544] nvmet: adding queue 12 to ctrl 919.
[ 1661.874785] nvmet: adding queue 13 to ctrl 919.
[ 1661.874960] nvmet: adding queue 14 to ctrl 919.
[ 1661.875175] nvmet: adding queue 15 to ctrl 919.
[ 1661.875409] nvmet: adding queue 16 to ctrl 919.
[ 1662.009708] nvmet: creating controller 920 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1662.063553] nvmet: adding queue 1 to ctrl 920.
[ 1662.082843] nvmet: adding queue 2 to ctrl 920.
[ 1662.083112] nvmet: adding queue 3 to ctrl 920.
[ 1662.083402] nvmet: adding queue 4 to ctrl 920.
[ 1662.083695] nvmet: adding queue 5 to ctrl 920.
[ 1662.083979] nvmet: adding queue 6 to ctrl 920.
[ 1662.084302] nvmet: adding queue 7 to ctrl 920.
[ 1662.084595] nvmet: adding queue 8 to ctrl 920.
[ 1662.084840] nvmet: adding queue 9 to ctrl 920.
[ 1662.085042] nvmet: adding queue 10 to ctrl 920.
[ 1662.085265] nvmet: adding queue 11 to ctrl 920.
[ 1662.085523] nvmet: adding queue 12 to ctrl 920.
[ 1662.085756] nvmet: adding queue 13 to ctrl 920.
[ 1662.104065] nvmet: adding queue 14 to ctrl 920.
[ 1662.104338] nvmet: adding queue 15 to ctrl 920.
[ 1662.125282] nvmet: adding queue 16 to ctrl 920.
[ 1662.209021] nvmet: creating controller 921 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1662.262396] nvmet: adding queue 1 to ctrl 921.
[ 1662.262609] nvmet: adding queue 2 to ctrl 921.
[ 1662.262838] nvmet: adding queue 3 to ctrl 921.
[ 1662.263040] nvmet: adding queue 4 to ctrl 921.
[ 1662.263210] nvmet: adding queue 5 to ctrl 921.
[ 1662.268545] nvmet: adding queue 6 to ctrl 921.
[ 1662.268727] nvmet: adding queue 7 to ctrl 921.
[ 1662.288912] nvmet: adding queue 8 to ctrl 921.
[ 1662.289175] nvmet: adding queue 9 to ctrl 921.
[ 1662.342896] nvmet: adding queue 10 to ctrl 921.
[ 1662.343172] nvmet: adding queue 11 to ctrl 921.
[ 1662.343437] nvmet: adding queue 12 to ctrl 921.
[ 1662.343718] nvmet: adding queue 13 to ctrl 921.
[ 1662.343980] nvmet: adding queue 14 to ctrl 921.
[ 1662.344222] nvmet: adding queue 15 to ctrl 921.
[ 1662.344497] nvmet: adding queue 16 to ctrl 921.
[ 1662.448969] nvmet: creating controller 922 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1662.502108] nvmet: adding queue 1 to ctrl 922.
[ 1662.502330] nvmet: adding queue 2 to ctrl 922.
[ 1662.502657] nvmet: adding queue 3 to ctrl 922.
[ 1662.502894] nvmet: adding queue 4 to ctrl 922.
[ 1662.503125] nvmet: adding queue 5 to ctrl 922.
[ 1662.503292] nvmet: adding queue 6 to ctrl 922.
[ 1662.503478] nvmet: adding queue 7 to ctrl 922.
[ 1662.503675] nvmet: adding queue 8 to ctrl 922.
[ 1662.503915] nvmet: adding queue 9 to ctrl 922.
[ 1662.510316] nvmet: adding queue 10 to ctrl 922.
[ 1662.531498] nvmet: adding queue 11 to ctrl 922.
[ 1662.531785] nvmet: adding queue 12 to ctrl 922.
[ 1662.532031] nvmet: adding queue 13 to ctrl 922.
[ 1662.532271] nvmet: adding queue 14 to ctrl 922.
[ 1662.532579] nvmet: adding queue 15 to ctrl 922.
[ 1662.532894] nvmet: adding queue 16 to ctrl 922.
[ 1662.629354] nvmet: creating controller 923 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1662.681433] nvmet: adding queue 1 to ctrl 923.
[ 1662.681603] nvmet: adding queue 2 to ctrl 923.
[ 1662.681836] nvmet: adding queue 3 to ctrl 923.
[ 1662.682195] nvmet: adding queue 4 to ctrl 923.
[ 1662.682423] nvmet: adding queue 5 to ctrl 923.
[ 1662.682594] nvmet: adding queue 6 to ctrl 923.
[ 1662.682793] nvmet: adding queue 7 to ctrl 923.
[ 1662.682999] nvmet: adding queue 8 to ctrl 923.
[ 1662.683195] nvmet: adding queue 9 to ctrl 923.
[ 1662.683423] nvmet: adding queue 10 to ctrl 923.
[ 1662.683684] nvmet: adding queue 11 to ctrl 923.
[ 1662.683935] nvmet: adding queue 12 to ctrl 923.
[ 1662.733860] nvmet: adding queue 13 to ctrl 923.
[ 1662.734120] nvmet: adding queue 14 to ctrl 923.
[ 1662.734380] nvmet: adding queue 15 to ctrl 923.
[ 1662.734682] nvmet: adding queue 16 to ctrl 923.
[ 1662.809403] nvmet: creating controller 924 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1662.860751] nvmet: adding queue 1 to ctrl 924.
[ 1662.860964] nvmet: adding queue 2 to ctrl 924.
[ 1662.861197] nvmet: adding queue 3 to ctrl 924.
[ 1662.861388] nvmet: adding queue 4 to ctrl 924.
[ 1662.861515] nvmet: adding queue 5 to ctrl 924.
[ 1662.861693] nvmet: adding queue 6 to ctrl 924.
[ 1662.861872] nvmet: adding queue 7 to ctrl 924.
[ 1662.881464] nvmet: adding queue 8 to ctrl 924.
[ 1662.881716] nvmet: adding queue 9 to ctrl 924.
[ 1662.902444] nvmet: adding queue 10 to ctrl 924.
[ 1662.902709] nvmet: adding queue 11 to ctrl 924.
[ 1662.902972] nvmet: adding queue 12 to ctrl 924.
[ 1662.903219] nvmet: adding queue 13 to ctrl 924.
[ 1662.903501] nvmet: adding queue 14 to ctrl 924.
[ 1662.903795] nvmet: adding queue 15 to ctrl 924.
[ 1662.904192] nvmet: adding queue 16 to ctrl 924.
[ 1662.958321] nvmet_rdma: freeing queue 15695
[ 1662.959736] nvmet_rdma: freeing queue 15696
[ 1662.989958] nvmet: creating controller 925 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1663.043545] nvmet: adding queue 1 to ctrl 925.
[ 1663.048129] nvmet: adding queue 2 to ctrl 925.
[ 1663.048313] nvmet: adding queue 3 to ctrl 925.
[ 1663.069388] nvmet: adding queue 4 to ctrl 925.
[ 1663.069662] nvmet: adding queue 5 to ctrl 925.
[ 1663.069897] nvmet: adding queue 6 to ctrl 925.
[ 1663.070077] nvmet: adding queue 7 to ctrl 925.
[ 1663.070318] nvmet: adding queue 8 to ctrl 925.
[ 1663.070542] nvmet: adding queue 9 to ctrl 925.
[ 1663.070773] nvmet: adding queue 10 to ctrl 925.
[ 1663.071057] nvmet: adding queue 11 to ctrl 925.
[ 1663.071347] nvmet: adding queue 12 to ctrl 925.
[ 1663.071560] nvmet: adding queue 13 to ctrl 925.
[ 1663.071730] nvmet: adding queue 14 to ctrl 925.
[ 1663.072060] nvmet: adding queue 15 to ctrl 925.
[ 1663.072419] nvmet: adding queue 16 to ctrl 925.
[ 1663.154634] nvmet_rdma: freeing queue 15710
[ 1663.189104] nvmet: creating controller 926 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1663.243207] nvmet: adding queue 1 to ctrl 926.
[ 1663.243414] nvmet: adding queue 2 to ctrl 926.
[ 1663.243621] nvmet: adding queue 3 to ctrl 926.
[ 1663.249121] nvmet: adding queue 4 to ctrl 926.
[ 1663.272375] nvmet: adding queue 5 to ctrl 926.
[ 1663.272652] nvmet: adding queue 6 to ctrl 926.
[ 1663.272969] nvmet: adding queue 7 to ctrl 926.
[ 1663.273266] nvmet: adding queue 8 to ctrl 926.
[ 1663.273534] nvmet: adding queue 9 to ctrl 926.
[ 1663.273864] nvmet: adding queue 10 to ctrl 926.
[ 1663.274186] nvmet: adding queue 11 to ctrl 926.
[ 1663.274515] nvmet: adding queue 12 to ctrl 926.
[ 1663.274798] nvmet: adding queue 13 to ctrl 926.
[ 1663.275058] nvmet: adding queue 14 to ctrl 926.
[ 1663.275375] nvmet: adding queue 15 to ctrl 926.
[ 1663.275603] nvmet: adding queue 16 to ctrl 926.
[ 1663.369143] nvmet: creating controller 927 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1663.422494] nvmet: adding queue 1 to ctrl 927.
[ 1663.422653] nvmet: adding queue 2 to ctrl 927.
[ 1663.422844] nvmet: adding queue 3 to ctrl 927.
[ 1663.423073] nvmet: adding queue 4 to ctrl 927.
[ 1663.423342] nvmet: adding queue 5 to ctrl 927.
[ 1663.423606] nvmet: adding queue 6 to ctrl 927.
[ 1663.443620] nvmet: adding queue 7 to ctrl 927.
[ 1663.443877] nvmet: adding queue 8 to ctrl 927.
[ 1663.444128] nvmet: adding queue 9 to ctrl 927.
[ 1663.444424] nvmet: adding queue 10 to ctrl 927.
[ 1663.444729] nvmet: adding queue 11 to ctrl 927.
[ 1663.445038] nvmet: adding queue 12 to ctrl 927.
[ 1663.445292] nvmet: adding queue 13 to ctrl 927.
[ 1663.445524] nvmet: adding queue 14 to ctrl 927.
[ 1663.445842] nvmet: adding queue 15 to ctrl 927.
[ 1663.446097] nvmet: adding queue 16 to ctrl 927.
[ 1663.533589] nvmet_rdma: freeing queue 15750
[ 1663.535078] nvmet_rdma: freeing queue 15751
[ 1663.559183] nvmet: creating controller 928 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1663.613371] nvmet: adding queue 1 to ctrl 928.
[ 1663.623928] nvmet: adding queue 2 to ctrl 928.
[ 1663.624155] nvmet: adding queue 3 to ctrl 928.
[ 1663.644688] nvmet: adding queue 4 to ctrl 928.
[ 1663.644991] nvmet: adding queue 5 to ctrl 928.
[ 1663.645261] nvmet: adding queue 6 to ctrl 928.
[ 1663.645603] nvmet: adding queue 7 to ctrl 928.
[ 1663.645872] nvmet: adding queue 8 to ctrl 928.
[ 1663.646130] nvmet: adding queue 9 to ctrl 928.
[ 1663.646476] nvmet: adding queue 10 to ctrl 928.
[ 1663.665443] nvmet: adding queue 11 to ctrl 928.
[ 1663.665740] nvmet: adding queue 12 to ctrl 928.
[ 1663.685960] nvmet: adding queue 13 to ctrl 928.
[ 1663.686224] nvmet: adding queue 14 to ctrl 928.
[ 1663.706890] nvmet: adding queue 15 to ctrl 928.
[ 1663.707159] nvmet: adding queue 16 to ctrl 928.
[ 1663.809615] nvmet: creating controller 929 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1663.862933] nvmet: adding queue 1 to ctrl 929.
[ 1663.863097] nvmet: adding queue 2 to ctrl 929.
[ 1663.863273] nvmet: adding queue 3 to ctrl 929.
[ 1663.863481] nvmet: adding queue 4 to ctrl 929.
[ 1663.863695] nvmet: adding queue 5 to ctrl 929.
[ 1663.863860] nvmet: adding queue 6 to ctrl 929.
[ 1663.864048] nvmet: adding queue 7 to ctrl 929.
[ 1663.864242] nvmet: adding queue 8 to ctrl 929.
[ 1663.864450] nvmet: adding queue 9 to ctrl 929.
[ 1663.864689] nvmet: adding queue 10 to ctrl 929.
[ 1663.864949] nvmet: adding queue 11 to ctrl 929.
[ 1663.865190] nvmet: adding queue 12 to ctrl 929.
[ 1663.865367] nvmet: adding queue 13 to ctrl 929.
[ 1663.865586] nvmet: adding queue 14 to ctrl 929.
[ 1663.879738] nvmet: adding queue 15 to ctrl 929.
[ 1663.900786] nvmet: adding queue 16 to ctrl 929.
[ 1663.969503] nvmet: creating controller 930 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1664.030890] nvmet: adding queue 1 to ctrl 930.
[ 1664.031093] nvmet: adding queue 2 to ctrl 930.
[ 1664.031329] nvmet: adding queue 3 to ctrl 930.
[ 1664.031574] nvmet: adding queue 4 to ctrl 930.
[ 1664.031701] nvmet: adding queue 5 to ctrl 930.
[ 1664.031938] nvmet: adding queue 6 to ctrl 930.
[ 1664.032119] nvmet: adding queue 7 to ctrl 930.
[ 1664.032341] nvmet: adding queue 8 to ctrl 930.
[ 1664.032598] nvmet: adding queue 9 to ctrl 930.
[ 1664.032861] nvmet: adding queue 10 to ctrl 930.
[ 1664.033109] nvmet: adding queue 11 to ctrl 930.
[ 1664.033403] nvmet: adding queue 12 to ctrl 930.
[ 1664.033589] nvmet: adding queue 13 to ctrl 930.
[ 1664.033748] nvmet: adding queue 14 to ctrl 930.
[ 1664.033973] nvmet: adding queue 15 to ctrl 930.
[ 1664.034223] nvmet: adding queue 16 to ctrl 930.
[ 1664.102723] nvmet_rdma: freeing queue 15794
[ 1664.122411] nvmet_rdma: freeing queue 15807
[ 1664.140015] nvmet: creating controller 931 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1664.203453] nvmet: adding queue 1 to ctrl 931.
[ 1664.203667] nvmet: adding queue 2 to ctrl 931.
[ 1664.203891] nvmet: adding queue 3 to ctrl 931.
[ 1664.204076] nvmet: adding queue 4 to ctrl 931.
[ 1664.204283] nvmet: adding queue 5 to ctrl 931.
[ 1664.204444] nvmet: adding queue 6 to ctrl 931.
[ 1664.204631] nvmet: adding queue 7 to ctrl 931.
[ 1664.204851] nvmet: adding queue 8 to ctrl 931.
[ 1664.205028] nvmet: adding queue 9 to ctrl 931.
[ 1664.205301] nvmet: adding queue 10 to ctrl 931.
[ 1664.205650] nvmet: adding queue 11 to ctrl 931.
[ 1664.205986] nvmet: adding queue 12 to ctrl 931.
[ 1664.224766] nvmet: adding queue 13 to ctrl 931.
[ 1664.224960] nvmet: adding queue 14 to ctrl 931.
[ 1664.245956] nvmet: adding queue 15 to ctrl 931.
[ 1664.246243] nvmet: adding queue 16 to ctrl 931.
[ 1664.312326] nvmet_rdma: freeing queue 15817
[ 1664.315480] nvmet_rdma: freeing queue 15819
[ 1664.316734] nvmet_rdma: freeing queue 15820
[ 1664.318466] nvmet_rdma: freeing queue 15821
[ 1664.321030] nvmet_rdma: freeing queue 15823
[ 1664.326836] nvmet_rdma: freeing queue 15810
[ 1664.339111] nvmet: creating controller 932 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1664.394080] nvmet: adding queue 1 to ctrl 932.
[ 1664.394300] nvmet: adding queue 2 to ctrl 932.
[ 1664.394486] nvmet: adding queue 3 to ctrl 932.
[ 1664.394690] nvmet: adding queue 4 to ctrl 932.
[ 1664.407433] nvmet: adding queue 5 to ctrl 932.
[ 1664.407623] nvmet: adding queue 6 to ctrl 932.
[ 1664.460595] nvmet: adding queue 7 to ctrl 932.
[ 1664.460922] nvmet: adding queue 8 to ctrl 932.
[ 1664.481467] nvmet: adding queue 9 to ctrl 932.
[ 1664.481758] nvmet: adding queue 10 to ctrl 932.
[ 1664.482105] nvmet: adding queue 11 to ctrl 932.
[ 1664.482384] nvmet: adding queue 12 to ctrl 932.
[ 1664.482663] nvmet: adding queue 13 to ctrl 932.
[ 1664.482899] nvmet: adding queue 14 to ctrl 932.
[ 1664.483161] nvmet: adding queue 15 to ctrl 932.
[ 1664.483458] nvmet: adding queue 16 to ctrl 932.
[ 1664.650080] nvmet: creating controller 933 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1664.703992] nvmet: adding queue 1 to ctrl 933.
[ 1664.704155] nvmet: adding queue 2 to ctrl 933.
[ 1664.704327] nvmet: adding queue 3 to ctrl 933.
[ 1664.704591] nvmet: adding queue 4 to ctrl 933.
[ 1664.704801] nvmet: adding queue 5 to ctrl 933.
[ 1664.704994] nvmet: adding queue 6 to ctrl 933.
[ 1664.705211] nvmet: adding queue 7 to ctrl 933.
[ 1664.705418] nvmet: adding queue 8 to ctrl 933.
[ 1664.710997] nvmet: adding queue 9 to ctrl 933.
[ 1664.732076] nvmet: adding queue 10 to ctrl 933.
[ 1664.732327] nvmet: adding queue 11 to ctrl 933.
[ 1664.732602] nvmet: adding queue 12 to ctrl 933.
[ 1664.732915] nvmet: adding queue 13 to ctrl 933.
[ 1664.733146] nvmet: adding queue 14 to ctrl 933.
[ 1664.733422] nvmet: adding queue 15 to ctrl 933.
[ 1664.733819] nvmet: adding queue 16 to ctrl 933.
[ 1664.792268] nvmet_rdma: freeing queue 15858
[ 1664.793840] nvmet_rdma: freeing queue 15859
[ 1664.797424] nvmet_rdma: freeing queue 15844
[ 1664.809434] nvmet: creating controller 934 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1664.864517] nvmet: adding queue 1 to ctrl 934.
[ 1664.864764] nvmet: adding queue 2 to ctrl 934.
[ 1664.864944] nvmet: adding queue 3 to ctrl 934.
[ 1664.865217] nvmet: adding queue 4 to ctrl 934.
[ 1664.865403] nvmet: adding queue 5 to ctrl 934.
[ 1664.865578] nvmet: adding queue 6 to ctrl 934.
[ 1664.865784] nvmet: adding queue 7 to ctrl 934.
[ 1664.865976] nvmet: adding queue 8 to ctrl 934.
[ 1664.866180] nvmet: adding queue 9 to ctrl 934.
[ 1664.866391] nvmet: adding queue 10 to ctrl 934.
[ 1664.866628] nvmet: adding queue 11 to ctrl 934.
[ 1664.876781] nvmet: adding queue 12 to ctrl 934.
[ 1664.876947] nvmet: adding queue 13 to ctrl 934.
[ 1664.877147] nvmet: adding queue 14 to ctrl 934.
[ 1664.877519] nvmet: adding queue 15 to ctrl 934.
[ 1664.877819] nvmet: adding queue 16 to ctrl 934.
[ 1664.998805] nvmet: creating controller 935 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1665.052027] nvmet: adding queue 1 to ctrl 935.
[ 1665.052235] nvmet: adding queue 2 to ctrl 935.
[ 1665.052449] nvmet: adding queue 3 to ctrl 935.
[ 1665.052623] nvmet: adding queue 4 to ctrl 935.
[ 1665.052812] nvmet: adding queue 5 to ctrl 935.
[ 1665.052984] nvmet: adding queue 6 to ctrl 935.
[ 1665.068069] nvmet: adding queue 7 to ctrl 935.
[ 1665.068268] nvmet: adding queue 8 to ctrl 935.
[ 1665.088017] nvmet: adding queue 9 to ctrl 935.
[ 1665.088331] nvmet: adding queue 10 to ctrl 935.
[ 1665.088586] nvmet: adding queue 11 to ctrl 935.
[ 1665.088890] nvmet: adding queue 12 to ctrl 935.
[ 1665.089151] nvmet: adding queue 13 to ctrl 935.
[ 1665.089374] nvmet: adding queue 14 to ctrl 935.
[ 1665.089624] nvmet: adding queue 15 to ctrl 935.
[ 1665.107913] nvmet: adding queue 16 to ctrl 935.
[ 1665.159401] nvmet_rdma: freeing queue 15883
[ 1665.160718] nvmet_rdma: freeing queue 15884
[ 1665.170773] nvmet_rdma: freeing queue 15891
[ 1665.173994] nvmet_rdma: freeing queue 15893
[ 1665.175184] nvmet: ctrl 856 keep-alive timer (15 seconds) expired!
[ 1665.175186] nvmet: ctrl 856 fatal error occurred!
[ 1665.189178] nvmet: creating controller 936 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1665.248863] nvmet: adding queue 1 to ctrl 936.
[ 1665.249062] nvmet: adding queue 2 to ctrl 936.
[ 1665.269154] nvmet: adding queue 3 to ctrl 936.
[ 1665.269458] nvmet: adding queue 4 to ctrl 936.
[ 1665.269775] nvmet: adding queue 5 to ctrl 936.
[ 1665.269991] nvmet: adding queue 6 to ctrl 936.
[ 1665.270215] nvmet: adding queue 7 to ctrl 936.
[ 1665.270371] nvmet: adding queue 8 to ctrl 936.
[ 1665.270572] nvmet: adding queue 9 to ctrl 936.
[ 1665.270858] nvmet: adding queue 10 to ctrl 936.
[ 1665.271140] nvmet: adding queue 11 to ctrl 936.
[ 1665.271372] nvmet: adding queue 12 to ctrl 936.
[ 1665.271567] nvmet: adding queue 13 to ctrl 936.
[ 1665.271829] nvmet: adding queue 14 to ctrl 936.
[ 1665.272119] nvmet: adding queue 15 to ctrl 936.
[ 1665.272411] nvmet: adding queue 16 to ctrl 936.
[ 1665.419279] nvmet: creating controller 937 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1665.473576] nvmet: adding queue 1 to ctrl 937.
[ 1665.473750] nvmet: adding queue 2 to ctrl 937.
[ 1665.488908] nvmet: adding queue 3 to ctrl 937.
[ 1665.508880] nvmet: adding queue 4 to ctrl 937.
[ 1665.509164] nvmet: adding queue 5 to ctrl 937.
[ 1665.509466] nvmet: adding queue 6 to ctrl 937.
[ 1665.509788] nvmet: adding queue 7 to ctrl 937.
[ 1665.510008] nvmet: adding queue 8 to ctrl 937.
[ 1665.510237] nvmet: adding queue 9 to ctrl 937.
[ 1665.510461] nvmet: adding queue 10 to ctrl 937.
[ 1665.510703] nvmet: adding queue 11 to ctrl 937.
[ 1665.510984] nvmet: adding queue 12 to ctrl 937.
[ 1665.511212] nvmet: adding queue 13 to ctrl 937.
[ 1665.511427] nvmet: adding queue 14 to ctrl 937.
[ 1665.511728] nvmet: adding queue 15 to ctrl 937.
[ 1665.512069] nvmet: adding queue 16 to ctrl 937.
[ 1665.620685] nvmet: creating controller 938 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1665.674200] nvmet: adding queue 1 to ctrl 938.
[ 1665.674375] nvmet: adding queue 2 to ctrl 938.
[ 1665.674579] nvmet: adding queue 3 to ctrl 938.
[ 1665.674785] nvmet: adding queue 4 to ctrl 938.
[ 1665.674978] nvmet: adding queue 5 to ctrl 938.
[ 1665.691186] nvmet: adding queue 6 to ctrl 938.
[ 1665.691403] nvmet: adding queue 7 to ctrl 938.
[ 1665.691703] nvmet: adding queue 8 to ctrl 938.
[ 1665.691978] nvmet: adding queue 9 to ctrl 938.
[ 1665.692296] nvmet: adding queue 10 to ctrl 938.
[ 1665.692600] nvmet: adding queue 11 to ctrl 938.
[ 1665.692876] nvmet: adding queue 12 to ctrl 938.
[ 1665.693142] nvmet: adding queue 13 to ctrl 938.
[ 1665.693409] nvmet: adding queue 14 to ctrl 938.
[ 1665.693673] nvmet: adding queue 15 to ctrl 938.
[ 1665.693993] nvmet: adding queue 16 to ctrl 938.
[ 1665.780093] nvmet: creating controller 939 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1665.834350] nvmet: adding queue 1 to ctrl 939.
[ 1665.834525] nvmet: adding queue 2 to ctrl 939.
[ 1665.856115] nvmet: adding queue 3 to ctrl 939.
[ 1665.856421] nvmet: adding queue 4 to ctrl 939.
[ 1665.856695] nvmet: adding queue 5 to ctrl 939.
[ 1665.857016] nvmet: adding queue 6 to ctrl 939.
[ 1665.857338] nvmet: adding queue 7 to ctrl 939.
[ 1665.857539] nvmet: adding queue 8 to ctrl 939.
[ 1665.857741] nvmet: adding queue 9 to ctrl 939.
[ 1665.875695] nvmet: adding queue 10 to ctrl 939.
[ 1665.876002] nvmet: adding queue 11 to ctrl 939.
[ 1665.895756] nvmet: adding queue 12 to ctrl 939.
[ 1665.896043] nvmet: adding queue 13 to ctrl 939.
[ 1665.915841] nvmet: adding queue 14 to ctrl 939.
[ 1665.916108] nvmet: adding queue 15 to ctrl 939.
[ 1665.916376] nvmet: adding queue 16 to ctrl 939.
[ 1665.999612] nvmet: creating controller 940 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.053632] nvmet: adding queue 1 to ctrl 940.
[ 1666.053814] nvmet: adding queue 2 to ctrl 940.
[ 1666.054011] nvmet: adding queue 3 to ctrl 940.
[ 1666.054184] nvmet: adding queue 4 to ctrl 940.
[ 1666.054351] nvmet: adding queue 5 to ctrl 940.
[ 1666.054517] nvmet: adding queue 6 to ctrl 940.
[ 1666.054699] nvmet: adding queue 7 to ctrl 940.
[ 1666.054874] nvmet: adding queue 8 to ctrl 940.
[ 1666.055122] nvmet: adding queue 9 to ctrl 940.
[ 1666.055348] nvmet: adding queue 10 to ctrl 940.
[ 1666.055613] nvmet: adding queue 11 to ctrl 940.
[ 1666.055855] nvmet: adding queue 12 to ctrl 940.
[ 1666.056081] nvmet: adding queue 13 to ctrl 940.
[ 1666.058540] nvmet: adding queue 14 to ctrl 940.
[ 1666.078918] nvmet: adding queue 15 to ctrl 940.
[ 1666.079200] nvmet: adding queue 16 to ctrl 940.
[ 1666.178430] nvmet: creating controller 941 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.233226] nvmet: adding queue 1 to ctrl 941.
[ 1666.233408] nvmet: adding queue 2 to ctrl 941.
[ 1666.233609] nvmet: adding queue 3 to ctrl 941.
[ 1666.233793] nvmet: adding queue 4 to ctrl 941.
[ 1666.234005] nvmet: adding queue 5 to ctrl 941.
[ 1666.234181] nvmet: adding queue 6 to ctrl 941.
[ 1666.234386] nvmet: adding queue 7 to ctrl 941.
[ 1666.234608] nvmet: adding queue 8 to ctrl 941.
[ 1666.234804] nvmet: adding queue 9 to ctrl 941.
[ 1666.235070] nvmet: adding queue 10 to ctrl 941.
[ 1666.235349] nvmet: adding queue 11 to ctrl 941.
[ 1666.235572] nvmet: adding queue 12 to ctrl 941.
[ 1666.235743] nvmet: adding queue 13 to ctrl 941.
[ 1666.235908] nvmet: adding queue 14 to ctrl 941.
[ 1666.236157] nvmet: adding queue 15 to ctrl 941.
[ 1666.236412] nvmet: adding queue 16 to ctrl 941.
[ 1666.329041] nvmet: creating controller 942 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.383476] nvmet: adding queue 1 to ctrl 942.
[ 1666.383665] nvmet: adding queue 2 to ctrl 942.
[ 1666.383852] nvmet: adding queue 3 to ctrl 942.
[ 1666.384100] nvmet: adding queue 4 to ctrl 942.
[ 1666.384312] nvmet: adding queue 5 to ctrl 942.
[ 1666.384479] nvmet: adding queue 6 to ctrl 942.
[ 1666.384671] nvmet: adding queue 7 to ctrl 942.
[ 1666.384831] nvmet: adding queue 8 to ctrl 942.
[ 1666.385021] nvmet: adding queue 9 to ctrl 942.
[ 1666.385295] nvmet: adding queue 10 to ctrl 942.
[ 1666.385548] nvmet: adding queue 11 to ctrl 942.
[ 1666.399293] nvmet: adding queue 12 to ctrl 942.
[ 1666.399524] nvmet: adding queue 13 to ctrl 942.
[ 1666.420297] nvmet: adding queue 14 to ctrl 942.
[ 1666.420590] nvmet: adding queue 15 to ctrl 942.
[ 1666.420818] nvmet: adding queue 16 to ctrl 942.
[ 1666.464940] nvmet: ctrl 865 keep-alive timer (15 seconds) expired!
[ 1666.464941] nvmet: ctrl 864 keep-alive timer (15 seconds) expired!
[ 1666.464942] nvmet: ctrl 865 fatal error occurred!
[ 1666.464943] nvmet: ctrl 864 fatal error occurred!
[ 1666.493123] nvmet_rdma: freeing queue 16011
[ 1666.510003] nvmet: creating controller 943 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.564642] nvmet: adding queue 1 to ctrl 943.
[ 1666.564856] nvmet: adding queue 2 to ctrl 943.
[ 1666.565029] nvmet: adding queue 3 to ctrl 943.
[ 1666.572547] nvmet: adding queue 4 to ctrl 943.
[ 1666.572750] nvmet: adding queue 5 to ctrl 943.
[ 1666.592502] nvmet: adding queue 6 to ctrl 943.
[ 1666.592752] nvmet: adding queue 7 to ctrl 943.
[ 1666.613556] nvmet: adding queue 8 to ctrl 943.
[ 1666.613766] nvmet: adding queue 9 to ctrl 943.
[ 1666.614102] nvmet: adding queue 10 to ctrl 943.
[ 1666.614394] nvmet: adding queue 11 to ctrl 943.
[ 1666.614695] nvmet: adding queue 12 to ctrl 943.
[ 1666.614938] nvmet: adding queue 13 to ctrl 943.
[ 1666.615178] nvmet: adding queue 14 to ctrl 943.
[ 1666.615486] nvmet: adding queue 15 to ctrl 943.
[ 1666.615743] nvmet: adding queue 16 to ctrl 943.
[ 1666.719338] nvmet: creating controller 944 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.773410] nvmet: adding queue 1 to ctrl 944.
[ 1666.773628] nvmet: adding queue 2 to ctrl 944.
[ 1666.773821] nvmet: adding queue 3 to ctrl 944.
[ 1666.774022] nvmet: adding queue 4 to ctrl 944.
[ 1666.774238] nvmet: adding queue 5 to ctrl 944.
[ 1666.774412] nvmet: adding queue 6 to ctrl 944.
[ 1666.774616] nvmet: adding queue 7 to ctrl 944.
[ 1666.776228] nvmet: adding queue 8 to ctrl 944.
[ 1666.796403] nvmet: adding queue 9 to ctrl 944.
[ 1666.796673] nvmet: adding queue 10 to ctrl 944.
[ 1666.797067] nvmet: adding queue 11 to ctrl 944.
[ 1666.797362] nvmet: adding queue 12 to ctrl 944.
[ 1666.797624] nvmet: adding queue 13 to ctrl 944.
[ 1666.797867] nvmet: adding queue 14 to ctrl 944.
[ 1666.798140] nvmet: adding queue 15 to ctrl 944.
[ 1666.798433] nvmet: adding queue 16 to ctrl 944.
[ 1666.887562] nvmet_rdma: freeing queue 16035
[ 1666.892021] nvmet_rdma: freeing queue 16038
[ 1666.894960] nvmet_rdma: freeing queue 16040
[ 1666.896376] nvmet_rdma: freeing queue 16041
[ 1666.897760] nvmet_rdma: freeing queue 16042
[ 1666.900964] nvmet_rdma: freeing queue 16044
[ 1666.919378] nvmet: creating controller 945 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1666.973434] nvmet: adding queue 1 to ctrl 945.
[ 1666.973627] nvmet: adding queue 2 to ctrl 945.
[ 1666.973829] nvmet: adding queue 3 to ctrl 945.
[ 1666.974035] nvmet: adding queue 4 to ctrl 945.
[ 1666.974243] nvmet: adding queue 5 to ctrl 945.
[ 1666.974448] nvmet: adding queue 6 to ctrl 945.
[ 1666.974621] nvmet: adding queue 7 to ctrl 945.
[ 1666.974834] nvmet: adding queue 8 to ctrl 945.
[ 1666.975043] nvmet: adding queue 9 to ctrl 945.
[ 1666.975277] nvmet: adding queue 10 to ctrl 945.
[ 1666.976192] nvmet: adding queue 11 to ctrl 945.
[ 1666.976472] nvmet: adding queue 12 to ctrl 945.
[ 1666.976740] nvmet: adding queue 13 to ctrl 945.
[ 1666.977011] nvmet: adding queue 14 to ctrl 945.
[ 1666.977282] nvmet: adding queue 15 to ctrl 945.
[ 1666.977559] nvmet: adding queue 16 to ctrl 945.
[ 1667.093512] nvmet_rdma: freeing queue 16056
[ 1667.094640] nvmet_rdma: freeing queue 16057
[ 1667.119685] nvmet: creating controller 946 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1667.172547] nvmet: adding queue 1 to ctrl 946.
[ 1667.172749] nvmet: adding queue 2 to ctrl 946.
[ 1667.172948] nvmet: adding queue 3 to ctrl 946.
[ 1667.173172] nvmet: adding queue 4 to ctrl 946.
[ 1667.173437] nvmet: adding queue 5 to ctrl 946.
[ 1667.177654] nvmet: adding queue 6 to ctrl 946.
[ 1667.177814] nvmet: adding queue 7 to ctrl 946.
[ 1667.198062] nvmet: adding queue 8 to ctrl 946.
[ 1667.198341] nvmet: adding queue 9 to ctrl 946.
[ 1667.198568] nvmet: adding queue 10 to ctrl 946.
[ 1667.198828] nvmet: adding queue 11 to ctrl 946.
[ 1667.199153] nvmet: adding queue 12 to ctrl 946.
[ 1667.199364] nvmet: adding queue 13 to ctrl 946.
[ 1667.199602] nvmet: adding queue 14 to ctrl 946.
[ 1667.218418] nvmet: adding queue 15 to ctrl 946.
[ 1667.218743] nvmet: adding queue 16 to ctrl 946.
[ 1667.338615] nvmet: creating controller 947 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1667.393868] nvmet: adding queue 1 to ctrl 947.
[ 1667.394773] nvmet: adding queue 2 to ctrl 947.
[ 1667.394969] nvmet: adding queue 3 to ctrl 947.
[ 1667.395261] nvmet: adding queue 4 to ctrl 947.
[ 1667.395463] nvmet: adding queue 5 to ctrl 947.
[ 1667.395597] nvmet: adding queue 6 to ctrl 947.
[ 1667.395791] nvmet: adding queue 7 to ctrl 947.
[ 1667.396015] nvmet: adding queue 8 to ctrl 947.
[ 1667.396220] nvmet: adding queue 9 to ctrl 947.
[ 1667.396432] nvmet: adding queue 10 to ctrl 947.
[ 1667.396660] nvmet: adding queue 11 to ctrl 947.
[ 1667.396984] nvmet: adding queue 12 to ctrl 947.
[ 1667.397212] nvmet: adding queue 13 to ctrl 947.
[ 1667.397407] nvmet: adding queue 14 to ctrl 947.
[ 1667.397621] nvmet: adding queue 15 to ctrl 947.
[ 1667.397918] nvmet: adding queue 16 to ctrl 947.
[ 1667.519444] nvmet: creating controller 948 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1667.572590] nvmet: adding queue 1 to ctrl 948.
[ 1667.588434] nvmet: adding queue 2 to ctrl 948.
[ 1667.607997] nvmet: adding queue 3 to ctrl 948.
[ 1667.608287] nvmet: adding queue 4 to ctrl 948.
[ 1667.608598] nvmet: adding queue 5 to ctrl 948.
[ 1667.608903] nvmet: adding queue 6 to ctrl 948.
[ 1667.609103] nvmet: adding queue 7 to ctrl 948.
[ 1667.609355] nvmet: adding queue 8 to ctrl 948.
[ 1667.609584] nvmet: adding queue 9 to ctrl 948.
[ 1667.609843] nvmet: adding queue 10 to ctrl 948.
[ 1667.610101] nvmet: adding queue 11 to ctrl 948.
[ 1667.610390] nvmet: adding queue 12 to ctrl 948.
[ 1667.610605] nvmet: adding queue 13 to ctrl 948.
[ 1667.610821] nvmet: adding queue 14 to ctrl 948.
[ 1667.611085] nvmet: adding queue 15 to ctrl 948.
[ 1667.611326] nvmet: adding queue 16 to ctrl 948.
[ 1667.707757] nvmet_rdma: freeing queue 16110
[ 1667.709060] nvmet_rdma: freeing queue 16111
[ 1667.712384] nvmet_rdma: freeing queue 16113
[ 1667.713743] nvmet_rdma: freeing queue 16114
[ 1667.728986] nvmet: creating controller 949 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1667.782483] nvmet: adding queue 1 to ctrl 949.
[ 1667.782671] nvmet: adding queue 2 to ctrl 949.
[ 1667.782886] nvmet: adding queue 3 to ctrl 949.
[ 1667.783075] nvmet: adding queue 4 to ctrl 949.
[ 1667.788267] nvmet: adding queue 5 to ctrl 949.
[ 1667.788463] nvmet: adding queue 6 to ctrl 949.
[ 1667.788654] nvmet: adding queue 7 to ctrl 949.
[ 1667.788855] nvmet: adding queue 8 to ctrl 949.
[ 1667.789091] nvmet: adding queue 9 to ctrl 949.
[ 1667.789442] nvmet: adding queue 10 to ctrl 949.
[ 1667.789730] nvmet: adding queue 11 to ctrl 949.
[ 1667.790028] nvmet: adding queue 12 to ctrl 949.
[ 1667.790208] nvmet: adding queue 13 to ctrl 949.
[ 1667.790371] nvmet: adding queue 14 to ctrl 949.
[ 1667.790620] nvmet: adding queue 15 to ctrl 949.
[ 1667.790841] nvmet: adding queue 16 to ctrl 949.
[ 1667.874167] nvmet_rdma: freeing queue 16131
[ 1667.875688] nvmet_rdma: freeing queue 16132
[ 1667.889301] nvmet: creating controller 950 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1667.943038] nvmet: adding queue 1 to ctrl 950.
[ 1667.993274] nvmet: adding queue 2 to ctrl 950.
[ 1667.993590] nvmet: adding queue 3 to ctrl 950.
[ 1667.993852] nvmet: adding queue 4 to ctrl 950.
[ 1667.994164] nvmet: adding queue 5 to ctrl 950.
[ 1667.994432] nvmet: adding queue 6 to ctrl 950.
[ 1667.994713] nvmet: adding queue 7 to ctrl 950.
[ 1667.995058] nvmet: adding queue 8 to ctrl 950.
[ 1668.013190] nvmet: adding queue 9 to ctrl 950.
[ 1668.013501] nvmet: adding queue 10 to ctrl 950.
[ 1668.033101] nvmet: adding queue 11 to ctrl 950.
[ 1668.033423] nvmet: adding queue 12 to ctrl 950.
[ 1668.053757] nvmet: adding queue 13 to ctrl 950.
[ 1668.053995] nvmet: adding queue 14 to ctrl 950.
[ 1668.054286] nvmet: adding queue 15 to ctrl 950.
[ 1668.054598] nvmet: adding queue 16 to ctrl 950.
[ 1668.138388] nvmet: creating controller 951 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1668.191920] nvmet: adding queue 1 to ctrl 951.
[ 1668.192155] nvmet: adding queue 2 to ctrl 951.
[ 1668.192444] nvmet: adding queue 3 to ctrl 951.
[ 1668.192642] nvmet: adding queue 4 to ctrl 951.
[ 1668.192845] nvmet: adding queue 5 to ctrl 951.
[ 1668.193022] nvmet: adding queue 6 to ctrl 951.
[ 1668.193296] nvmet: adding queue 7 to ctrl 951.
[ 1668.193521] nvmet: adding queue 8 to ctrl 951.
[ 1668.193789] nvmet: adding queue 9 to ctrl 951.
[ 1668.193987] nvmet: adding queue 10 to ctrl 951.
[ 1668.194268] nvmet: adding queue 11 to ctrl 951.
[ 1668.194516] nvmet: adding queue 12 to ctrl 951.
[ 1668.213629] nvmet: adding queue 13 to ctrl 951.
[ 1668.233895] nvmet: adding queue 14 to ctrl 951.
[ 1668.234130] nvmet: adding queue 15 to ctrl 951.
[ 1668.234413] nvmet: adding queue 16 to ctrl 951.
[ 1668.350659] nvmet: creating controller 952 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1668.405319] nvmet: adding queue 1 to ctrl 952.
[ 1668.405496] nvmet: adding queue 2 to ctrl 952.
[ 1668.405785] nvmet: adding queue 3 to ctrl 952.
[ 1668.406008] nvmet: adding queue 4 to ctrl 952.
[ 1668.406151] nvmet: adding queue 5 to ctrl 952.
[ 1668.406353] nvmet: adding queue 6 to ctrl 952.
[ 1668.406528] nvmet: adding queue 7 to ctrl 952.
[ 1668.406819] nvmet: adding queue 8 to ctrl 952.
[ 1668.407040] nvmet: adding queue 9 to ctrl 952.
[ 1668.407313] nvmet: adding queue 10 to ctrl 952.
[ 1668.407564] nvmet: adding queue 11 to ctrl 952.
[ 1668.407790] nvmet: adding queue 12 to ctrl 952.
[ 1668.408008] nvmet: adding queue 13 to ctrl 952.
[ 1668.408186] nvmet: adding queue 14 to ctrl 952.
[ 1668.408401] nvmet: adding queue 15 to ctrl 952.
[ 1668.448488] nvmet: adding queue 16 to ctrl 952.
[ 1668.539535] nvmet: creating controller 953 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1668.593707] nvmet: adding queue 1 to ctrl 953.
[ 1668.593911] nvmet: adding queue 2 to ctrl 953.
[ 1668.594162] nvmet: adding queue 3 to ctrl 953.
[ 1668.594387] nvmet: adding queue 4 to ctrl 953.
[ 1668.594599] nvmet: adding queue 5 to ctrl 953.
[ 1668.594774] nvmet: adding queue 6 to ctrl 953.
[ 1668.594957] nvmet: adding queue 7 to ctrl 953.
[ 1668.595177] nvmet: adding queue 8 to ctrl 953.
[ 1668.595419] nvmet: adding queue 9 to ctrl 953.
[ 1668.595684] nvmet: adding queue 10 to ctrl 953.
[ 1668.608232] nvmet: adding queue 11 to ctrl 953.
[ 1668.608433] nvmet: adding queue 12 to ctrl 953.
[ 1668.628146] nvmet: adding queue 13 to ctrl 953.
[ 1668.628380] nvmet: adding queue 14 to ctrl 953.
[ 1668.628597] nvmet: adding queue 15 to ctrl 953.
[ 1668.628878] nvmet: adding queue 16 to ctrl 953.
[ 1668.702475] nvmet_rdma: freeing queue 16185
[ 1668.704572] nvmet_rdma: freeing queue 16186
[ 1668.707504] nvmet_rdma: freeing queue 16188
[ 1668.709308] nvmet_rdma: freeing queue 16189
[ 1668.715505] nvmet_rdma: freeing queue 16193
[ 1668.718229] nvmet_rdma: freeing queue 16195
[ 1668.739852] nvmet: creating controller 954 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1668.793930] nvmet: adding queue 1 to ctrl 954.
[ 1668.794132] nvmet: adding queue 2 to ctrl 954.
[ 1668.800769] nvmet: adding queue 3 to ctrl 954.
[ 1668.800963] nvmet: adding queue 4 to ctrl 954.
[ 1668.821906] nvmet: adding queue 5 to ctrl 954.
[ 1668.822181] nvmet: adding queue 6 to ctrl 954.
[ 1668.840297] nvmet: adding queue 7 to ctrl 954.
[ 1668.840583] nvmet: adding queue 8 to ctrl 954.
[ 1668.840806] nvmet: adding queue 9 to ctrl 954.
[ 1668.841114] nvmet: adding queue 10 to ctrl 954.
[ 1668.841404] nvmet: adding queue 11 to ctrl 954.
[ 1668.841755] nvmet: adding queue 12 to ctrl 954.
[ 1668.842026] nvmet: adding queue 13 to ctrl 954.
[ 1668.842256] nvmet: adding queue 14 to ctrl 954.
[ 1668.842584] nvmet: adding queue 15 to ctrl 954.
[ 1668.842945] nvmet: adding queue 16 to ctrl 954.
[ 1668.909645] nvmet_rdma: freeing queue 16206
[ 1668.911272] nvmet_rdma: freeing queue 16207
[ 1668.912524] nvmet_rdma: freeing queue 16208
[ 1668.914085] nvmet_rdma: freeing queue 16209
[ 1668.939620] nvmet: creating controller 955 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1668.990900] nvmet: adding queue 1 to ctrl 955.
[ 1668.991174] nvmet: adding queue 2 to ctrl 955.
[ 1668.991467] nvmet: adding queue 3 to ctrl 955.
[ 1668.991671] nvmet: adding queue 4 to ctrl 955.
[ 1668.991859] nvmet: adding queue 5 to ctrl 955.
[ 1668.992017] nvmet: adding queue 6 to ctrl 955.
[ 1668.994776] nvmet: adding queue 7 to ctrl 955.
[ 1669.014686] nvmet: adding queue 8 to ctrl 955.
[ 1669.014977] nvmet: adding queue 9 to ctrl 955.
[ 1669.015345] nvmet: adding queue 10 to ctrl 955.
[ 1669.015594] nvmet: adding queue 11 to ctrl 955.
[ 1669.015880] nvmet: adding queue 12 to ctrl 955.
[ 1669.016122] nvmet: adding queue 13 to ctrl 955.
[ 1669.016327] nvmet: adding queue 14 to ctrl 955.
[ 1669.016565] nvmet: adding queue 15 to ctrl 955.
[ 1669.016805] nvmet: adding queue 16 to ctrl 955.
[ 1669.109646] nvmet: creating controller 956 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1669.163612] nvmet: adding queue 1 to ctrl 956.
[ 1669.163804] nvmet: adding queue 2 to ctrl 956.
[ 1669.164082] nvmet: adding queue 3 to ctrl 956.
[ 1669.164296] nvmet: adding queue 4 to ctrl 956.
[ 1669.164497] nvmet: adding queue 5 to ctrl 956.
[ 1669.164661] nvmet: adding queue 6 to ctrl 956.
[ 1669.164827] nvmet: adding queue 7 to ctrl 956.
[ 1669.165022] nvmet: adding queue 8 to ctrl 956.
[ 1669.165201] nvmet: adding queue 9 to ctrl 956.
[ 1669.176410] nvmet: adding queue 10 to ctrl 956.
[ 1669.176717] nvmet: adding queue 11 to ctrl 956.
[ 1669.177025] nvmet: adding queue 12 to ctrl 956.
[ 1669.177258] nvmet: adding queue 13 to ctrl 956.
[ 1669.177471] nvmet: adding queue 14 to ctrl 956.
[ 1669.177750] nvmet: adding queue 15 to ctrl 956.
[ 1669.178038] nvmet: adding queue 16 to ctrl 956.
[ 1669.272224] nvmet_rdma: freeing queue 16242
[ 1669.273462] nvmet_rdma: freeing queue 16243
[ 1669.274639] nvmet_rdma: freeing queue 16244
[ 1669.277578] nvmet_rdma: freeing queue 16246
[ 1669.282514] nvmet_rdma: freeing queue 16249
[ 1669.284197] nvmet_rdma: freeing queue 16250
[ 1669.299313] nvmet: creating controller 957 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1669.350426] nvmet: adding queue 1 to ctrl 957.
[ 1669.350608] nvmet: adding queue 2 to ctrl 957.
[ 1669.350837] nvmet: adding queue 3 to ctrl 957.
[ 1669.351391] nvmet: adding queue 4 to ctrl 957.
[ 1669.355358] nvmet: adding queue 5 to ctrl 957.
[ 1669.355527] nvmet: adding queue 6 to ctrl 957.
[ 1669.374073] nvmet: adding queue 7 to ctrl 957.
[ 1669.374414] nvmet: adding queue 8 to ctrl 957.
[ 1669.374623] nvmet: adding queue 9 to ctrl 957.
[ 1669.374965] nvmet: adding queue 10 to ctrl 957.
[ 1669.375313] nvmet: adding queue 11 to ctrl 957.
[ 1669.375656] nvmet: adding queue 12 to ctrl 957.
[ 1669.375883] nvmet: adding queue 13 to ctrl 957.
[ 1669.431409] nvmet: adding queue 14 to ctrl 957.
[ 1669.431814] nvmet: adding queue 15 to ctrl 957.
[ 1669.453743] nvmet: adding queue 16 to ctrl 957.
[ 1669.578824] nvmet: creating controller 958 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1669.633466] nvmet: adding queue 1 to ctrl 958.
[ 1669.633692] nvmet: adding queue 2 to ctrl 958.
[ 1669.633877] nvmet: adding queue 3 to ctrl 958.
[ 1669.634066] nvmet: adding queue 4 to ctrl 958.
[ 1669.634233] nvmet: adding queue 5 to ctrl 958.
[ 1669.634403] nvmet: adding queue 6 to ctrl 958.
[ 1669.634565] nvmet: adding queue 7 to ctrl 958.
[ 1669.634778] nvmet: adding queue 8 to ctrl 958.
[ 1669.635005] nvmet: adding queue 9 to ctrl 958.
[ 1669.635240] nvmet: adding queue 10 to ctrl 958.
[ 1669.635520] nvmet: adding queue 11 to ctrl 958.
[ 1669.635854] nvmet: adding queue 12 to ctrl 958.
[ 1669.636013] nvmet: adding queue 13 to ctrl 958.
[ 1669.636267] nvmet: adding queue 14 to ctrl 958.
[ 1669.636607] nvmet: adding queue 15 to ctrl 958.
[ 1669.636834] nvmet: adding queue 16 to ctrl 958.
[ 1669.654808] nvmet: ctrl 880 keep-alive timer (15 seconds) expired!
[ 1669.654810] nvmet: ctrl 880 fatal error occurred!
[ 1669.749397] nvmet: creating controller 959 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1669.806315] nvmet: adding queue 1 to ctrl 959.
[ 1669.826279] nvmet: adding queue 2 to ctrl 959.
[ 1669.826517] nvmet: adding queue 3 to ctrl 959.
[ 1669.826845] nvmet: adding queue 4 to ctrl 959.
[ 1669.827141] nvmet: adding queue 5 to ctrl 959.
[ 1669.827451] nvmet: adding queue 6 to ctrl 959.
[ 1669.827761] nvmet: adding queue 7 to ctrl 959.
[ 1669.827969] nvmet: adding queue 8 to ctrl 959.
[ 1669.828201] nvmet: adding queue 9 to ctrl 959.
[ 1669.828461] nvmet: adding queue 10 to ctrl 959.
[ 1669.828698] nvmet: adding queue 11 to ctrl 959.
[ 1669.828924] nvmet: adding queue 12 to ctrl 959.
[ 1669.829159] nvmet: adding queue 13 to ctrl 959.
[ 1669.829360] nvmet: adding queue 14 to ctrl 959.
[ 1669.829582] nvmet: adding queue 15 to ctrl 959.
[ 1669.829764] nvmet: adding queue 16 to ctrl 959.
[ 1669.919043] nvmet: creating controller 960 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1670.016385] nvmet: adding queue 1 to ctrl 960.
[ 1670.016570] nvmet: adding queue 2 to ctrl 960.
[ 1670.016750] nvmet: adding queue 3 to ctrl 960.
[ 1670.034668] nvmet: adding queue 4 to ctrl 960.
[ 1670.034929] nvmet: adding queue 5 to ctrl 960.
[ 1670.035214] nvmet: adding queue 6 to ctrl 960.
[ 1670.035532] nvmet: adding queue 7 to ctrl 960.
[ 1670.035852] nvmet: adding queue 8 to ctrl 960.
[ 1670.036112] nvmet: adding queue 9 to ctrl 960.
[ 1670.036413] nvmet: adding queue 10 to ctrl 960.
[ 1670.036674] nvmet: adding queue 11 to ctrl 960.
[ 1670.036934] nvmet: adding queue 12 to ctrl 960.
[ 1670.037194] nvmet: adding queue 13 to ctrl 960.
[ 1670.037457] nvmet: adding queue 14 to ctrl 960.
[ 1670.037660] nvmet: adding queue 15 to ctrl 960.
[ 1670.054617] nvmet: adding queue 16 to ctrl 960.
[ 1670.178649] nvmet: creating controller 961 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1670.247300] nvmet: adding queue 1 to ctrl 961.
[ 1670.247481] nvmet: adding queue 2 to ctrl 961.
[ 1670.247735] nvmet: adding queue 3 to ctrl 961.
[ 1670.248000] nvmet: adding queue 4 to ctrl 961.
[ 1670.248204] nvmet: adding queue 5 to ctrl 961.
[ 1670.248457] nvmet: adding queue 6 to ctrl 961.
[ 1670.248692] nvmet: adding queue 7 to ctrl 961.
[ 1670.267066] nvmet: adding queue 8 to ctrl 961.
[ 1670.267357] nvmet: adding queue 9 to ctrl 961.
[ 1670.287185] nvmet: adding queue 10 to ctrl 961.
[ 1670.287510] nvmet: adding queue 11 to ctrl 961.
[ 1670.294786] nvmet: ctrl 886 keep-alive timer (15 seconds) expired!
[ 1670.294788] nvmet: ctrl 886 fatal error occurred!
[ 1670.307294] nvmet: adding queue 12 to ctrl 961.
[ 1670.307533] nvmet: adding queue 13 to ctrl 961.
[ 1670.307800] nvmet: adding queue 14 to ctrl 961.
[ 1670.308091] nvmet: adding queue 15 to ctrl 961.
[ 1670.308380] nvmet: adding queue 16 to ctrl 961.
[ 1670.393564] nvmet_rdma: freeing queue 16335
[ 1670.395213] nvmet_rdma: freeing queue 16336
[ 1670.397107] nvmet_rdma: freeing queue 16320
[ 1670.409416] nvmet: creating controller 962 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1670.462697] nvmet: adding queue 1 to ctrl 962.
[ 1670.462908] nvmet: adding queue 2 to ctrl 962.
[ 1670.463115] nvmet: adding queue 3 to ctrl 962.
[ 1670.463334] nvmet: adding queue 4 to ctrl 962.
[ 1670.463552] nvmet: adding queue 5 to ctrl 962.
[ 1670.463708] nvmet: adding queue 6 to ctrl 962.
[ 1670.464007] nvmet: adding queue 7 to ctrl 962.
[ 1670.464234] nvmet: adding queue 8 to ctrl 962.
[ 1670.464452] nvmet: adding queue 9 to ctrl 962.
[ 1670.464671] nvmet: adding queue 10 to ctrl 962.
[ 1670.465015] nvmet: adding queue 11 to ctrl 962.
[ 1670.476076] nvmet: adding queue 12 to ctrl 962.
[ 1670.498042] nvmet: adding queue 13 to ctrl 962.
[ 1670.498257] nvmet: adding queue 14 to ctrl 962.
[ 1670.498574] nvmet: adding queue 15 to ctrl 962.
[ 1670.498864] nvmet: adding queue 16 to ctrl 962.
[ 1670.619215] nvmet: creating controller 963 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1670.674355] nvmet: adding queue 1 to ctrl 963.
[ 1670.674585] nvmet: adding queue 2 to ctrl 963.
[ 1670.674850] nvmet: adding queue 3 to ctrl 963.
[ 1670.675047] nvmet: adding queue 4 to ctrl 963.
[ 1670.675233] nvmet: adding queue 5 to ctrl 963.
[ 1670.675398] nvmet: adding queue 6 to ctrl 963.
[ 1670.675603] nvmet: adding queue 7 to ctrl 963.
[ 1670.675799] nvmet: adding queue 8 to ctrl 963.
[ 1670.675970] nvmet: adding queue 9 to ctrl 963.
[ 1670.676179] nvmet: adding queue 10 to ctrl 963.
[ 1670.676372] nvmet: adding queue 11 to ctrl 963.
[ 1670.676635] nvmet: adding queue 12 to ctrl 963.
[ 1670.676850] nvmet: adding queue 13 to ctrl 963.
[ 1670.677017] nvmet: adding queue 14 to ctrl 963.
[ 1670.680200] nvmet: adding queue 15 to ctrl 963.
[ 1670.680436] nvmet: adding queue 16 to ctrl 963.
[ 1670.778763] nvmet: creating controller 964 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1670.890256] nvmet: adding queue 1 to ctrl 964.
[ 1670.890452] nvmet: adding queue 2 to ctrl 964.
[ 1670.890699] nvmet: adding queue 3 to ctrl 964.
[ 1670.890928] nvmet: adding queue 4 to ctrl 964.
[ 1670.891193] nvmet: adding queue 5 to ctrl 964.
[ 1670.891354] nvmet: adding queue 6 to ctrl 964.
[ 1670.891620] nvmet: adding queue 7 to ctrl 964.
[ 1670.891838] nvmet: adding queue 8 to ctrl 964.
[ 1670.892035] nvmet: adding queue 9 to ctrl 964.
[ 1670.902392] nvmet: adding queue 10 to ctrl 964.
[ 1670.902654] nvmet: adding queue 11 to ctrl 964.
[ 1670.922633] nvmet: adding queue 12 to ctrl 964.
[ 1670.922878] nvmet: adding queue 13 to ctrl 964.
[ 1670.923065] nvmet: adding queue 14 to ctrl 964.
[ 1670.923402] nvmet: adding queue 15 to ctrl 964.
[ 1670.923732] nvmet: adding queue 16 to ctrl 964.
[ 1670.998994] nvmet: creating controller 965 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1671.158510] nvmet: adding queue 1 to ctrl 965.
[ 1671.162949] nvmet: adding queue 2 to ctrl 965.
[ 1671.163228] nvmet: adding queue 3 to ctrl 965.
[ 1671.182766] nvmet: adding queue 4 to ctrl 965.
[ 1671.183088] nvmet: adding queue 5 to ctrl 965.
[ 1671.202304] nvmet: adding queue 6 to ctrl 965.
[ 1671.202556] nvmet: adding queue 7 to ctrl 965.
[ 1671.202885] nvmet: adding queue 8 to ctrl 965.
[ 1671.203162] nvmet: adding queue 9 to ctrl 965.
[ 1671.203472] nvmet: adding queue 10 to ctrl 965.
[ 1671.203771] nvmet: adding queue 11 to ctrl 965.
[ 1671.204047] nvmet: adding queue 12 to ctrl 965.
[ 1671.204321] nvmet: adding queue 13 to ctrl 965.
[ 1671.204592] nvmet: adding queue 14 to ctrl 965.
[ 1671.204937] nvmet: adding queue 15 to ctrl 965.
[ 1671.205243] nvmet: adding queue 16 to ctrl 965.
[ 1671.308441] nvmet: creating controller 966 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1671.368702] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[ 1671.368703] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 1671.368705] CPU: 7 PID: 4983 Comm: kworker/7:256 Not tainted 4.10.0 #5
[ 1671.368706] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1671.368711] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 1671.368712] Call Trace:
[ 1671.368716]  dump_stack+0x63/0x87
[ 1671.368719]  swiotlb_alloc_coherent+0x14a/0x160
[ 1671.368721]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 1671.368743]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[ 1671.368747]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[ 1671.368751]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[ 1671.368754]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 1671.368761]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 1671.368765]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 1671.368767]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[ 1671.368769]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[ 1671.368770]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[ 1671.368772]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[ 1671.368774]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[ 1671.368775]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[ 1671.368777]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 1671.368779]  cm_process_work+0x25/0x120 [ib_cm]
[ 1671.368780]  cm_req_handler+0x967/0xca0 [ib_cm]
[ 1671.368782]  cm_work_handler+0x1bf/0x16c8 [ib_cm]
[ 1671.368784]  process_one_work+0x165/0x410
[ 1671.368785]  worker_thread+0x137/0x4c0
[ 1671.368786]  kthread+0x101/0x140
[ 1671.368788]  ? rescuer_thread+0x3b0/0x3b0
[ 1671.368788]  ? kthread_park+0x90/0x90
[ 1671.368791]  ret_from_fork+0x2c/0x40
[ 1671.371745] nvmet: adding queue 1 to ctrl 966.
[ 1671.372048] nvmet: adding queue 2 to ctrl 966.
[ 1671.372238] nvmet: adding queue 3 to ctrl 966.
[ 1671.372467] nvmet: adding queue 4 to ctrl 966.
[ 1671.372634] nvmet: adding queue 5 to ctrl 966.
[ 1671.384171] nvmet: adding queue 6 to ctrl 966.
[ 1671.435126] nvmet: adding queue 7 to ctrl 966.
[ 1671.435403] nvmet: adding queue 8 to ctrl 966.
[ 1671.435687] nvmet: adding queue 9 to ctrl 966.
[ 1671.435989] nvmet: adding queue 10 to ctrl 966.
[ 1671.436293] nvmet: adding queue 11 to ctrl 966.
[ 1671.436584] nvmet: adding queue 12 to ctrl 966.
[ 1671.436844] nvmet: adding queue 13 to ctrl 966.
[ 1671.437133] nvmet: adding queue 14 to ctrl 966.
[ 1671.437391] nvmet: adding queue 15 to ctrl 966.
[ 1671.437688] nvmet: adding queue 16 to ctrl 966.
[ 1671.747787] nvmet: creating controller 967 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1671.803699] nvmet: adding queue 1 to ctrl 967.
[ 1671.803991] nvmet: adding queue 2 to ctrl 967.
[ 1671.804195] nvmet: adding queue 3 to ctrl 967.
[ 1671.804405] nvmet: adding queue 4 to ctrl 967.
[ 1671.804557] nvmet: adding queue 5 to ctrl 967.
[ 1671.804735] nvmet: adding queue 6 to ctrl 967.
[ 1671.804963] nvmet: adding queue 7 to ctrl 967.
[ 1671.805162] nvmet: adding queue 8 to ctrl 967.
[ 1671.813666] nvmet: adding queue 9 to ctrl 967.
[ 1671.813896] nvmet: adding queue 10 to ctrl 967.
[ 1671.814148] nvmet: adding queue 11 to ctrl 967.
[ 1671.814428] nvmet: adding queue 12 to ctrl 967.
[ 1671.814662] nvmet: adding queue 13 to ctrl 967.
[ 1671.814931] nvmet: adding queue 14 to ctrl 967.
[ 1671.815232] nvmet: adding queue 15 to ctrl 967.
[ 1671.815530] nvmet: adding queue 16 to ctrl 967.
[ 1671.898673] nvmet: creating controller 968 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1671.953860] nvmet: adding queue 1 to ctrl 968.
[ 1671.954081] nvmet: adding queue 2 to ctrl 968.
[ 1671.954290] nvmet: adding queue 3 to ctrl 968.
[ 1671.964368] nvmet: adding queue 4 to ctrl 968.
[ 1671.964512] nvmet: adding queue 5 to ctrl 968.
[ 1671.984286] nvmet: adding queue 6 to ctrl 968.
[ 1671.984583] nvmet: adding queue 7 to ctrl 968.
[ 1671.984840] nvmet: adding queue 8 to ctrl 968.
[ 1671.985156] nvmet: adding queue 9 to ctrl 968.
[ 1671.985482] nvmet: adding queue 10 to ctrl 968.
[ 1671.985783] nvmet: adding queue 11 to ctrl 968.
[ 1671.986047] nvmet: adding queue 12 to ctrl 968.
[ 1672.008281] nvmet: adding queue 13 to ctrl 968.
[ 1672.008615] nvmet: adding queue 14 to ctrl 968.
[ 1672.030391] nvmet: adding queue 15 to ctrl 968.
[ 1672.030708] nvmet: adding queue 16 to ctrl 968.
[ 1672.101363] nvmet_rdma: freeing queue 16452
[ 1672.102879] nvmet_rdma: freeing queue 16453
[ 1672.105822] nvmet_rdma: freeing queue 16455
[ 1672.107424] nvmet_rdma: freeing queue 16439
[ 1672.120396] nvmet: creating controller 969 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:e7bbdfa5-aef4-44ab-ad8f-1b957e700096.
[ 1672.174405] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[ 1672.174406] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 1672.174407] CPU: 17 PID: 6825 Comm: kworker/17:256 Not tainted 4.10.0 #5
[ 1672.174408] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1672.174413] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 1672.174414] Call Trace:
[ 1672.174418]  dump_stack+0x63/0x87
[ 1672.174421]  swiotlb_alloc_coherent+0x14a/0x160
[ 1672.174424]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 1672.174434]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[ 1672.174438]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[ 1672.174442]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[ 1672.174445]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 1672.174453]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 1672.174456]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 1672.174458]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[ 1672.174460]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[ 1672.174462]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[ 1672.174463]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[ 1672.174465]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[ 1672.174467]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[ 1672.174468]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 1672.174470]  cm_process_work+0x25/0x120 [ib_cm]
[ 1672.174472]  cm_req_handler+0x967/0xca0 [ib_cm]
[ 1672.174473]  cm_work_handler+0x1bf/0x16c8 [ib_cm]
[ 1672.174476]  process_one_work+0x165/0x410
[ 1672.174477]  worker_thread+0x137/0x4c0
[ 1672.174478]  kthread+0x101/0x140
[ 1672.174480]  ? rescuer_thread+0x3b0/0x3b0
[ 1672.174480]  ? kthread_park+0x90/0x90
[ 1672.174483]  ret_from_fork+0x2c/0x40
[ 1672.179398] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[ 1672.179399] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 1672.179400] CPU: 6 PID: 4250 Comm: kworker/6:256 Not tainted 4.10.0 #5
[ 1672.179400] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1672.179403] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 1672.179404] Call Trace:
[ 1672.179406]  dump_stack+0x63/0x87
[ 1672.179408]  swiotlb_alloc_coherent+0x14a/0x160
[ 1672.179409]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 1672.179414]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[ 1672.179418]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[ 1672.179421]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[ 1672.179424]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 1672.179429]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 1672.179431]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 1672.179432]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[ 1672.179434]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[ 1672.179436]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[ 1672.179437]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[ 1672.179439]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[ 1672.179441]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[ 1672.179442]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 1672.179444]  cm_process_work+0x25/0x120 [ib_cm]
[ 1672.179445]  cm_req_handler+0x967/0xca0 [ib_cm]
[ 1672.179447]  cm_work_handler+0x1bf/0x16c8 [ib_cm]
[ 1672.179449]  process_one_work+0x165/0x410
[ 1672.179450]  worker_thread+0x137/0x4c0
[ 1672.179451]  kthread+0x101/0x140
[ 1672.179452]  ? rescuer_thread+0x3b0/0x3b0
[ 1672.179453]  ? kthread_park+0x90/0x90
[ 1672.179454]  ret_from_fork+0x2c/0x40
[ 1672.183544] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[ 1672.183545] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[ 1672.183546] CPU: 6 PID: 4250 Comm: kworker/6:256 Not tainted 4.10.0 #5
[ 1672.183547] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1672.183549] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 1672.183549] Call Trace:
[ 1672.183551]  dump_stack+0x63/0x87
[ 1672.183553]  swiotlb_alloc_coherent+0x14a/0x160
[ 1672.183554]  x86_swiotlb_alloc_coherent+0x43/0x50
[ 1672.183558]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[ 1672.183562]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[ 1672.183565]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[ 1672.183567]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[ 1672.183572]  ib_create_qp+0x70/0x2b0 [ib_core]
[ 1672.183574]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[ 1672.183576]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[ 1672.183577]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[ 1672.183579]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[ 1672.183580]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[ 1672.183582]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[ 1672.183583]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[ 1672.183585]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 1672.183587]  cm_process_work+0x25/0x120 [ib_cm]
[ 1672.183588]  cm_req_handler+0x967/0xca0 [ib_cm]
[ 1672.183590]  cm_work_handler+0x1bf/0x16c8 [ib_cm]
[ 1672.183592]  process_one_work+0x165/0x410
[ 1672.183593]  worker_thread+0x137/0x4c0
[ 1672.183594]  kthread+0x101/0x140
[ 1672.183595]  ? rescuer_thread+0x3b0/0x3b0
[ 1672.183596]  ? kthread_park+0x90/0x90
[ 1672.183598]  ret_from_fork+0x2c/0x40
[ 1672.186873] kworker/6:256: page allocation failure: order:6, mode:0x140c0c0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO)
[ 1672.186877] CPU: 6 PID: 4250 Comm: kworker/6:256 Not tainted 4.10.0 #5
[ 1672.186877] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1672.186879] Workqueue: ib_cm cm_work_handler [ib_cm]
[ 1672.186879] Call Trace:
[ 1672.186881]  dump_stack+0x63/0x87
[ 1672.186883]  warn_alloc+0x13f/0x170
[ 1672.186885]  ? __alloc_pages_direct_compact+0x47/0x100
[ 1672.186886]  __alloc_pages_slowpath+0x28a/0xaf0
[ 1672.186888]  __alloc_pages_nodemask+0x223/0x2a0
[ 1672.186890]  alloc_pages_current+0x88/0x120
[ 1672.186892]  kmalloc_order+0x1f/0x70
[ 1672.186894]  kmalloc_order_trace+0x26/0xa0
[ 1672.186896]  __kmalloc+0x20c/0x220
[ 1672.186897]  nvmet_rdma_alloc_queue+0x214/0x900 [nvmet_rdma]
[ 1672.186899]  ? _cma_attach_to_dev+0x6b/0xa0 [rdma_cm]
[ 1672.186900]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[ 1672.186902]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[ 1672.186903]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[ 1672.186905]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[ 1672.186907]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[ 1672.186908]  cm_process_work+0x25/0x120 [ib_cm]
[ 1672.186910]  cm_req_handler+0x967/0xca0 [ib_cm]
[ 1672.186911]  cm_work_handler+0x1bf/0x16c8 [ib_cm]
[ 1672.186913]  process_one_work+0x165/0x410
[ 1672.186914]  worker_thread+0x137/0x4c0
[ 1672.186915]  kthread+0x101/0x140
[ 1672.186916]  ? rescuer_thread+0x3b0/0x3b0
[ 1672.186917]  ? kthread_park+0x90/0x90
[ 1672.186918]  ret_from_fork+0x2c/0x40
[ 1672.186919] Mem-Info:
[ 1672.186923] active_anon:189 inactive_anon:512 isolated_anon:0
 active_file:0 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:763 unstable:0
 slab_reclaimable:11952 slab_unreclaimable:820173
 mapped:205 shmem:63 pagetables:1739 bounce:0
 free:39850 free_pcp:405 free_cma:0
[ 1672.186927] Node 0 active_anon:208kB inactive_anon:2288kB active_file:96kB inactive_file:124kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:232kB dirty:0kB writeback:3244kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 28672kB anon_thp: 8kB writeback_tmp:0kB unstable:0kB pages_scanned:4413 all_unreclaimable? yes
[ 1672.186931] Node 1 active_anon:548kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:588kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 244kB writeback_tmp:0kB unstable:0kB pages_scanned:9012 all_unreclaimable? yes
[ 1672.186932] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1672.186935] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1672.186937] Node 0 DMA32 free:60276kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260800kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1672.186939] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1672.186941] Node 0 Normal free:36272kB min:36664kB low:50028kB high:63392kB active_anon:208kB inactive_anon:2288kB active_file:96kB inactive_file:124kB unevictable:0kB writepending:3244kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18472kB slab_unreclaimable:1382856kB kernel_stack:29352kB pagetables:3272kB bounce:0kB free_pcp:1148kB local_pcp:120kB free_cma:0kB
[ 1672.186944] lowmem_reserve[]: 0 0 0 0 0
[ 1672.186946] Node 1 Normal free:46972kB min:45296kB low:61804kB high:78312kB active_anon:548kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29336kB slab_unreclaimable:1637020kB kernel_stack:27448kB pagetables:3684kB bounce:0kB free_pcp:472kB local_pcp:52kB free_cma:0kB
[ 1672.186948] lowmem_reserve[]: 0 0 0 0 0
[ 1672.186950] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1672.186955] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1672.186961] Node 0 Normal: 251*4kB (MEH) 244*8kB (MEH) 166*16kB (UMEH) 104*32kB (MH) 69*64kB (ME) 37*128kB (UM) 22*256kB (UM) 12*512kB (M) 4*1024kB (UM) 1*2048kB (M) 0*4096kB = 36012kB
[ 1672.186967] Node 1 Normal: 17*4kB (UEH) 83*8kB (UMEH) 83*16kB (UMEH) 61*32kB (UME) 51*64kB (UMEH) 51*128kB (UME) 35*256kB (UM) 26*512kB (UME) 7*1024kB (UM) 2*2048kB (M) 0*4096kB = 47340kB
[ 1672.186973] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1672.186974] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1672.186975] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1672.186975] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1672.186976] 959 total pagecache pages
[ 1672.186976] 616 pages in swap cache
[ 1672.186977] Swap cache stats: add 32700, delete 32084, find 178/318
[ 1672.186978] Free swap  = 16386556kB
[ 1672.186978] Total swap = 16516092kB
[ 1672.186979] 8379718 pages RAM
[ 1672.186979] 0 pages HighMem/MovableOnly
[ 1672.186979] 153786 pages reserved
[ 1672.186979] 0 pages cma reserved
[ 1672.186980] 0 pages hwpoisoned
[ 1672.572274] kmemleak: Cannot allocate a kmemleak_object structure
[ 1672.572277] kmemleak: Kernel memory leak detector disabled
[ 1672.572908] kmemleak: Automatic memory scanning thread ended
[ 1672.572917] kmemleak: Kmemleak disabled without freeing internal data. Reclaim the memory with "echo clear > /sys/kernel/debug/kmemleak".
[ 1674.338537] crond invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.338538] crond cpuset=/ mems_allowed=0-1
[ 1674.338542] CPU: 9 PID: 7132 Comm: crond Not tainted 4.10.0 #5
[ 1674.338542] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.338543] Call Trace:
[ 1674.338547]  dump_stack+0x63/0x87
[ 1674.338550]  dump_header+0x82/0x212
[ 1674.338553]  ? selinux_capable+0x20/0x30
[ 1674.338555]  ? security_capable_noaudit+0x45/0x60
[ 1674.338558]  oom_kill_process+0x21c/0x3f0
[ 1674.338559]  out_of_memory+0x117/0x4a0
[ 1674.338560]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.338562]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.338564]  alloc_pages_current+0x88/0x120
[ 1674.338567]  __page_cache_alloc+0xae/0xc0
[ 1674.338568]  filemap_fault+0x5cb/0x740
[ 1674.338571]  ? down_read+0x12/0x40
[ 1674.338607]  xfs_filemap_fault+0x60/0xf0 [xfs]
[ 1674.338609]  __do_fault+0x21/0x80
[ 1674.338610]  handle_mm_fault+0xc0f/0x1350
[ 1674.338627]  ? xfs_file_read_iter+0x68/0xc0 [xfs]
[ 1674.338630]  __do_page_fault+0x22a/0x4a0
[ 1674.338631]  do_page_fault+0x30/0x80
[ 1674.338633]  ? do_syscall_64+0x175/0x180
[ 1674.338635]  page_fault+0x28/0x30
[ 1674.338636] RIP: 0033:0x7fe54599c2f0
[ 1674.338637] RSP: 002b:00007fff279c04e8 EFLAGS: 00010283
[ 1674.338638] RAX: 0000000000000020 RBX: 0000000000000001 RCX: 0000000000000000
[ 1674.338639] RDX: 00000000ffff0010 RSI: 0000556f99860980 RDI: 0000556f9985e6e0
[ 1674.338639] RBP: 0000556f99860950 R08: 00007fe545c23060 R09: 00007fe53ee18a4c
[ 1674.338640] R10: 0000000000000000 R11: 0000000000000000 R12: 0000556f9985e6e0
[ 1674.338640] R13: 0000556f99860980 R14: 0000000000000400 R15: 00007fe5466956d0
[ 1674.338641] Mem-Info:
[ 1674.338645] active_anon:115 inactive_anon:7 isolated_anon:0
 active_file:367 inactive_file:147 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:301 shmem:0 pagetables:1785 bounce:0
 free:39454 free_pcp:0 free_cma:0
[ 1674.338650] Node 0 active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:16kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:3498 all_unreclaimable? yes
[ 1674.338654] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1439 all_unreclaimable? yes
[ 1674.338655] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.338658] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.338659] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.338662] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.338664] Node 0 Normal free:36660kB min:36664kB low:50028kB high:63392kB active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.338667] lowmem_reserve[]: 0 0 0 0 0
[ 1674.338668] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:672kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.338671] lowmem_reserve[]: 0 0 0 0 0
[ 1674.338672] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.338677] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.338683] Node 0 Normal: 154*4kB (UMH) 148*8kB (UMEH) 131*16kB (UMEH) 69*32kB (UMEH) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 38424kB
[ 1674.338689] Node 1 Normal: 55*4kB (UME) 45*8kB (UME) 13*16kB (UME) 11*32kB (UM) 26*64kB (UMH) 32*128kB (UMH) 28*256kB (UMH) 23*512kB (UMH) 10*1024kB (UMH) 1*2048kB (M) 2*4096kB (M) = 46324kB
[ 1674.338695] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.338696] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.338697] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.338697] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.338698] 648 total pagecache pages
[ 1674.338698] 68 pages in swap cache
[ 1674.338699] Swap cache stats: add 34034, delete 33966, find 904/1661
[ 1674.338699] Free swap  = 16385924kB
[ 1674.338700] Total swap = 16516092kB
[ 1674.338700] 8379718 pages RAM
[ 1674.338701] 0 pages HighMem/MovableOnly
[ 1674.338701] 153786 pages reserved
[ 1674.338701] 0 pages cma reserved
[ 1674.338702] 0 pages hwpoisoned
[ 1674.338702] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.338721] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.338722] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.338724] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.338727] [ 1096]     0  1096    13856        0      27       3      112         -1000 auditd
[ 1674.338729] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.338730] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.338731] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.338732] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.338734] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.338735] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.338736] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.338737] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.338739] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.338740] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.338742] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.338743] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.338744] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.338746] [ 1902]     0  1902    28209        0      53       3     3123             0 dhclient
[ 1674.338747] [ 1976]     0  1976   138299        0      89       4     2712             0 tuned
[ 1674.338748] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.338749] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.338750] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.338751] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.338753] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.338754] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.338755] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.338756] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.338758] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.338759] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.338761] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.338762] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.338763] [ 3373]     0  3373    64652        1      82       4     3413             0 beah-srv
[ 1674.338764] [ 3374]     0  3374    90269        1      98       4     4723             0 beah-beaker-bac
[ 1674.338765] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.338767] [ 3377]     0  3377    60773        1      75       4     3102             0 beah-fwd-backen
[ 1674.338768] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.338769] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.338770] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.338772] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.338773] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.339000] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.339008] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.339009] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.339012] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.339021] [ 7132]     0  7132    43495       33      41       4      187             0 crond
[ 1674.339021] Out of memory: Kill process 3374 (beah-beaker-bac) score 0 or sacrifice child
[ 1674.339027] Killed process 3374 (beah-beaker-bac) total-vm:361076kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.345131] oom_reaper: reaped process 3374 (beah-beaker-bac), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.345848] auditd invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=0-1, order=0, oom_score_adj=-1000
[ 1674.345849] auditd cpuset=/ mems_allowed=0-1
[ 1674.345851] CPU: 11 PID: 1096 Comm: auditd Not tainted 4.10.0 #5
[ 1674.345852] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.345852] Call Trace:
[ 1674.345856]  dump_stack+0x63/0x87
[ 1674.345857]  dump_header+0x82/0x212
[ 1674.345859]  ? selinux_capable+0x20/0x30
[ 1674.345860]  ? security_capable_noaudit+0x45/0x60
[ 1674.345861]  oom_kill_process+0x21c/0x3f0
[ 1674.345862]  out_of_memory+0x117/0x4a0
[ 1674.345864]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.345865]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.345867]  alloc_pages_current+0x88/0x120
[ 1674.345869]  __page_cache_alloc+0xae/0xc0
[ 1674.345870]  filemap_fault+0x5cb/0x740
[ 1674.345871]  ? down_read+0x12/0x40
[ 1674.345898]  xfs_filemap_fault+0x60/0xf0 [xfs]
[ 1674.345899]  __do_fault+0x21/0x80
[ 1674.345901]  handle_mm_fault+0xc0f/0x1350
[ 1674.345903]  ? hrtimer_init+0x150/0x150
[ 1674.345904]  __do_page_fault+0x22a/0x4a0
[ 1674.345906]  do_page_fault+0x30/0x80
[ 1674.345907]  page_fault+0x28/0x30
[ 1674.345908] RIP: 0033:0x556d484aa198
[ 1674.345909] RSP: 002b:00007ffddd79bcd0 EFLAGS: 00010207
[ 1674.345910] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00007fe0b1635d13
[ 1674.345911] RDX: 0000000000000001 RSI: 0000556d499a4da0 RDI: 0000000000000000
[ 1674.345911] RBP: 0000000000000000 R08: 000000000003452a R09: 0000000000000001
[ 1674.345912] R10: 000000000000e95f R11: 0000000000000000 R12: 0000556d486b9e60
[ 1674.345913] R13: 0000000000000000 R14: 0000000000000001 R15: 0000556d486b9e60
[ 1674.345913] Mem-Info:
[ 1674.345918] active_anon:115 inactive_anon:7 isolated_anon:0
 active_file:367 inactive_file:147 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:301 shmem:0 pagetables:1785 bounce:0
 free:39454 free_pcp:30 free_cma:0
[ 1674.345922] Node 0 active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:16kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:3498 all_unreclaimable? yes
[ 1674.345926] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1439 all_unreclaimable? yes
[ 1674.345927] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.345929] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.345931] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.345934] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.345936] Node 0 Normal free:36660kB min:36664kB low:50028kB high:63392kB active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.345939] lowmem_reserve[]: 0 0 0 0 0
[ 1674.345940] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:672kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:120kB local_pcp:0kB free_cma:0kB
[ 1674.345943] lowmem_reserve[]: 0 0 0 0 0
[ 1674.345944] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.345949] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.345955] Node 0 Normal: 154*4kB (UMH) 148*8kB (UMEH) 131*16kB (UMEH) 69*32kB (UMEH) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 38424kB
[ 1674.345961] Node 1 Normal: 28*4kB (UE) 43*8kB (UME) 13*16kB (UME) 11*32kB (UM) 26*64kB (UMH) 32*128kB (UMH) 28*256kB (UMH) 23*512kB (UMH) 10*1024kB (UMH) 1*2048kB (M) 2*4096kB (M) = 46200kB
[ 1674.345967] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.345968] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.345968] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.345969] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.345969] 648 total pagecache pages
[ 1674.345970] 68 pages in swap cache
[ 1674.345971] Swap cache stats: add 34035, delete 33967, find 906/1665
[ 1674.345971] Free swap  = 16404752kB
[ 1674.345971] Total swap = 16516092kB
[ 1674.345972] 8379718 pages RAM
[ 1674.345972] 0 pages HighMem/MovableOnly
[ 1674.345972] 153786 pages reserved
[ 1674.345973] 0 pages cma reserved
[ 1674.345973] 0 pages hwpoisoned
[ 1674.345973] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.345988] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.345990] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.345991] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.345994] [ 1096]     0  1096    13856        0      27       3      112         -1000 auditd
[ 1674.345995] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.345996] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.345997] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.345999] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.346000] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.346001] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.346002] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.346004] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.346005] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.346006] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.346007] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.346008] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.346009] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.346011] [ 1902]     0  1902    28209        0      53       3     3123             0 dhclient
[ 1674.346012] [ 1976]     0  1976   138299        0      89       4     2712             0 tuned
[ 1674.346013] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.346014] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.346015] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.346017] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.346018] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.346019] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.346020] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.346022] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.346023] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.346024] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.346026] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.346027] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.346028] [ 3373]     0  3373    64652        1      82       4     3413             0 beah-srv
[ 1674.346029] [ 3401]     0  3374    90269        0      98       4        0             0 beah-beaker-bac
[ 1674.346030] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.346031] [ 3377]     0  3377    60773        1      75       4     3102             0 beah-fwd-backen
[ 1674.346032] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.346033] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.346034] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.346036] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.346037] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.346254] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.346261] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.346262] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.346265] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.346273] [ 7132]     0  7132    43495       33      41       4      187             0 crond
[ 1674.346274] Out of memory: Kill process 3373 (beah-srv) score 0 or sacrifice child
[ 1674.346280] Killed process 3373 (beah-srv) total-vm:258608kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.368662] beah-fwd-backen invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.368663] beah-fwd-backen cpuset=/ mems_allowed=0-1
[ 1674.368665] CPU: 31 PID: 3377 Comm: beah-fwd-backen Not tainted 4.10.0 #5
[ 1674.368666] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.368666] Call Trace:
[ 1674.368670]  dump_stack+0x63/0x87
[ 1674.368671]  dump_header+0x82/0x212
[ 1674.368672]  ? selinux_capable+0x20/0x30
[ 1674.368673]  ? security_capable_noaudit+0x45/0x60
[ 1674.368674]  oom_kill_process+0x21c/0x3f0
[ 1674.368676]  out_of_memory+0x117/0x4a0
[ 1674.368677]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.368679]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.368680]  alloc_pages_vma+0xa5/0x220
[ 1674.368683]  __read_swap_cache_async+0x129/0x1d0
[ 1674.368684]  read_swap_cache_async+0x26/0x60
[ 1674.368685]  swapin_readahead+0x16b/0x200
[ 1674.368687]  ? find_get_entry+0x20/0x140
[ 1674.368688]  ? pagecache_get_page+0x2c/0x250
[ 1674.368690]  do_swap_page+0x2aa/0x780
[ 1674.368691]  handle_mm_fault+0x7bb/0x1350
[ 1674.368693]  __do_page_fault+0x22a/0x4a0
[ 1674.368694]  do_page_fault+0x30/0x80
[ 1674.368696]  page_fault+0x28/0x30
[ 1674.368699] RIP: 0010:ep_send_events_proc+0xfd/0x1e0
[ 1674.368700] RSP: 0018:ffffc900095bfd60 EFLAGS: 00010246
[ 1674.368701] RAX: 0000000000000011 RBX: ffffc900095bfde0 RCX: 0000000002baa1c0
[ 1674.368701] RDX: 0000000000000000 RSI: ffff88082e426140 RDI: ffff880825a3dc00
[ 1674.368702] RBP: ffffc900095bfdb8 R08: ffff88083f472d18 R09: cccccccccccccccd
[ 1674.368702] R10: 00000185a063a590 R11: 0000000000000018 R12: 0000000000000000
[ 1674.368703] R13: ffffc900095bfe78 R14: ffff8804274b3380 R15: ffff88083f472d18
[ 1674.368705]  ? ep_poll+0x3c0/0x3c0
[ 1674.368707]  ep_scan_ready_list.isra.11+0x9c/0x210
[ 1674.368708]  ? hrtimer_init+0x150/0x150
[ 1674.368709]  ep_poll+0x195/0x3c0
[ 1674.368712]  ? wake_up_q+0x80/0x80
[ 1674.368713]  SyS_epoll_wait+0xbc/0xe0
[ 1674.368715]  do_syscall_64+0x67/0x180
[ 1674.368717]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1674.368718] RIP: 0033:0x7fe04060dcf3
[ 1674.368718] RSP: 002b:00007fff0e679a58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[ 1674.368719] RAX: ffffffffffffffda RBX: 00007fe041752210 RCX: 00007fe04060dcf3
[ 1674.368720] RDX: 0000000000000003 RSI: 0000000002baa1c0 RDI: 0000000000000006
[ 1674.368721] RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000024
[ 1674.368721] R10: 00000000ffffffff R11: 0000000000000246 R12: 00000000024150a0
[ 1674.368722] R13: 0000000002baa1c0 R14: 0000000002ca9480 R15: 0000000002c57ab8
[ 1674.368722] Mem-Info:
[ 1674.368726] active_anon:115 inactive_anon:7 isolated_anon:0
 active_file:367 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:301 shmem:0 pagetables:1785 bounce:0
 free:39454 free_pcp:62 free_cma:0
[ 1674.368730] Node 0 active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:16kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6244 all_unreclaimable? yes
[ 1674.368734] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.368735] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.368738] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.368740] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.368743] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.368744] Node 0 Normal free:36660kB min:36664kB low:50028kB high:63392kB active_anon:376kB inactive_anon:0kB active_file:1200kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:248kB local_pcp:0kB free_cma:0kB
[ 1674.368747] lowmem_reserve[]: 0 0 0 0 0
[ 1674.368749] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.368751] lowmem_reserve[]: 0 0 0 0 0
[ 1674.368753] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.368758] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.368764] Node 0 Normal: 264*4kB (UM) 160*8kB (UME) 131*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 38960kB
[ 1674.368770] Node 1 Normal: 65*4kB (UME) 53*8kB (UME) 21*16kB (UME) 11*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 46556kB
[ 1674.368776] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.368776] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.368777] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.368778] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.368778] 551 total pagecache pages
[ 1674.368778] 63 pages in swap cache
[ 1674.368779] Swap cache stats: add 34058, delete 33995, find 907/1670
[ 1674.368779] Free swap  = 16418316kB
[ 1674.368780] Total swap = 16516092kB
[ 1674.368780] 8379718 pages RAM
[ 1674.368781] 0 pages HighMem/MovableOnly
[ 1674.368781] 153786 pages reserved
[ 1674.368781] 0 pages cma reserved
[ 1674.368781] 0 pages hwpoisoned
[ 1674.368782] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.368795] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.368797] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.368798] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.368801] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.368803] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.368804] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.368805] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.368806] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.368807] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.368808] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.368810] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.368811] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.368812] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.368814] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.368815] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.368816] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.368817] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.368819] [ 1902]     0  1902    28209        0      53       3     3123             0 dhclient
[ 1674.368820] [ 1976]     0  1976   138299        0      89       4     2712             0 tuned
[ 1674.368821] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.368822] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.368823] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.368825] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.368826] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.368827] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.368828] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.368829] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.368830] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.368831] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.368834] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.368835] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.368836] [ 3401]     0  3374    90269        0      98       4        0             0 beah-beaker-bac
[ 1674.368837] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.368838] [ 3377]     0  3377    60773        1      75       4     3102             0 beah-fwd-backen
[ 1674.368839] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.368840] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.368841] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.368843] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.368844] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.369060] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.369067] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.369069] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.369072] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.369080] [ 7132]     0  7132    43495       12      41       4      208             0 crond
[ 1674.369081] Out of memory: Kill process 1902 (dhclient) score 0 or sacrifice child
[ 1674.369086] Killed process 1902 (dhclient) total-vm:112836kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.389776] crond invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.389777] crond cpuset=/ mems_allowed=0-1
[ 1674.389779] CPU: 12 PID: 7132 Comm: crond Not tainted 4.10.0 #5
[ 1674.389780] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.389780] Call Trace:
[ 1674.389783]  dump_stack+0x63/0x87
[ 1674.389785]  dump_header+0x82/0x212
[ 1674.389786]  ? selinux_capable+0x20/0x30
[ 1674.389788]  ? security_capable_noaudit+0x45/0x60
[ 1674.389789]  oom_kill_process+0x21c/0x3f0
[ 1674.389790]  out_of_memory+0x117/0x4a0
[ 1674.389792]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.389793]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.389795]  alloc_pages_current+0x88/0x120
[ 1674.389797]  __page_cache_alloc+0xae/0xc0
[ 1674.389798]  filemap_fault+0x5cb/0x740
[ 1674.389799]  ? down_read+0x12/0x40
[ 1674.389823]  xfs_filemap_fault+0x60/0xf0 [xfs]
[ 1674.389824]  __do_fault+0x21/0x80
[ 1674.389825]  handle_mm_fault+0xc0f/0x1350
[ 1674.389827]  __do_page_fault+0x22a/0x4a0
[ 1674.389828]  do_page_fault+0x30/0x80
[ 1674.389830]  ? do_syscall_64+0x175/0x180
[ 1674.389832]  page_fault+0x28/0x30
[ 1674.389832] RIP: 0033:0x7fe545971a10
[ 1674.389833] RSP: 002b:00007fff279c0528 EFLAGS: 00010246
[ 1674.389834] RAX: 0000000000000001 RBX: 0000556f99860950 RCX: 00007fff279c0560
[ 1674.389835] RDX: 0000000000000000 RSI: 00007fe5459e5621 RDI: 00007fff279c0550
[ 1674.389836] RBP: 0000556f9985e6e0 R08: 0000000000000001 R09: 0000000000000000
[ 1674.389836] R10: 0000000000000000 R11: 0000000000000206 R12: 0000556f99860980
[ 1674.389837] R13: 0000000000000400 R14: 00007fe5466956d0 R15: 0000000000000001
[ 1674.389838] Mem-Info:
[ 1674.389842] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:269 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:531 free_cma:0
[ 1674.389847] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:0kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.389851] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.389852] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.389855] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.389856] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.389859] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.389861] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1452kB local_pcp:120kB free_cma:0kB
[ 1674.389864] lowmem_reserve[]: 0 0 0 0 0
[ 1674.389866] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:672kB local_pcp:4kB free_cma:0kB
[ 1674.389868] lowmem_reserve[]: 0 0 0 0 0
[ 1674.389870] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.389875] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.389881] Node 0 Normal: 10*4kB (U) 59*8kB (UME) 121*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36976kB
[ 1674.389887] Node 1 Normal: 17*4kB (UME) 46*8kB (UME) 21*16kB (UME) 11*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 46308kB
[ 1674.389894] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.389895] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.389895] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.389896] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.389896] 677 total pagecache pages
[ 1674.389897] 65 pages in swap cache
[ 1674.389898] Swap cache stats: add 34068, delete 34003, find 916/1686
[ 1674.389898] Free swap  = 16430832kB
[ 1674.389898] Total swap = 16516092kB
[ 1674.389899] 8379718 pages RAM
[ 1674.389899] 0 pages HighMem/MovableOnly
[ 1674.389899] 153786 pages reserved
[ 1674.389900] 0 pages cma reserved
[ 1674.389900] 0 pages hwpoisoned
[ 1674.389900] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.389915] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.389916] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.389918] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.389921] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.389922] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.389923] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.389924] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.389925] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.389927] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.389928] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.389929] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.389930] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.389931] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.389932] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.389934] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.389935] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.389936] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.389937] [ 1976]     0  1976   138299        0      89       4     2712             0 tuned
[ 1674.389939] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.389940] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.389941] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.389942] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.389944] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.389945] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.389946] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.389947] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.389948] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.389949] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.389952] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.389953] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.389954] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.389955] [ 3377]     0  3377    60773        1      75       4     3102             0 beah-fwd-backen
[ 1674.389956] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.389958] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.389959] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.389961] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.389962] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.390182] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.390189] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.390191] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.390194] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.390202] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.390203] Out of memory: Kill process 3377 (beah-fwd-backen) score 0 or sacrifice child
[ 1674.390206] Killed process 3377 (beah-fwd-backen) total-vm:243092kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.406118] auditd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=-1000
[ 1674.406119] auditd cpuset=/ mems_allowed=0-1
[ 1674.406121] CPU: 11 PID: 1096 Comm: auditd Not tainted 4.10.0 #5
[ 1674.406122] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.406122] Call Trace:
[ 1674.406126]  dump_stack+0x63/0x87
[ 1674.406127]  dump_header+0x82/0x212
[ 1674.406129]  ? selinux_capable+0x20/0x30
[ 1674.406130]  ? security_capable_noaudit+0x45/0x60
[ 1674.406132]  oom_kill_process+0x21c/0x3f0
[ 1674.406133]  out_of_memory+0x117/0x4a0
[ 1674.406134]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.406136]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.406138]  alloc_pages_vma+0xa5/0x220
[ 1674.406139]  __read_swap_cache_async+0x129/0x1d0
[ 1674.406140]  read_swap_cache_async+0x26/0x60
[ 1674.406141]  swapin_readahead+0x16b/0x200
[ 1674.406143]  ? find_get_entry+0x20/0x140
[ 1674.406145]  ? pagecache_get_page+0x2c/0x250
[ 1674.406146]  do_swap_page+0x2aa/0x780
[ 1674.406148]  handle_mm_fault+0x7bb/0x1350
[ 1674.406149]  ? hrtimer_init+0x150/0x150
[ 1674.406151]  __do_page_fault+0x22a/0x4a0
[ 1674.406152]  do_page_fault+0x30/0x80
[ 1674.406154]  page_fault+0x28/0x30
[ 1674.406155] RIP: 0033:0x556d484aa1d3
[ 1674.406156] RSP: 002b:00007ffddd79bcd0 EFLAGS: 00010206
[ 1674.406157] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1674.406157] RDX: 0000000000000001 RSI: 0000556d499a4da0 RDI: 0000000000000000
[ 1674.406158] RBP: 0000000000000000 R08: 000000000003452a R09: 0000000000000001
[ 1674.406158] R10: 000000000000e95f R11: 0000000000000000 R12: 0000000000000000
[ 1674.406159] R13: 000000000000000c R14: 0000000000000001 R15: 0000556d486b9e60
[ 1674.406160] Mem-Info:
[ 1674.406164] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:675 free_cma:0
[ 1674.406169] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.406173] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.406174] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.406177] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.406179] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.406181] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.406183] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1652kB local_pcp:120kB free_cma:0kB
[ 1674.406186] lowmem_reserve[]: 0 0 0 0 0
[ 1674.406187] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1048kB local_pcp:0kB free_cma:0kB
[ 1674.406190] lowmem_reserve[]: 0 0 0 0 0
[ 1674.406191] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.406197] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.406203] Node 0 Normal: 10*4kB (U) 59*8kB (UME) 121*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36976kB
[ 1674.406210] Node 1 Normal: 15*4kB (E) 22*8kB (UME) 18*16kB (UME) 11*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 46060kB
[ 1674.406216] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.406217] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.406217] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.406218] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.406218] 677 total pagecache pages
[ 1674.406219] 64 pages in swap cache
[ 1674.406220] Swap cache stats: add 34070, delete 34006, find 918/1692
[ 1674.406220] Free swap  = 16443208kB
[ 1674.406220] Total swap = 16516092kB
[ 1674.406221] 8379718 pages RAM
[ 1674.406221] 0 pages HighMem/MovableOnly
[ 1674.406221] 153786 pages reserved
[ 1674.406222] 0 pages cma reserved
[ 1674.406222] 0 pages hwpoisoned
[ 1674.406222] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.406237] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.406238] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.406239] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.406243] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.406244] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.406245] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.406246] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.406248] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.406249] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.406250] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.406251] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.406252] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.406254] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.406255] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.406256] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.406257] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.406259] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.406260] [ 1976]     0  1976   138299        0      89       4     2712             0 tuned
[ 1674.406261] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.406262] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.406263] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.406265] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.406266] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.406267] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.406268] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.406269] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.406270] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.406271] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.406274] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.406275] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.406276] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.406277] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.406278] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.406279] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.406282] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.406282] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.406494] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.406502] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.406503] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.406506] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.406514] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.406515] Out of memory: Kill process 1976 (tuned) score 0 or sacrifice child
[ 1674.406527] Killed process 1976 (tuned) total-vm:553196kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.425148] oom_reaper: reaped process 1976 (tuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.428588] crond invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.428588] crond cpuset=/ mems_allowed=0-1
[ 1674.428591] CPU: 12 PID: 7132 Comm: crond Not tainted 4.10.0 #5
[ 1674.428591] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.428592] Call Trace:
[ 1674.428595]  dump_stack+0x63/0x87
[ 1674.428596]  dump_header+0x82/0x212
[ 1674.428598]  ? selinux_capable+0x20/0x30
[ 1674.428599]  ? security_capable_noaudit+0x45/0x60
[ 1674.428600]  oom_kill_process+0x21c/0x3f0
[ 1674.428601]  out_of_memory+0x117/0x4a0
[ 1674.428603]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.428604]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.428606]  alloc_pages_current+0x88/0x120
[ 1674.428608]  __page_cache_alloc+0xae/0xc0
[ 1674.428609]  filemap_fault+0x5cb/0x740
[ 1674.428610]  ? down_read+0x12/0x40
[ 1674.428633]  xfs_filemap_fault+0x60/0xf0 [xfs]
[ 1674.428635]  __do_fault+0x21/0x80
[ 1674.428636]  handle_mm_fault+0xc0f/0x1350
[ 1674.428638]  __do_page_fault+0x22a/0x4a0
[ 1674.428639]  do_page_fault+0x30/0x80
[ 1674.428640]  ? do_syscall_64+0x175/0x180
[ 1674.428642]  page_fault+0x28/0x30
[ 1674.428643] RIP: 0033:0x7fe545971a10
[ 1674.428644] RSP: 002b:00007fff279c0528 EFLAGS: 00010246
[ 1674.428645] RAX: 0000000000000001 RBX: 0000556f99860950 RCX: 00007fff279c0560
[ 1674.428645] RDX: 0000000000000000 RSI: 00007fe5459e5621 RDI: 00007fff279c0550
[ 1674.428646] RBP: 0000556f9985e6e0 R08: 0000000000000001 R09: 0000000000000000
[ 1674.428647] R10: 0000000000000000 R11: 0000000000000206 R12: 0000556f99860980
[ 1674.428647] R13: 0000000000000400 R14: 00007fe5466956d0 R15: 0000000000000001
[ 1674.428648] Mem-Info:
[ 1674.428652] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:711 free_cma:0
[ 1674.428657] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.428661] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.428662] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.428664] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.428666] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.428669] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.428671] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1668kB local_pcp:120kB free_cma:0kB
[ 1674.428674] lowmem_reserve[]: 0 0 0 0 0
[ 1674.428675] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1176kB local_pcp:4kB free_cma:0kB
[ 1674.428678] lowmem_reserve[]: 0 0 0 0 0
[ 1674.428680] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.428685] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.428691] Node 0 Normal: 10*4kB (U) 59*8kB (UME) 121*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36976kB
[ 1674.428697] Node 1 Normal: 16*4kB (ME) 22*8kB (UME) 12*16kB (UE) 10*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 45936kB
[ 1674.428703] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.428704] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.428705] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.428705] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.428706] 677 total pagecache pages
[ 1674.428706] 52 pages in swap cache
[ 1674.428707] Swap cache stats: add 34072, delete 34020, find 920/1699
[ 1674.428707] Free swap  = 16454024kB
[ 1674.428708] Total swap = 16516092kB
[ 1674.428708] 8379718 pages RAM
[ 1674.428708] 0 pages HighMem/MovableOnly
[ 1674.428709] 153786 pages reserved
[ 1674.428709] 0 pages cma reserved
[ 1674.428709] 0 pages hwpoisoned
[ 1674.428710] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.428724] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.428725] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.428726] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.428730] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.428731] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.428732] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.428733] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.428734] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.428735] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.428736] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.428737] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.428739] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.428740] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.428741] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.428743] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.428744] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.428745] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.428746] [ 2719]     0  1976   138299        0      89       4        8             0 gmain
[ 1674.428747] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.428749] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.428750] [ 2005]     0  2005   154722        8     147       4     2118             0 libvirtd
[ 1674.428751] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.428753] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.428754] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.428755] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.428756] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.428758] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.428758] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.428761] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.428762] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.428763] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.428764] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.428766] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.428767] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.428769] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.428770] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.428986] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.428993] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.428995] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.428998] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.429006] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.429007] Out of memory: Kill process 2005 (libvirtd) score 0 or sacrifice child
[ 1674.429063] Killed process 2005 (libvirtd) total-vm:618888kB, anon-rss:0kB, file-rss:32kB, shmem-rss:0kB
[ 1674.445187] oom_reaper: reaped process 2005 (libvirtd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.448800] libvirtd invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.448801] libvirtd cpuset=/ mems_allowed=0-1
[ 1674.448804] CPU: 7 PID: 2939 Comm: libvirtd Not tainted 4.10.0 #5
[ 1674.448804] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.448805] Call Trace:
[ 1674.448808]  dump_stack+0x63/0x87
[ 1674.448810]  dump_header+0x82/0x212
[ 1674.448812]  ? selinux_capable+0x20/0x30
[ 1674.448814]  ? security_capable_noaudit+0x45/0x60
[ 1674.448815]  oom_kill_process+0x21c/0x3f0
[ 1674.448816]  out_of_memory+0x117/0x4a0
[ 1674.448818]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.448819]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.448821]  alloc_pages_vma+0xa5/0x220
[ 1674.448823]  __read_swap_cache_async+0x129/0x1d0
[ 1674.448825]  read_swap_cache_async+0x26/0x60
[ 1674.448826]  swapin_readahead+0x16b/0x200
[ 1674.448828]  ? find_get_entry+0x20/0x140
[ 1674.448830]  ? pagecache_get_page+0x2c/0x250
[ 1674.448831]  do_swap_page+0x2aa/0x780
[ 1674.448834]  ? find_busiest_group+0x47/0x4d0
[ 1674.448835]  handle_mm_fault+0x7bb/0x1350
[ 1674.448837]  __do_page_fault+0x22a/0x4a0
[ 1674.448838]  do_page_fault+0x30/0x80
[ 1674.448840]  page_fault+0x28/0x30
[ 1674.448843] RIP: 0010:__get_user_8+0x1b/0x25
[ 1674.448843] RSP: 0018:ffffc900079e7c28 EFLAGS: 00010287
[ 1674.448844] RAX: 00007f8f22ce59e7 RBX: ffff880828f70f80 RCX: 00000000000002b0
[ 1674.448845] RDX: ffff880427261680 RSI: ffff880828f70f80 RDI: ffff880427261680
[ 1674.448845] RBP: ffffc900079e7c78 R08: ffff88040ccfc800 R09: 000000018020001b
[ 1674.448846] R10: 000000000ccfe401 R11: ffff88040ccfc800 R12: ffff880427261680
[ 1674.448847] R13: 00007f8f22ce59e0 R14: ffff880427261680 R15: ffff88040d8d6400
[ 1674.448850]  ? exit_robust_list+0x37/0x120
[ 1674.448851]  mm_release+0x123/0x140
[ 1674.448853]  do_exit+0x149/0xb60
[ 1674.448854]  ? __unqueue_futex+0x2f/0x60
[ 1674.448855]  do_group_exit+0x3f/0xb0
[ 1674.448856]  get_signal+0x1cc/0x600
[ 1674.448859]  do_signal+0x37/0x6a0
[ 1674.448860]  ? do_futex+0xfd/0x570
[ 1674.448861]  ? __delete_object+0x3a/0x70
[ 1674.448863]  exit_to_usermode_loop+0x4c/0x92
[ 1674.448865]  do_syscall_64+0x165/0x180
[ 1674.448867]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1674.448867] RIP: 0033:0x7f8f3d7a06d5
[ 1674.448868] RSP: 002b:00007f8f22ce4cf0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 1674.448869] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f8f3d7a06d5
[ 1674.448869] RDX: 0000000000000002 RSI: 0000000000000080 RDI: 000056426efde7ec
[ 1674.448870] RBP: 000056426efde848 R08: 000056426efde700 R09: 0000000000000000
[ 1674.448870] R10: 0000000000000000 R11: 0000000000000246 R12: 000056426efde860
[ 1674.448871] R13: 000056426efde7c0 R14: 000056426efde7e8 R15: 000056426efde780
[ 1674.448872] Mem-Info:
[ 1674.448876] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:710 free_cma:0
[ 1674.448880] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.448884] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.448885] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.448887] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.448889] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.448892] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.448893] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1672kB local_pcp:0kB free_cma:0kB
[ 1674.448896] lowmem_reserve[]: 0 0 0 0 0
[ 1674.448897] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1168kB local_pcp:0kB free_cma:0kB
[ 1674.448900] lowmem_reserve[]: 0 0 0 0 0
[ 1674.448901] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.448906] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.448912] Node 0 Normal: 10*4kB (U) 59*8kB (UME) 121*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36976kB
[ 1674.448918] Node 1 Normal: 16*4kB (ME) 22*8kB (UME) 12*16kB (UE) 10*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 45936kB
[ 1674.448925] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.448925] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.448926] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.448927] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.448927] 677 total pagecache pages
[ 1674.448928] 52 pages in swap cache
[ 1674.448928] Swap cache stats: add 34074, delete 34022, find 921/1715
[ 1674.448929] Free swap  = 16462496kB
[ 1674.448929] Total swap = 16516092kB
[ 1674.448930] 8379718 pages RAM
[ 1674.448930] 0 pages HighMem/MovableOnly
[ 1674.448930] 153786 pages reserved
[ 1674.448931] 0 pages cma reserved
[ 1674.448931] 0 pages hwpoisoned
[ 1674.448931] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.448947] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.448949] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.448950] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.448955] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.448956] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.448957] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.448958] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.448959] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.448960] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.448961] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.448962] [ 1149]   998  1149   132401        1      60       4     1872             0 polkitd
[ 1674.448964] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.448965] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.448966] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.448967] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.448968] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.448969] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.448971] [ 2719]     0  1976   138299        0      89       4        8             0 gmain
[ 1674.448972] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.448973] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.448974] [ 2527]     0  2005   154722        0     147       4        0             0 libvirtd
[ 1674.448975] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.448977] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.448978] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.448979] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.448980] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.448981] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.448982] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.448985] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.448986] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.448987] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.448988] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.448989] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.448990] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.448992] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.448993] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.449251] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.449263] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.449264] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.449268] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.449280] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.449281] Out of memory: Kill process 1149 (polkitd) score 0 or sacrifice child
[ 1674.449295] Killed process 1149 (polkitd) total-vm:529604kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.465130] oom_reaper: reaped process 1149 (polkitd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.468584] gmain invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.468585] gmain cpuset=/ mems_allowed=0-1
[ 1674.468587] CPU: 16 PID: 1184 Comm: gmain Not tainted 4.10.0 #5
[ 1674.468588] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.468588] Call Trace:
[ 1674.468591]  dump_stack+0x63/0x87
[ 1674.468592]  dump_header+0x82/0x212
[ 1674.468594]  ? selinux_capable+0x20/0x30
[ 1674.468595]  ? security_capable_noaudit+0x45/0x60
[ 1674.468596]  oom_kill_process+0x21c/0x3f0
[ 1674.468597]  out_of_memory+0x117/0x4a0
[ 1674.468599]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.468600]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.468602]  alloc_pages_vma+0xa5/0x220
[ 1674.468603]  __read_swap_cache_async+0x129/0x1d0
[ 1674.468604]  read_swap_cache_async+0x26/0x60
[ 1674.468606]  swapin_readahead+0x16b/0x200
[ 1674.468607]  ? find_get_entry+0x20/0x140
[ 1674.468609]  ? pagecache_get_page+0x2c/0x250
[ 1674.468610]  do_swap_page+0x2aa/0x780
[ 1674.468611]  handle_mm_fault+0x7bb/0x1350
[ 1674.468613]  __do_page_fault+0x22a/0x4a0
[ 1674.468615]  do_page_fault+0x30/0x80
[ 1674.468616]  page_fault+0x28/0x30
[ 1674.468619] RIP: 0010:do_sys_poll+0x475/0x510
[ 1674.468619] RSP: 0018:ffffc9000cb57ad0 EFLAGS: 00010246
[ 1674.468620] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1674.468621] RDX: 0000000000000000 RSI: ffffc9000cb57b30 RDI: ffffc9000cb57b3c
[ 1674.468621] RBP: ffffc9000cb57ee0 R08: 0000000000000000 R09: ffff8804271ab700
[ 1674.468622] R10: 0000000000000020 R11: ffff880403b87a38 R12: 0000000000000000
[ 1674.468623] R13: ffffc9000cb57b4c R14: 00000000fffffffc R15: 00007f03400008e0
[ 1674.468625]  ? update_cfs_shares+0xbc/0x100
[ 1674.468626]  ? unwind_next_frame+0x93/0x200
[ 1674.468628]  ? poll_select_copy_remaining+0x150/0x150
[ 1674.468629]  ? poll_select_copy_remaining+0x150/0x150
[ 1674.468630]  ? __alloc_pages_nodemask+0xfd/0x2a0
[ 1674.468633]  ? eventfd_ctx_read+0x67/0x210
[ 1674.468635]  ? wake_up_q+0x80/0x80
[ 1674.468636]  ? eventfd_read+0x5d/0x90
[ 1674.468638]  ? __audit_syscall_entry+0xaf/0x100
[ 1674.468639]  SyS_poll+0x74/0x100
[ 1674.468641]  do_syscall_64+0x67/0x180
[ 1674.468642]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1674.468643] RIP: 0033:0x7f0348456dfd
[ 1674.468644] RSP: 002b:00007f0344eefd30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[ 1674.468645] RAX: ffffffffffffffda RBX: 0000557bcb5d5ac0 RCX: 00007f0348456dfd
[ 1674.468645] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f03400008e0
[ 1674.468646] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[ 1674.468646] R10: 0000000000000001 R11: 0000000000000293 R12: 00007f03400008e0
[ 1674.468647] R13: 00000000ffffffff R14: 00007f03491ae8b0 R15: 0000000000000002
[ 1674.468648] Mem-Info:
[ 1674.468652] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:743 free_cma:0
[ 1674.468656] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.468660] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.468660] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.468663] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.468665] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.468668] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.468669] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1688kB local_pcp:0kB free_cma:0kB
[ 1674.468672] lowmem_reserve[]: 0 0 0 0 0
[ 1674.468674] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1284kB local_pcp:0kB free_cma:0kB
[ 1674.468676] lowmem_reserve[]: 0 0 0 0 0
[ 1674.468678] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.468683] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.468689] Node 0 Normal: 10*4kB (U) 59*8kB (UME) 121*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36976kB
[ 1674.468695] Node 1 Normal: 15*4kB (E) 21*8kB (UE) 13*16kB (UME) 6*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 45812kB
[ 1674.468701] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.468702] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.468703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.468703] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.468704] 677 total pagecache pages
[ 1674.468704] 52 pages in swap cache
[ 1674.468705] Swap cache stats: add 34076, delete 34024, find 922/1723
[ 1674.468705] Free swap  = 16469984kB
[ 1674.468706] Total swap = 16516092kB
[ 1674.468707] 8379718 pages RAM
[ 1674.468707] 0 pages HighMem/MovableOnly
[ 1674.468707] 153786 pages reserved
[ 1674.468707] 0 pages cma reserved
[ 1674.468708] 0 pages hwpoisoned
[ 1674.468708] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.468722] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.468724] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.468725] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.468728] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.468730] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.468731] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.468732] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.468733] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.468734] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.468735] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.468736] [ 1184]   998  1149   132401        0      60       4        0             0 gmain
[ 1674.468738] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.468739] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.468740] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.468741] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.468742] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.468744] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.468745] [ 2719]     0  1976   138299        0      89       4        8             0 gmain
[ 1674.468746] [ 1978]     0  1978    71863        0      41       3      806             0 rsyslogd
[ 1674.468747] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.468749] [ 2527]     0  2005   154722        0     147       4        0             0 libvirtd
[ 1674.468750] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.468751] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.468752] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.468753] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.468754] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.468756] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.468757] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.468759] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.468760] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.468761] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.468762] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.468763] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.468764] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.468766] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.468767] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.469021] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.469033] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.469034] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.469038] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.469049] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.469050] Out of memory: Kill process 1978 (rsyslogd) score 0 or sacrifice child
[ 1674.469060] Killed process 1978 (rsyslogd) total-vm:287452kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.469590] oom_reaper: reaped process 1978 (rsyslogd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.471116] tuned invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.471117] tuned cpuset=/ mems_allowed=0-1
[ 1674.471121] CPU: 17 PID: 2727 Comm: tuned Not tainted 4.10.0 #5
[ 1674.471121] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.471122] Call Trace:
[ 1674.471126]  dump_stack+0x63/0x87
[ 1674.471128]  dump_header+0x82/0x212
[ 1674.471130]  ? selinux_capable+0x20/0x30
[ 1674.471132]  ? security_capable_noaudit+0x45/0x60
[ 1674.471133]  oom_kill_process+0x21c/0x3f0
[ 1674.471135]  out_of_memory+0x117/0x4a0
[ 1674.471136]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.471138]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.471139]  alloc_pages_vma+0xa5/0x220
[ 1674.471141]  __read_swap_cache_async+0x129/0x1d0
[ 1674.471142]  read_swap_cache_async+0x26/0x60
[ 1674.471144]  swapin_readahead+0x16b/0x200
[ 1674.471146]  ? find_get_entry+0x20/0x140
[ 1674.471147]  ? pagecache_get_page+0x2c/0x250
[ 1674.471148]  do_swap_page+0x2aa/0x780
[ 1674.471150]  handle_mm_fault+0x7bb/0x1350
[ 1674.471151]  __do_page_fault+0x22a/0x4a0
[ 1674.471153]  do_page_fault+0x30/0x80
[ 1674.471155]  page_fault+0x28/0x30
[ 1674.471157] RIP: 0010:copy_user_generic_string+0x2c/0x40
[ 1674.471157] RSP: 0018:ffffc900077efe48 EFLAGS: 00010246
[ 1674.471158] RAX: 0000000000000010 RBX: 00000000fffffdfe RCX: 0000000000000002
[ 1674.471159] RDX: 0000000000000000 RSI: ffffc900077efe80 RDI: 00007fcf06b32dd0
[ 1674.471160] RBP: ffffc900077efe50 R08: 00007ffffffff000 R09: cccccccccccccccd
[ 1674.471160] R10: 00000185b8b8790d R11: 0000000000000018 R12: ffffc900077efed0
[ 1674.471161] R13: 00007fcf06b32dd0 R14: 0000000000000001 R15: 0000000000000000
[ 1674.471163]  ? _copy_to_user+0x2d/0x40
[ 1674.471165]  poll_select_copy_remaining+0xfb/0x150
[ 1674.471166]  SyS_select+0xcc/0x110
[ 1674.471168]  do_syscall_64+0x67/0x180
[ 1674.471169]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1674.471170] RIP: 0033:0x7fcf16167ba3
[ 1674.471171] RSP: 002b:00007fcf06b32da0 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[ 1674.471172] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcf16167ba3
[ 1674.471172] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1674.471173] RBP: 0000000002389400 R08: 00007fcf06b32dd0 R09: 00007fcf06b32b80
[ 1674.471174] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fcf0e8c1810
[ 1674.471174] R13: 0000000000000001 R14: 00007fcefc00dc20 R15: 00007fcf171c5ef0
[ 1674.471175] Mem-Info:
[ 1674.471179] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:774 free_cma:0
[ 1674.471184] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.471188] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.471189] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.471191] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.471193] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.471196] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.471198] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1812kB local_pcp:0kB free_cma:0kB
[ 1674.471201] lowmem_reserve[]: 0 0 0 0 0
[ 1674.471202] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1284kB local_pcp:0kB free_cma:0kB
[ 1674.471205] lowmem_reserve[]: 0 0 0 0 0
[ 1674.471207] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.471224] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.471230] Node 0 Normal: 11*4kB (UM) 59*8kB (UME) 113*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36852kB
[ 1674.471236] Node 1 Normal: 15*4kB (E) 21*8kB (UE) 13*16kB (UME) 6*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 45812kB
[ 1674.471243] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.471243] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.471244] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.471244] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.471245] 677 total pagecache pages
[ 1674.471245] 52 pages in swap cache
[ 1674.471246] Swap cache stats: add 34078, delete 34026, find 924/1728
[ 1674.471246] Free swap  = 16473208kB
[ 1674.471247] Total swap = 16516092kB
[ 1674.471247] 8379718 pages RAM
[ 1674.471248] 0 pages HighMem/MovableOnly
[ 1674.471248] 153786 pages reserved
[ 1674.471248] 0 pages cma reserved
[ 1674.471248] 0 pages hwpoisoned
[ 1674.471249] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.471263] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.471264] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.471266] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.471269] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.471270] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.471271] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.471273] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.471274] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.471275] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.471276] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.471277] [ 1184]   998  1149   132401        0      60       4        0             0 gmain
[ 1674.471278] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.471279] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.471280] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.471282] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.471283] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.471284] [ 1251]     0  1251   637907        0      84       5      398             0 opensm
[ 1674.471285] [ 2719]     0  1976   138299        0      89       4        8             0 gmain
[ 1674.471287] [ 2174]     0  1978    71863        0      41       3        0             0 in:imjournal
[ 1674.471288] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.471289] [ 2527]     0  2005   154722        0     147       4        0             0 libvirtd
[ 1674.471290] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.471291] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.471293] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.471294] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.471295] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.471296] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.471297] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.471299] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.471300] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.471301] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.471302] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.471303] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.471304] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.471306] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.471307] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.471577] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.471589] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.471590] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.471594] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.471606] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.471607] Out of memory: Kill process 1251 (opensm) score 0 or sacrifice child
[ 1674.471704] Killed process 1251 (opensm) total-vm:2551628kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.475692] oom_reaper: reaped process 1251 (opensm), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.476256] opensm invoked oom-killer: gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=0-1, order=0, oom_score_adj=0
[ 1674.476257] opensm cpuset=/ mems_allowed=0-1
[ 1674.476259] CPU: 11 PID: 1301 Comm: opensm Not tainted 4.10.0 #5
[ 1674.476260] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1674.476260] Call Trace:
[ 1674.476264]  dump_stack+0x63/0x87
[ 1674.476265]  dump_header+0x82/0x212
[ 1674.476266]  ? selinux_capable+0x20/0x30
[ 1674.476267]  ? security_capable_noaudit+0x45/0x60
[ 1674.476269]  oom_kill_process+0x21c/0x3f0
[ 1674.476270]  out_of_memory+0x117/0x4a0
[ 1674.476272]  __alloc_pages_slowpath+0x913/0xaf0
[ 1674.476273]  __alloc_pages_nodemask+0x223/0x2a0
[ 1674.476275]  alloc_pages_vma+0xa5/0x220
[ 1674.476276]  __read_swap_cache_async+0x129/0x1d0
[ 1674.476278]  read_swap_cache_async+0x26/0x60
[ 1674.476279]  swapin_readahead+0x16b/0x200
[ 1674.476281]  ? find_get_entry+0x20/0x140
[ 1674.476282]  ? pagecache_get_page+0x2c/0x250
[ 1674.476283]  do_swap_page+0x2aa/0x780
[ 1674.476286]  ? find_busiest_group+0x47/0x4d0
[ 1674.476287]  handle_mm_fault+0x7bb/0x1350
[ 1674.476289]  __do_page_fault+0x22a/0x4a0
[ 1674.476290]  do_page_fault+0x30/0x80
[ 1674.476292]  page_fault+0x28/0x30
[ 1674.476294] RIP: 0010:__get_user_8+0x1b/0x25
[ 1674.476295] RSP: 0000:ffffc90005737c28 EFLAGS: 00010287
[ 1674.476296] RAX: 00007fe41be299e7 RBX: ffff88082845c5c0 RCX: 00000000000002b0
[ 1674.476297] RDX: ffff88081ead1680 RSI: ffff88082845c5c0 RDI: ffff88081ead1680
[ 1674.476297] RBP: ffffc90005737c78 R08: ffff88082d4d7800 R09: 0000000180200018
[ 1674.476298] R10: 000000002d4d0001 R11: ffff88082d4d7800 R12: ffff88081ead1680
[ 1674.476299] R13: 00007fe41be299e0 R14: ffff88081ead1680 R15: ffff880427f36c40
[ 1674.476302]  ? exit_robust_list+0x37/0x120
[ 1674.476304]  mm_release+0x123/0x140
[ 1674.476305]  do_exit+0x149/0xb60
[ 1674.476307]  ? __unqueue_futex+0x2f/0x60
[ 1674.476308]  do_group_exit+0x3f/0xb0
[ 1674.476310]  get_signal+0x1cc/0x600
[ 1674.476313]  do_signal+0x37/0x6a0
[ 1674.476314]  ? do_futex+0xfd/0x570
[ 1674.476317]  exit_to_usermode_loop+0x4c/0x92
[ 1674.476318]  do_syscall_64+0x165/0x180
[ 1674.476320]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1674.476321] RIP: 0033:0x7fe4284246d5
[ 1674.476321] RSP: 002b:00007fe41be28ed0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[ 1674.476322] RAX: fffffffffffffe00 RBX: 00007ffeeb78ee08 RCX: 00007fe4284246d5
[ 1674.476323] RDX: 00000000000088d2 RSI: 0000000000000080 RDI: 00007ffeeb78ee24
[ 1674.476323] RBP: 00007ffeeb78ee50 R08: 00007ffeeb78ee00 R09: 0000000000004459
[ 1674.476324] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeeb78ee20
[ 1674.476325] R13: 00007fe41be299c0 R14: 00007fe41be29700 R15: 0000000000000000
[ 1674.476325] Mem-Info:
[ 1674.476330] active_anon:50 inactive_anon:65 isolated_anon:0
 active_file:292 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:24 unstable:0
 slab_reclaimable:12064 slab_unreclaimable:821118
 mapped:366 shmem:0 pagetables:1785 bounce:0
 free:39400 free_pcp:809 free_cma:0
[ 1674.476334] Node 0 active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:276kB dirty:0kB writeback:96kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:6280 all_unreclaimable? yes
[ 1674.476338] Node 1 active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:1188kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1260 all_unreclaimable? yes
[ 1674.476339] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.476342] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1674.476344] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1674.476347] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1674.476348] Node 0 Normal free:36444kB min:36664kB low:50028kB high:63392kB active_anon:116kB inactive_anon:172kB active_file:900kB inactive_file:0kB unevictable:0kB writepending:96kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:18696kB slab_unreclaimable:1384136kB kernel_stack:29400kB pagetables:3440kB bounce:0kB free_pcp:1952kB local_pcp:136kB free_cma:0kB
[ 1674.476351] lowmem_reserve[]: 0 0 0 0 0
[ 1674.476353] Node 1 Normal free:45048kB min:45296kB low:61804kB high:78312kB active_anon:84kB inactive_anon:88kB active_file:268kB inactive_file:240kB unevictable:0kB writepending:0kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:29560kB slab_unreclaimable:1639440kB kernel_stack:27480kB pagetables:3700kB bounce:0kB free_pcp:1284kB local_pcp:116kB free_cma:0kB
[ 1674.476355] lowmem_reserve[]: 0 0 0 0 0
[ 1674.476357] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1674.476362] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1674.476368] Node 0 Normal: 10*4kB (U) 58*8kB (UE) 106*16kB (UME) 69*32kB (UME) 39*64kB (UM) 17*128kB (UM) 6*256kB (UM) 5*512kB (M) 1*1024kB (M) 7*2048kB (M) 2*4096kB (ME) = 36728kB
[ 1674.476374] Node 1 Normal: 15*4kB (E) 21*8kB (UE) 13*16kB (UME) 6*32kB (UM) 26*64kB (UM) 32*128kB (UM) 28*256kB (UM) 23*512kB (UM) 10*1024kB (UM) 1*2048kB (M) 2*4096kB (M) = 45812kB
[ 1674.476381] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.476381] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.476382] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1674.476382] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1674.476383] 677 total pagecache pages
[ 1674.476383] 48 pages in swap cache
[ 1674.476384] Swap cache stats: add 34079, delete 34031, find 925/1738
[ 1674.476384] Free swap  = 16474324kB
[ 1674.476385] Total swap = 16516092kB
[ 1674.476385] 8379718 pages RAM
[ 1674.476386] 0 pages HighMem/MovableOnly
[ 1674.476386] 153786 pages reserved
[ 1674.476386] 0 pages cma reserved
[ 1674.476387] 0 pages hwpoisoned
[ 1674.476387] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1674.476400] [  774]     0   774     9206        1      21       3       82             0 systemd-journal
[ 1674.476402] [  812]     0   812    30349        0      29       3      374             0 lvmetad
[ 1674.476403] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1674.476405] [ 1096]     0  1096    13856        0      27       3      115         -1000 auditd
[ 1674.476407] [ 1127]   994  1127     2133        0      11       3       45             0 lsmd
[ 1674.476408] [ 1128]     0  1128     4889        0      14       3      145             0 irqbalance
[ 1674.476409] [ 1133]     0  1133     6050        1      16       3       73             0 systemd-logind
[ 1674.476410] [ 1135]     0  1135    31969        1      20       3      132             0 smartd
[ 1674.476411] [ 1145]     0  1145    53126        0      57       3      404             0 abrtd
[ 1674.476412] [ 1147]     0  1147    52551        1      55       3      338             0 abrt-watch-log
[ 1674.476413] [ 1184]   998  1149   132401        0      60       4        0             0 gmain
[ 1674.476415] [ 1153]    81  1153     8714        1      19       3      129          -900 dbus-daemon
[ 1674.476416] [ 1161]   997  1161     5672        0      16       3       61             0 chronyd
[ 1674.476417] [ 1163]     0  1163    50305        0      39       3      125             0 gssproxy
[ 1674.476419] [ 1230]     0  1230    28814        0      12       4       63             0 ksmtuned
[ 1674.476420] [ 1250]     0  1250    28813        0      12       3       53             0 opensm-launch
[ 1674.476421] [ 1274]     0  1251   637907        0      84       5       82             0 opensm
[ 1674.476423] [ 2719]     0  1976   138299        0      89       4        8             0 gmain
[ 1674.476424] [ 2174]     0  1978    71863        0      41       3        0             0 in:imjournal
[ 1674.476425] [ 1979]     0  1979    28337        1      12       3       37             0 rhsmcertd
[ 1674.476427] [ 2527]     0  2005   154722        0     147       4        0             0 libvirtd
[ 1674.476428] [ 2016]     0  2016     6463        0      18       3       52             0 atd
[ 1674.476429] [ 2111]     0  2111    20619        0      43       3      215         -1000 sshd
[ 1674.476431] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1674.476432] [ 2263]     0  2263    27511        1      12       3       31             0 agetty
[ 1674.476433] [ 2911]     0  2911    22767        1      44       3      256             0 master
[ 1674.476434] [ 2962]    89  2962    22793        1      43       3      254             0 pickup
[ 1674.476435] [ 2964]    89  2964    22810        1      43       3      254             0 qmgr
[ 1674.476438] [ 3339]    99  3339     3888        0      13       3       58             0 dnsmasq
[ 1674.476439] [ 3340]     0  3340     3881        0      12       3       45             0 dnsmasq
[ 1674.476440] [ 3375]     0  3375    31557        0      19       4      168             0 crond
[ 1674.476441] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1674.476442] [ 3410]     0  3410    35257        2      71       3      336             0 sshd
[ 1674.476443] [ 3414]     0  3414    29148        1      15       3      384             0 bash
[ 1674.476446] [ 3641]     0  3641    35257        2      72       3      335             0 sshd
[ 1674.476447] [ 3653]     0  3653    29148        1      15       3      412             0 bash
[ 1674.476665] [ 6884]     0  6884    35220        2      71       3      315             0 sshd
[ 1674.476672] [ 6961]     0  6961    29148        1      15       3      385             0 bash
[ 1674.476673] [ 6979]     0  6979    83699        1      61       3      489          -900 abrt-dbus
[ 1674.476677] [ 7042]     0  7042    26976        0      12       4       22             0 sleep
[ 1674.476685] [ 7132]     0  7132    43494      114      41       4      200             0 crond
[ 1674.476686] Out of memory: Kill process 1145 (abrtd) score 0 or sacrifice child
[ 1674.476691] Killed process 1145 (abrtd) total-vm:212504kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.517437] Out of memory: Kill process 3653 (bash) score 0 or sacrifice child
[ 1674.517443] Killed process 3653 (bash) total-vm:116592kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.585200] Out of memory: Kill process 3410 (sshd) score 0 or sacrifice child
[ 1674.585206] Killed process 3414 (bash) total-vm:116592kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.599308] Out of memory: Kill process 3410 (sshd) score 0 or sacrifice child
[ 1674.599311] Killed process 3410 (sshd) total-vm:141028kB, anon-rss:0kB, file-rss:8kB, shmem-rss:0kB
[ 1674.623168] Out of memory: Kill process 3641 (sshd) score 0 or sacrifice child
[ 1674.623170] Killed process 3641 (sshd) total-vm:141028kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.634775] oom_reaper: reaped process 3641 (sshd), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.636239] Out of memory: Kill process 1147 (abrt-watch-log) score 0 or sacrifice child
[ 1674.636245] Killed process 1147 (abrt-watch-log) total-vm:210204kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.655057] Out of memory: Kill process 812 (lvmetad) score 0 or sacrifice child
[ 1674.655064] Killed process 812 (lvmetad) total-vm:121396kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1674.678520] Out of memory: Kill process 6961 (bash) score 0 or sacrifice child
[ 1674.678524] Killed process 6961 (bash) total-vm:116592kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1674.774578] nvmet: ctrl 908 keep-alive timer (15 seconds) expired!
[ 1674.774579] nvmet: ctrl 908 fatal error occurred!
[ 1675.024273] Out of memory: Kill process 6884 (sshd) score 0 or sacrifice child
[ 1675.024277] Killed process 6884 (sshd) total-vm:140880kB, anon-rss:72kB, file-rss:392kB, shmem-rss:0kB
[ 1675.164645] Out of memory: Kill process 2911 (master) score 0 or sacrifice child
[ 1675.164649] Killed process 2962 (pickup) total-vm:91172kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1675.279862] Out of memory: Kill process 2911 (master) score 0 or sacrifice child
[ 1675.279868] Killed process 2964 (qmgr) total-vm:91240kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1675.312553] Out of memory: Kill process 2911 (master) score 0 or sacrifice child
[ 1675.312557] Killed process 2911 (master) total-vm:91068kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.324703] oom_reaper: reaped process 2911 (master), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.344082] Out of memory: Kill process 7132 (crond) score 0 or sacrifice child
[ 1675.344085] Killed process 7132 (crond) total-vm:173976kB, anon-rss:8kB, file-rss:8kB, shmem-rss:0kB
[ 1675.364659] oom_reaper: reaped process 7132 (crond), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.379700] Out of memory: Kill process 3375 (crond) score 0 or sacrifice child
[ 1675.379703] Killed process 3375 (crond) total-vm:126228kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.384637] oom_reaper: reaped process 3375 (crond), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.386673] Out of memory: Kill process 1163 (gssproxy) score 0 or sacrifice child
[ 1675.386688] Killed process 1163 (gssproxy) total-vm:201220kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.414656] oom_reaper: reaped process 1163 (gssproxy), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.423152] Out of memory: Kill process 1128 (irqbalance) score 0 or sacrifice child
[ 1675.423160] Killed process 1128 (irqbalance) total-vm:19556kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.450098] Out of memory: Kill process 1135 (smartd) score 0 or sacrifice child
[ 1675.450105] Killed process 1135 (smartd) total-vm:127876kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1675.486825] Out of memory: Kill process 774 (systemd-journal) score 0 or sacrifice child
[ 1675.486829] Killed process 774 (systemd-journal) total-vm:36824kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.494692] oom_reaper: reaped process 774 (systemd-journal), now anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
[ 1675.519331] Out of memory: Kill process 1133 (systemd-logind) score 0 or sacrifice child
[ 1675.519334] Killed process 1133 (systemd-logind) total-vm:24200kB, anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
[ 1675.537965] Out of memory: Kill process 1250 (opensm-launch) score 0 or sacrifice child
[ 1675.537969] Killed process 1250 (opensm-launch) total-vm:115252kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.562480] Out of memory: Kill process 1161 (chronyd) score 0 or sacrifice child
[ 1675.562484] Killed process 1161 (chronyd) total-vm:22688kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.590406] Out of memory: Kill process 1230 (ksmtuned) score 0 or sacrifice child
[ 1675.590412] Killed process 7042 (sleep) total-vm:107904kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.603676] Out of memory: Kill process 1230 (ksmtuned) score 0 or sacrifice child
[ 1675.603680] Killed process 1230 (ksmtuned) total-vm:115256kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.604062] oom_reaper: reaped process 1230 (ksmtuned), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.627746] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 1675.627752] Killed process 3340 (dnsmasq) total-vm:15524kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.637272] Out of memory: Kill process 3339 (dnsmasq) score 0 or sacrifice child
[ 1675.637275] Killed process 3339 (dnsmasq) total-vm:15552kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.673593] Out of memory: Kill process 2016 (atd) score 0 or sacrifice child
[ 1675.673598] Killed process 2016 (atd) total-vm:25852kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.702964] Out of memory: Kill process 1127 (lsmd) score 0 or sacrifice child
[ 1675.702970] Killed process 1127 (lsmd) total-vm:8532kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.753340] Out of memory: Kill process 7143 (systemd-cgroups) score 0 or sacrifice child
[ 1675.753343] Killed process 7143 (systemd-cgroups) total-vm:10564kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.772994] Out of memory: Kill process 1979 (rhsmcertd) score 0 or sacrifice child
[ 1675.773002] Killed process 1979 (rhsmcertd) total-vm:113348kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1675.793134] Out of memory: Kill process 7146 (systemd-cgroups) score 0 or sacrifice child
[ 1675.793138] Killed process 7146 (systemd-cgroups) total-vm:10620kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.813095] Out of memory: Kill process 2263 (agetty) score 0 or sacrifice child
[ 1675.813100] Killed process 2263 (agetty) total-vm:110044kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[ 1675.835563] Out of memory: Kill process 7139 (systemd-cgroups) score 0 or sacrifice child
[ 1675.835568] Killed process 7139 (systemd-cgroups) total-vm:10564kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.891427] Out of memory: Kill process 7148 (systemd-cgroups) score 0 or sacrifice child
[ 1675.891430] Killed process 7148 (systemd-cgroups) total-vm:10564kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1675.922733] Out of memory: Kill process 7153 (systemd-cgroups) score 0 or sacrifice child
[ 1675.922736] Killed process 7153 (systemd-cgroups) total-vm:10564kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1676.114613] oom_reaper: reaped process 7153 (systemd-cgroups), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1676.151173] Out of memory: Kill process 7135 (systemd-cgroups) score 0 or sacrifice child
[ 1676.151177] Killed process 7135 (systemd-cgroups) total-vm:10696kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1676.269304] Out of memory: Kill process 7144 (systemd-cgroups) score 0 or sacrifice child
[ 1676.269307] Killed process 7144 (systemd-cgroups) total-vm:10564kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1676.654606] oom_reaper: reaped process 7144 (systemd-cgroups), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1679.284408] nvmet: ctrl 931 keep-alive timer (15 seconds) expired!
[ 1679.284410] nvmet: ctrl 931 fatal error occurred!
[ 1680.224351] nvmet: ctrl 932 keep-alive timer (15 seconds) expired!
[ 1680.224353] nvmet: ctrl 932 fatal error occurred!
[ 1680.224372] nvmet: ctrl 934 keep-alive timer (15 seconds) expired!
[ 1680.224374] nvmet: ctrl 934 fatal error occurred!
[ 1683.364230] nvmet: ctrl 950 keep-alive timer (15 seconds) expired!
[ 1683.364232] nvmet: ctrl 950 fatal error occurred!
[ 1684.374195] nvmet: ctrl 954 keep-alive timer (15 seconds) expired!
[ 1684.374197] nvmet: ctrl 954 fatal error occurred!
[ 1685.964134] nvmet: ctrl 962 keep-alive timer (15 seconds) expired!
[ 1685.964136] nvmet: ctrl 962 fatal error occurred!
[ 1687.934043] nvmet: ctrl 969 keep-alive timer (15 seconds) expired!
[ 1687.934045] nvmet: ctrl 969 fatal error occurred!
[ 1687.934692] nvmet_rdma: freeing queue 16456
[ 1725.052499] INFO: task kworker/0:0:3 blocked for more than 120 seconds.
[ 1725.052501]       Not tainted 4.10.0 #5
[ 1725.052501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052502] kworker/0:0     D    0     3      2 0x00000000
[ 1725.052508] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052510] Call Trace:
[ 1725.052514]  __schedule+0x21c/0x6b0
[ 1725.052529]  ? sched_clock+0x9/0x10
[ 1725.052530]  schedule+0x36/0x80
[ 1725.052532]  schedule_timeout+0x249/0x300
[ 1725.052533]  wait_for_completion+0x11c/0x180
[ 1725.052535]  ? wake_up_q+0x80/0x80
[ 1725.052548]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052550]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052551]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052554]  process_one_work+0x165/0x410
[ 1725.052555]  worker_thread+0x137/0x4c0
[ 1725.052556]  kthread+0x101/0x140
[ 1725.052557]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052558]  ? kthread_park+0x90/0x90
[ 1725.052560]  ret_from_fork+0x2c/0x40
[ 1725.052566] INFO: task kworker/17:0:115 blocked for more than 120 seconds.
[ 1725.052567]       Not tainted 4.10.0 #5
[ 1725.052567] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052567] kworker/17:0    D    0   115      2 0x00000000
[ 1725.052570] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052570] Call Trace:
[ 1725.052572]  __schedule+0x21c/0x6b0
[ 1725.052573]  ? sched_clock+0x9/0x10
[ 1725.052574]  schedule+0x36/0x80
[ 1725.052575]  schedule_timeout+0x249/0x300
[ 1725.052576]  wait_for_completion+0x11c/0x180
[ 1725.052578]  ? wake_up_q+0x80/0x80
[ 1725.052591]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052593]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052594]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052595]  process_one_work+0x165/0x410
[ 1725.052596]  worker_thread+0x137/0x4c0
[ 1725.052597]  kthread+0x101/0x140
[ 1725.052598]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052599]  ? kthread_park+0x90/0x90
[ 1725.052600]  ret_from_fork+0x2c/0x40
[ 1725.052610] INFO: task kworker/1:1:205 blocked for more than 120 seconds.
[ 1725.052610]       Not tainted 4.10.0 #5
[ 1725.052611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052611] kworker/1:1     D    0   205      2 0x00000000
[ 1725.052613] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052613] Call Trace:
[ 1725.052615]  __schedule+0x21c/0x6b0
[ 1725.052616]  ? sched_clock+0x9/0x10
[ 1725.052617]  schedule+0x36/0x80
[ 1725.052618]  schedule_timeout+0x249/0x300
[ 1725.052619]  wait_for_completion+0x11c/0x180
[ 1725.052620]  ? wake_up_q+0x80/0x80
[ 1725.052621]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052623]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052624]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052625]  process_one_work+0x165/0x410
[ 1725.052626]  worker_thread+0x137/0x4c0
[ 1725.052627]  kthread+0x101/0x140
[ 1725.052628]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052629]  ? kthread_park+0x90/0x90
[ 1725.052630]  ret_from_fork+0x2c/0x40
[ 1725.052633] INFO: task kworker/20:1:291 blocked for more than 120 seconds.
[ 1725.052633]       Not tainted 4.10.0 #5
[ 1725.052633] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052634] kworker/20:1    D    0   291      2 0x00000000
[ 1725.052635] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052636] Call Trace:
[ 1725.052637]  __schedule+0x21c/0x6b0
[ 1725.052638]  ? sched_clock+0x9/0x10
[ 1725.052639]  schedule+0x36/0x80
[ 1725.052640]  schedule_timeout+0x249/0x300
[ 1725.052641]  wait_for_completion+0x11c/0x180
[ 1725.052642]  ? wake_up_q+0x80/0x80
[ 1725.052644]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052645]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052647]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052648]  process_one_work+0x165/0x410
[ 1725.052649]  worker_thread+0x137/0x4c0
[ 1725.052650]  kthread+0x101/0x140
[ 1725.052651]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052651]  ? kthread_park+0x90/0x90
[ 1725.052653]  ret_from_fork+0x2c/0x40
[ 1725.052654] INFO: task kworker/3:1:296 blocked for more than 120 seconds.
[ 1725.052654]       Not tainted 4.10.0 #5
[ 1725.052655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052655] kworker/3:1     D    0   296      2 0x00000000
[ 1725.052657] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052657] Call Trace:
[ 1725.052659]  __schedule+0x21c/0x6b0
[ 1725.052660]  ? sched_clock+0x9/0x10
[ 1725.052660]  schedule+0x36/0x80
[ 1725.052661]  schedule_timeout+0x249/0x300
[ 1725.052663]  wait_for_completion+0x11c/0x180
[ 1725.052664]  ? wake_up_q+0x80/0x80
[ 1725.052665]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052667]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052668]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052669]  process_one_work+0x165/0x410
[ 1725.052670]  worker_thread+0x137/0x4c0
[ 1725.052671]  kthread+0x101/0x140
[ 1725.052672]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052672]  ? kthread_park+0x90/0x90
[ 1725.052674]  ret_from_fork+0x2c/0x40
[ 1725.052675] INFO: task kworker/21:1:315 blocked for more than 120 seconds.
[ 1725.052675]       Not tainted 4.10.0 #5
[ 1725.052676] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052676] kworker/21:1    D    0   315      2 0x00000000
[ 1725.052678] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052678] Call Trace:
[ 1725.052679]  __schedule+0x21c/0x6b0
[ 1725.052680]  ? sched_clock+0x9/0x10
[ 1725.052681]  schedule+0x36/0x80
[ 1725.052682]  schedule_timeout+0x249/0x300
[ 1725.052683]  wait_for_completion+0x11c/0x180
[ 1725.052684]  ? wake_up_q+0x80/0x80
[ 1725.052686]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052687]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052688]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052689]  process_one_work+0x165/0x410
[ 1725.052691]  worker_thread+0x137/0x4c0
[ 1725.052691]  kthread+0x101/0x140
[ 1725.052692]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052693]  ? kthread_park+0x90/0x90
[ 1725.052694]  ret_from_fork+0x2c/0x40
[ 1725.052695] INFO: task kworker/6:1:327 blocked for more than 120 seconds.
[ 1725.052696]       Not tainted 4.10.0 #5
[ 1725.052696] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052696] kworker/6:1     D    0   327      2 0x00000000
[ 1725.052698] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052699] Call Trace:
[ 1725.052700]  __schedule+0x21c/0x6b0
[ 1725.052701]  ? sched_clock+0x9/0x10
[ 1725.052702]  schedule+0x36/0x80
[ 1725.052703]  schedule_timeout+0x249/0x300
[ 1725.052704]  wait_for_completion+0x11c/0x180
[ 1725.052705]  ? wake_up_q+0x80/0x80
[ 1725.052706]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052708]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052709]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052710]  process_one_work+0x165/0x410
[ 1725.052711]  worker_thread+0x137/0x4c0
[ 1725.052712]  kthread+0x101/0x140
[ 1725.052713]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052714]  ? kthread_park+0x90/0x90
[ 1725.052715]  ret_from_fork+0x2c/0x40
[ 1725.052716] INFO: task kworker/18:1:331 blocked for more than 120 seconds.
[ 1725.052716]       Not tainted 4.10.0 #5
[ 1725.052717] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052717] kworker/18:1    D    0   331      2 0x00000000
[ 1725.052719] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052719] Call Trace:
[ 1725.052721]  __schedule+0x21c/0x6b0
[ 1725.052722]  ? sched_clock+0x9/0x10
[ 1725.052722]  schedule+0x36/0x80
[ 1725.052723]  schedule_timeout+0x249/0x300
[ 1725.052725]  wait_for_completion+0x11c/0x180
[ 1725.052726]  ? wake_up_q+0x80/0x80
[ 1725.052727]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052728]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052730]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052731]  process_one_work+0x165/0x410
[ 1725.052732]  worker_thread+0x137/0x4c0
[ 1725.052733]  kthread+0x101/0x140
[ 1725.052734]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052735]  ? kthread_park+0x90/0x90
[ 1725.052736]  ret_from_fork+0x2c/0x40
[ 1725.052737] INFO: task kworker/0:3:356 blocked for more than 120 seconds.
[ 1725.052738]       Not tainted 4.10.0 #5
[ 1725.052738] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052738] kworker/0:3     D    0   356      2 0x00000000
[ 1725.052740] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052741] Call Trace:
[ 1725.052742]  __schedule+0x21c/0x6b0
[ 1725.052743]  ? sched_clock+0x9/0x10
[ 1725.052744]  schedule+0x36/0x80
[ 1725.052745]  schedule_timeout+0x249/0x300
[ 1725.052746]  wait_for_completion+0x11c/0x180
[ 1725.052747]  ? wake_up_q+0x80/0x80
[ 1725.052748]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052750]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052751]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052752]  process_one_work+0x165/0x410
[ 1725.052753]  worker_thread+0x137/0x4c0
[ 1725.052754]  kthread+0x101/0x140
[ 1725.052755]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052756]  ? kthread_park+0x90/0x90
[ 1725.052757]  ret_from_fork+0x2c/0x40
[ 1725.052758] INFO: task kworker/4:1:361 blocked for more than 120 seconds.
[ 1725.052758]       Not tainted 4.10.0 #5
[ 1725.052759] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1725.052759] kworker/4:1     D    0   361      2 0x00000000
[ 1725.052761] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.052761] Call Trace:
[ 1725.052762]  __schedule+0x21c/0x6b0
[ 1725.052763]  ? sched_clock+0x9/0x10
[ 1725.052764]  schedule+0x36/0x80
[ 1725.052765]  schedule_timeout+0x249/0x300
[ 1725.052766]  wait_for_completion+0x11c/0x180
[ 1725.052767]  ? wake_up_q+0x80/0x80
[ 1725.052769]  nvmet_sq_destroy+0x41/0xd0 [nvmet]
[ 1725.052770]  nvmet_rdma_free_queue+0x2a/0xa0 [nvmet_rdma]
[ 1725.052771]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.052772]  process_one_work+0x165/0x410
[ 1725.052773]  worker_thread+0x137/0x4c0
[ 1725.052774]  kthread+0x101/0x140
[ 1725.052775]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.052776]  ? kthread_park+0x90/0x90
[ 1725.052777]  ret_from_fork+0x2c/0x40
[ 1725.593635] INFO: rcu_sched self-detected stall on CPU
[ 1725.593637] 	19-...: (9252 ticks this GP) idle=9dd/140000000000001/0 softirq=8820/8820 fqs=8761 
[ 1725.593637] 	 (t=24042 jiffies g=24278 c=24277 q=954530)
[ 1725.593642] Task dump for CPU 19:
[ 1725.593642] kworker/19:1    R  running task        0   377      2 0x00000008
[ 1725.593646] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1725.593646] Call Trace:
[ 1725.593647]  <IRQ>
[ 1725.593650]  sched_show_task+0xd7/0x140
[ 1725.593651]  dump_cpu_task+0x39/0x40
[ 1725.593653]  rcu_dump_cpu_stacks+0x85/0xc3
[ 1725.593656]  rcu_check_callbacks+0x79f/0x900
[ 1725.593659]  ? tick_sched_do_timer+0x70/0x70
[ 1725.593660]  update_process_times+0x2f/0x60
[ 1725.593662]  tick_sched_handle.isra.18+0x25/0x60
[ 1725.593662]  tick_sched_timer+0x3d/0x70
[ 1725.593664]  __hrtimer_run_queues+0xe5/0x250
[ 1725.593665]  hrtimer_interrupt+0xa8/0x1a0
[ 1725.593667]  local_apic_timer_interrupt+0x35/0x60
[ 1725.593669]  smp_apic_timer_interrupt+0x38/0x50
[ 1725.593670]  apic_timer_interrupt+0x93/0xa0
[ 1725.593672] RIP: 0010:console_unlock+0x236/0x490
[ 1725.593673] RSP: 0018:ffffc9000512bce0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[ 1725.593674] RAX: 0000000000000000 RBX: 0000000000000033 RCX: 0000000000000000
[ 1725.593674] RDX: 00000000000002f9 RSI: 0000000000000046 RDI: 0000000000000246
[ 1725.593675] RBP: ffffc9000512bd20 R08: 00000000fffffffe R09: 0000000000000000
[ 1725.593675] R10: 0000000000000004 R11: 00000000000031a5 R12: 0000000000000400
[ 1725.593676] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000033
[ 1725.593676]  </IRQ>
[ 1725.593678]  vprintk_emit+0x2eb/0x490
[ 1725.593679]  vprintk_default+0x29/0x50
[ 1725.593681]  printk+0x5d/0x74
[ 1725.593682]  nvmet_rdma_free_queue+0x21/0xa0 [nvmet_rdma]
[ 1725.593683]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1725.593685]  process_one_work+0x165/0x410
[ 1725.593686]  worker_thread+0x137/0x4c0
[ 1725.593687]  kthread+0x101/0x140
[ 1725.593688]  ? rescuer_thread+0x3b0/0x3b0
[ 1725.593689]  ? kthread_park+0x90/0x90
[ 1725.593690]  ret_from_fork+0x2c/0x40
[ 1806.046925] INFO: rcu_bh self-detected stall on CPU
[ 1806.046927] 	19-...: (1 GPs behind) idle=9dd/140000000000001/0 softirq=8276/8820 fqs=5639 
[ 1806.046927] 	 (t=24008 jiffies g=-278 c=-279 q=6)
[ 1806.046931] Task dump for CPU 19:
[ 1806.046932] kworker/19:1    R  running task        0   377      2 0x00000008
[ 1806.046935] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1806.046936] Call Trace:
[ 1806.046936]  <IRQ>
[ 1806.046938]  sched_show_task+0xd7/0x140
[ 1806.046940]  dump_cpu_task+0x39/0x40
[ 1806.046942]  rcu_dump_cpu_stacks+0x85/0xc3
[ 1806.046944]  rcu_check_callbacks+0x79f/0x900
[ 1806.046946]  ? tick_sched_do_timer+0x70/0x70
[ 1806.046947]  update_process_times+0x2f/0x60
[ 1806.046949]  tick_sched_handle.isra.18+0x25/0x60
[ 1806.046949]  tick_sched_timer+0x3d/0x70
[ 1806.046951]  __hrtimer_run_queues+0xe5/0x250
[ 1806.046952]  hrtimer_interrupt+0xa8/0x1a0
[ 1806.046954]  local_apic_timer_interrupt+0x35/0x60
[ 1806.046955]  smp_apic_timer_interrupt+0x38/0x50
[ 1806.046956]  apic_timer_interrupt+0x93/0xa0
[ 1806.046957] RIP: 0010:console_unlock+0x236/0x490
[ 1806.046958] RSP: 0018:ffffc9000512bce0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[ 1806.046959] RAX: 0000000000000000 RBX: 0000000000000033 RCX: 0000000000000000
[ 1806.046960] RDX: 00000000000002f9 RSI: 0000000000000046 RDI: 0000000000000246
[ 1806.046960] RBP: ffffc9000512bd20 R08: 00000000fffffffe R09: 0000000000000000
[ 1806.046961] R10: 0000000000000005 R11: 000000000000421a R12: 0000000000000400
[ 1806.046961] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000033
[ 1806.046962]  </IRQ>
[ 1806.046963]  vprintk_emit+0x2eb/0x490
[ 1806.046964]  vprintk_default+0x29/0x50
[ 1806.046966]  printk+0x5d/0x74
[ 1806.046967]  nvmet_rdma_free_queue+0x21/0xa0 [nvmet_rdma]
[ 1806.046968]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1806.046970]  process_one_work+0x165/0x410
[ 1806.046971]  worker_thread+0x137/0x4c0
[ 1806.046972]  kthread+0x101/0x140
[ 1806.046973]  ? rescuer_thread+0x3b0/0x3b0
[ 1806.046974]  ? kthread_park+0x90/0x90
[ 1806.046975]  ret_from_fork+0x2c/0x40
[ 1905.846591] INFO: rcu_sched self-detected stall on CPU
[ 1905.846593] 	19-...: (11109 ticks this GP) idle=9dd/140000000000001/0 softirq=8820/8820 fqs=9831 
[ 1905.846594] 	 (t=42068 jiffies g=24278 c=24277 q=954931)
[ 1905.846597] Task dump for CPU 19:
[ 1905.846598] kworker/19:1    R  running task        0   377      2 0x00000008
[ 1905.846601] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[ 1905.846602] Call Trace:
[ 1905.846602]  <IRQ>
[ 1905.846604]  sched_show_task+0xd7/0x140
[ 1905.846606]  dump_cpu_task+0x39/0x40
[ 1905.846607]  rcu_dump_cpu_stacks+0x85/0xc3
[ 1905.846609]  rcu_check_callbacks+0x79f/0x900
[ 1905.846611]  ? tick_sched_do_timer+0x70/0x70
[ 1905.846612]  update_process_times+0x2f/0x60
[ 1905.846614]  tick_sched_handle.isra.18+0x25/0x60
[ 1905.846615]  tick_sched_timer+0x3d/0x70
[ 1905.846616]  __hrtimer_run_queues+0xe5/0x250
[ 1905.846617]  hrtimer_interrupt+0xa8/0x1a0
[ 1905.846619]  local_apic_timer_interrupt+0x35/0x60
[ 1905.846620]  smp_apic_timer_interrupt+0x38/0x50
[ 1905.846621]  apic_timer_interrupt+0x93/0xa0
[ 1905.846623] RIP: 0010:console_unlock+0x236/0x490
[ 1905.846623] RSP: 0018:ffffc9000512bce0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[ 1905.846624] RAX: 0000000000000000 RBX: 0000000000000063 RCX: 0000000000000000
[ 1905.846625] RDX: 00000000000002f9 RSI: 0000000000000046 RDI: 0000000000000246
[ 1905.846625] RBP: ffffc9000512bd20 R08: 00000000fffffffe R09: 0000000000000000
[ 1905.846626] R10: 0000000000000005 R11: 0000000000005553 R12: 0000000000000400
[ 1905.846627] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000063
[ 1905.846627]  </IRQ>
[ 1905.846629]  vprintk_emit+0x2eb/0x490
[ 1905.846630]  vprintk_default+0x29/0x50
[ 1905.846631]  printk+0x5d/0x74
[ 1905.846633]  nvmet_rdma_free_queue+0x21/0xa0 [nvmet_rdma]
[ 1905.846634]  nvmet_rdma_release_queue_work+0x25/0x60 [nvmet_rdma]
[ 1905.846635]  process_one_work+0x165/0x410
[ 1905.846637]  worker_thread+0x137/0x4c0
[ 1905.846638]  kthread+0x101/0x140
[ 1905.846639]  ? rescuer_thread+0x3b0/0x3b0
[ 1905.846639]  ? kthread_park+0x90/0x90
[ 1905.846641]  ret_from_fork+0x2c/0x40
[ 1948.045459] clocksource: timekeeping watchdog on CPU19: Marking clocksource 'tsc' as unstable because the skew is too large:
[ 1948.045460] clocksource:                       'hpet' wd_now: 7e952960 wd_last: fb3302a5 mask: ffffffff
[ 1948.045461] clocksource:                       'tsc' cs_now: d34b7f48730 cs_last: c37af34df4d mask: ffffffffffffffff
[ 1948.449157] clocksource: Switched to clocksource hpet
[ 1948.449164] nvmet_rdma: freeing queue 3
[ 1948.450107] nvmet_rdma: freeing queue 4
[ 1948.450497] nvmet_rdma: freeing queue 5
[ 1948.450974] nvmet_rdma: freeing queue 6
[ 1948.473709] oom_kill_process: 35 callbacks suppressed
[ 1948.475434] systemd-cgroups invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), nodemask=0-1, order=0, oom_score_adj=0
[ 1948.479480] systemd-cgroups cpuset=/ mems_allowed=0-1
[ 1948.481161] CPU: 18 PID: 7154 Comm: systemd-cgroups Not tainted 4.10.0 #5
[ 1948.483348] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[ 1948.485447] Call Trace:
[ 1948.486232]  dump_stack+0x63/0x87
[ 1948.487279]  dump_header+0x82/0x212
[ 1948.488380]  ? _raw_spin_unlock_irqrestore+0x15/0x20
[ 1948.489950]  oom_kill_process+0x21c/0x3f0
[ 1948.928137] nvmet_rdma: freeing queue 7
[ 1948.928319] nvmet_rdma: freeing queue 8
[ 1948.929574] nvmet_rdma: freeing queue 9
[ 1948.931206] nvmet_rdma: freeing queue 10
[ 1948.931367] nvmet_rdma: freeing queue 11
[ 1948.931456] nvmet_rdma: freeing queue 12
[ 1948.931569] nvmet_rdma: freeing queue 13
[ 1948.999773]  out_of_memory+0x117/0x4a0
[ 1949.001004]  __alloc_pages_slowpath+0x913/0xaf0
[ 1949.002565]  __alloc_pages_nodemask+0x223/0x2a0
[ 1949.004044]  alloc_pages_current+0x88/0x120
[ 1949.005438]  __page_cache_alloc+0xae/0xc0
[ 1949.006750]  filemap_fault+0x5cb/0x740
[ 1949.007989]  ? down_read+0x12/0x40
[ 1949.009146]  xfs_filemap_fault+0x60/0xf0 [xfs]
[ 1949.010623]  __do_fault+0x21/0x80
[ 1949.011759]  handle_mm_fault+0xc0f/0x1350
[ 1949.013078]  __do_page_fault+0x22a/0x4a0
[ 1949.014390]  do_page_fault+0x30/0x80
[ 1949.015566]  ? do_syscall_64+0x175/0x180
[ 1949.016847]  page_fault+0x28/0x30
[ 1949.017938] RIP: 0033:0x7fdfdf120960
[ 1949.019132] RSP: 002b:00007ffd8a67fd88 EFLAGS: 00010246
[ 1949.020849] RAX: 00007fdfdf46f680 RBX: 0000555c4c2b4010 RCX: 000000000000000a
[ 1949.023327] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000555c4c2b4010
[ 1949.025711] RBP: 000000000000000a R08: 0000000000000001 R09: 0000000000000000
[ 1949.028016] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 1949.030353] R13: 0000000000000000 R14: 0000555c4c2b4010 R15: 00000000000007ff
[ 1949.032847] Mem-Info:
[ 1949.033675] active_anon:98 inactive_anon:0 isolated_anon:0
 active_file:14 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:13 unstable:0
 slab_reclaimable:12263 slab_unreclaimable:821490
 mapped:0 shmem:0 pagetables:396 bounce:0
 free:40686 free_pcp:2076 free_cma:0
[ 1949.034959] nvmet_rdma: freeing queue 13808
[ 1949.036154] nvmet_rdma: freeing queue 13809
[ 1949.039354] nvmet_rdma: freeing queue 491
[ 1949.039356] nvmet_rdma: freeing queue 492
[ 1949.039358] nvmet_rdma: freeing queue 476
[ 1949.039362] nvmet_rdma: freeing queue 511
[ 1949.039363] nvmet_rdma: freeing queue 512
[ 1949.039365] nvmet_rdma: freeing queue 513
[ 1949.039366] nvmet_rdma: freeing queue 514
[ 1949.039369] nvmet_rdma: freeing queue 515
[ 1949.146963] nvmet_rdma: freeing queue 528
[ 1949.147531] nvmet_rdma: freeing queue 529
[ 1949.147769] nvmet_rdma: freeing queue 530
[ 1949.238166] nvmet_rdma: freeing queue 531
[ 1949.238169] nvmet_rdma: freeing queue 532
[ 1949.238386] nvmet_rdma: freeing queue 533
[ 1949.238389] nvmet_rdma: freeing queue 534
[ 1949.238438] nvmet_rdma: freeing queue 535
[ 1949.238615] nvmet_rdma: freeing queue 541
[ 1949.238807] nvmet_rdma: freeing queue 542
[ 1949.363279] nvmet_rdma: freeing queue 543
[ 1949.363282] nvmet_rdma: freeing queue 545
[ 1949.363283] nvmet_rdma: freeing queue 546
[ 1949.363284] nvmet_rdma: freeing queue 547
[ 1949.363286] nvmet_rdma: freeing queue 548
[ 1949.363287] nvmet_rdma: freeing queue 549
[ 1949.363288] nvmet_rdma: freeing queue 550
[ 1949.363290] nvmet_rdma: freeing queue 551
[ 1949.363291] nvmet_rdma: freeing queue 552
[ 1949.363292] nvmet_rdma: freeing queue 553
[ 1949.363293] nvmet_rdma: freeing queue 554
[ 1949.363295] nvmet_rdma: freeing queue 555
[ 1949.363296] nvmet_rdma: freeing queue 556
[ 1949.363297] nvmet_rdma: freeing queue 557
[ 1949.363298] nvmet_rdma: freeing queue 558
[ 1949.363299] nvmet_rdma: freeing queue 559
[ 1949.363301] nvmet_rdma: freeing queue 560
[ 1949.363302] nvmet_rdma: freeing queue 544
[ 1949.363306] nvmet_rdma: freeing queue 562
[ 1949.363307] nvmet_rdma: freeing queue 563
[ 1949.363308] nvmet_rdma: freeing queue 564
[ 1949.363310] nvmet_rdma: freeing queue 579
[ 1949.363311] nvmet_rdma: freeing queue 580
[ 1949.363313] nvmet_rdma: freeing queue 581
[ 1949.363314] nvmet_rdma: freeing queue 582
[ 1949.363315] nvmet_rdma: freeing queue 583
[ 1949.363316] nvmet_rdma: freeing queue 584
[ 1949.363318] nvmet_rdma: freeing queue 585
[ 1949.363319] nvmet_rdma: freeing queue 586
[ 1949.363321] nvmet_rdma: freeing queue 587
[ 1949.363322] nvmet_rdma: freeing queue 588
[ 1949.363390] nvmet_rdma: freeing queue 589
[ 1949.363602] nvmet_rdma: freeing queue 590
[ 1949.363604] nvmet_rdma: freeing queue 591
[ 1949.363823] nvmet_rdma: freeing queue 592
[ 1949.363825] nvmet_rdma: freeing queue 593
[ 1949.364095] nvmet_rdma: freeing queue 594
[ 1949.364423] nvmet_rdma: freeing queue 578
[ 1949.364427] nvmet_rdma: freeing queue 596
[ 1949.364428] nvmet_rdma: freeing queue 597
[ 1949.364644] nvmet_rdma: freeing queue 598
[ 1949.364843] nvmet_rdma: freeing queue 599
[ 1949.364903] nvmet_rdma: freeing queue 600
[ 1949.365087] nvmet_rdma: freeing queue 605
[ 1949.365277] nvmet_rdma: freeing queue 606
[ 1949.365279] nvmet_rdma: freeing queue 607
[ 1949.365482] nvmet_rdma: freeing queue 608
[ 1949.365647] nvmet_rdma: freeing queue 609
[ 1949.365847] nvmet_rdma: freeing queue 610
[ 1949.365848] nvmet_rdma: freeing queue 611
[ 1949.365899] nvmet_rdma: freeing queue 595
[ 1949.366050] nvmet_rdma: freeing queue 613
[ 1949.366123] nvmet_rdma: freeing queue 614
[ 1949.366284] nvmet_rdma: freeing queue 615
[ 1949.366341] nvmet_rdma: freeing queue 616
[ 1949.366533] nvmet_rdma: freeing queue 617
[ 1949.366604] nvmet_rdma: freeing queue 619
[ 1949.366760] nvmet_rdma: freeing queue 620
[ 1949.366932] nvmet_rdma: freeing queue 621
[ 1949.367087] nvmet_rdma: freeing queue 622
[ 1949.367161] nvmet_rdma: freeing queue 623
[ 1949.367333] nvmet_rdma: freeing queue 624
[ 1949.367566] nvmet_rdma: freeing queue 625
[ 1949.367608] nvmet_rdma: freeing queue 626
[ 1949.367934] nvmet_rdma: freeing queue 627
[ 1949.367936] nvmet_rdma: freeing queue 628
[ 1949.368044] nvmet_rdma: freeing queue 612
[ 1949.368127] nvmet_rdma: freeing queue 632
[ 1949.368206] nvmet_rdma: freeing queue 633
[ 1949.368375] nvmet_rdma: freeing queue 634
[ 1949.368449] nvmet_rdma: freeing queue 635
[ 1949.368712] nvmet_rdma: freeing queue 636
[ 1949.368713] nvmet_rdma: freeing queue 637
[ 1949.368763] nvmet_rdma: freeing queue 638
[ 1949.368935] nvmet_rdma: freeing queue 639
[ 1949.368984] nvmet_rdma: freeing queue 640
[ 1949.369178] nvmet_rdma: freeing queue 641
[ 1949.369245] nvmet_rdma: freeing queue 642
[ 1949.369320] nvmet_rdma: freeing queue 643
[ 1949.369500] nvmet_rdma: freeing queue 644
[ 1949.369575] nvmet_rdma: freeing queue 645
[ 1949.369736] nvmet_rdma: freeing queue 629
[ 1949.369825] nvmet_rdma: freeing queue 647
[ 1949.369909] nvmet_rdma: freeing queue 648
[ 1949.370055] nvmet_rdma: freeing queue 649
[ 1949.370132] nvmet_rdma: freeing queue 650
[ 1949.370295] nvmet_rdma: freeing queue 651
[ 1949.370381] nvmet_rdma: freeing queue 655
[ 1949.370468] nvmet_rdma: freeing queue 656
[ 1949.370609] nvmet_rdma: freeing queue 657
[ 1949.370692] nvmet_rdma: freeing queue 658
[ 1949.370863] nvmet_rdma: freeing queue 659
[ 1949.370945] nvmet_rdma: freeing queue 660
[ 1949.371036] nvmet_rdma: freeing queue 661
[ 1949.371174] nvmet_rdma: freeing queue 662
[ 1949.371252] nvmet_rdma: freeing queue 646
[ 1949.371364] nvmet_rdma: freeing queue 664
[ 1949.371508] nvmet_rdma: freeing queue 665
[ 1949.371584] nvmet_rdma: freeing queue 666
[ 1949.371737] nvmet_rdma: freeing queue 667
[ 1949.371828] nvmet_rdma: freeing queue 668
[ 1949.372073] nvmet_rdma: freeing queue 679
[ 1949.372211] nvmet_rdma: freeing queue 663
[ 1949.372286] nvmet_rdma: freeing queue 681
[ 1949.372470] nvmet_rdma: freeing queue 682
[ 1949.372545] nvmet_rdma: freeing queue 684
[ 1949.372625] nvmet_rdma: freeing queue 685
[ 1949.372782] nvmet_rdma: freeing queue 686
[ 1949.372880] nvmet_rdma: freeing queue 687
[ 1949.372957] nvmet_rdma: freeing queue 688
[ 1949.373230] nvmet_rdma: freeing queue 689
[ 1949.373232] nvmet_rdma: freeing queue 690
[ 1949.373392] nvmet_rdma: freeing queue 691
[ 1949.373469] nvmet_rdma: freeing queue 692
[ 1949.373563] nvmet_rdma: freeing queue 693
[ 1949.373699] nvmet_rdma: freeing queue 694
[ 1949.373776] nvmet_rdma: freeing queue 695
[ 1949.373876] nvmet_rdma: freeing queue 696
[ 1949.374025] nvmet_rdma: freeing queue 680
[ 1949.374104] nvmet_rdma: freeing queue 698
[ 1949.374260] nvmet_rdma: freeing queue 699
[ 1949.374361] nvmet_rdma: freeing queue 700
[ 1949.374439] nvmet_rdma: freeing queue 701
[ 1949.374590] nvmet_rdma: freeing queue 702
[ 1949.374665] nvmet_rdma: freeing queue 703
[ 1949.374833] nvmet_rdma: freeing queue 704
[ 1949.374908] nvmet_rdma: freeing queue 705
[ 1949.374982] nvmet_rdma: freeing queue 706
[ 1949.375140] nvmet_rdma: freeing queue 707
[ 1949.375213] nvmet_rdma: freeing queue 708
[ 1949.375383] nvmet_rdma: freeing queue 709
[ 1949.375462] nvmet_rdma: freeing queue 710
[ 1949.375608] nvmet_rdma: freeing queue 713
[ 1949.375692] nvmet_rdma: freeing queue 697
[ 1949.375965] nvmet_rdma: freeing queue 715
[ 1949.375967] nvmet_rdma: freeing queue 716
[ 1949.376019] nvmet_rdma: freeing queue 717
[ 1949.376188] nvmet_rdma: freeing queue 718
[ 1949.376251] nvmet_rdma: freeing queue 724
[ 1949.376355] nvmet_rdma: freeing queue 725
[ 1949.376500] nvmet_rdma: freeing queue 726
[ 1949.376578] nvmet_rdma: freeing queue 727
[ 1949.376728] nvmet_rdma: freeing queue 728
[ 1949.376823] nvmet_rdma: freeing queue 729
[ 1949.377060] nvmet_rdma: freeing queue 730
[ 1949.377202] nvmet_rdma: freeing queue 714
[ 1949.377283] nvmet_rdma: freeing queue 732
[ 1949.377384] nvmet_rdma: freeing queue 733
[ 1949.377523] nvmet_rdma: freeing queue 734
[ 1949.377669] nvmet_rdma: freeing queue 735
[ 1949.377743] nvmet_rdma: freeing queue 736
[ 1949.377854] nvmet_rdma: freeing queue 737
[ 1949.378418] nvmet_rdma: freeing queue 738
[ 1949.378719] nvmet_rdma: freeing queue 739
[ 1949.378792] nvmet_rdma: freeing queue 740
[ 1949.378891] nvmet_rdma: freeing queue 741
[ 1949.378971] nvmet_rdma: freeing queue 742
[ 1949.379048] nvmet_rdma: freeing queue 743
[ 1949.379318] nvmet_rdma: freeing queue 744
[ 1949.379320] nvmet_rdma: freeing queue 745
[ 1949.379380] nvmet_rdma: freeing queue 747
[ 1949.379520] nvmet_rdma: freeing queue 731
[ 1949.379596] nvmet_rdma: freeing queue 749
[ 1949.379753] nvmet_rdma: freeing queue 750
[ 1949.379845] nvmet_rdma: freeing queue 751
[ 1949.379925] nvmet_rdma: freeing queue 752
[ 1949.380075] nvmet_rdma: freeing queue 756
[ 1949.380149] nvmet_rdma: freeing queue 757
[ 1949.380326] nvmet_rdma: freeing queue 758
[ 1949.380402] nvmet_rdma: freeing queue 759
[ 1949.380552] nvmet_rdma: freeing queue 760
[ 1949.380632] nvmet_rdma: freeing queue 761
[ 1949.380876] nvmet_rdma: freeing queue 762
[ 1949.380977] nvmet_rdma: freeing queue 763
[ 1949.380979] nvmet_rdma: freeing queue 764
[ 1949.381105] nvmet_rdma: freeing queue 748
[ 1949.381182] nvmet_rdma: freeing queue 766
[ 1949.381366] nvmet_rdma: freeing queue 767
[ 1949.381434] nvmet_rdma: freeing queue 768
[ 1949.381517] nvmet_rdma: freeing queue 769
[ 1949.381666] nvmet_rdma: freeing queue 770
[ 1949.381737] nvmet_rdma: freeing queue 771
[ 1949.382002] nvmet_rdma: freeing queue 772
[ 1949.382918] nvmet_rdma: freeing queue 783
[ 1949.382920] nvmet_rdma: freeing queue 784
[ 1949.382921] nvmet_rdma: freeing queue 785
[ 1949.382922] nvmet_rdma: freeing queue 786
[ 1949.383044] nvmet_rdma: freeing queue 787
[ 1949.383127] nvmet_rdma: freeing queue 788
[ 1949.383286] nvmet_rdma: freeing queue 789
[ 1949.383465] nvmet_rdma: freeing queue 790
[ 1949.383619] nvmet_rdma: freeing queue 791
[ 1949.383700] nvmet_rdma: freeing queue 792
[ 1949.383840] nvmet_rdma: freeing queue 793
[ 1949.384082] nvmet_rdma: freeing queue 794
[ 1949.384084] nvmet_rdma: freeing queue 795
[ 1949.384357] nvmet_rdma: freeing queue 796
[ 1949.384437] nvmet_rdma: freeing queue 797
[ 1949.385005] nvmet_rdma: freeing queue 798
[ 1949.385091] nvmet_rdma: freeing queue 782
[ 1949.385254] nvmet_rdma: freeing queue 800
[ 1949.385520] nvmet_rdma: freeing queue 801
[ 1949.385595] nvmet_rdma: freeing queue 802
[ 1949.385750] nvmet_rdma: freeing queue 803
[ 1949.385847] nvmet_rdma: freeing queue 809
[ 1949.385994] nvmet_rdma: freeing queue 810
[ 1949.386068] nvmet_rdma: freeing queue 811
[ 1949.386215] nvmet_rdma: freeing queue 812
[ 1949.386442] nvmet_rdma: freeing queue 813
[ 1949.386512] nvmet_rdma: freeing queue 814
[ 1949.386646] nvmet_rdma: freeing queue 815
[ 1949.387372] nvmet_rdma: freeing queue 799
[ 1949.387490] nvmet_rdma: freeing queue 817
[ 1949.387545] nvmet_rdma: freeing queue 818
[ 1949.470767] nvmet_rdma: freeing queue 819
[ 1949.477136] nvmet_rdma: freeing queue 820
[ 1949.477139] nvmet_rdma: freeing queue 821
[ 1949.477140] nvmet_rdma: freeing queue 822
[ 1949.478085] nvmet_rdma: freeing queue 826
[ 1949.478138] nvmet_rdma: freeing queue 827
[ 1949.478290] nvmet_rdma: freeing queue 828
[ 1949.478360] nvmet_rdma: freeing queue 829
[ 1949.478442] nvmet_rdma: freeing queue 830
[ 1949.563290] nvmet_rdma: freeing queue 831
[ 1949.643371] nvmet_rdma: freeing queue 832
[ 1949.643521] nvmet_rdma: freeing queue 816
[ 1949.644129] nvmet_rdma: freeing queue 834
[ 1949.645487] nvmet_rdma: freeing queue 835
[ 1949.647161] nvmet_rdma: freeing queue 836
[ 1949.647164] nvmet_rdma: freeing queue 843
[ 1949.647358] nvmet_rdma: freeing queue 844
[ 1949.647360] nvmet_rdma: freeing queue 845
[ 1949.727129] nvmet_rdma: freeing queue 846
[ 1949.727588] nvmet_rdma: freeing queue 847
[ 1949.727591] nvmet_rdma: freeing queue 848
[ 1949.727592] nvmet_rdma: freeing queue 849
[ 1949.727752] nvmet_rdma: freeing queue 833
[ 1949.732044] nvmet_rdma: freeing queue 851
[ 1954.391722] Node 0 active_anon:1596kB inactive_anon:644kB active_file:4732kB inactive_file:9232kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:7672kB dirty:12kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 8kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? no
[ 1954.391728] Node 1 active_anon:0kB inactive_anon:0kB active_file:344kB inactive_file:380kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:760kB dirty:4kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? no
[ 1954.391730] Node 0 DMA free:15880kB min:40kB low:52kB high:64kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15980kB managed:15896kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1954.391733] lowmem_reserve[]: 0 2884 15935 15935 15935
[ 1954.391736] Node 0 DMA32 free:60228kB min:8100kB low:11052kB high:14004kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3094192kB managed:3013444kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:260880kB kernel_stack:4320kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1954.391738] lowmem_reserve[]: 0 0 13051 13051 13051
[ 1954.391741] Node 0 Normal free:472996kB min:36664kB low:50028kB high:63392kB active_anon:1596kB inactive_anon:644kB active_file:4732kB inactive_file:9232kB unevictable:0kB writepending:0kB present:13631488kB managed:13364548kB mlocked:0kB slab_reclaimable:19628kB slab_unreclaimable:1382908kB kernel_stack:29080kB pagetables:848kB bounce:0kB free_pcp:9968kB local_pcp:0kB free_cma:0kB
[ 1954.391744] lowmem_reserve[]: 0 0 0 0 0
[ 1954.391747] Node 1 Normal free:48736kB min:45296kB low:61804kB high:78312kB active_anon:0kB inactive_anon:0kB active_file:344kB inactive_file:380kB unevictable:0kB writepending:4kB present:16777212kB managed:16509840kB mlocked:0kB slab_reclaimable:30220kB slab_unreclaimable:1639508kB kernel_stack:26552kB pagetables:300kB bounce:0kB free_pcp:2000kB local_pcp:0kB free_cma:0kB
[ 1954.391749] lowmem_reserve[]: 0 0 0 0 0
[ 1954.391751] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1954.391756] Node 0 DMA32: 17*4kB (UM) 18*8kB (UM) 3*16kB (M) 6*32kB (UM) 4*64kB (UM) 3*128kB (M) 3*256kB (M) 6*512kB (UM) 2*1024kB (UM) 2*2048kB (UM) 12*4096kB (M) = 60228kB
[ 1954.391762] Node 0 Normal: 279*4kB (U) 388*8kB (U) 1025*16kB (UME) 799*32kB (UM) 785*64kB (U) 319*128kB (U) 258*256kB (UM) 5*512kB (U) 177*1024kB (UE) 24*2048kB (UM) 9*4096kB (U) = 473132kB
[ 1954.391767] Node 1 Normal: 426*4kB (UME) 160*8kB (U) 56*16kB (UME) 39*32kB (UMH) 23*64kB (UM) 24*128kB (UMH) 19*256kB (UMH) 25*512kB (UMH) 17*1024kB (UMH) 2*2048kB (M) 0*4096kB = 48840kB
[ 1954.391781] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1954.391782] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1954.391783] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[ 1954.391783] Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1954.391784] 3802 total pagecache pages
[ 1954.391785] 73 pages in swap cache
[ 1954.391785] Swap cache stats: add 42127, delete 42054, find 6434/11935
[ 1954.391786] Free swap  = 16497800kB
[ 1954.391786] Total swap = 16516092kB
[ 1954.391787] 8379718 pages RAM
[ 1954.391787] 0 pages HighMem/MovableOnly
[ 1954.391787] 153786 pages reserved
[ 1954.391788] 0 pages cma reserved
[ 1954.391796] 0 pages hwpoisoned
[ 1954.391797] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1954.391825] [  824]     0   824    11841        1      25       3      711         -1000 systemd-udevd
[ 1954.391833] [ 1096]     0  1096    13856       12      27       3      100         -1000 auditd
[ 1954.391835] [ 1153]    81  1153     8714        0      19       3      130          -900 dbus-daemon
[ 1954.391838] [ 2111]     0  2111    20619       52      43       3      210         -1000 sshd
[ 1954.391839] [ 2259]     0  2259    27511        1      10       3       31             0 agetty
[ 1954.391846] [ 3381]     0  3381    26973        0       8       3       23             0 rhnsd
[ 1954.392200] [ 7154]     0  7154     2674        0      10       3       32             0 systemd-cgroups
[ 1954.392202] [ 7177]     0  7177    34395     1927      71       3        0             0 sshd
[ 1954.392205] [ 7193]    74  7193    22059     1473      46       3        0             0 sshd
[ 1954.392206] Out of memory: Kill process 7136 (systemd-cgroups) score 0 or sacrifice child
[ 1955.404157] nvmet_rdma: freeing queue 15000
[ 1956.331251] nvmet_rdma: freeing queue 13099
[ 1956.348511] nvmet_rdma: freeing queue 13185
[ 1956.351393] nvmet_rdma: freeing queue 13010
[ 1956.374327] nvmet_rdma: freeing queue 13225
[ 1956.388049] nvmet_rdma: freeing queue 13011
[ 1956.392748] nvmet_rdma: freeing queue 13287
[ 1956.421092] nvmet_rdma: freeing queue 13012
[ 1956.421814] nvmet_rdma: freeing queue 13337
[ 1956.437719] nvmet_rdma: freeing queue 13420
[ 1956.441829] nvmet_rdma: freeing queue 13421
[ 1956.458922] nvmet_rdma: freeing queue 13013
[ 1956.464582] nvmet_rdma: freeing queue 13422
[ 1956.476526] nvmet_rdma: freeing queue 13606
[ 1956.486775] nvmet_rdma: freeing queue 13014
[ 1956.490909] nvmet_rdma: freeing queue 13712
[ 1956.495506] nvmet_rdma: freeing queue 13015
[ 1956.503003] nvmet_rdma: freeing queue 13730
[ 1956.513958] nvmet_rdma: freeing queue 13780
[ 1956.527151] nvmet_rdma: freeing queue 13016
[ 1956.535790] nvmet_rdma: freeing queue 13849
[ 1956.546581] nvmet_rdma: freeing queue 13017
[ 1956.551146] nvmet_rdma: freeing queue 13899
[ 1956.559835] nvmet_rdma: freeing queue 13018
[ 1956.575782] nvmet_rdma: freeing queue 13968
[ 1956.581594] nvmet_rdma: freeing queue 14017
[ 1956.600387] nvmet_rdma: freeing queue 13019
[ 1956.605712] nvmet_rdma: freeing queue 13020
[ 1956.621761] nvmet_rdma: freeing queue 13021
[ 1956.628045] nvmet_rdma: freeing queue 14036
[ 1956.640629] nvmet_rdma: freeing queue 13167
[ 1956.643509] nvmet_rdma: freeing queue 14052
[ 1956.645962] nvmet_rdma: freeing queue 13232
[ 1956.654001] nvmet_rdma: freeing queue 14086
[ 1956.665985] nvmet_rdma: freeing queue 13275
[ 1956.669915] nvmet_rdma: freeing queue 14119
[ 1956.670672] nvmet_rdma: freeing queue 13358
[ 1956.675318] nvmet_rdma: freeing queue 14553
[ 1956.733899] nvmet_rdma: freeing queue 13390
[ 1956.742492] nvmet_rdma: freeing queue 13589
[ 1956.756198] nvmet_rdma: freeing queue 13590
[ 1956.756765] nvmet_rdma: freeing queue 14663
[ 1956.765458] nvmet_rdma: freeing queue 14681
[ 1956.777425] nvmet_rdma: freeing queue 14838
[ 1956.782701] nvmet_rdma: freeing queue 13591
[ 1956.792486] nvmet_rdma: freeing queue 14851
[ 1956.797090] nvmet_rdma: freeing queue 13594
[ 1956.802212] nvmet_rdma: freeing queue 14937
[ 1956.807432] nvmet: ctrl 803 keep-alive timer (15 seconds) expired!
[ 1956.807434] nvmet_rdma: freeing queue 14972
[ 1956.817206] nvmet_rdma: freeing queue 13602
[ 1956.823611] nvmet_rdma: freeing queue 14981
[ 1956.824347] nvmet_rdma: freeing queue 14982
[ 1956.828805] nvmet_rdma: freeing queue 14983
[ 1956.833607] nvmet_rdma: freeing queue 14989
[ 1956.846701] nvmet_rdma: freeing queue 13650
[ 1956.853642] nvmet_rdma: freeing queue 13702
[ 1956.865160] nvmet_rdma: freeing queue 13838
[ 1956.875364] nvmet: ctrl 808 keep-alive timer (15 seconds) expired!
[ 1956.875366] nvmet_rdma: freeing queue 15378
[ 1956.878895] nvmet_rdma: freeing queue 13883
[ 1956.893251] nvmet_rdma: freeing queue 15379
[ 1956.895584] nvmet_rdma: freeing queue 14018
[ 1956.911579] nvmet_rdma: freeing queue 15380
[ 1956.921327] nvmet_rdma: freeing queue 15747
[ 1956.937733] nvmet_rdma: freeing queue 15748
[ 1956.940586] nvmet_rdma: freeing queue 14026
[ 1956.947309] nvmet_rdma: freeing queue 14032
[ 1956.952669] nvmet_rdma: freeing queue 14084
[ 1956.972278] nvmet_rdma: freeing queue 15809
[ 1956.975710] nvmet_rdma: freeing queue 15853
[ 1956.981558] nvmet_rdma: freeing queue 14533
[ 1956.986672] nvmet: ctrl 777 keep-alive timer (15 seconds) expired!
[ 1956.986673] nvmet_rdma: freeing queue 14718
[ 1956.991941] nvmet_rdma: freeing queue 15880
[ 1956.992023] nvmet_rdma: freeing queue 15001
[ 1956.997815] nvmet_rdma: freeing queue 15881
[ 1957.000673] nvmet_rdma: freeing queue 14827
[ 1957.005376] nvmet_rdma: freeing queue 15882
[ 1957.014577] nvmet_rdma: freeing queue 15070
[ 1957.016826] nvmet_rdma: freeing queue 15887
[ 1957.034219] nvmet_rdma: freeing queue 15382
[ 1957.038896] nvmet_rdma: freeing queue 14828
[ 1957.043547] nvmet_rdma: freeing queue 15825
[ 1957.070000] nvmet_rdma: freeing queue 15992
[ 1957.083313] nvmet_rdma: freeing queue 14829
[ 1957.086811] nvmet_rdma: freeing queue 14830
[ 1957.100484] nvmet_rdma: freeing queue 15856
[ 1957.109711] nvmet_rdma: freeing queue 15998
[ 1957.114237] nvmet_rdma: freeing queue 15889
[ 1957.119192] nvmet_rdma: freeing queue 15999
[ 1957.119864] nvmet_rdma: freeing queue 14831
[ 1957.121667] nvmet_rdma: freeing queue 16000
[ 1957.122699] nvmet_rdma: freeing queue 14832
[ 1957.123231] nvmet_rdma: freeing queue 16001
[ 1957.123304] nvmet_rdma: freeing queue 15994
[ 1957.123414] nvmet_rdma: freeing queue 16002
[ 1957.123575] nvmet_rdma: freeing queue 15997
[ 1957.124003] nvmet_rdma: freeing queue 14833
[ 1957.124579] nvmet_rdma: freeing queue 14834
[ 1957.124583] nvmet_rdma: freeing queue 14980
[ 1957.124791] nvmet_rdma: freeing queue 16003
[ 1957.125058] nvmet_rdma: freeing queue 15006
[ 1957.125167] nvmet_rdma: freeing queue 16004
[ 1957.126017] nvmet_rdma: freeing queue 15074
[ 1957.126071] nvmet_rdma: freeing queue 16108
[ 1957.126323] nvmet_rdma: freeing queue 16005
[ 1957.126493] nvmet_rdma: freeing queue 16006
[ 1957.127003] nvmet_rdma: freeing queue 16129
[ 1957.127085] nvmet_rdma: freeing queue 15148
[ 1957.127349] nvmet_rdma: freeing queue 15149
[ 1957.127942] nvmet_rdma: freeing queue 15150
[ 1957.128089] nvmet_rdma: freeing queue 16187
[ 1957.128971] nvmet_rdma: freeing queue 16007
[ 1957.129213] nvmet_rdma: freeing queue 16200
[ 1957.129278] nvmet_rdma: freeing queue 15151
[ 1957.129503] nvmet_rdma: freeing queue 16333
[ 1957.129526] nvmet_rdma: freeing queue 16008
[ 1957.130410] nvmet_rdma: freeing queue 16440
[ 1957.131990] nvmet_rdma: freeing queue 16009
[ 1957.132107] nvmet_rdma: freeing queue 16012
[ 1957.132184] nvmet_rdma: freeing queue 15152
[ 1957.132266] nvmet_rdma: freeing queue 16441
[ 1957.132364] nvmet_rdma: freeing queue 16036
[ 1957.132569] nvmet_rdma: freeing queue 15153
[ 1957.132953] nvmet_rdma: freeing queue 16037
[ 1957.134158] nvmet_rdma: freeing queue 16442
[ 1957.135261] nvmet_rdma: freeing queue 16443
[ 1957.135932] nvmet_rdma: freeing queue 16106
[ 1957.135981] nvmet_rdma: freeing queue 16444
[ 1957.136689] nvmet_rdma: freeing queue 15154
[ 1957.136986] nvmet_rdma: freeing queue 16127
[ 1957.137599] nvmet_rdma: freeing queue 16445
[ 1957.137641] nvmet_rdma: freeing queue 16192
[ 1957.137969] nvmet_rdma: freeing queue 15179
[ 1957.138641] nvmet_rdma: freeing queue 16446
[ 1957.139030] nvmet_rdma: freeing queue 16198
[ 1957.139324] nvmet_rdma: freeing queue 16447
[ 1957.139460] nvmet_rdma: freeing queue 16448
[ 1957.140165] nvmet_rdma: freeing queue 15416
[ 1957.141267] nvmet_rdma: freeing queue 16330
[ 1957.141625] nvmet_rdma: freeing queue 16331
[ 1957.141678] nvmet_rdma: freeing queue 16449
[ 1957.141935] nvmet_rdma: freeing queue 16450
[ 1957.142373] nvmet: ctrl 803 fatal error occurred!
[ 1957.142374] nvmet: ctrl 808 fatal error occurred!
[ 1957.144036] nvmet_rdma: freeing queue 15418
[ 1957.144510] nvmet_rdma: freeing queue 15476
[ 1957.146035] nvmet: ctrl 903 keep-alive timer (15 seconds) expired!
[ 1957.146042] nvmet: ctrl 903 fatal error occurred!
[ 1957.146505] nvmet_rdma: freeing queue 15505
[ 1957.147163] nvmet_rdma: freeing queue 15806
[ 1957.149455] nvmet_rdma: freeing queue 15822
[ 1957.149945] nvmet_rdma: freeing queue 15892
[ 1957.150950] nvmet_rdma: freeing queue 16013
[ 1957.150953] nvmet_rdma: freeing queue 16033
[ 1957.154114] nvmet_rdma: freeing queue 16034
[ 1957.157648] nvmet_rdma: freeing queue 16043
[ 1957.163292] nvmet_rdma: freeing queue 16083
[ 1957.196880] nvmet_rdma: freeing queue 16084
[ 1957.208755] nvmet_rdma: freeing queue 16085
[ 1957.209504] nvmet_rdma: freeing queue 16086
[ 1957.209857] nvmet_rdma: freeing queue 16087
[ 1957.211092] nvmet_rdma: freeing queue 16088
[ 1957.211187] nvmet_rdma: freeing queue 16194
[ 1957.211490] nvmet_rdma: freeing queue 16245
[ 1957.255410] nvmet_rdma: freeing queue 16247
[ 1957.269868] nvmet: ctrl 777 fatal error occurred!
[ 1957.467616] nvmet_rdma: freeing queue 4190
[ 1957.468305] nvmet_rdma: freeing queue 4191
[ 1957.468573] nvmet_rdma: freeing queue 4202
[ 1957.468575] nvmet_rdma: freeing queue 4203
[ 1957.468577] nvmet_rdma: freeing queue 4204
[ 1957.468761] nvmet_rdma: freeing queue 4205
[ 1957.468896] nvmet_rdma: freeing queue 4206
[ 1957.469031] nvmet_rdma: freeing queue 4207
[ 1957.469279] nvmet_rdma: freeing queue 4208
[ 1957.469496] nvmet_rdma: freeing queue 4225
[ 1957.469755] nvmet_rdma: freeing queue 4291
[ 1957.469757] nvmet_rdma: freeing queue 4292
[ 1957.469992] nvmet_rdma: freeing queue 4305
[ 1957.470793] nvmet_rdma: freeing queue 4306
[ 1957.470868] nvmet_rdma: freeing queue 4307
[ 1957.471287] nvmet_rdma: freeing queue 4308
[ 1957.471969] nvmet_rdma: freeing queue 4309
[ 1957.472037] nvmet_rdma: freeing queue 4310
[ 1957.473159] nvmet_rdma: freeing queue 4373
[ 1957.474209] nvmet_rdma: freeing queue 4374
[ 1957.474333] nvmet_rdma: freeing queue 4375
[ 1957.474535] nvmet_rdma: freeing queue 4376
[ 1957.474935] nvmet_rdma: freeing queue 4377
[ 1957.475535] nvmet_rdma: freeing queue 4378
[ 1957.475732] nvmet_rdma: freeing queue 4427
[ 1957.475983] nvmet_rdma: freeing queue 4428
[ 1957.476948] nvmet_rdma: freeing queue 4429
[ 1957.477379] nvmet_rdma: freeing queue 4444
[ 1957.478366] nvmet_rdma: freeing queue 4445
[ 1957.479001] nvmet_rdma: freeing queue 4446
[ 1957.479081] nvmet_rdma: freeing queue 4546
[ 1957.480654] nvmet_rdma: freeing queue 4547
[ 1957.481067] nvmet_rdma: freeing queue 4548
[ 1957.481070] nvmet_rdma: freeing queue 4646
[ 1957.481658] nvmet_rdma: freeing queue 4647
[ 1957.481781] nvmet_rdma: freeing queue 4648
[ 1957.481956] nvmet_rdma: freeing queue 4652
[ 1957.482437] nvmet_rdma: freeing queue 4660
[ 1957.483831] nvmet_rdma: freeing queue 4661
[ 1957.484185] nvmet_rdma: freeing queue 4662
[ 1957.484323] nvmet_rdma: freeing queue 4663
[ 1957.484523] nvmet_rdma: freeing queue 4664
[ 1957.484965] nvmet_rdma: freeing queue 4665
[ 1957.485698] nvmet_rdma: freeing queue 4666
[ 1957.485899] nvmet_rdma: freeing queue 4716
[ 1957.486298] nvmet_rdma: freeing queue 4717
[ 1957.486964] nvmet_rdma: freeing queue 4718
[ 1957.487330] nvmet_rdma: freeing queue 4719
[ 1957.487332] nvmet_rdma: freeing queue 4800
[ 1957.487537] nvmet_rdma: freeing queue 4801
[ 1957.487538] nvmet_rdma: freeing queue 4802
[ 1957.488007] nvmet_rdma: freeing queue 4803
[ 1957.488327] nvmet_rdma: freeing queue 5074
[ 1957.488605] nvmet_rdma: freeing queue 5075
[ 1957.488652] nvmet_rdma: freeing queue 5076
[ 1957.488849] nvmet_rdma: freeing queue 5077
[ 1957.488910] nvmet_rdma: freeing queue 5078
[ 1957.489164] nvmet_rdma: freeing queue 5129
[ 1957.489166] nvmet_rdma: freeing queue 5158
[ 1957.489424] nvmet_rdma: freeing queue 5159
[ 1957.489776] nvmet_rdma: freeing queue 5160
[ 1957.490028] nvmet_rdma: freeing queue 5163
[ 1957.490030] nvmet_rdma: freeing queue 5201
[ 1957.490421] nvmet_rdma: freeing queue 5206
[ 1957.490630] nvmet_rdma: freeing queue 5207
[ 1957.490834] nvmet_rdma: freeing queue 5208
[ 1957.491006] nvmet_rdma: freeing queue 5209
[ 1957.492781] nvmet_rdma: freeing queue 5210
[ 1957.493068] nvmet_rdma: freeing queue 5246
[ 1957.493310] nvmet_rdma: freeing queue 5278
[ 1957.493367] nvmet_rdma: freeing queue 5279
[ 1957.493897] nvmet_rdma: freeing queue 5317
[ 1957.493898] nvmet_rdma: freeing queue 5344
[ 1957.494041] nvmet_rdma: freeing queue 5345
[ 1957.494234] nvmet_rdma: freeing queue 5346
[ 1957.494236] nvmet_rdma: freeing queue 5347
[ 1957.494630] nvmet_rdma: freeing queue 5379
[ 1957.495352] nvmet_rdma: freeing queue 5380
[ 1957.495542] nvmet_rdma: freeing queue 5381
[ 1957.495891] nvmet_rdma: freeing queue 5395
[ 1957.495893] nvmet_rdma: freeing queue 5396
[ 1957.496227] nvmet_rdma: freeing queue 14021
[ 1957.496599] nvmet_rdma: freeing queue 14055
[ 1957.496600] nvmet_rdma: freeing queue 5397
[ 1957.496931] nvmet_rdma: freeing queue 5398
[ 1957.497136] nvmet_rdma: freeing queue 5463
[ 1957.497362] nvmet_rdma: freeing queue 14078
[ 1957.497496] nvmet_rdma: freeing queue 14079
[ 1957.498250] nvmet_rdma: freeing queue 5464
[ 1957.498568] nvmet_rdma: freeing queue 5465
[ 1957.498858] nvmet_rdma: freeing queue 14080
[ 1957.498924] nvmet_rdma: freeing queue 14089
[ 1957.499050] nvmet_rdma: freeing queue 5466
[ 1957.499479] nvmet_rdma: freeing queue 5467
[ 1957.499666] nvmet_rdma: freeing queue 5484
[ 1957.499902] nvmet_rdma: freeing queue 14180
[ 1957.500021] nvmet_rdma: freeing queue 5605
[ 1957.500676] nvmet_rdma: freeing queue 14181
[ 1957.500798] nvmet_rdma: freeing queue 5702
[ 1957.501044] nvmet_rdma: freeing queue 14502
[ 1957.501267] nvmet_rdma: freeing queue 5703
[ 1957.501269] nvmet_rdma: freeing queue 5718
[ 1957.501425] nvmet_rdma: freeing queue 13810
[ 1957.501877] nvmet_rdma: freeing queue 5719
[ 1957.501879] nvmet_rdma: freeing queue 5720
[ 1957.502003] nvmet_rdma: freeing queue 14503
[ 1957.502188] nvmet_rdma: freeing queue 14684
[ 1957.502190] nvmet_rdma: freeing queue 14854
[ 1957.502429] nvmet_rdma: freeing queue 5721
[ 1957.502455] nvmet_rdma: freeing queue 14940
[ 1957.502628] nvmet_rdma: freeing queue 13811
[ 1957.502786] nvmet_rdma: freeing queue 14975
[ 1957.502913] nvmet_rdma: freeing queue 15071
[ 1957.503131] nvmet_rdma: freeing queue 15383
[ 1957.503201] nvmet_rdma: freeing queue 13812
[ 1957.503390] nvmet_rdma: freeing queue 13813
[ 1957.503446] nvmet_rdma: freeing queue 15412
[ 1957.503569] nvmet_rdma: freeing queue 15697
[ 1957.503729] nvmet_rdma: freeing queue 5750
[ 1957.504127] nvmet_rdma: freeing queue 13814
[ 1957.504130] nvmet_rdma: freeing queue 13815
[ 1957.504581] nvmet_rdma: freeing queue 15826
[ 1957.504654] nvmet_rdma: freeing queue 5751
[ 1957.504869] nvmet_rdma: freeing queue 5752
[ 1957.505029] nvmet_rdma: freeing queue 15857
[ 1957.505271] nvmet_rdma: freeing queue 15890
[ 1957.505514] nvmet_rdma: freeing queue 13816
[ 1957.505585] nvmet_rdma: freeing queue 13817
[ 1957.505799] nvmet_rdma: freeing queue 15995
[ 1957.506035] nvmet_rdma: freeing queue 13818
[ 1957.506276] nvmet_rdma: freeing queue 13819
[ 1957.506584] nvmet_rdma: freeing queue 5753
[ 1957.506586] nvmet_rdma: freeing queue 5754
[ 1957.506879] nvmet_rdma: freeing queue 5755
[ 1957.506891] nvmet_rdma: freeing queue 16010
[ 1957.507011] nvmet_rdma: freeing queue 16109
[ 1957.507212] nvmet_rdma: freeing queue 5854
[ 1957.507214] nvmet_rdma: freeing queue 5855
[ 1957.507339] nvmet_rdma: freeing queue 13850
[ 1957.507516] nvmet_rdma: freeing queue 5856
[ 1957.507569] nvmet_rdma: freeing queue 5857
[ 1957.507697] nvmet_rdma: freeing queue 13900
[ 1957.507865] nvmet_rdma: freeing queue 5903
[ 1957.508064] nvmet_rdma: freeing queue 16130
[ 1957.508409] nvmet_rdma: freeing queue 5904
[ 1957.508698] nvmet_rdma: freeing queue 13969
[ 1957.508700] nvmet_rdma: freeing queue 14019
[ 1957.508869] nvmet_rdma: freeing queue 16184
[ 1957.509004] nvmet_rdma: freeing queue 16334
[ 1957.509175] nvmet_rdma: freeing queue 5905
[ 1957.509459] nvmet_rdma: freeing queue 14037
[ 1957.509614] nvmet_rdma: freeing queue 14053
[ 1957.509865] nvmet_rdma: freeing queue 16451
[ 1957.510431] nvmet_rdma: freeing queue 14082
[ 1957.511772] nvmet_rdma: freeing queue 14087
[ 1957.512078] nvmet_rdma: freeing queue 14133
[ 1957.512127] nvmet_rdma: freeing queue 5906
[ 1957.512257] nvmet_rdma: freeing queue 14135
[ 1957.512411] nvmet_rdma: freeing queue 5907
[ 1957.512782] nvmet_rdma: freeing queue 5908
[ 1957.513018] nvmet_rdma: freeing queue 5909
[ 1957.513092] nvmet_rdma: freeing queue 14508
[ 1957.513329] nvmet_rdma: freeing queue 14554
[ 1957.513331] nvmet_rdma: freeing queue 14555
[ 1957.513711] nvmet_rdma: freeing queue 14645
[ 1957.513931] nvmet_rdma: freeing queue 14664
[ 1957.514054] nvmet_rdma: freeing queue 14682
[ 1957.514284] nvmet_rdma: freeing queue 14839
[ 1957.514741] nvmet_rdma: freeing queue 5920
[ 1957.514911] nvmet_rdma: freeing queue 5933
[ 1957.515448] nvmet_rdma: freeing queue 14852
[ 1957.516137] nvmet_rdma: freeing queue 5965
[ 1957.516182] nvmet_rdma: freeing queue 5972
[ 1957.516305] nvmet_rdma: freeing queue 5973
[ 1957.516580] nvmet_rdma: freeing queue 14938
[ 1957.516638] nvmet_rdma: freeing queue 5974
[ 1957.516912] nvmet_rdma: freeing queue 5975
[ 1957.517181] nvmet_rdma: freeing queue 14973
[ 1957.517309] nvmet_rdma: freeing queue 5976
[ 1957.517516] nvmet_rdma: freeing queue 14998
[ 1957.517767] nvmet_rdma: freeing queue 5977
[ 1957.518186] nvmet: ctrl 810 keep-alive timer (15 seconds) expired!
[ 1957.518188] nvmet_rdma: freeing queue 15381
[ 1957.518376] nvmet_rdma: freeing queue 15729
[ 1957.518678] nvmet_rdma: freeing queue 15793
[ 1957.519064] nvmet_rdma: freeing queue 15824
[ 1957.519267] nvmet_rdma: freeing queue 5978
[ 1957.519408] nvmet_rdma: freeing queue 5979
[ 1957.519847] nvmet_rdma: freeing queue 15854
[ 1957.520271] nvmet_rdma: freeing queue 15855
[ 1957.520592] nvmet_rdma: freeing queue 5990
[ 1957.520594] nvmet_rdma: freeing queue 5991
[ 1957.520611] nvmet_rdma: freeing queue 15888
[ 1957.520793] nvmet_rdma: freeing queue 15993
[ 1957.520836] nvmet: ctrl 275 keep-alive timer (15 seconds) expired!
[ 1957.520838] nvmet_rdma: freeing queue 6014
[ 1957.521303] nvmet_rdma: freeing queue 6022
[ 1957.521679] nvmet_rdma: freeing queue 16107
[ 1957.521942] nvmet_rdma: freeing queue 6023
[ 1957.522180] nvmet_rdma: freeing queue 16128
[ 1957.522344] nvmet_rdma: freeing queue 6024
[ 1957.522736] nvmet_rdma: freeing queue 16199
[ 1957.522997] nvmet_rdma: freeing queue 16219
[ 1957.523626] nvmet_rdma: freeing queue 16220
[ 1957.523947] nvmet_rdma: freeing queue 6025
[ 1957.524083] nvmet_rdma: freeing queue 16239
[ 1957.524223] nvmet_rdma: freeing queue 6026
[ 1957.524484] nvmet_rdma: freeing queue 16240
[ 1957.524814] nvmet_rdma: freeing queue 6027
[ 1957.524866] nvmet_rdma: freeing queue 6107
[ 1957.525008] nvmet_rdma: freeing queue 6108
[ 1957.525741] nvmet_rdma: freeing queue 6109
[ 1957.525938] nvmet_rdma: freeing queue 6110
[ 1957.526059] nvmet_rdma: freeing queue 6111
[ 1957.526376] nvmet_rdma: freeing queue 6112
[ 1957.526642] nvmet_rdma: freeing queue 6113
[ 1957.527040] nvmet_rdma: freeing queue 6157
[ 1957.527082] nvmet_rdma: freeing queue 16241
[ 1957.527265] nvmet_rdma: freeing queue 16332
[ 1957.527501] nvmet: ctrl 810 fatal error occurred!
[ 1957.527625] nvmet_rdma: freeing queue 6158
[ 1957.528512] nvmet_rdma: freeing queue 6159
[ 1957.529518] nvmet_rdma: freeing queue 6160
[ 1957.529755] nvmet_rdma: freeing queue 6161
[ 1957.530520] nvmet_rdma: freeing queue 6162
[ 1957.530639] nvmet_rdma: freeing queue 6163
[ 1957.530993] nvmet_rdma: freeing queue 6164
[ 1957.532428] nvmet_rdma: freeing queue 6165
[ 1957.532693] nvmet_rdma: freeing queue 6166
[ 1957.533509] nvmet_rdma: freeing queue 6253
[ 1957.533738] nvmet_rdma: freeing queue 6327
[ 1957.534137] nvmet_rdma: freeing queue 6328
[ 1957.534415] nvmet_rdma: freeing queue 6329
[ 1957.534614] nvmet_rdma: freeing queue 6330
[ 1957.537992] nvmet_rdma: freeing queue 6331
[ 1957.538236] nvmet_rdma: freeing queue 6332
[ 1957.538238] nvmet_rdma: freeing queue 6333
[ 1957.538733] nvmet_rdma: freeing queue 6334
[ 1957.539090] nvmet_rdma: freeing queue 6357
[ 1957.539092] nvmet_rdma: freeing queue 6413
[ 1957.539717] nvmet_rdma: freeing queue 6414
[ 1957.540492] nvmet_rdma: freeing queue 6415
[ 1957.541009] nvmet_rdma: freeing queue 6416
[ 1957.541836] nvmet_rdma: freeing queue 6417
[ 1957.542248] nvmet_rdma: freeing queue 6418
[ 1957.543786] nvmet_rdma: freeing queue 6482
[ 1957.544115] nvmet_rdma: freeing queue 6483
[ 1957.544343] nvmet_rdma: freeing queue 6484
[ 1957.546207] nvmet_rdma: freeing queue 6485
[ 1957.548562] nvmet_rdma: freeing queue 6486
[ 1957.548784] nvmet_rdma: freeing queue 6515
[ 1957.549368] nvmet_rdma: freeing queue 6516
[ 1957.550015] nvmet_rdma: freeing queue 6517
[ 1957.550017] nvmet_rdma: freeing queue 6518
[ 1957.551374] nvmet_rdma: freeing queue 6519
[ 1957.551440] nvmet_rdma: freeing queue 6520
[ 1957.552686] nvmet_rdma: freeing queue 6521
[ 1957.553417] nvmet_rdma: freeing queue 6621
[ 1957.556613] nvmet_rdma: freeing queue 6622
[ 1957.556737] nvmet_rdma: freeing queue 6623
[ 1957.556909] nvmet_rdma: freeing queue 6690
[ 1957.557236] nvmet_rdma: freeing queue 6691
[ 1957.557237] nvmet_rdma: freeing queue 6701
[ 1957.557443] nvmet_rdma: freeing queue 6702
[ 1957.557762] nvmet_rdma: freeing queue 6703
[ 1957.557921] nvmet_rdma: freeing queue 6704
[ 1957.558151] nvmet_rdma: freeing queue 6705
[ 1957.558153] nvmet_rdma: freeing queue 6706
[ 1957.558596] nvmet_rdma: freeing queue 6707
[ 1957.558598] nvmet_rdma: freeing queue 6738
[ 1957.559193] nvmet_rdma: freeing queue 6739
[ 1957.559402] nvmet_rdma: freeing queue 6740
[ 1957.559615] nvmet_rdma: freeing queue 6741
[ 1957.560812] nvmet_rdma: freeing queue 6742
[ 1957.561480] nvmet_rdma: freeing queue 6755
[ 1957.562273] nvmet_rdma: freeing queue 6756
[ 1957.562509] nvmet_rdma: freeing queue 6757
[ 1957.562977] nvmet_rdma: freeing queue 6758
[ 1957.563525] nvmet_rdma: freeing queue 6786
[ 1957.564796] nvmet_rdma: freeing queue 6787
[ 1957.567687] nvmet_rdma: freeing queue 6788
[ 1957.567874] nvmet_rdma: freeing queue 6789
[ 1957.568187] nvmet_rdma: freeing queue 6790
[ 1957.568968] nvmet_rdma: freeing queue 6791
[ 1957.569678] nvmet_rdma: freeing queue 6792
[ 1957.570345] nvmet_rdma: freeing queue 6793
[ 1957.570347] nvmet_rdma: freeing queue 6819
[ 1957.570812] nvmet_rdma: freeing queue 6820
[ 1957.573342] nvmet_rdma: freeing queue 6821
[ 1957.573848] nvmet_rdma: freeing queue 6822
[ 1957.575022] nvmet_rdma: freeing queue 6823
[ 1957.576185] nvmet_rdma: freeing queue 6824
[ 1957.576187] nvmet_rdma: freeing queue 6825
[ 1957.576315] nvmet_rdma: freeing queue 6826
[ 1957.576544] nvmet_rdma: freeing queue 6827
[ 1957.576674] nvmet_rdma: freeing queue 6828
[ 1957.577078] nvmet_rdma: freeing queue 6829
[ 1957.577327] nvmet_rdma: freeing queue 6863
[ 1957.582929] nvmet_rdma: freeing queue 12217
[ 1957.583913] nvmet_rdma: freeing queue 12245
[ 1957.584038] nvmet_rdma: freeing queue 12257
[ 1957.584250] nvmet_rdma: freeing queue 12392
[ 1957.584457] nvmet_rdma: freeing queue 12404
[ 1957.584584] nvmet_rdma: freeing queue 12573
[ 1957.585173] nvmet_rdma: freeing queue 12665
[ 1957.585599] nvmet_rdma: freeing queue 12682
[ 1957.585905] nvmet_rdma: freeing queue 12700
[ 1957.586692] nvmet_rdma: freeing queue 12701
[ 1957.586817] nvmet_rdma: freeing queue 12722
[ 1957.586997] nvmet_rdma: freeing queue 12723
[ 1957.587046] nvmet_rdma: freeing queue 12725
[ 1957.587341] nvmet_rdma: freeing queue 12828
[ 1957.588384] nvmet_rdma: freeing queue 12894
[ 1957.588906] nvmet_rdma: freeing queue 12921
[ 1957.589143] nvmet_rdma: freeing queue 12922
[ 1957.589145] nvmet_rdma: freeing queue 12923
[ 1957.589433] nvmet_rdma: freeing queue 12924
[ 1957.590469] nvmet_rdma: freeing queue 12925
[ 1957.590799] nvmet_rdma: freeing queue 12926
[ 1957.591276] nvmet_rdma: freeing queue 12927
[ 1957.591278] nvmet_rdma: freeing queue 12928
[ 1957.591279] nvmet_rdma: freeing queue 12929
[ 1957.591841] nvmet_rdma: freeing queue 13024
[ 1957.592188] nvmet_rdma: freeing queue 13033
[ 1957.592592] nvmet_rdma: freeing queue 13022
[ 1957.592866] nvmet_rdma: freeing queue 13073
[ 1957.593123] nvmet_rdma: freeing queue 13191
[ 1957.593399] nvmet_rdma: freeing queue 13175
[ 1957.594192] nvmet_rdma: freeing queue 13228
[ 1957.594669] nvmet_rdma: freeing queue 13271
[ 1957.594864] nvmet_rdma: freeing queue 13285
[ 1957.597862] nvmet_rdma: freeing queue 13290
[ 1957.597889] nvmet_rdma: freeing queue 13343
[ 1957.598066] nvmet_rdma: freeing queue 13391
[ 1957.598219] nvmet_rdma: freeing queue 13507
[ 1957.598758] nvmet_rdma: freeing queue 6893
[ 1957.599202] nvmet_rdma: freeing queue 13548
[ 1957.609675] nvmet_rdma: freeing queue 13609
[ 1957.610990] nvmet_rdma: freeing queue 13635
[ 1957.611255] nvmet_rdma: freeing queue 13637
[ 1957.611322] nvmet_rdma: freeing queue 13638
[ 1957.611474] nvmet_rdma: freeing queue 13719
[ 1957.612215] nvmet_rdma: freeing queue 13755
[ 1957.612217] nvmet_rdma: freeing queue 13756
[ 1957.612433] nvmet_rdma: freeing queue 13786
[ 1957.612484] nvmet_rdma: freeing queue 13905
[ 1957.613308] nvmet_rdma: freeing queue 14024
[ 1957.613638] nvmet_rdma: freeing queue 14008
[ 1957.614166] nvmet_rdma: freeing queue 14031
[ 1957.614472] nvmet_rdma: freeing queue 14058
[ 1957.614858] nvmet_rdma: freeing queue 14092
[ 1957.615323] nvmet_rdma: freeing queue 14141
[ 1957.615387] nvmet_rdma: freeing queue 14145
[ 1957.615589] nvmet_rdma: freeing queue 14146
[ 1957.615792] nvmet_rdma: freeing queue 14179
[ 1957.615857] nvmet_rdma: freeing queue 14183
[ 1957.616813] nvmet_rdma: freeing queue 14184
[ 1957.618108] nvmet_rdma: freeing queue 14418
[ 1957.618544] nvmet_rdma: freeing queue 14522
[ 1957.618667] nvmet_rdma: freeing queue 14523
[ 1957.619244] nvmet_rdma: freeing queue 14524
[ 1957.619246] nvmet_rdma: freeing queue 14525
[ 1957.621163] nvmet_rdma: freeing queue 14526
[ 1957.621166] nvmet_rdma: freeing queue 14527
[ 1957.621285] nvmet_rdma: freeing queue 14528
[ 1957.621644] nvmet_rdma: freeing queue 14529
[ 1957.621645] nvmet_rdma: freeing queue 14646
[ 1957.621647] nvmet_rdma: freeing queue 14665
[ 1957.621994] nvmet_rdma: freeing queue 14666
[ 1957.622158] nvmet_rdma: freeing queue 14687
[ 1957.622478] nvmet_rdma: freeing queue 14690
[ 1957.622662] nvmet_rdma: freeing queue 14691
[ 1957.623426] nvmet_rdma: freeing queue 14692
[ 1957.623772] nvmet_rdma: freeing queue 14701
[ 1957.624021] nvmet_rdma: freeing queue 14707
[ 1957.624544] nvmet_rdma: freeing queue 14708
[ 1957.624715] nvmet_rdma: freeing queue 14709
[ 1957.625302] nvmet_rdma: freeing queue 14710
[ 1957.626653] nvmet_rdma: freeing queue 14711
[ 1957.626840] nvmet_rdma: freeing queue 14712
[ 1957.627233] nvmet_rdma: freeing queue 14713
[ 1957.628581] nvmet_rdma: freeing queue 14714
[ 1957.628710] nvmet_rdma: freeing queue 14826
[ 1957.628935] nvmet_rdma: freeing queue 14860
[ 1957.629179] nvmet_rdma: freeing queue 14861
[ 1957.629181] nvmet_rdma: freeing queue 14862
[ 1957.629381] nvmet_rdma: freeing queue 14863
[ 1957.629436] nvmet_rdma: freeing queue 14864
[ 1957.630114] nvmet_rdma: freeing queue 14865
[ 1957.630415] nvmet_rdma: freeing queue 14866
[ 1957.630872] nvmet_rdma: freeing queue 14867
[ 1957.630995] nvmet_rdma: freeing queue 14868
[ 1957.631205] nvmet_rdma: freeing queue 14869
[ 1957.631207] nvmet_rdma: freeing queue 14870
[ 1957.631329] nvmet_rdma: freeing queue 14871
[ 1957.631451] nvmet_rdma: freeing queue 14872
[ 1957.631662] nvmet_rdma: freeing queue 14873
[ 1957.631663] nvmet_rdma: freeing queue 14874
[ 1957.631889] nvmet_rdma: freeing queue 14858
[ 1957.632034] nvmet_rdma: freeing queue 14898
[ 1957.632273] nvmet_rdma: freeing queue 14899
[ 1957.632395] nvmet_rdma: freeing queue 14900
[ 1957.632574] nvmet_rdma: freeing queue 14926
[ 1957.632758] nvmet_rdma: freeing queue 14984
[ 1957.633512] nvmet_rdma: freeing queue 14985
[ 1957.633686] nvmet_rdma: freeing queue 15010
[ 1957.634008] nvmet_rdma: freeing queue 15065
[ 1957.634083] nvmet_rdma: freeing queue 15068
[ 1957.634217] nvmet_rdma: freeing queue 15069
[ 1957.634309] nvmet_rdma: freeing queue 15507
[ 1957.634460] nvmet_rdma: freeing queue 15749
[ 1957.634631] nvmet_rdma: freeing queue 15795
[ 1957.634682] nvmet_rdma: freeing queue 15796
[ 1957.634885] nvmet_rdma: freeing queue 15797
[ 1957.634953] nvmet_rdma: freeing queue 15798
[ 1957.635225] nvmet_rdma: freeing queue 15799
[ 1957.635391] nvmet_rdma: freeing queue 15800
[ 1957.635514] nvmet_rdma: freeing queue 15801
[ 1957.635684] nvmet_rdma: freeing queue 15802
[ 1957.635981] nvmet_rdma: freeing queue 15803
[ 1957.635982] nvmet_rdma: freeing queue 15804
[ 1957.636237] nvmet_rdma: freeing queue 15805
[ 1957.636238] nvmet_rdma: freeing queue 15818
[ 1957.636295] nvmet_rdma: freeing queue 15860
[ 1957.636549] nvmet_rdma: freeing queue 16039
[ 1957.636551] nvmet_rdma: freeing queue 16055
[ 1957.636807] nvmet_rdma: freeing queue 16089
[ 1957.636809] nvmet_rdma: freeing queue 16090
[ 1957.636993] nvmet_rdma: freeing queue 16091
[ 1957.637047] nvmet_rdma: freeing queue 16112
[ 1957.637305] nvmet_rdma: freeing queue 16116
[ 1957.637311] nvmet: ctrl 876 keep-alive timer (15 seconds) expired!
[ 1957.637312] nvmet_rdma: freeing queue 16248
[ 1957.637670] nvmet_rdma: freeing queue 16454
[ 1957.637686] nvmet: ctrl 906 keep-alive timer (15 seconds) expired!
[ 1957.637687] nvmet: ctrl 876 fatal error occurred!
[ 1957.637688] nvmet: ctrl 906 fatal error occurred!
[ 1957.648164] nvmet_rdma: freeing queue 6894
[ 1957.648716] nvmet_rdma: freeing queue 6907
[ 1957.651253] nvmet_rdma: freeing queue 6908
[ 1957.651568] nvmet_rdma: freeing queue 6909
[ 1957.651762] nvmet_rdma: freeing queue 6910
[ 1957.651812] nvmet_rdma: freeing queue 6911
[ 1957.652132] nvmet_rdma: freeing queue 6979
[ 1957.652438] nvmet_rdma: freeing queue 7025
[ 1957.652439] nvmet_rdma: freeing queue 7026
[ 1957.652441] nvmet_rdma: freeing queue 7027
[ 1957.653671] nvmet_rdma: freeing queue 7028
[ 1957.653673] nvmet_rdma: freeing queue 7029
[ 1957.653674] nvmet_rdma: freeing queue 7030
[ 1957.653676] nvmet_rdma: freeing queue 7031
[ 1957.653865] nvmet_rdma: freeing queue 7032
[ 1957.653868] nvmet_rdma: freeing queue 7033
[ 1957.654171] nvmet_rdma: freeing queue 7060
[ 1957.654221] nvmet_rdma: freeing queue 7061
[ 1957.654344] nvmet_rdma: freeing queue 7062
[ 1957.654587] nvmet_rdma: freeing queue 7063
[ 1957.654589] nvmet_rdma: freeing queue 7064
[ 1957.654648] nvmet_rdma: freeing queue 7153
[ 1957.654861] nvmet_rdma: freeing queue 7258
[ 1957.654921] nvmet_rdma: freeing queue 7267
[ 1957.655070] nvmet_rdma: freeing queue 7268
[ 1957.655353] nvmet_rdma: freeing queue 7316
[ 1957.655528] nvmet_rdma: freeing queue 7317
[ 1957.655817] nvmet_rdma: freeing queue 7318
[ 1957.655818] nvmet_rdma: freeing queue 7335
[ 1957.656340] nvmet_rdma: freeing queue 7336
[ 1957.656342] nvmet_rdma: freeing queue 7437
[ 1957.656543] nvmet_rdma: freeing queue 7438
[ 1957.656650] nvmet_rdma: freeing queue 7481
[ 1957.657652] nvmet_rdma: freeing queue 7482
[ 1957.657655] nvmet_rdma: freeing queue 7483
[ 1957.671594] nvmet_rdma: freeing queue 852
[ 1957.671777] nvmet_rdma: freeing queue 853
[ 1957.671854] nvmet_rdma: freeing queue 854
[ 1957.671946] nvmet_rdma: freeing queue 855
[ 1957.672099] nvmet_rdma: freeing queue 856
[ 1957.672186] nvmet_rdma: freeing queue 859
[ 1957.672331] nvmet_rdma: freeing queue 860
[ 1957.672432] nvmet_rdma: freeing queue 861
[ 1957.672573] nvmet_rdma: freeing queue 862
[ 1957.672618] nvmet_rdma: freeing queue 863
[ 1957.673015] nvmet_rdma: freeing queue 864
[ 1957.673017] nvmet_rdma: freeing queue 865
[ 1957.673018] nvmet_rdma: freeing queue 866
[ 1957.673119] nvmet_rdma: freeing queue 850
[ 1957.673200] nvmet_rdma: freeing queue 868
[ 1957.673384] nvmet_rdma: freeing queue 869
[ 1957.673537] nvmet_rdma: freeing queue 870
[ 1957.673695] nvmet_rdma: freeing queue 871
[ 1957.673761] nvmet_rdma: freeing queue 872
[ 1957.673932] nvmet_rdma: freeing queue 873
[ 1957.674009] nvmet_rdma: freeing queue 874
[ 1957.674091] nvmet_rdma: freeing queue 875
[ 1957.674252] nvmet_rdma: freeing queue 877
[ 1957.674317] nvmet_rdma: freeing queue 878
[ 1957.674421] nvmet_rdma: freeing queue 879
[ 1957.674557] nvmet_rdma: freeing queue 880
[ 1957.674629] nvmet_rdma: freeing queue 881
[ 1957.674784] nvmet_rdma: freeing queue 882
[ 1957.674858] nvmet_rdma: freeing queue 883
[ 1957.674971] nvmet_rdma: freeing queue 885
[ 1957.675611] nvmet_rdma: freeing queue 886
[ 1957.675783] nvmet_rdma: freeing queue 887
[ 1957.675878] nvmet_rdma: freeing queue 888
[ 1957.675958] nvmet_rdma: freeing queue 889
[ 1957.676106] nvmet_rdma: freeing queue 890
[ 1957.676180] nvmet_rdma: freeing queue 891
[ 1957.676256] nvmet_rdma: freeing queue 892
[ 1957.676422] nvmet_rdma: freeing queue 893
[ 1957.676507] nvmet_rdma: freeing queue 894
[ 1957.676657] nvmet_rdma: freeing queue 895
[ 1957.676734] nvmet_rdma: freeing queue 896
[ 1957.676820] nvmet_rdma: freeing queue 897
[ 1957.676988] nvmet_rdma: freeing queue 898
[ 1957.677065] nvmet_rdma: freeing queue 899
[ 1957.677222] nvmet_rdma: freeing queue 900
[ 1957.677291] nvmet_rdma: freeing queue 884
[ 1957.677390] nvmet_rdma: freeing queue 902
[ 1957.677535] nvmet_rdma: freeing queue 903
[ 1957.677614] nvmet_rdma: freeing queue 904
[ 1957.677879] nvmet_rdma: freeing queue 905
[ 1957.677881] nvmet_rdma: freeing queue 906
[ 1957.677937] nvmet_rdma: freeing queue 907
[ 1957.678086] nvmet_rdma: freeing queue 908
[ 1957.678243] nvmet_rdma: freeing queue 909
[ 1957.678506] nvmet_rdma: freeing queue 910
[ 1957.678559] nvmet_rdma: freeing queue 911
[ 1957.678705] nvmet_rdma: freeing queue 912
[ 1957.678834] nvmet_rdma: freeing queue 913
[ 1957.678891] nvmet_rdma: freeing queue 914
[ 1957.679847] nvmet_rdma: freeing queue 915
[ 1957.679848] nvmet_rdma: freeing queue 916
[ 1957.680025] nvmet_rdma: freeing queue 917
[ 1957.680358] nvmet_rdma: freeing queue 901
[ 1957.680489] nvmet_rdma: freeing queue 919
[ 1957.680970] nvmet_rdma: freeing queue 936
[ 1957.681103] nvmet_rdma: freeing queue 937
[ 1957.681335] nvmet_rdma: freeing queue 938
[ 1957.681336] nvmet_rdma: freeing queue 939
[ 1957.681609] nvmet_rdma: freeing queue 940
[ 1957.681610] nvmet_rdma: freeing queue 941
[ 1957.681842] nvmet_rdma: freeing queue 942
[ 1957.681844] nvmet_rdma: freeing queue 943
[ 1957.682038] nvmet_rdma: freeing queue 944
[ 1957.682039] nvmet_rdma: freeing queue 945
[ 1957.682214] nvmet_rdma: freeing queue 946
[ 1957.682533] nvmet_rdma: freeing queue 947
[ 1957.682535] nvmet_rdma: freeing queue 948
[ 1957.682720] nvmet_rdma: freeing queue 949
[ 1957.683124] nvmet_rdma: freeing queue 950
[ 1957.683314] nvmet_rdma: freeing queue 951
[ 1957.683350] nvmet_rdma: freeing queue 935
[ 1957.683500] nvmet_rdma: freeing queue 953
[ 1957.684087] nvmet_rdma: freeing queue 954
[ 1957.684089] nvmet_rdma: freeing queue 955
[ 1957.684312] nvmet_rdma: freeing queue 961
[ 1957.684863] nvmet_rdma: freeing queue 962
[ 1957.684865] nvmet_rdma: freeing queue 963
[ 1957.684923] nvmet_rdma: freeing queue 964
[ 1957.685107] nvmet_rdma: freeing queue 965
[ 1957.685434] nvmet_rdma: freeing queue 966
[ 1957.685571] nvmet_rdma: freeing queue 967
[ 1957.685663] nvmet_rdma: freeing queue 968
[ 1957.685859] nvmet_rdma: freeing queue 952
[ 1957.686003] nvmet_rdma: freeing queue 970
[ 1957.686197] nvmet_rdma: freeing queue 971
[ 1957.686255] nvmet_rdma: freeing queue 972
[ 1957.686416] nvmet_rdma: freeing queue 973
[ 1957.686511] nvmet_rdma: freeing queue 974
[ 1957.686634] nvmet_rdma: freeing queue 975
[ 1957.686844] nvmet_rdma: freeing queue 976
[ 1957.686846] nvmet_rdma: freeing queue 977
[ 1957.687099] nvmet_rdma: freeing queue 978
[ 1957.687101] nvmet_rdma: freeing queue 979
[ 1957.687252] nvmet_rdma: freeing queue 980
[ 1957.687334] nvmet_rdma: freeing queue 981
[ 1957.687492] nvmet_rdma: freeing queue 982
[ 1957.687697] nvmet_rdma: freeing queue 983
[ 1957.687699] nvmet_rdma: freeing queue 984
[ 1957.687859] nvmet_rdma: freeing queue 985
[ 1957.687956] nvmet_rdma: freeing queue 969
[ 1957.688088] nvmet_rdma: freeing queue 987
[ 1957.688325] nvmet_rdma: freeing queue 988
[ 1957.688327] nvmet_rdma: freeing queue 989
[ 1957.688448] nvmet_rdma: freeing queue 990
[ 1957.688547] nvmet_rdma: freeing queue 991
[ 1957.688674] nvmet_rdma: freeing queue 992
[ 1957.688829] nvmet_rdma: freeing queue 993
[ 1957.688949] nvmet_rdma: freeing queue 994
[ 1957.689147] nvmet_rdma: freeing queue 995
[ 1957.689149] nvmet_rdma: freeing queue 996
[ 1957.689275] nvmet_rdma: freeing queue 997
[ 1957.689830] nvmet_rdma: freeing queue 998
[ 1957.689965] nvmet_rdma: freeing queue 999
[ 1957.690185] nvmet_rdma: freeing queue 1000
[ 1957.690361] nvmet_rdma: freeing queue 1001
[ 1957.690589] nvmet_rdma: freeing queue 1002
[ 1957.690590] nvmet_rdma: freeing queue 986
[ 1957.690717] nvmet_rdma: freeing queue 1004
[ 1957.690868] nvmet_rdma: freeing queue 1005
[ 1957.690937] nvmet_rdma: freeing queue 1006
[ 1957.691124] nvmet_rdma: freeing queue 1007
[ 1957.691174] nvmet_rdma: freeing queue 1008
[ 1957.691358] nvmet_rdma: freeing queue 1009
[ 1957.691482] nvmet_rdma: freeing queue 1003
[ 1957.691631] nvmet_rdma: freeing queue 1021
[ 1957.691650] nvmet_rdma: freeing queue 1022
[ 1957.691804] nvmet_rdma: freeing queue 1023
[ 1957.691981] nvmet_rdma: freeing queue 1024
[ 1957.691982] nvmet_rdma: freeing queue 1025
[ 1957.692034] nvmet_rdma: freeing queue 1026
[ 1957.692223] nvmet_rdma: freeing queue 1027
[ 1957.692271] nvmet_rdma: freeing queue 1028
[ 1957.692542] nvmet_rdma: freeing queue 1029
[ 1957.692544] nvmet_rdma: freeing queue 1030
[ 1957.692666] nvmet_rdma: freeing queue 1031
[ 1957.692924] nvmet_rdma: freeing queue 1032
[ 1957.692926] nvmet_rdma: freeing queue 1033
[ 1957.693128] nvmet_rdma: freeing queue 1034
[ 1957.693129] nvmet_rdma: freeing queue 1035
[ 1957.693329] nvmet_rdma: freeing queue 1036
[ 1957.693390] nvmet_rdma: freeing queue 1020
[ 1957.693515] nvmet_rdma: freeing queue 1038
[ 1957.693686] nvmet_rdma: freeing queue 1039
[ 1957.693688] nvmet_rdma: freeing queue 1040
[ 1957.693852] nvmet_rdma: freeing queue 1041
[ 1957.694081] nvmet_rdma: freeing queue 1042
[ 1957.694083] nvmet_rdma: freeing queue 1043
[ 1957.694202] nvmet_rdma: freeing queue 1044
[ 1957.694379] nvmet_rdma: freeing queue 1045
[ 1957.694441] nvmet_rdma: freeing queue 1046
[ 1957.694802] nvmet_rdma: freeing queue 1047
[ 1957.694803] nvmet_rdma: freeing queue 1048
[ 1957.695109] nvmet_rdma: freeing queue 1049
[ 1957.695362] nvmet_rdma: freeing queue 1050
[ 1957.695429] nvmet_rdma: freeing queue 1051
[ 1957.695707] nvmet_rdma: freeing queue 1052
[ 1957.695708] nvmet_rdma: freeing queue 1053
[ 1957.695997] nvmet_rdma: freeing queue 1037
[ 1957.696316] nvmet_rdma: freeing queue 1055
[ 1957.696318] nvmet_rdma: freeing queue 1056
[ 1957.696540] nvmet_rdma: freeing queue 1057
[ 1957.696852] nvmet_rdma: freeing queue 1058
[ 1957.698128] nvmet_rdma: freeing queue 1059
[ 1957.701838] nvmet_rdma: freeing queue 1060
[ 1957.702322] nvmet_rdma: freeing queue 1061
[ 1957.702324] nvmet_rdma: freeing queue 1062
[ 1957.702897] nvmet_rdma: freeing queue 1063
[ 1957.702979] nvmet_rdma: freeing queue 1064
[ 1957.703039] nvmet_rdma: freeing queue 1065
[ 1957.703346] nvmet_rdma: freeing queue 1066
[ 1957.703420] nvmet_rdma: freeing queue 1067
[ 1957.703532] nvmet_rdma: freeing queue 1068
[ 1957.703684] nvmet_rdma: freeing queue 1069
[ 1957.703801] nvmet_rdma: freeing queue 1070
[ 1957.703888] nvmet_rdma: freeing queue 1054
[ 1957.704156] nvmet_rdma: freeing queue 1072
[ 1957.704158] nvmet_rdma: freeing queue 1073
[ 1957.706575] nvmet_rdma: freeing queue 1074
[ 1957.706784] nvmet_rdma: freeing queue 1075
[ 1957.706786] nvmet_rdma: freeing queue 1076
[ 1957.707041] nvmet_rdma: freeing queue 1077
[ 1957.707042] nvmet_rdma: freeing queue 1078
[ 1957.707236] nvmet_rdma: freeing queue 1081
[ 1957.707290] nvmet_rdma: freeing queue 1082
[ 1957.707676] nvmet_rdma: freeing queue 1083
[ 1957.707678] nvmet_rdma: freeing queue 1084
[ 1957.707679] nvmet_rdma: freeing queue 1085
[ 1957.707836] nvmet_rdma: freeing queue 1086
[ 1957.707899] nvmet_rdma: freeing queue 1087
[ 1957.708029] nvmet_rdma: freeing queue 1071
[ 1957.708193] nvmet_rdma: freeing queue 1089
[ 1957.708408] nvmet_rdma: freeing queue 7484
[ 1957.708437] nvmet_rdma: freeing queue 1090
[ 1957.708556] nvmet_rdma: freeing queue 1091
[ 1957.708718] nvmet_rdma: freeing queue 1092
[ 1957.708764] nvmet_rdma: freeing queue 1093
[ 1957.708887] nvmet_rdma: freeing queue 1094
[ 1957.708948] nvmet_rdma: freeing queue 1095
[ 1957.710213] nvmet_rdma: freeing queue 1096
[ 1957.710382] nvmet_rdma: freeing queue 1097
[ 1957.710578] nvmet_rdma: freeing queue 1098
[ 1957.710580] nvmet_rdma: freeing queue 1099
[ 1957.710908] nvmet_rdma: freeing queue 1100
[ 1957.711076] nvmet_rdma: freeing queue 1101
[ 1957.711642] nvmet_rdma: freeing queue 1102
[ 1957.711827] nvmet_rdma: freeing queue 1103
[ 1957.712023] nvmet_rdma: freeing queue 1104
[ 1957.712257] nvmet_rdma: freeing queue 1088
[ 1957.712508] nvmet_rdma: freeing queue 1106
[ 1957.712509] nvmet_rdma: freeing queue 1107
[ 1957.712634] nvmet_rdma: freeing queue 1108
[ 1957.712883] nvmet_rdma: freeing queue 1109
[ 1957.712885] nvmet_rdma: freeing queue 1110
[ 1957.712936] nvmet_rdma: freeing queue 1105
[ 1957.713172] nvmet_rdma: freeing queue 1123
[ 1957.713173] nvmet_rdma: freeing queue 1124
[ 1957.713366] nvmet_rdma: freeing queue 1125
[ 1957.713433] nvmet_rdma: freeing queue 1126
[ 1957.713694] nvmet_rdma: freeing queue 1127
[ 1957.713695] nvmet_rdma: freeing queue 1128
[ 1957.713882] nvmet_rdma: freeing queue 1129
[ 1957.713940] nvmet_rdma: freeing queue 1130
[ 1957.714067] nvmet_rdma: freeing queue 1131
[ 1957.714289] nvmet_rdma: freeing queue 1132
[ 1957.714290] nvmet_rdma: freeing queue 1133
[ 1957.714349] nvmet_rdma: freeing queue 1134
[ 1957.714614] nvmet_rdma: freeing queue 1135
[ 1957.714615] nvmet_rdma: freeing queue 1136
[ 1957.714813] nvmet_rdma: freeing queue 1137
[ 1957.714872] nvmet_rdma: freeing queue 1138
[ 1957.715010] nvmet_rdma: freeing queue 1122
[ 1957.715247] nvmet_rdma: freeing queue 1140
[ 1957.715440] nvmet_rdma: freeing queue 1141
[ 1957.715744] nvmet_rdma: freeing queue 1142
[ 1957.715746] nvmet_rdma: freeing queue 1143
[ 1957.716024] nvmet_rdma: freeing queue 1144
[ 1957.716026] nvmet_rdma: freeing queue 1145
[ 1957.716500] nvmet_rdma: freeing queue 1146
[ 1957.716501] nvmet_rdma: freeing queue 1147
[ 1957.716503] nvmet_rdma: freeing queue 1148
[ 1957.716714] nvmet_rdma: freeing queue 1149
[ 1957.716715] nvmet_rdma: freeing queue 1150
[ 1957.716847] nvmet_rdma: freeing queue 1151
[ 1957.717011] nvmet_rdma: freeing queue 1152
[ 1957.717013] nvmet_rdma: freeing queue 1153
[ 1957.740253] nvmet_rdma: freeing queue 1154
[ 1957.741160] nvmet_rdma: freeing queue 1155
[ 1958.111268] nvmet_rdma: freeing queue 7485
[ 1958.111271] nvmet_rdma: freeing queue 7486
[ 1958.117170] nvmet_rdma: freeing queue 7487
[ 1958.121240] nvmet_rdma: freeing queue 7488
[ 1958.121242] nvmet_rdma: freeing queue 7489
[ 1958.124710] nvmet_rdma: freeing queue 7598
[ 1958.128875] nvmet_rdma: freeing queue 7640
[ 1958.135279] nvmet_rdma: freeing queue 7641
[ 1958.135828] nvmet_rdma: freeing queue 7696
[ 1958.146442] nvmet_rdma: freeing queue 7756
[ 1958.151268] nvmet_rdma: freeing queue 7757
[ 1958.151270] nvmet_rdma: freeing queue 7758
[ 1958.151271] nvmet_rdma: freeing queue 7759
[ 1958.154276] nvmet_rdma: freeing queue 7760
[ 1958.154278] nvmet_rdma: freeing queue 7761
[ 1958.154280] nvmet_rdma: freeing queue 7789
[ 1958.159350] nvmet_rdma: freeing queue 7790
[ 1958.159352] nvmet_rdma: freeing queue 7791
[ 1958.159353] nvmet_rdma: freeing queue 7792
[ 1958.159355] nvmet_rdma: freeing queue 7793
[ 1958.159649] nvmet_rdma: freeing queue 7794
[ 1958.159698] nvmet_rdma: freeing queue 7795
[ 1958.159975] nvmet_rdma: freeing queue 7796
[ 1958.160857] nvmet_rdma: freeing queue 7797
[ 1958.160859] nvmet_rdma: freeing queue 7798
[ 1958.160920] nvmet_rdma: freeing queue 7799
[ 1958.161130] nvmet_rdma: freeing queue 7800
[ 1958.161398] nvmet_rdma: freeing queue 7801
[ 1958.161399] nvmet_rdma: freeing queue 7827
[ 1958.161401] nvmet_rdma: freeing queue 7828
[ 1958.161597] nvmet_rdma: freeing queue 7829
[ 1958.161599] nvmet_rdma: freeing queue 7844
[ 1958.161717] nvmet_rdma: freeing queue 7845
[ 1958.161960] nvmet_rdma: freeing queue 7846
[ 1958.161961] nvmet_rdma: freeing queue 8015
[ 1958.162007] nvmet_rdma: freeing queue 8016
[ 1958.162125] nvmet_rdma: freeing queue 8029
[ 1958.164071] nvmet_rdma: freeing queue 8030
[ 1958.164134] nvmet_rdma: freeing queue 8031
[ 1958.165226] nvmet_rdma: freeing queue 8064
[ 1958.165354] nvmet_rdma: freeing queue 8065
[ 1958.165438] nvmet_rdma: freeing queue 8066
[ 1958.166003] nvmet_rdma: freeing queue 8067
[ 1958.166083] nvmet_rdma: freeing queue 8146
[ 1958.166252] nvmet_rdma: freeing queue 8147
[ 1958.166397] nvmet_rdma: freeing queue 8148
[ 1958.166547] nvmet_rdma: freeing queue 8149
[ 1958.166613] nvmet_rdma: freeing queue 8150
[ 1958.166846] nvmet_rdma: freeing queue 8151
[ 1958.166990] nvmet_rdma: freeing queue 8152
[ 1958.167136] nvmet_rdma: freeing queue 8167
[ 1958.167208] nvmet_rdma: freeing queue 8168
[ 1958.167306] nvmet_rdma: freeing queue 8251
[ 1958.167391] nvmet_rdma: freeing queue 8252
[ 1958.167603] nvmet_rdma: freeing queue 8253
[ 1958.167673] nvmet_rdma: freeing queue 8283
[ 1958.167842] nvmet_rdma: freeing queue 8284
[ 1958.167912] nvmet_rdma: freeing queue 8285
[ 1958.168067] nvmet_rdma: freeing queue 8286
[ 1958.168138] nvmet_rdma: freeing queue 8287
[ 1958.169759] nvmet_rdma: freeing queue 8288
[ 1958.169761] nvmet_rdma: freeing queue 8322
[ 1958.169763] nvmet_rdma: freeing queue 8313
[ 1958.169768] nvmet_rdma: freeing queue 8335
[ 1958.169770] nvmet_rdma: freeing queue 8336
[ 1958.169828] nvmet_rdma: freeing queue 8337
[ 1958.169830] nvmet_rdma: freeing queue 8390
[ 1958.170407] nvmet_rdma: freeing queue 8402
[ 1958.170493] nvmet_rdma: freeing queue 8454
[ 1958.172079] nvmet_rdma: freeing queue 8455
[ 1958.173417] nvmet_rdma: freeing queue 8456
[ 1958.173419] nvmet_rdma: freeing queue 8457
[ 1958.173421] nvmet_rdma: freeing queue 8458
[ 1958.173521] nvmet_rdma: freeing queue 8474
[ 1958.173773] nvmet_rdma: freeing queue 8475
[ 1958.173776] nvmet_rdma: freeing queue 8510
[ 1958.173777] nvmet_rdma: freeing queue 8559
[ 1958.175492] nvmet_rdma: freeing queue 8610
[ 1958.175495] nvmet_rdma: freeing queue 8640
[ 1958.175634] nvmet_rdma: freeing queue 8641
[ 1958.175834] nvmet_rdma: freeing queue 8642
[ 1958.176067] nvmet_rdma: freeing queue 8643
[ 1958.176377] nvmet_rdma: freeing queue 8644
[ 1958.176378] nvmet_rdma: freeing queue 8645
[ 1958.178416] nvmet_rdma: freeing queue 8685
[ 1958.178985] nvmet_rdma: freeing queue 8697
[ 1958.179487] nvmet_rdma: freeing queue 8711
[ 1958.179838] nvmet_rdma: freeing queue 8712
[ 1958.180142] nvmet_rdma: freeing queue 8720
[ 1958.181758] nvmet_rdma: freeing queue 8727
[ 1958.182248] nvmet_rdma: freeing queue 8728
[ 1958.182307] nvmet_rdma: freeing queue 8729
[ 1958.182309] nvmet_rdma: freeing queue 8730
[ 1958.182981] nvmet_rdma: freeing queue 8758
[ 1958.183142] nvmet_rdma: freeing queue 8759
[ 1958.183236] nvmet_rdma: freeing queue 8760
[ 1958.183239] nvmet_rdma: freeing queue 8761
[ 1958.183521] nvmet_rdma: freeing queue 8762
[ 1958.183816] nvmet_rdma: freeing queue 8763
[ 1958.183819] nvmet_rdma: freeing queue 8764
[ 1958.184112] nvmet_rdma: freeing queue 8765
[ 1958.184362] nvmet_rdma: freeing queue 8827
[ 1958.184549] nvmet_rdma: freeing queue 8828
[ 1958.184551] nvmet_rdma: freeing queue 8829
[ 1958.186632] nvmet_rdma: freeing queue 8830
[ 1958.198219] nvmet_rdma: freeing queue 8831
[ 1958.198486] nvmet_rdma: freeing queue 8832
[ 1958.198824] nvmet_rdma: freeing queue 8909
[ 1958.199004] nvmet_rdma: freeing queue 8910
[ 1958.199646] nvmet_rdma: freeing queue 8911
[ 1958.199939] nvmet_rdma: freeing queue 8912
[ 1958.200128] nvmet_rdma: freeing queue 8945
[ 1958.200307] nvmet_rdma: freeing queue 8946
[ 1958.200904] nvmet_rdma: freeing queue 8947
[ 1958.200906] nvmet_rdma: freeing queue 8948
[ 1958.200975] nvmet_rdma: freeing queue 8949
[ 1958.201303] nvmet_rdma: freeing queue 8968
[ 1958.201525] nvmet_rdma: freeing queue 9064
[ 1958.201527] nvmet_rdma: freeing queue 9065
[ 1958.201816] nvmet_rdma: freeing queue 9066
[ 1958.201931] nvmet_rdma: freeing queue 9067
[ 1958.202166] nvmet_rdma: freeing queue 9068
[ 1958.202545] nvmet_rdma: freeing queue 9069
[ 1958.202617] nvmet_rdma: freeing queue 9070
[ 1958.202917] nvmet_rdma: freeing queue 9089
[ 1958.202919] nvmet_rdma: freeing queue 9116
[ 1958.203292] nvmet_rdma: freeing queue 9117
[ 1958.203679] nvmet_rdma: freeing queue 9118
[ 1958.204071] nvmet_rdma: freeing queue 9119
[ 1958.204441] nvmet_rdma: freeing queue 9153
[ 1958.204631] nvmet_rdma: freeing queue 9154
[ 1958.204818] nvmet_rdma: freeing queue 9155
[ 1958.205004] nvmet_rdma: freeing queue 9181
[ 1958.205424] nvmet_rdma: freeing queue 9182
[ 1958.205426] nvmet_rdma: freeing queue 9183
[ 1958.205720] nvmet_rdma: freeing queue 9184
[ 1958.205965] nvmet_rdma: freeing queue 9185
[ 1958.206251] nvmet_rdma: freeing queue 9186
[ 1958.206603] nvmet_rdma: freeing queue 9187
[ 1958.206758] nvmet_rdma: freeing queue 9188
[ 1958.206928] nvmet_rdma: freeing queue 9189
[ 1958.207160] nvmet_rdma: freeing queue 9190
[ 1958.207413] nvmet_rdma: freeing queue 9251
[ 1958.207668] nvmet_rdma: freeing queue 9252
[ 1958.207759] nvmet_rdma: freeing queue 9253
[ 1958.208298] nvmet_rdma: freeing queue 9254
[ 1958.208654] nvmet_rdma: freeing queue 9255
[ 1958.208901] nvmet_rdma: freeing queue 9256
[ 1958.209199] nvmet_rdma: freeing queue 9257
[ 1958.209434] nvmet_rdma: freeing queue 9392
[ 1958.209560] nvmet_rdma: freeing queue 9426
[ 1958.209795] nvmet_rdma: freeing queue 9427
[ 1958.210331] nvmet_rdma: freeing queue 9513
[ 1958.210392] nvmet_rdma: freeing queue 9557
[ 1958.210530] nvmet_rdma: freeing queue 9558
[ 1958.210749] nvmet_rdma: freeing queue 9559
[ 1958.210967] nvmet_rdma: freeing queue 9560
[ 1958.211024] nvmet_rdma: freeing queue 9561
[ 1958.211153] nvmet_rdma: freeing queue 9562
[ 1958.211772] nvmet_rdma: freeing queue 9563
[ 1958.212022] nvmet_rdma: freeing queue 9564
[ 1958.212234] nvmet_rdma: freeing queue 9692
[ 1958.212302] nvmet_rdma: freeing queue 9716
[ 1958.212488] nvmet_rdma: freeing queue 9734
[ 1958.213065] nvmet_rdma: freeing queue 9774
[ 1958.213360] nvmet_rdma: freeing queue 9837
[ 1958.213648] nvmet_rdma: freeing queue 9914
[ 1958.213800] nvmet_rdma: freeing queue 9915
[ 1958.214625] nvmet_rdma: freeing queue 9916
[ 1958.214916] nvmet_rdma: freeing queue 9917
[ 1958.215304] nvmet_rdma: freeing queue 9918
[ 1958.215450] nvmet_rdma: freeing queue 9919
[ 1958.215814] nvmet_rdma: freeing queue 9920
[ 1958.216251] nvmet_rdma: freeing queue 9933
[ 1958.216317] nvmet_rdma: freeing queue 9934
[ 1958.218108] nvmet_rdma: freeing queue 9935
[ 1958.218302] nvmet_rdma: freeing queue 9936
[ 1958.218577] nvmet_rdma: freeing queue 9937
[ 1958.218764] nvmet_rdma: freeing queue 10006
[ 1958.218827] nvmet_rdma: freeing queue 10053
[ 1958.219598] nvmet_rdma: freeing queue 10054
[ 1958.219896] nvmet_rdma: freeing queue 10055
[ 1958.220220] nvmet_rdma: freeing queue 10056
[ 1958.220387] nvmet_rdma: freeing queue 10068
[ 1958.220747] nvmet_rdma: freeing queue 10069
[ 1958.220749] nvmet_rdma: freeing queue 10070
[ 1958.221019] nvmet_rdma: freeing queue 10071
[ 1958.221389] nvmet_rdma: freeing queue 10072
[ 1958.221914] nvmet_rdma: freeing queue 10073
[ 1958.221974] nvmet_rdma: freeing queue 10123
[ 1958.222159] nvmet_rdma: freeing queue 10155
[ 1958.222219] nvmet_rdma: freeing queue 10156
[ 1958.222494] nvmet_rdma: freeing queue 10157
[ 1958.222614] nvmet_rdma: freeing queue 10171
[ 1958.222863] nvmet_rdma: freeing queue 10172
[ 1958.222865] nvmet_rdma: freeing queue 10173
[ 1958.223000] nvmet_rdma: freeing queue 10174
[ 1958.223189] nvmet_rdma: freeing queue 10207
[ 1958.223191] nvmet_rdma: freeing queue 10208
[ 1958.223325] nvmet_rdma: freeing queue 10209
[ 1958.223381] nvmet_rdma: freeing queue 10210
[ 1958.227851] nvmet_rdma: freeing queue 10274
[ 1958.291863] nvmet_rdma: freeing queue 10275
[ 1958.303958] nvmet_rdma: freeing queue 1139
[ 1958.303962] nvmet_rdma: freeing queue 1157
[ 1958.303964] nvmet_rdma: freeing queue 1158
[ 1958.303966] nvmet_rdma: freeing queue 1159
[ 1958.305264] nvmet_rdma: freeing queue 1160
[ 1958.308353] nvmet_rdma: freeing queue 10276
[ 1958.308356] nvmet_rdma: freeing queue 10277
[ 1958.308360] nvmet_rdma: freeing queue 10486
[ 1958.308363] nvmet_rdma: freeing queue 10513
[ 1958.308365] nvmet_rdma: freeing queue 10514
[ 1958.308367] nvmet_rdma: freeing queue 10515
[ 1958.309450] nvmet_rdma: freeing queue 10527
[ 1958.312593] nvmet_rdma: freeing queue 1161
[ 1958.313260] nvmet_rdma: freeing queue 1176
[ 1958.314352] nvmet_rdma: freeing queue 1177
[ 1958.326761] nvmet_rdma: freeing queue 10528
[ 1958.326764] nvmet_rdma: freeing queue 10529
[ 1958.326766] nvmet_rdma: freeing queue 10530
[ 1958.326768] nvmet_rdma: freeing queue 10531
[ 1958.326771] nvmet_rdma: freeing queue 10532
[ 1958.328988] nvmet_rdma: freeing queue 10649
[ 1958.329561] nvmet_rdma: freeing queue 10650
[ 1958.403455] nvmet_rdma: freeing queue 10651
[ 1958.528675] nvmet_rdma: freeing queue 10652
[ 1958.534608] nvmet_rdma: freeing queue 10662
[ 1958.534848] nvmet_rdma: freeing queue 10663
[ 1958.534851] nvmet_rdma: freeing queue 10664
[ 1958.535259] nvmet_rdma: freeing queue 10665
[ 1958.535445] nvmet_rdma: freeing queue 10666
[ 1958.535504] nvmet_rdma: freeing queue 10667
[ 1958.535859] nvmet_rdma: freeing queue 10668
[ 1958.536149] nvmet_rdma: freeing queue 10669
[ 1958.538899] nvmet_rdma: freeing queue 10670
[ 1958.539792] nvmet_rdma: freeing queue 1178
[ 1958.540062] nvmet_rdma: freeing queue 1179
[ 1958.540282] nvmet_rdma: freeing queue 1180
[ 1958.540484] nvmet_rdma: freeing queue 1181
[ 1958.540883] nvmet_rdma: freeing queue 1183
[ 1958.540884] nvmet_rdma: freeing queue 1184
[ 1958.540931] nvmet_rdma: freeing queue 1185
[ 1958.540933] nvmet_rdma: freeing queue 1186
[ 1958.540934] nvmet_rdma: freeing queue 1187
[ 1958.541074] nvmet_rdma: freeing queue 1188
[ 1958.541293] nvmet_rdma: freeing queue 1189
[ 1958.541295] nvmet_rdma: freeing queue 1173
[ 1958.541429] nvmet_rdma: freeing queue 1191
[ 1958.541594] nvmet_rdma: freeing queue 1192
[ 1958.541815] nvmet_rdma: freeing queue 1193
[ 1958.541816] nvmet_rdma: freeing queue 1200
[ 1958.542084] nvmet_rdma: freeing queue 1201
[ 1958.542086] nvmet_rdma: freeing queue 1202
[ 1958.542212] nvmet_rdma: freeing queue 1203
[ 1958.542267] nvmet_rdma: freeing queue 1204
[ 1958.542340] nvmet_rdma: freeing queue 1205
[ 1958.542593] nvmet_rdma: freeing queue 1206
[ 1958.542642] nvmet_rdma: freeing queue 1190
[ 1958.542836] nvmet_rdma: freeing queue 1208
[ 1958.542838] nvmet_rdma: freeing queue 1209
[ 1958.542914] nvmet_rdma: freeing queue 1210
[ 1958.543049] nvmet_rdma: freeing queue 1211
[ 1958.543308] nvmet_rdma: freeing queue 1212
[ 1958.548628] nvmet_rdma: freeing queue 1213
[ 1958.549394] nvmet_rdma: freeing queue 1214
[ 1958.550342] nvmet_rdma: freeing queue 1215
[ 1958.550614] nvmet_rdma: freeing queue 1216
[ 1958.551751] nvmet_rdma: freeing queue 1217
[ 1958.551936] nvmet_rdma: freeing queue 1218
[ 1958.551989] nvmet_rdma: freeing queue 1219
[ 1958.552171] nvmet_rdma: freeing queue 1220
[ 1958.552173] nvmet_rdma: freeing queue 1221
[ 1958.552223] nvmet_rdma: freeing queue 1222
[ 1958.552793] nvmet_rdma: freeing queue 1223
[ 1958.552795] nvmet_rdma: freeing queue 1207
[ 1958.552810] nvmet_rdma: freeing queue 1225
[ 1958.552811] nvmet_rdma: freeing queue 1226
[ 1958.552813] nvmet_rdma: freeing queue 1227
[ 1958.552960] nvmet_rdma: freeing queue 1228
[ 1958.553016] nvmet_rdma: freeing queue 1233
[ 1958.553566] nvmet_rdma: freeing queue 1234
[ 1958.553675] nvmet_rdma: freeing queue 1235
[ 1958.553795] nvmet_rdma: freeing queue 1236
[ 1958.554848] nvmet_rdma: freeing queue 1237
[ 1958.554850] nvmet_rdma: freeing queue 1238
[ 1958.554851] nvmet_rdma: freeing queue 1239
[ 1958.554852] nvmet_rdma: freeing queue 1240
[ 1958.555444] nvmet_rdma: freeing queue 1224
[ 1958.556019] nvmet_rdma: freeing queue 1242
[ 1958.556124] nvmet_rdma: freeing queue 1243
[ 1958.557510] nvmet_rdma: freeing queue 1244
[ 1958.557522] nvmet_rdma: freeing queue 1245
[ 1958.557523] nvmet_rdma: freeing queue 1246
[ 1958.557734] nvmet_rdma: freeing queue 1247
[ 1958.557736] nvmet_rdma: freeing queue 1248
[ 1958.557904] nvmet_rdma: freeing queue 1250
[ 1958.558024] nvmet_rdma: freeing queue 1251
[ 1958.558245] nvmet_rdma: freeing queue 1252
[ 1958.558247] nvmet_rdma: freeing queue 1253
[ 1958.559069] nvmet_rdma: freeing queue 1254
[ 1958.559071] nvmet_rdma: freeing queue 1255
[ 1958.559073] nvmet_rdma: freeing queue 1256
[ 1958.559074] nvmet_rdma: freeing queue 1257
[ 1958.559075] nvmet_rdma: freeing queue 1241
[ 1958.559078] nvmet_rdma: freeing queue 1261
[ 1958.559080] nvmet_rdma: freeing queue 1262
[ 1958.559081] nvmet_rdma: freeing queue 1263
[ 1958.559082] nvmet_rdma: freeing queue 1264
[ 1958.559084] nvmet_rdma: freeing queue 1265
[ 1958.559295] nvmet_rdma: freeing queue 1266
[ 1958.559296] nvmet_rdma: freeing queue 1267
[ 1958.559470] nvmet_rdma: freeing queue 1268
[ 1958.559529] nvmet_rdma: freeing queue 1269
[ 1958.560700] nvmet_rdma: freeing queue 1270
[ 1958.560701] nvmet_rdma: freeing queue 1271
[ 1958.560703] nvmet_rdma: freeing queue 1272
[ 1958.560704] nvmet_rdma: freeing queue 1273
[ 1958.560705] nvmet_rdma: freeing queue 1274
[ 1958.560706] nvmet_rdma: freeing queue 1258
[ 1958.560709] nvmet_rdma: freeing queue 1276
[ 1958.560857] nvmet_rdma: freeing queue 1277
[ 1958.561031] nvmet_rdma: freeing queue 1278
[ 1958.561078] nvmet_rdma: freeing queue 1275
[ 1958.561206] nvmet_rdma: freeing queue 1293
[ 1958.561798] nvmet_rdma: freeing queue 1294
[ 1958.561799] nvmet_rdma: freeing queue 1295
[ 1958.561951] nvmet_rdma: freeing queue 1296
[ 1958.562017] nvmet_rdma: freeing queue 1297
[ 1958.562108] nvmet_rdma: freeing queue 1298
[ 1958.562230] nvmet_rdma: freeing queue 1299
[ 1958.562475] nvmet_rdma: freeing queue 1300
[ 1958.562525] nvmet_rdma: freeing queue 1301
[ 1958.562720] nvmet_rdma: freeing queue 1302
[ 1958.562841] nvmet_rdma: freeing queue 1303
[ 1958.563196] nvmet_rdma: freeing queue 1304
[ 1958.563197] nvmet_rdma: freeing queue 1305
[ 1958.563472] nvmet_rdma: freeing queue 1306
[ 1958.563473] nvmet_rdma: freeing queue 1307
[ 1958.563475] nvmet_rdma: freeing queue 1308
[ 1958.563721] nvmet_rdma: freeing queue 1292
[ 1958.563724] nvmet_rdma: freeing queue 1310
[ 1958.563923] nvmet_rdma: freeing queue 1311
[ 1958.563925] nvmet_rdma: freeing queue 1312
[ 1958.564049] nvmet_rdma: freeing queue 1313
[ 1958.564362] nvmet_rdma: freeing queue 1314
[ 1958.564364] nvmet_rdma: freeing queue 1315
[ 1958.564365] nvmet_rdma: freeing queue 1316
[ 1958.564414] nvmet_rdma: freeing queue 1319
[ 1958.564546] nvmet_rdma: freeing queue 1320
[ 1958.564712] nvmet_rdma: freeing queue 1321
[ 1958.564761] nvmet_rdma: freeing queue 1322
[ 1958.564883] nvmet_rdma: freeing queue 1323
[ 1958.565145] nvmet_rdma: freeing queue 1324
[ 1958.565380] nvmet_rdma: freeing queue 1325
[ 1958.565382] nvmet_rdma: freeing queue 1309
[ 1958.565438] nvmet_rdma: freeing queue 1336
[ 1958.565660] nvmet_rdma: freeing queue 1337
[ 1958.565717] nvmet_rdma: freeing queue 1338
[ 1958.566062] nvmet_rdma: freeing queue 1339
[ 1958.566064] nvmet_rdma: freeing queue 1340
[ 1958.566251] nvmet_rdma: freeing queue 1341
[ 1958.566301] nvmet_rdma: freeing queue 1342
[ 1958.566536] nvmet_rdma: freeing queue 1326
[ 1958.566587] nvmet_rdma: freeing queue 1344
[ 1958.566711] nvmet_rdma: freeing queue 1345
[ 1958.566963] nvmet_rdma: freeing queue 1346
[ 1958.566965] nvmet_rdma: freeing queue 1347
[ 1958.567156] nvmet_rdma: freeing queue 1348
[ 1958.567393] nvmet_rdma: freeing queue 1349
[ 1958.567394] nvmet_rdma: freeing queue 1350
[ 1958.567558] nvmet_rdma: freeing queue 1351
[ 1958.567616] nvmet_rdma: freeing queue 1352
[ 1958.567812] nvmet_rdma: freeing queue 1353
[ 1958.567862] nvmet_rdma: freeing queue 1354
[ 1958.568391] nvmet_rdma: freeing queue 1355
[ 1958.568571] nvmet_rdma: freeing queue 1356
[ 1958.568618] nvmet_rdma: freeing queue 1357
[ 1958.568744] nvmet_rdma: freeing queue 1358
[ 1958.568906] nvmet_rdma: freeing queue 1359
[ 1958.569026] nvmet_rdma: freeing queue 1343
[ 1958.569075] nvmet_rdma: freeing queue 1361
[ 1958.569318] nvmet_rdma: freeing queue 1362
[ 1958.569320] nvmet_rdma: freeing queue 1363
[ 1958.569614] nvmet_rdma: freeing queue 1364
[ 1958.569879] nvmet_rdma: freeing queue 1365
[ 1958.570145] nvmet_rdma: freeing queue 1366
[ 1958.570399] nvmet_rdma: freeing queue 1367
[ 1958.570513] nvmet_rdma: freeing queue 1368
[ 1958.570677] nvmet_rdma: freeing queue 1369
[ 1958.570724] nvmet_rdma: freeing queue 1370
[ 1958.570861] nvmet_rdma: freeing queue 1371
[ 1958.570909] nvmet_rdma: freeing queue 1372
[ 1958.571095] nvmet_rdma: freeing queue 1373
[ 1958.573786] nvmet_rdma: freeing queue 1374
[ 1958.573787] nvmet_rdma: freeing queue 1375
[ 1958.573966] nvmet_rdma: freeing queue 1376
[ 1958.574143] nvmet_rdma: freeing queue 1360
[ 1958.574146] nvmet_rdma: freeing queue 1378
[ 1958.574305] nvmet_rdma: freeing queue 1379
[ 1958.574364] nvmet_rdma: freeing queue 1380
[ 1958.574491] nvmet_rdma: freeing queue 1381
[ 1958.574684] nvmet_rdma: freeing queue 1382
[ 1958.574686] nvmet_rdma: freeing queue 1383
[ 1958.574840] nvmet_rdma: freeing queue 1384
[ 1958.575108] nvmet_rdma: freeing queue 1385
[ 1958.575277] nvmet_rdma: freeing queue 1386
[ 1958.575329] nvmet_rdma: freeing queue 1387
[ 1958.575615] nvmet_rdma: freeing queue 1388
[ 1958.575616] nvmet_rdma: freeing queue 1389
[ 1958.575678] nvmet_rdma: freeing queue 1390
[ 1958.575856] nvmet_rdma: freeing queue 1391
[ 1958.575911] nvmet_rdma: freeing queue 1392
[ 1958.576115] nvmet_rdma: freeing queue 1393
[ 1958.576163] nvmet_rdma: freeing queue 1377
[ 1958.576450] nvmet_rdma: freeing queue 1395
[ 1958.576452] nvmet_rdma: freeing queue 1396
[ 1958.576505] nvmet_rdma: freeing queue 1397
[ 1958.576740] nvmet_rdma: freeing queue 1398
[ 1958.576741] nvmet_rdma: freeing queue 1399
[ 1958.576935] nvmet_rdma: freeing queue 1400
[ 1958.577052] nvmet_rdma: freeing queue 1401
[ 1958.577208] nvmet_rdma: freeing queue 1402
[ 1958.577257] nvmet_rdma: freeing queue 1403
[ 1958.577382] nvmet_rdma: freeing queue 1404
[ 1958.577812] nvmet_rdma: freeing queue 1405
[ 1958.577813] nvmet_rdma: freeing queue 1406
[ 1958.577814] nvmet_rdma: freeing queue 1407
[ 1958.578097] nvmet_rdma: freeing queue 1408
[ 1958.578099] nvmet_rdma: freeing queue 1409
[ 1958.578100] nvmet_rdma: freeing queue 1410
[ 1958.578320] nvmet_rdma: freeing queue 1394
[ 1958.578323] nvmet_rdma: freeing queue 1412
[ 1958.578507] nvmet_rdma: freeing queue 1413
[ 1958.578569] nvmet_rdma: freeing queue 1414
[ 1958.578688] nvmet_rdma: freeing queue 1415
[ 1958.578905] nvmet_rdma: freeing queue 1416
[ 1958.578907] nvmet_rdma: freeing queue 1417
[ 1958.579036] nvmet_rdma: freeing queue 1418
[ 1958.579277] nvmet_rdma: freeing queue 1419
[ 1958.579279] nvmet_rdma: freeing queue 1420
[ 1958.579511] nvmet_rdma: freeing queue 1421
[ 1958.579675] nvmet_rdma: freeing queue 1422
[ 1958.579676] nvmet_rdma: freeing queue 1423
[ 1958.579879] nvmet_rdma: freeing queue 1424
[ 1958.580141] nvmet_rdma: freeing queue 1425
[ 1958.580188] nvmet_rdma: freeing queue 1426
[ 1958.580337] nvmet_rdma: freeing queue 1427
[ 1958.580486] nvmet_rdma: freeing queue 1411
[ 1958.580667] nvmet_rdma: freeing queue 1429
[ 1958.580731] nvmet_rdma: freeing queue 10682
[ 1958.580911] nvmet_rdma: freeing queue 1430
[ 1958.580970] nvmet_rdma: freeing queue 1431
[ 1958.581106] nvmet_rdma: freeing queue 10683
[ 1958.581262] nvmet_rdma: freeing queue 1432
[ 1958.581308] nvmet_rdma: freeing queue 1433
[ 1958.581519] nvmet_rdma: freeing queue 1434
[ 1958.581570] nvmet_rdma: freeing queue 10684
[ 1958.581697] nvmet_rdma: freeing queue 10685
[ 1958.581859] nvmet_rdma: freeing queue 10692
[ 1958.581909] nvmet_rdma: freeing queue 10739
[ 1958.582053] nvmet_rdma: freeing queue 10750
[ 1958.582225] nvmet_rdma: freeing queue 10751
[ 1958.582289] nvmet_rdma: freeing queue 10836
[ 1958.582507] nvmet_rdma: freeing queue 10837
[ 1958.582563] nvmet_rdma: freeing queue 10838
[ 1958.582838] nvmet_rdma: freeing queue 10921
[ 1958.582888] nvmet_rdma: freeing queue 10922
[ 1958.583330] nvmet_rdma: freeing queue 10923
[ 1958.583334] nvmet_rdma: freeing queue 10967
[ 1958.583336] nvmet_rdma: freeing queue 10971
[ 1958.583670] nvmet_rdma: freeing queue 10972
[ 1958.583672] nvmet_rdma: freeing queue 10973
[ 1958.583954] nvmet_rdma: freeing queue 10974
[ 1958.584132] nvmet_rdma: freeing queue 11021
[ 1958.584560] nvmet_rdma: freeing queue 11022
[ 1958.584769] nvmet_rdma: freeing queue 1435
[ 1958.585055] nvmet_rdma: freeing queue 1436
[ 1958.585208] nvmet_rdma: freeing queue 11023
[ 1958.585255] nvmet_rdma: freeing queue 11024
[ 1958.585457] nvmet_rdma: freeing queue 11079
[ 1958.585990] nvmet_rdma: freeing queue 1437
[ 1958.586171] nvmet_rdma: freeing queue 1438
[ 1958.586401] nvmet_rdma: freeing queue 1439
[ 1958.586408] nvmet: ctrl 574 keep-alive timer (15 seconds) expired!
[ 1958.586410] nvmet_rdma: freeing queue 11093
[ 1958.586523] nvmet_rdma: freeing queue 1440
[ 1958.586725] nvmet_rdma: freeing queue 1441
[ 1958.586727] nvmet_rdma: freeing queue 1442
[ 1958.586898] nvmet_rdma: freeing queue 1443
[ 1958.587183] nvmet_rdma: freeing queue 1444
[ 1958.587185] nvmet_rdma: freeing queue 1428
[ 1958.587356] nvmet_rdma: freeing queue 1446
[ 1958.587470] nvmet_rdma: freeing queue 1447
[ 1958.587557] nvmet_rdma: freeing queue 1448
[ 1958.587725] nvmet_rdma: freeing queue 11106
[ 1958.587860] nvmet_rdma: freeing queue 1449
[ 1958.626775] nvmet_rdma: freeing queue 1450
[ 1958.642159] nvmet_rdma: freeing queue 1451
[ 1958.645504] nvmet_rdma: freeing queue 1452
[ 1958.648757] nvmet_rdma: freeing queue 1453
[ 1958.657489] nvmet_rdma: freeing queue 1454
[ 1958.658064] nvmet_rdma: freeing queue 1455
[ 1958.658304] nvmet_rdma: freeing queue 1456
[ 1958.662392] nvmet_rdma: freeing queue 1457
[ 1958.662541] nvmet_rdma: freeing queue 1458
[ 1958.663519] nvmet_rdma: freeing queue 1459
[ 1958.665018] nvmet_rdma: freeing queue 11107
[ 1958.671119] nvmet_rdma: freeing queue 11108
[ 1958.687013] nvmet_rdma: freeing queue 1460
[ 1958.748740] nvmet_rdma: freeing queue 11109
[ 1958.748742] nvmet_rdma: freeing queue 11110
[ 1958.748801] nvmet_rdma: freeing queue 11144
[ 1958.748803] nvmet_rdma: freeing queue 11208
[ 1958.748804] nvmet_rdma: freeing queue 11209
[ 1958.748806] nvmet_rdma: freeing queue 11210
[ 1958.748808] nvmet_rdma: freeing queue 11211
[ 1958.748809] nvmet_rdma: freeing queue 11212
[ 1958.748810] nvmet_rdma: freeing queue 11275
[ 1958.748812] nvmet_rdma: freeing queue 11276
[ 1958.748814] nvmet_rdma: freeing queue 11277
[ 1958.748816] nvmet_rdma: freeing queue 11278
[ 1958.748817] nvmet_rdma: freeing queue 11279
[ 1958.748819] nvmet_rdma: freeing queue 11280
[ 1958.748820] nvmet_rdma: freeing queue 11439
[ 1958.748829] nvmet_rdma: freeing queue 11462
[ 1958.748832] nvmet_rdma: freeing queue 11463
[ 1958.748833] nvmet_rdma: freeing queue 11464
[ 1958.748834] nvmet_rdma: freeing queue 11465
[ 1958.748836] nvmet_rdma: freeing queue 11466
[ 1958.748837] nvmet_rdma: freeing queue 11467
[ 1958.748839] nvmet_rdma: freeing queue 11468
[ 1958.748840] nvmet_rdma: freeing queue 11469
[ 1958.748842] nvmet_rdma: freeing queue 11470
[ 1958.748843] nvmet_rdma: freeing queue 11471
[ 1958.748845] nvmet_rdma: freeing queue 11485
[ 1958.748846] nvmet_rdma: freeing queue 11503
[ 1958.748848] nvmet_rdma: freeing queue 11627
[ 1958.748850] nvmet_rdma: freeing queue 11649
[ 1958.748852] nvmet_rdma: freeing queue 11658
[ 1958.748854] nvmet_rdma: freeing queue 11732
[ 1958.748856] nvmet_rdma: freeing queue 11733
[ 1958.748857] nvmet_rdma: freeing queue 11734
[ 1958.748859] nvmet_rdma: freeing queue 11735
[ 1958.748860] nvmet_rdma: freeing queue 11737
[ 1958.748862] nvmet_rdma: freeing queue 11738
[ 1958.748866] nvmet: ctrl 614 keep-alive timer (15 seconds) expired!
[ 1958.748868] nvmet_rdma: freeing queue 11793
[ 1958.748870] nvmet_rdma: freeing queue 11838
[ 1958.748872] nvmet_rdma: freeing queue 11839
[ 1958.748873] nvmet_rdma: freeing queue 11840
[ 1958.748875] nvmet_rdma: freeing queue 11841
[ 1958.748877] nvmet_rdma: freeing queue 12022
[ 1958.748879] nvmet_rdma: freeing queue 12023
[ 1958.748880] nvmet_rdma: freeing queue 12024
[ 1958.748882] nvmet_rdma: freeing queue 12025
[ 1958.748884] nvmet_rdma: freeing queue 12026
[ 1958.748948] nvmet_rdma: freeing queue 12033
[ 1958.749109] nvmet_rdma: freeing queue 12145
[ 1958.760922] nvmet_rdma: freeing queue 12146
[ 1958.772839] nvmet_rdma: freeing queue 12210
[ 1958.775901] nvmet_rdma: freeing queue 12256
[ 1958.775904] nvmet_rdma: freeing queue 12265
[ 1958.775906] nvmet_rdma: freeing queue 12266
[ 1958.776573] nvmet_rdma: freeing queue 12267
[ 1958.777080] nvmet_rdma: freeing queue 12303
[ 1958.778298] nvmet_rdma: freeing queue 12333
[ 1958.779033] nvmet_rdma: freeing queue 12334
[ 1958.780596] nvmet_rdma: freeing queue 12358
[ 1958.780598] nvmet_rdma: freeing queue 12342
[ 1958.781824] nvmet_rdma: freeing queue 12385
[ 1958.781826] nvmet_rdma: freeing queue 12398
[ 1958.782063] nvmet_rdma: freeing queue 12399
[ 1958.783229] nvmet_rdma: freeing queue 12400
[ 1958.783799] nvmet_rdma: freeing queue 12401
[ 1958.784815] nvmet_rdma: freeing queue 12416
[ 1958.785467] nvmet_rdma: freeing queue 12417
[ 1958.786717] nvmet_rdma: freeing queue 12418
[ 1958.786718] nvmet_rdma: freeing queue 12419
[ 1958.787861] nvmet_rdma: freeing queue 12466
[ 1958.788189] nvmet_rdma: freeing queue 12467
[ 1958.788474] nvmet_rdma: freeing queue 12468
[ 1958.788477] nvmet_rdma: freeing queue 12469
[ 1958.788478] nvmet_rdma: freeing queue 12583
[ 1958.790242] nvmet_rdma: freeing queue 12584
[ 1958.790887] nvmet_rdma: freeing queue 12585
[ 1958.793186] nvmet_rdma: freeing queue 12586
[ 1958.793756] nvmet_rdma: freeing queue 12587
[ 1958.794326] nvmet_rdma: freeing queue 12588
[ 1958.794893] nvmet_rdma: freeing queue 12603
[ 1958.795741] nvmet_rdma: freeing queue 1461
[ 1958.797850] nvmet_rdma: freeing queue 12604
[ 1958.803302] nvmet_rdma: freeing queue 12605
[ 1958.806943] nvmet_rdma: freeing queue 12606
[ 1958.807447] nvmet_rdma: freeing queue 12607
[ 1958.808248] nvmet_rdma: freeing queue 12608
[ 1958.809985] nvmet_rdma: freeing queue 12669
[ 1958.810660] nvmet_rdma: freeing queue 12670
[ 1958.810661] nvmet_rdma: freeing queue 12671
[ 1958.811571] nvmet_rdma: freeing queue 1445
[ 1958.812769] nvmet_rdma: freeing queue 12672
[ 1958.813339] nvmet_rdma: freeing queue 12673
[ 1958.814071] nvmet_rdma: freeing queue 12674
[ 1958.815734] nvmet_rdma: freeing queue 12675
[ 1958.816876] nvmet_rdma: freeing queue 12692
[ 1958.817448] nvmet_rdma: freeing queue 12774
[ 1958.818589] nvmet_rdma: freeing queue 12834
[ 1958.819157] nvmet_rdma: freeing queue 12846
[ 1958.819728] nvmet_rdma: freeing queue 12895
[ 1958.835880] nvmet_rdma: freeing queue 12936
[ 1958.836084] nvmet_rdma: freeing queue 13077
[ 1958.836626] nvmet_rdma: freeing queue 13078
[ 1958.836629] nvmet_rdma: freeing queue 13079
[ 1958.836865] nvmet_rdma: freeing queue 13080
[ 1958.836951] nvmet_rdma: freeing queue 13081
[ 1958.837058] nvmet_rdma: freeing queue 13082
[ 1958.837215] nvmet_rdma: freeing queue 13083
[ 1958.837217] nvmet_rdma: freeing queue 13095
[ 1958.837301] nvmet_rdma: freeing queue 1463
[ 1958.837358] nvmet_rdma: freeing queue 13096
[ 1958.837471] nvmet_rdma: freeing queue 1464
[ 1958.837540] nvmet_rdma: freeing queue 13113
[ 1958.837604] nvmet_rdma: freeing queue 13114
[ 1958.837799] nvmet_rdma: freeing queue 13115
[ 1958.838019] nvmet_rdma: freeing queue 1465
[ 1958.838022] nvmet_rdma: freeing queue 1466
[ 1958.838226] nvmet_rdma: freeing queue 1467
[ 1958.838803] nvmet_rdma: freeing queue 1468
[ 1958.838884] nvmet_rdma: freeing queue 13116
[ 1958.839015] nvmet_rdma: freeing queue 1469
[ 1958.839049] nvmet_rdma: freeing queue 13148
[ 1958.839218] nvmet_rdma: freeing queue 13149
[ 1958.839381] nvmet_rdma: freeing queue 13160
[ 1958.839452] nvmet_rdma: freeing queue 13161
[ 1958.839523] nvmet_rdma: freeing queue 13162
[ 1958.839872] nvmet_rdma: freeing queue 13163
[ 1958.839874] nvmet_rdma: freeing queue 13164
[ 1958.839875] nvmet_rdma: freeing queue 13181
[ 1958.840062] nvmet_rdma: freeing queue 13182
[ 1958.840383] nvmet_rdma: freeing queue 13183
[ 1958.840384] nvmet_rdma: freeing queue 13184
[ 1958.840386] nvmet_rdma: freeing queue 13195
[ 1958.840388] nvmet_rdma: freeing queue 13196
[ 1958.840575] nvmet_rdma: freeing queue 13197
[ 1958.840577] nvmet_rdma: freeing queue 13214
[ 1958.840770] nvmet_rdma: freeing queue 13215
[ 1958.840772] nvmet_rdma: freeing queue 13216
[ 1958.840823] nvmet_rdma: freeing queue 13217
[ 1958.840978] nvmet_rdma: freeing queue 13333
[ 1958.841204] nvmet_rdma: freeing queue 13334
[ 1958.841206] nvmet_rdma: freeing queue 13335
[ 1958.841836] nvmet_rdma: freeing queue 13336
[ 1958.854992] nvmet_rdma: freeing queue 13416
[ 1958.855374] nvmet_rdma: freeing queue 13417
[ 1958.855646] nvmet_rdma: freeing queue 13418
[ 1958.855709] nvmet_rdma: freeing queue 13419
[ 1958.855899] nvmet_rdma: freeing queue 13432
[ 1958.855969] nvmet: ctrl 715 keep-alive timer (15 seconds) expired!
[ 1958.855971] nvmet_rdma: freeing queue 13556
[ 1958.856297] nvmet_rdma: freeing queue 13557
[ 1958.856298] nvmet_rdma: freeing queue 13558
[ 1958.856300] nvmet_rdma: freeing queue 13587
[ 1958.857150] nvmet_rdma: freeing queue 13588
[ 1958.857152] nvmet: ctrl 723 keep-alive timer (15 seconds) expired!
[ 1958.857153] nvmet_rdma: freeing queue 13624
[ 1958.857154] nvmet_rdma: freeing queue 13625
[ 1958.857721] nvmet_rdma: freeing queue 13617
[ 1958.859321] nvmet_rdma: freeing queue 13703
[ 1958.859322] nvmet_rdma: freeing queue 13704
[ 1958.859324] nvmet_rdma: freeing queue 13705
[ 1958.859325] nvmet_rdma: freeing queue 13706
[ 1958.859327] nvmet_rdma: freeing queue 13707
[ 1958.859328] nvmet_rdma: freeing queue 13708
[ 1958.859329] nvmet_rdma: freeing queue 13709
[ 1958.859331] nvmet_rdma: freeing queue 13710
[ 1958.859332] nvmet_rdma: freeing queue 13711
[ 1958.859334] nvmet_rdma: freeing queue 13721
[ 1958.859555] nvmet_rdma: freeing queue 13722
[ 1958.859556] nvmet_rdma: freeing queue 13723
[ 1958.859807] nvmet_rdma: freeing queue 13724
[ 1958.859809] nvmet_rdma: freeing queue 13725
[ 1958.860093] nvmet_rdma: freeing queue 13726
[ 1958.860242] nvmet_rdma: freeing queue 13727
[ 1958.860418] nvmet_rdma: freeing queue 13728
[ 1958.860487] nvmet_rdma: freeing queue 13729
[ 1958.860618] nvmet_rdma: freeing queue 13774
[ 1958.860761] nvmet_rdma: freeing queue 13775
[ 1958.860807] nvmet_rdma: freeing queue 13776
[ 1958.860958] nvmet_rdma: freeing queue 13777
[ 1958.861190] nvmet_rdma: freeing queue 13778
[ 1958.861192] nvmet_rdma: freeing queue 13779
[ 1958.861441] nvmet_rdma: freeing queue 13847
[ 1958.861776] nvmet_rdma: freeing queue 13848
[ 1958.861777] nvmet_rdma: freeing queue 13897
[ 1958.861779] nvmet_rdma: freeing queue 13898
[ 1958.861780] nvmet_rdma: freeing queue 13941
[ 1958.862331] nvmet_rdma: freeing queue 13967
[ 1958.862333] nvmet_rdma: freeing queue 14011
[ 1958.862334] nvmet_rdma: freeing queue 14012
[ 1958.862335] nvmet_rdma: freeing queue 14035
[ 1958.862337] nvmet_rdma: freeing queue 14041
[ 1958.862570] nvmet_rdma: freeing queue 14051
[ 1958.862572] nvmet_rdma: freeing queue 14085
[ 1958.862904] nvmet_rdma: freeing queue 14117
[ 1958.862906] nvmet_rdma: freeing queue 14118
[ 1958.862908] nvmet_rdma: freeing queue 14130
[ 1958.863647] nvmet_rdma: freeing queue 14134
[ 1958.863648] nvmet_rdma: freeing queue 14286
[ 1958.864163] nvmet_rdma: freeing queue 14287
[ 1958.864341] nvmet_rdma: freeing queue 14288
[ 1958.864538] nvmet_rdma: freeing queue 14472
[ 1958.864701] nvmet_rdma: freeing queue 14473
[ 1958.865457] nvmet_rdma: freeing queue 14474
[ 1958.866045] nvmet_rdma: freeing queue 14475
[ 1958.866046] nvmet_rdma: freeing queue 14509
[ 1958.866455] nvmet: ctrl 781 keep-alive timer (15 seconds) expired!
[ 1958.866457] nvmet: ctrl 786 keep-alive timer (15 seconds) expired!
[ 1958.866458] nvmet: ctrl 785 keep-alive timer (15 seconds) expired!
[ 1958.866459] nvmet_rdma: freeing queue 14675
[ 1958.866909] nvmet_rdma: freeing queue 14676
[ 1958.866975] nvmet_rdma: freeing queue 14677
[ 1958.867165] nvmet_rdma: freeing queue 14678
[ 1958.867308] nvmet_rdma: freeing queue 14679
[ 1958.867590] nvmet_rdma: freeing queue 14680
[ 1958.867592] nvmet_rdma: freeing queue 14761
[ 1958.867594] nvmet_rdma: freeing queue 14762
[ 1958.867851] nvmet_rdma: freeing queue 14763
[ 1958.867853] nvmet_rdma: freeing queue 14764
[ 1958.867855] nvmet_rdma: freeing queue 14837
[ 1958.868053] nvmet_rdma: freeing queue 14845
[ 1958.907053] nvmet_rdma: freeing queue 14846
[ 1958.907508] nvmet_rdma: freeing queue 14847
[ 1958.933626] nvmet_rdma: freeing queue 14848
[ 1958.934421] nvmet_rdma: freeing queue 14849
[ 1958.939417] nvmet_rdma: freeing queue 14850
[ 1958.939791] nvmet_rdma: freeing queue 14933
[ 1958.948985] nvmet_rdma: freeing queue 14934
[ 1958.954308] nvmet_rdma: freeing queue 14935
[ 1958.969573] nvmet_rdma: freeing queue 14936
[ 1958.989257] nvmet_rdma: freeing queue 14971
[ 1958.989393] nvmet: ctrl 804 keep-alive timer (15 seconds) expired!
[ 1958.989406] nvmet: ctrl 812 keep-alive timer (15 seconds) expired!
[ 1958.989408] nvmet_rdma: freeing queue 15184
[ 1958.996107] nvmet_rdma: freeing queue 15185
[ 1959.002320] nvmet_rdma: freeing queue 15186
[ 1959.060126] nvmet_rdma: freeing queue 1470
[ 1959.060128] nvmet_rdma: freeing queue 1471
[ 1959.060129] nvmet_rdma: freeing queue 1472
[ 1959.060131] nvmet_rdma: freeing queue 1473
[ 1959.060133] nvmet_rdma: freeing queue 1474
[ 1959.060134] nvmet_rdma: freeing queue 1475
[ 1959.060136] nvmet_rdma: freeing queue 1476
[ 1959.060137] nvmet_rdma: freeing queue 1477
[ 1959.060139] nvmet_rdma: freeing queue 1478
[ 1959.060140] nvmet_rdma: freeing queue 1462
[ 1959.060144] nvmet_rdma: freeing queue 1480
[ 1959.060145] nvmet_rdma: freeing queue 1481
[ 1959.060147] nvmet_rdma: freeing queue 1482
[ 1959.060148] nvmet_rdma: freeing queue 1483
[ 1959.060149] nvmet_rdma: freeing queue 1484
[ 1959.060150] nvmet_rdma: freeing queue 1485
[ 1959.060152] nvmet_rdma: freeing queue 1489
[ 1959.060154] nvmet_rdma: freeing queue 1490
[ 1959.060155] nvmet_rdma: freeing queue 1491
[ 1959.060157] nvmet_rdma: freeing queue 1492
[ 1959.060158] nvmet_rdma: freeing queue 1493
[ 1959.060160] nvmet_rdma: freeing queue 1494
[ 1959.061686] nvmet_rdma: freeing queue 1495
[ 1959.061786] nvmet_rdma: freeing queue 1479
[ 1959.062338] nvmet_rdma: freeing queue 1497
[ 1959.062378] nvmet_rdma: freeing queue 1498
[ 1959.062966] nvmet_rdma: freeing queue 1499
[ 1959.064125] nvmet_rdma: freeing queue 1500
[ 1959.065797] nvmet_rdma: freeing queue 1501
[ 1959.108554] nvmet_rdma: freeing queue 1502
[ 1959.108557] nvmet_rdma: freeing queue 1503
[ 1959.108558] nvmet_rdma: freeing queue 1504
[ 1959.108559] nvmet_rdma: freeing queue 1505
[ 1959.108561] nvmet_rdma: freeing queue 1506
[ 1959.108562] nvmet_rdma: freeing queue 1507
[ 1959.108563] nvmet_rdma: freeing queue 1508
[ 1959.108564] nvmet_rdma: freeing queue 1509
[ 1959.108566] nvmet_rdma: freeing queue 1510
[ 1959.108567] nvmet_rdma: freeing queue 1511
[ 1959.108568] nvmet_rdma: freeing queue 1512
[ 1959.108569] nvmet_rdma: freeing queue 1496
[ 1959.108573] nvmet_rdma: freeing queue 1514
[ 1959.108574] nvmet_rdma: freeing queue 1515
[ 1959.108575] nvmet_rdma: freeing queue 1516
[ 1959.108577] nvmet_rdma: freeing queue 1517
[ 1959.108578] nvmet_rdma: freeing queue 1523
[ 1959.108579] nvmet_rdma: freeing queue 1524
[ 1959.108580] nvmet_rdma: freeing queue 1525
[ 1959.108582] nvmet_rdma: freeing queue 1526
[ 1959.108583] nvmet_rdma: freeing queue 1527
[ 1959.108585] nvmet_rdma: freeing queue 1528
[ 1959.108586] nvmet_rdma: freeing queue 1529
[ 1959.108587] nvmet_rdma: freeing queue 1513
[ 1959.108590] nvmet_rdma: freeing queue 1531
[ 1959.108591] nvmet_rdma: freeing queue 1532
[ 1959.108592] nvmet_rdma: freeing queue 1533
[ 1959.108594] nvmet_rdma: freeing queue 1534
[ 1959.108595] nvmet_rdma: freeing queue 1535
[ 1959.108596] nvmet_rdma: freeing queue 1536
[ 1959.108597] nvmet_rdma: freeing queue 1537
[ 1959.108599] nvmet_rdma: freeing queue 1538
[ 1959.108600] nvmet_rdma: freeing queue 1539
[ 1959.108601] nvmet_rdma: freeing queue 1540
[ 1959.108602] nvmet_rdma: freeing queue 1541
[ 1959.108604] nvmet_rdma: freeing queue 1542
[ 1959.108605] nvmet_rdma: freeing queue 1543
[ 1959.108606] nvmet_rdma: freeing queue 1544
[ 1959.108870] nvmet_rdma: freeing queue 1545
[ 1959.108887] nvmet_rdma: freeing queue 1546
[ 1959.109120] nvmet_rdma: freeing queue 1530
[ 1959.109694] nvmet_rdma: freeing queue 1548
[ 1959.109967] nvmet_rdma: freeing queue 1549
[ 1959.110111] nvmet_rdma: freeing queue 1550
[ 1959.110173] nvmet_rdma: freeing queue 1551
[ 1959.110411] nvmet_rdma: freeing queue 1552
[ 1959.110413] nvmet_rdma: freeing queue 1553
[ 1959.110577] nvmet_rdma: freeing queue 1554
[ 1959.110579] nvmet_rdma: freeing queue 1555
[ 1959.110801] nvmet_rdma: freeing queue 1556
[ 1959.111009] nvmet_rdma: freeing queue 1557
[ 1959.111164] nvmet_rdma: freeing queue 1558
[ 1959.111332] nvmet_rdma: freeing queue 1559
[ 1959.111395] nvmet_rdma: freeing queue 1560
[ 1959.111656] nvmet_rdma: freeing queue 1561
[ 1959.111658] nvmet_rdma: freeing queue 1562
[ 1959.112137] nvmet_rdma: freeing queue 1563
[ 1959.124134] nvmet_rdma: freeing queue 1547
[ 1959.130901] nvmet_rdma: freeing queue 1565
[ 1959.132108] nvmet_rdma: freeing queue 1566
[ 1959.132109] nvmet_rdma: freeing queue 1567
[ 1959.132161] nvmet_rdma: freeing queue 1568
[ 1959.132985] nvmet_rdma: freeing queue 1569
[ 1959.133600] nvmet_rdma: freeing queue 1570
[ 1959.134384] nvmet_rdma: freeing queue 1571
[ 1959.134386] nvmet_rdma: freeing queue 1572
[ 1959.134531] nvmet_rdma: freeing queue 1573
[ 1959.134774] nvmet_rdma: freeing queue 1574
[ 1959.134775] nvmet_rdma: freeing queue 1575
[ 1959.134777] nvmet_rdma: freeing queue 1576
[ 1959.135555] nvmet_rdma: freeing queue 1577
[ 1959.135557] nvmet_rdma: freeing queue 1578
[ 1959.135718] nvmet_rdma: freeing queue 1579
[ 1959.135767] nvmet_rdma: freeing queue 1580
[ 1959.136977] nvmet_rdma: freeing queue 1564
[ 1959.137131] nvmet_rdma: freeing queue 1582
[ 1959.137768] nvmet_rdma: freeing queue 1583
[ 1959.137770] nvmet_rdma: freeing queue 1584
[ 1959.137963] nvmet_rdma: freeing queue 1585
[ 1959.138095] nvmet_rdma: freeing queue 15187
[ 1959.139190] nvmet_rdma: freeing queue 1586
[ 1959.139192] nvmet_rdma: freeing queue 1587
[ 1959.139999] nvmet_rdma: freeing queue 1588
[ 1959.140136] nvmet_rdma: freeing queue 15188
[ 1959.141091] nvmet_rdma: freeing queue 1589
[ 1959.141959] nvmet_rdma: freeing queue 15189
[ 1959.141962] nvmet_rdma: freeing queue 15190
[ 1959.144203] nvmet_rdma: freeing queue 15376
[ 1959.145857] nvmet_rdma: freeing queue 1590
[ 1959.145859] nvmet_rdma: freeing queue 1591
[ 1959.145860] nvmet_rdma: freeing queue 1592
[ 1959.145862] nvmet_rdma: freeing queue 1593
[ 1959.145863] nvmet_rdma: freeing queue 1594
[ 1959.146423] nvmet_rdma: freeing queue 1595
[ 1959.148700] nvmet_rdma: freeing queue 1596
[ 1959.152375] nvmet_rdma: freeing queue 1597
[ 1959.167160] nvmet_rdma: freeing queue 15377
[ 1959.167163] nvmet_rdma: freeing queue 15543
[ 1959.167165] nvmet_rdma: freeing queue 15544
[ 1959.167886] nvmet_rdma: freeing queue 15545
[ 1959.167888] nvmet_rdma: freeing queue 15546
[ 1959.169822] nvmet_rdma: freeing queue 15547
[ 1959.169824] nvmet: ctrl 839 keep-alive timer (15 seconds) expired!
[ 1959.169826] nvmet_rdma: freeing queue 15732
[ 1959.169827] nvmet_rdma: freeing queue 15733
[ 1959.169829] nvmet_rdma: freeing queue 15734
[ 1959.169830] nvmet_rdma: freeing queue 15852
[ 1959.169832] nvmet_rdma: freeing queue 15885
[ 1959.170158] nvmet_rdma: freeing queue 1581
[ 1959.170202] nvmet_rdma: freeing queue 15886
[ 1959.170205] nvmet_rdma: freeing queue 15990
[ 1959.170206] nvmet_rdma: freeing queue 15991
[ 1959.170457] nvmet: ctrl 867 keep-alive timer (15 seconds) expired!
[ 1959.170458] nvmet_rdma: freeing queue 16071
[ 1959.170804] nvmet_rdma: freeing queue 16072
[ 1959.170806] nvmet_rdma: freeing queue 16073
[ 1959.170807] nvmet_rdma: freeing queue 16074
[ 1959.171017] nvmet_rdma: freeing queue 16103
[ 1959.171243] nvmet_rdma: freeing queue 16104
[ 1959.171245] nvmet_rdma: freeing queue 16105
[ 1959.171248] nvmet_rdma: freeing queue 1599
[ 1959.171498] nvmet_rdma: freeing queue 16119
[ 1959.171500] nvmet_rdma: freeing queue 16120
[ 1959.171504] nvmet_rdma: freeing queue 1600
[ 1959.171688] nvmet_rdma: freeing queue 16121
[ 1959.171729] nvmet_rdma: freeing queue 1601
[ 1959.171797] nvmet_rdma: freeing queue 1602
[ 1959.172016] nvmet_rdma: freeing queue 16122
[ 1959.172087] nvmet_rdma: freeing queue 1603
[ 1959.172089] nvmet_rdma: freeing queue 1604
[ 1959.172240] nvmet_rdma: freeing queue 1605
[ 1959.172290] nvmet_rdma: freeing queue 1606
[ 1959.172470] nvmet_rdma: freeing queue 1607
[ 1959.172471] nvmet_rdma: freeing queue 1608
[ 1959.172655] nvmet_rdma: freeing queue 1609
[ 1959.172656] nvmet_rdma: freeing queue 1610
[ 1959.172675] nvmet_rdma: freeing queue 1611
[ 1959.172760] nvmet_rdma: freeing queue 1612
[ 1959.172935] nvmet_rdma: freeing queue 1613
[ 1959.173104] nvmet_rdma: freeing queue 1614
[ 1959.173716] nvmet_rdma: freeing queue 1598
[ 1959.173719] nvmet_rdma: freeing queue 1616
[ 1959.173846] nvmet_rdma: freeing queue 1617
[ 1959.174100] nvmet_rdma: freeing queue 1618
[ 1959.174148] nvmet_rdma: freeing queue 1619
[ 1959.174331] nvmet_rdma: freeing queue 1620
[ 1959.174450] nvmet_rdma: freeing queue 1621
[ 1959.174656] nvmet_rdma: freeing queue 1622
[ 1959.174658] nvmet_rdma: freeing queue 1624
[ 1959.174973] nvmet_rdma: freeing queue 1625
[ 1959.174974] nvmet_rdma: freeing queue 1626
[ 1959.175099] nvmet_rdma: freeing queue 1627
[ 1959.175161] nvmet_rdma: freeing queue 1628
[ 1959.175448] nvmet_rdma: freeing queue 1629
[ 1959.175449] nvmet_rdma: freeing queue 1630
[ 1959.175499] nvmet_rdma: freeing queue 1631
[ 1959.175500] nvmet_rdma: freeing queue 1615
[ 1959.175763] nvmet_rdma: freeing queue 1633
[ 1959.175765] nvmet_rdma: freeing queue 1634
[ 1959.175942] nvmet_rdma: freeing queue 1635
[ 1959.175998] nvmet_rdma: freeing queue 1636
[ 1959.176226] nvmet_rdma: freeing queue 1637
[ 1959.176228] nvmet_rdma: freeing queue 1638
[ 1959.176632] nvmet_rdma: freeing queue 1639
[ 1959.176634] nvmet_rdma: freeing queue 1640
[ 1959.176635] nvmet_rdma: freeing queue 1641
[ 1959.176790] nvmet_rdma: freeing queue 1642
[ 1959.176908] nvmet_rdma: freeing queue 1643
[ 1959.177207] nvmet_rdma: freeing queue 1644
[ 1959.177614] nvmet_rdma: freeing queue 1645
[ 1959.177616] nvmet_rdma: freeing queue 1659
[ 1959.177617] nvmet_rdma: freeing queue 1660
[ 1959.177793] nvmet_rdma: freeing queue 1661
[ 1959.177866] nvmet_rdma: freeing queue 1662
[ 1959.178056] nvmet_rdma: freeing queue 1663
[ 1959.178252] nvmet_rdma: freeing queue 1664
[ 1959.178301] nvmet_rdma: freeing queue 1665
[ 1959.178519] nvmet_rdma: freeing queue 1649
[ 1959.180223] nvmet_rdma: freeing queue 1667
[ 1959.180479] nvmet_rdma: freeing queue 1668
[ 1959.180720] nvmet_rdma: freeing queue 1669
[ 1959.180722] nvmet_rdma: freeing queue 1670
[ 1959.180770] nvmet_rdma: freeing queue 1671
[ 1959.181056] nvmet_rdma: freeing queue 1672
[ 1959.181230] nvmet_rdma: freeing queue 1673
[ 1959.181296] nvmet_rdma: freeing queue 16123
[ 1959.181437] nvmet_rdma: freeing queue 1674
[ 1959.181528] nvmet_rdma: freeing queue 1675
[ 1959.181795] nvmet_rdma: freeing queue 1676
[ 1959.181796] nvmet_rdma: freeing queue 1677
[ 1959.181922] nvmet_rdma: freeing queue 1678
[ 1959.182432] nvmet_rdma: freeing queue 1679
[ 1959.182588] nvmet_rdma: freeing queue 16124
[ 1959.182802] nvmet_rdma: freeing queue 1680
[ 1959.182924] nvmet_rdma: freeing queue 1681
[ 1959.183251] nvmet_rdma: freeing queue 1682
[ 1959.183253] nvmet_rdma: freeing queue 1666
[ 1959.183256] nvmet_rdma: freeing queue 1684
[ 1959.183846] nvmet_rdma: freeing queue 1685
[ 1959.184244] nvmet_rdma: freeing queue 1686
[ 1959.184245] nvmet_rdma: freeing queue 1687
[ 1959.184247] nvmet_rdma: freeing queue 1688
[ 1959.184248] nvmet_rdma: freeing queue 1689
[ 1959.184463] nvmet_rdma: freeing queue 1690
[ 1959.184464] nvmet_rdma: freeing queue 1691
[ 1959.184585] nvmet_rdma: freeing queue 1692
[ 1959.184693] nvmet_rdma: freeing queue 1693
[ 1959.185123] nvmet_rdma: freeing queue 1694
[ 1959.185124] nvmet_rdma: freeing queue 1695
[ 1959.185177] nvmet_rdma: freeing queue 1696
[ 1959.185300] nvmet_rdma: freeing queue 1697
[ 1959.185356] nvmet_rdma: freeing queue 1698
[ 1959.185543] nvmet_rdma: freeing queue 1699
[ 1959.185747] nvmet_rdma: freeing queue 1683
[ 1959.185750] nvmet_rdma: freeing queue 1701
[ 1959.185886] nvmet_rdma: freeing queue 1702
[ 1959.186064] nvmet_rdma: freeing queue 1709
[ 1959.186065] nvmet_rdma: freeing queue 1710
[ 1959.186222] nvmet_rdma: freeing queue 1711
[ 1959.186401] nvmet_rdma: freeing queue 1712
[ 1959.186453] nvmet_rdma: freeing queue 1713
[ 1959.186574] nvmet_rdma: freeing queue 1714
[ 1959.186726] nvmet_rdma: freeing queue 1715
[ 1959.186772] nvmet_rdma: freeing queue 1716
[ 1959.187151] nvmet_rdma: freeing queue 1700
[ 1959.187201] nvmet_rdma: freeing queue 1718
[ 1959.187203] nvmet_rdma: freeing queue 1719
[ 1959.187252] nvmet_rdma: freeing queue 1720
[ 1959.187385] nvmet_rdma: freeing queue 1721
[ 1959.187606] nvmet_rdma: freeing queue 1722
[ 1959.187608] nvmet_rdma: freeing queue 1727
[ 1959.187731] nvmet_rdma: freeing queue 1728
[ 1959.188062] nvmet_rdma: freeing queue 1729
[ 1959.188065] nvmet_rdma: freeing queue 1730
[ 1959.188066] nvmet_rdma: freeing queue 1731
[ 1959.188220] nvmet_rdma: freeing queue 1732
[ 1959.188392] nvmet_rdma: freeing queue 1733
[ 1959.188442] nvmet_rdma: freeing queue 1717
[ 1959.188562] nvmet_rdma: freeing queue 1735
[ 1959.188747] nvmet_rdma: freeing queue 1736
[ 1959.188749] nvmet_rdma: freeing queue 1737
[ 1959.188879] nvmet_rdma: freeing queue 1743
[ 1959.189145] nvmet_rdma: freeing queue 16125
[ 1959.189147] nvmet_rdma: freeing queue 16126
[ 1959.189283] nvmet_rdma: freeing queue 1744
[ 1959.189351] nvmet_rdma: freeing queue 16190
[ 1959.189513] nvmet_rdma: freeing queue 1745
[ 1959.189705] nvmet_rdma: freeing queue 1746
[ 1959.189707] nvmet_rdma: freeing queue 1747
[ 1959.264966] nvmet_rdma: freeing queue 16191
[ 1959.267786] nvmet_rdma: freeing queue 16197
[ 1959.267908] nvmet_rdma: freeing queue 1748
[ 1959.268115] nvmet_rdma: freeing queue 1749
[ 1959.268117] nvmet_rdma: freeing queue 1750
[ 1959.268216] nvmet_rdma: freeing queue 1734
[ 1959.268421] nvmet_rdma: freeing queue 1752
[ 1959.271894] nvmet_rdma: freeing queue 1753
[ 1959.292074] nvmet_rdma: freeing queue 16324
[ 1959.292076] nvmet_rdma: freeing queue 16325
[ 1959.292078] nvmet_rdma: freeing queue 16326
[ 1959.293038] nvmet_rdma: freeing queue 16327
[ 1959.313506] nvmet_rdma: freeing queue 16328
[ 1959.314637] nvmet_rdma: freeing queue 16329
[ 1959.315784] nvmet_rdma: freeing queue 16390
[ 1959.327436] nvmet_rdma: freeing queue 16423
[ 1959.328579] nvmet_rdma: freeing queue 16424
[ 1959.329149] nvmet_rdma: freeing queue 16425
[ 1959.329718] nvmet_rdma: freeing queue 16426
[ 1959.330289] nvmet_rdma: freeing queue 16427
[ 1959.332113] nvmet_rdma: freeing queue 16428
[ 1959.332114] nvmet_rdma: freeing queue 16429
[ 1959.333266] nvmet_rdma: freeing queue 1754
[ 1959.333509] nvmet_rdma: freeing queue 16430
[ 1959.333830] nvmet_rdma: freeing queue 16431
[ 1959.333831] nvmet_rdma: freeing queue 16432
[ 1959.337813] nvmet_rdma: freeing queue 16433
[ 1959.337815] nvmet_rdma: freeing queue 16434
[ 1959.337817] nvmet_rdma: freeing queue 16435
[ 1959.337818] nvmet_rdma: freeing queue 16436
[ 1959.341270] nvmet_rdma: freeing queue 16437
[ 1959.341272] nvmet_rdma: freeing queue 16438
[ 1959.341274] nvmet: ctrl 943 keep-alive timer (15 seconds) expired!
[ 1959.341282] nvmet: ctrl 275 fatal error occurred!
[ 1959.341283] nvmet: ctrl 574 fatal error occurred!
[ 1959.341284] nvmet: ctrl 614 fatal error occurred!
[ 1959.341285] nvmet: ctrl 715 fatal error occurred!
[ 1959.341286] nvmet: ctrl 723 fatal error occurred!
[ 1959.341287] nvmet: ctrl 781 fatal error occurred!
[ 1959.341288] nvmet: ctrl 786 fatal error occurred!
[ 1959.341289] nvmet: ctrl 785 fatal error occurred!
[ 1959.341289] nvmet: ctrl 804 fatal error occurred!
[ 1959.341290] nvmet: ctrl 812 fatal error occurred!
[ 1959.341291] nvmet: ctrl 839 fatal error occurred!
[ 1959.341291] nvmet: ctrl 867 fatal error occurred!
[ 1959.341292] nvmet: ctrl 943 fatal error occurred!
[ 1959.410219] nvmet_rdma: freeing queue 1755
[ 1959.410541] nvmet_rdma: freeing queue 1756
[ 1959.452500] nvmet_rdma: freeing queue 1757
[ 1959.452503] nvmet_rdma: freeing queue 1758
[ 1959.453171] nvmet_rdma: freeing queue 1759
[ 1959.453215] nvmet_rdma: freeing queue 1760
[ 1959.453429] nvmet_rdma: freeing queue 1761
[ 1959.544502] nvmet_rdma: freeing queue 1762
[ 1959.620661] nvmet_rdma: freeing queue 1763
[ 1959.620663] nvmet_rdma: freeing queue 1764
[ 1959.620664] nvmet_rdma: freeing queue 1765
[ 1959.620666] nvmet_rdma: freeing queue 1766
[ 1959.620667] nvmet_rdma: freeing queue 1767
[ 1959.620669] nvmet_rdma: freeing queue 1751
[ 1959.620673] nvmet_rdma: freeing queue 1769
[ 1959.620675] nvmet_rdma: freeing queue 1770
[ 1959.620676] nvmet_rdma: freeing queue 1771
[ 1959.620678] nvmet_rdma: freeing queue 1772
[ 1959.620679] nvmet_rdma: freeing queue 1773
[ 1959.620681] nvmet_rdma: freeing queue 1774
[ 1959.620682] nvmet_rdma: freeing queue 1775
[ 1959.620683] nvmet_rdma: freeing queue 1776
[ 1959.620685] nvmet_rdma: freeing queue 1777
[ 1959.620686] nvmet_rdma: freeing queue 1778
[ 1959.620687] nvmet_rdma: freeing queue 1779
[ 1959.620732] nvmet_rdma: freeing queue 1780
[ 1959.620734] nvmet_rdma: freeing queue 1781
[ 1959.620736] nvmet_rdma: freeing queue 1782
[ 1959.620737] nvmet_rdma: freeing queue 1783
[ 1959.620738] nvmet_rdma: freeing queue 1784
[ 1959.620740] nvmet_rdma: freeing queue 1768
[ 1959.620742] nvmet_rdma: freeing queue 1786
[ 1959.620743] nvmet_rdma: freeing queue 1787
[ 1959.620744] nvmet_rdma: freeing queue 1788
[ 1959.620746] nvmet_rdma: freeing queue 1789
[ 1959.620747] nvmet_rdma: freeing queue 1790
[ 1959.620748] nvmet_rdma: freeing queue 1795
[ 1959.620749] nvmet_rdma: freeing queue 1796
[ 1959.620751] nvmet_rdma: freeing queue 1797
[ 1959.620752] nvmet_rdma: freeing queue 1798
[ 1959.620754] nvmet_rdma: freeing queue 1799
[ 1959.719453] nvmet_rdma: freeing queue 1800
[ 1959.719455] nvmet_rdma: freeing queue 1801
[ 1959.719456] nvmet_rdma: freeing queue 1785
[ 1959.719461] nvmet_rdma: freeing queue 1803
[ 1959.719462] nvmet_rdma: freeing queue 1804
[ 1959.719464] nvmet_rdma: freeing queue 1805
[ 1959.719465] nvmet_rdma: freeing queue 1806
[ 1959.719726] nvmet_rdma: freeing queue 1807
[ 1959.719736] nvmet_rdma: freeing queue 1808
[ 1959.719737] nvmet_rdma: freeing queue 1809
[ 1959.719739] nvmet_rdma: freeing queue 1810
[ 1959.719740] nvmet_rdma: freeing queue 1811
[ 1959.719741] nvmet_rdma: freeing queue 1812
[ 1959.719743] nvmet_rdma: freeing queue 1813
[ 1959.719744] nvmet_rdma: freeing queue 1814
[ 1959.719746] nvmet_rdma: freeing queue 1815
[ 1959.719747] nvmet_rdma: freeing queue 1816
[ 1959.719748] nvmet_rdma: freeing queue 1817
[ 1959.719749] nvmet_rdma: freeing queue 1818
[ 1959.719751] nvmet_rdma: freeing queue 1802
[ 1959.719754] nvmet_rdma: freeing queue 1820
[ 1959.719755] nvmet_rdma: freeing queue 1821
[ 1959.719757] nvmet_rdma: freeing queue 1822
[ 1959.719758] nvmet_rdma: freeing queue 1823
[ 1959.719760] nvmet_rdma: freeing queue 1824
[ 1959.719761] nvmet_rdma: freeing queue 1825
[ 1959.719763] nvmet_rdma: freeing queue 1826
[ 1959.719764] nvmet_rdma: freeing queue 1827
[ 1959.719765] nvmet_rdma: freeing queue 1828
[ 1959.719767] nvmet_rdma: freeing queue 1829
[ 1959.719768] nvmet_rdma: freeing queue 1830
[ 1959.719769] nvmet_rdma: freeing queue 1831
[ 1959.719771] nvmet_rdma: freeing queue 1832
[ 1959.719772] nvmet_rdma: freeing queue 1833
[ 1959.719824] nvmet_rdma: freeing queue 1834
[ 1959.719826] nvmet_rdma: freeing queue 1835
[ 1959.719827] nvmet_rdma: freeing queue 1837
[ 1959.719829] nvmet_rdma: freeing queue 1838
[ 1959.719830] nvmet_rdma: freeing queue 1839
[ 1959.719832] nvmet_rdma: freeing queue 1840
[ 1959.719834] nvmet_rdma: freeing queue 1841
[ 1959.719835] nvmet_rdma: freeing queue 1842
[ 1959.719837] nvmet_rdma: freeing queue 1843
[ 1959.719839] nvmet_rdma: freeing queue 1844
[ 1959.719840] nvmet_rdma: freeing queue 1845
[ 1959.719842] nvmet_rdma: freeing queue 1846
[ 1959.719844] nvmet_rdma: freeing queue 1847
[ 1959.719845] nvmet_rdma: freeing queue 1848
[ 1959.719847] nvmet_rdma: freeing queue 1849
[ 1959.719848] nvmet_rdma: freeing queue 1850
[ 1959.719850] nvmet_rdma: freeing queue 1851
[ 1959.720176] nvmet_rdma: freeing queue 1852
[ 1959.720178] nvmet_rdma: freeing queue 1836
[ 1959.720372] nvmet_rdma: freeing queue 1854
[ 1959.720419] nvmet_rdma: freeing queue 1855
[ 1959.720616] nvmet_rdma: freeing queue 1856
[ 1959.720631] nvmet_rdma: freeing queue 1857
[ 1959.720875] nvmet_rdma: freeing queue 1858
[ 1959.720924] nvmet_rdma: freeing queue 1859
[ 1959.721107] nvmet_rdma: freeing queue 1860
[ 1959.721189] nvmet_rdma: freeing queue 1861
[ 1959.721460] nvmet_rdma: freeing queue 1862
[ 1959.721462] nvmet_rdma: freeing queue 1863
[ 1959.721463] nvmet_rdma: freeing queue 1864
[ 1959.721619] nvmet_rdma: freeing queue 1865
[ 1959.721680] nvmet_rdma: freeing queue 1866
[ 1959.721952] nvmet_rdma: freeing queue 1867
[ 1959.721955] nvmet_rdma: freeing queue 1868
[ 1959.722140] nvmet_rdma: freeing queue 1869
[ 1959.722196] nvmet_rdma: freeing queue 1853
[ 1959.722265] nvmet_rdma: freeing queue 1871
[ 1959.722521] nvmet_rdma: freeing queue 1872
[ 1959.722523] nvmet_rdma: freeing queue 1873
[ 1959.722872] nvmet_rdma: freeing queue 1874
[ 1959.722874] nvmet_rdma: freeing queue 1875
[ 1959.723107] nvmet_rdma: freeing queue 1876
[ 1959.724657] nvmet_rdma: freeing queue 1877
[ 1959.725226] nvmet_rdma: freeing queue 1878
[ 1959.725396] nvmet_rdma: freeing queue 1879
[ 1959.725454] nvmet_rdma: freeing queue 1880
[ 1959.725789] nvmet_rdma: freeing queue 1890
[ 1959.725791] nvmet_rdma: freeing queue 1891
[ 1959.726277] nvmet_rdma: freeing queue 1897
[ 1959.726520] nvmet_rdma: freeing queue 1898
[ 1959.726522] nvmet_rdma: freeing queue 1899
[ 1959.726735] nvmet_rdma: freeing queue 1900
[ 1959.726787] nvmet_rdma: freeing queue 1901
[ 1959.726910] nvmet_rdma: freeing queue 1902
[ 1959.727066] nvmet_rdma: freeing queue 1903
[ 1959.727133] nvmet_rdma: freeing queue 1887
[ 1959.727307] nvmet_rdma: freeing queue 1905
[ 1959.727309] nvmet_rdma: freeing queue 1906
[ 1959.727449] nvmet_rdma: freeing queue 1907
[ 1959.727601] nvmet_rdma: freeing queue 1908
[ 1959.727901] nvmet_rdma: freeing queue 1909
[ 1959.728126] nvmet_rdma: freeing queue 1910
[ 1959.728664] nvmet_rdma: freeing queue 1911
[ 1959.728665] nvmet_rdma: freeing queue 1912
[ 1959.728793] nvmet_rdma: freeing queue 1913
[ 1959.728962] nvmet_rdma: freeing queue 1914
[ 1959.729113] nvmet_rdma: freeing queue 1915
[ 1959.729352] nvmet_rdma: freeing queue 1916
[ 1959.729353] nvmet_rdma: freeing queue 1917
[ 1959.729467] nvmet_rdma: freeing queue 1918
[ 1959.729663] nvmet_rdma: freeing queue 1919
[ 1959.729798] nvmet_rdma: freeing queue 1920
[ 1959.729968] nvmet_rdma: freeing queue 1904
[ 1959.730091] nvmet_rdma: freeing queue 1922
[ 1959.730152] nvmet_rdma: freeing queue 1923
[ 1959.730426] nvmet_rdma: freeing queue 1924
[ 1959.730427] nvmet_rdma: freeing queue 1925
[ 1959.730599] nvmet_rdma: freeing queue 1926
[ 1959.730662] nvmet_rdma: freeing queue 1927
[ 1959.730794] nvmet_rdma: freeing queue 1928
[ 1959.731013] nvmet_rdma: freeing queue 1929
[ 1959.731015] nvmet_rdma: freeing queue 1930
[ 1959.731199] nvmet_rdma: freeing queue 1931
[ 1959.731375] nvmet_rdma: freeing queue 1932
[ 1959.731377] nvmet_rdma: freeing queue 1933
[ 1959.731547] nvmet_rdma: freeing queue 1934
[ 1959.731731] nvmet_rdma: freeing queue 1935
[ 1959.731781] nvmet_rdma: freeing queue 1936
[ 1959.731908] nvmet_rdma: freeing queue 1937
[ 1959.732071] nvmet_rdma: freeing queue 1921
[ 1959.732132] nvmet_rdma: freeing queue 1939
[ 1959.732300] nvmet_rdma: freeing queue 1940
[ 1959.732301] nvmet_rdma: freeing queue 1947
[ 1959.732494] nvmet_rdma: freeing queue 1948
[ 1959.732544] nvmet_rdma: freeing queue 1949
[ 1959.732811] nvmet_rdma: freeing queue 1950
[ 1959.732813] nvmet_rdma: freeing queue 1951
[ 1959.733088] nvmet_rdma: freeing queue 1952
[ 1959.733090] nvmet_rdma: freeing queue 1953
[ 1959.733138] nvmet_rdma: freeing queue 1954
[ 1959.733313] nvmet_rdma: freeing queue 1938
[ 1959.733434] nvmet_rdma: freeing queue 1958
[ 1959.733590] nvmet_rdma: freeing queue 1965
[ 1959.733660] nvmet_rdma: freeing queue 1966
[ 1959.733749] nvmet_rdma: freeing queue 1967
[ 1959.733939] nvmet_rdma: freeing queue 1968
[ 1959.734373] nvmet_rdma: freeing queue 1969
[ 1959.734375] nvmet_rdma: freeing queue 1970
[ 1959.734376] nvmet_rdma: freeing queue 1971
[ 1959.734377] nvmet_rdma: freeing queue 1955
[ 1959.734620] nvmet_rdma: freeing queue 1990
[ 1959.734621] nvmet_rdma: freeing queue 1991
[ 1959.734865] nvmet_rdma: freeing queue 1992
[ 1959.735076] nvmet_rdma: freeing queue 1993
[ 1959.735077] nvmet_rdma: freeing queue 1994
[ 1959.735244] nvmet_rdma: freeing queue 1995
[ 1959.735472] nvmet_rdma: freeing queue 1996
[ 1959.735473] nvmet_rdma: freeing queue 1997
[ 1959.735710] nvmet_rdma: freeing queue 1998
[ 1959.735711] nvmet_rdma: freeing queue 1999
[ 1959.735901] nvmet_rdma: freeing queue 2000
[ 1959.735950] nvmet_rdma: freeing queue 2001
[ 1959.736158] nvmet_rdma: freeing queue 1989
[ 1959.736212] nvmet_rdma: freeing queue 2007
[ 1959.736335] nvmet_rdma: freeing queue 2008
[ 1959.736493] nvmet_rdma: freeing queue 2009
[ 1959.736539] nvmet_rdma: freeing queue 2010
[ 1959.736685] nvmet_rdma: freeing queue 2011
[ 1959.736850] nvmet_rdma: freeing queue 2012
[ 1959.737088] nvmet_rdma: freeing queue 2016
[ 1959.737362] nvmet_rdma: freeing queue 2017
[ 1959.737408] nvmet_rdma: freeing queue 2018
[ 1959.737547] nvmet_rdma: freeing queue 2019
[ 1959.737781] nvmet_rdma: freeing queue 2020
[ 1959.738066] nvmet_rdma: freeing queue 2021
[ 1959.738231] nvmet_rdma: freeing queue 2022
[ 1959.738233] nvmet_rdma: freeing queue 2006
[ 1959.738458] nvmet_rdma: freeing queue 2024
[ 1959.738460] nvmet_rdma: freeing queue 2025
[ 1959.738836] nvmet_rdma: freeing queue 2026
[ 1959.739052] nvmet_rdma: freeing queue 2027
[ 1959.739185] nvmet_rdma: freeing queue 2028
[ 1959.739393] nvmet_rdma: freeing queue 2029
[ 1959.739395] nvmet_rdma: freeing queue 2041
[ 1959.739517] nvmet_rdma: freeing queue 2042
[ 1959.739927] nvmet_rdma: freeing queue 2043
[ 1959.740163] nvmet_rdma: freeing queue 2044
[ 1959.740288] nvmet_rdma: freeing queue 2058
[ 1959.740438] nvmet_rdma: freeing queue 2059
[ 1959.740490] nvmet_rdma: freeing queue 2060
[ 1959.740692] nvmet_rdma: freeing queue 2061
[ 1959.740748] nvmet_rdma: freeing queue 2062
[ 1959.740870] nvmet_rdma: freeing queue 2063
[ 1959.741020] nvmet_rdma: freeing queue 2064
[ 1959.741070] nvmet_rdma: freeing queue 2065
[ 1959.741200] nvmet_rdma: freeing queue 2066
[ 1959.741421] nvmet_rdma: freeing queue 2067
[ 1959.741422] nvmet_rdma: freeing queue 2068
[ 1959.741550] nvmet_rdma: freeing queue 2069
[ 1959.741726] nvmet_rdma: freeing queue 2070
[ 1959.741788] nvmet_rdma: freeing queue 2071
[ 1959.741948] nvmet_rdma: freeing queue 2072
[ 1959.742196] nvmet_rdma: freeing queue 2073
[ 1959.742217] nvmet_rdma: freeing queue 2057
[ 1959.742384] nvmet_rdma: freeing queue 2075
[ 1959.742568] nvmet_rdma: freeing queue 2076
[ 1959.742696] nvmet_rdma: freeing queue 2077
[ 1959.742910] nvmet_rdma: freeing queue 2078
[ 1959.742912] nvmet_rdma: freeing queue 2092
[ 1959.743041] nvmet_rdma: freeing queue 2093
[ 1959.743236] nvmet_rdma: freeing queue 2094
[ 1959.806664] nvmet_rdma: freeing queue 2095
[ 1959.819265] nvmet_rdma: freeing queue 2096
[ 1959.819268] nvmet_rdma: freeing queue 2097
[ 1959.819269] nvmet_rdma: freeing queue 2098
[ 1959.819270] nvmet_rdma: freeing queue 2099
[ 1959.819272] nvmet_rdma: freeing queue 2100
[ 1959.819273] nvmet_rdma: freeing queue 2101
[ 1959.819274] nvmet_rdma: freeing queue 2102
[ 1959.819861] nvmet_rdma: freeing queue 2103
[ 1959.820489] nvmet_rdma: freeing queue 2104
[ 1959.860351] nvmet_rdma: freeing queue 2105
[ 1959.860354] nvmet_rdma: freeing queue 2106
[ 1959.860539] nvmet_rdma: freeing queue 2107
[ 1959.897321] nvmet_rdma: freeing queue 2091
[ 1959.940070] nvmet_rdma: freeing queue 2109
[ 1959.940216] nvmet_rdma: freeing queue 2110
[ 1959.950695] nvmet_rdma: freeing queue 2111
[ 1959.993821] nvmet_rdma: freeing queue 2112
[ 1959.993823] nvmet_rdma: freeing queue 2113
[ 1959.993825] nvmet_rdma: freeing queue 2114
[ 1959.993826] nvmet_rdma: freeing queue 2115
[ 1959.993827] nvmet_rdma: freeing queue 2116
[ 1959.993828] nvmet_rdma: freeing queue 2117
[ 1959.993830] nvmet_rdma: freeing queue 2118
[ 1959.993831] nvmet_rdma: freeing queue 2119
[ 1959.993832] nvmet_rdma: freeing queue 2120
[ 1959.993833] nvmet_rdma: freeing queue 2121
[ 1959.993835] nvmet_rdma: freeing queue 2122
[ 1959.993836] nvmet_rdma: freeing queue 2123
[ 1959.993837] nvmet_rdma: freeing queue 2124
[ 1959.993839] nvmet_rdma: freeing queue 2108
[ 1959.993842] nvmet_rdma: freeing queue 2126
[ 1959.993844] nvmet_rdma: freeing queue 2127
[ 1959.993845] nvmet_rdma: freeing queue 2128
[ 1959.993846] nvmet_rdma: freeing queue 2129
[ 1959.993847] nvmet_rdma: freeing queue 2130
[ 1959.993849] nvmet_rdma: freeing queue 2131
[ 1959.993850] nvmet_rdma: freeing queue 2132
[ 1959.993851] nvmet_rdma: freeing queue 2133
[ 1959.993852] nvmet_rdma: freeing queue 2134
[ 1959.993853] nvmet_rdma: freeing queue 2135
[ 1959.993854] nvmet_rdma: freeing queue 2136
[ 1959.995223] nvmet_rdma: freeing queue 2137
[ 1960.055065] nvmet_rdma: freeing queue 2138
[ 1960.055125] nvmet_rdma: freeing queue 2139
[ 1960.058259] nvmet_rdma: freeing queue 2140
[ 1960.058262] nvmet_rdma: freeing queue 2141
[ 1960.160018] nvmet_rdma: freeing queue 2125
[ 1960.160022] nvmet_rdma: freeing queue 2143
[ 1960.160024] nvmet_rdma: freeing queue 2144
[ 1960.160025] nvmet_rdma: freeing queue 2145
[ 1960.160026] nvmet_rdma: freeing queue 2152
[ 1960.160028] nvmet_rdma: freeing queue 2153
[ 1960.160029] nvmet_rdma: freeing queue 2154
[ 1960.160030] nvmet_rdma: freeing queue 2155
[ 1960.160032] nvmet_rdma: freeing queue 2156
[ 1960.160033] nvmet_rdma: freeing queue 2157
[ 1960.160034] nvmet_rdma: freeing queue 2158
[ 1960.160036] nvmet_rdma: freeing queue 2142
[ 1960.160038] nvmet_rdma: freeing queue 2160
[ 1960.160040] nvmet_rdma: freeing queue 2161
[ 1960.160041] nvmet_rdma: freeing queue 2162
[ 1960.160042] nvmet_rdma: freeing queue 2163
[ 1960.160043] nvmet_rdma: freeing queue 2164
[ 1960.160045] nvmet_rdma: freeing queue 2165
[ 1960.160046] nvmet_rdma: freeing queue 2166
[ 1960.160047] nvmet_rdma: freeing queue 2167
[ 1960.160049] nvmet_rdma: freeing queue 2168
[ 1960.160050] nvmet_rdma: freeing queue 2159
[ 1960.160053] nvmet_rdma: freeing queue 2177
[ 1960.160054] nvmet_rdma: freeing queue 2178
[ 1960.160055] nvmet_rdma: freeing queue 2186
[ 1960.160057] nvmet_rdma: freeing queue 2187
[ 1960.160058] nvmet_rdma: freeing queue 2188
[ 1960.160059] nvmet_rdma: freeing queue 2189
[ 1960.160061] nvmet_rdma: freeing queue 2190
[ 1960.160062] nvmet_rdma: freeing queue 2191
[ 1960.160063] nvmet_rdma: freeing queue 2192
[ 1960.160065] nvmet_rdma: freeing queue 2176
[ 1960.160068] nvmet_rdma: freeing queue 2194

--------------573D2BC0FFF58B2526243DF5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
