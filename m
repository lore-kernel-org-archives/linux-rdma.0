From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: MLX5 iSER issue on 4.6?
Date: Sun, 29 May 2016 15:05:57 +0300
Message-ID: <574ADB25.8080903@mellanox.com>
References: <CAANLjFpPoynQeBiQjZ=2RA1YHaNp3jZKtavZ5URWcsJu+x85vA@mail.gmail.com>
 <574A930E.6030507@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574A930E.6030507-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 5/29/2016 9:58 AM, Sagi Grimberg wrote:
>
>> I've been running iSER on 4.1/4.4 with a Connect-IB and ConnectX-3 and
>> everything works fine. When running the 4.6 kernel, the Connect-IB
>> card aren't able to login to iSER even though the ConnectX-3 card does
>> just fine. Hopefully, someone here has an idea of what the issue may
>> be. For this test, we are making 12 sessions to the same host (three
>> ports on each host, four sessions per port). Only four sessions become
>> established which correlate to the ConnectX-3 card. It doesn't seem to
>> matter which kernel the target is on, only the initiator.
>>
>> 02:00.0 Network controller: Mellanox Technologies MT27500 Family
>> [ConnectX-3]
>> 81:00.0 Infiniband controller: Mellanox Technologies MT27600 [Connect-IB]
>
> Hi Robert, thanks for reporting.
>
> The difference in iSER in 4.6 is the arbitrary SG registration support
> which works with a capable device (IB_DEVICE_SG_GAPS_REG). The CIB does
> not support this feature but CX4 does, however, I wander if your CIB
> falsely reports it does support this feature.

Sagi your'e right.
I repro this bug and saw that we alloc mr with:
mr_type = IB_MR_TYPE_SG_GAPS (means that IB_DEVICE_SG_GAPS_REG cap is on).
We also never call blk_queue_virt_boundary(sdev->request_queue, 
~MASK_4K); because of this false cap.

>
> Can you share the output of ibv_devinfo -v on the CIB device? I'm
> specifically interested in knowing what the max_mw is? it should
> be 0, if its not I suspect this is a FW bug.

  ibv_devinfo -v | grep max_mw
         max_mw:                         0


>
> CC'ing some mellanox folks.
>
>>
>> # mstflint -d 02:00.0 q
>> Image type:      FS2
>> FW Version:      2.35.5100
>> Rom Info:        type=PXE version=3.4.648 devid=4099
>> Device ID:       4099
>> Description:     Node             Port1            Port2
>> Sys image
>> GUIDs:           0cc47affff4fea34 0cc47affff4fea35 0cc47affff4fea36
>> 0cc47affff4fea37
>> MACs:                                 0cc47a4fea35     0cc47a4fea36
>> VSD:             n/a
>> PSID:            SM_2221000001000
>> # mstflint -d 81:00.0 q
>> Image type:      FS3
>> FW Version:      10.0014.1100
>> FW Release Date: 31.1.2016
>> Product Version: rel-10_14_1100
>> Description:     UID                GuidsNumber  Step
>> Base GUID1:      e41d2d030000e010        8       1
>> Base GUID2:      e41d2d030000e018        8       1
>> Base MAC1:       0000e41d2d00e010        8       1
>> Base MAC2:       0000e41d2d00e018        8       1
>> Image VSD:
>> Device VSD:
>> PSID:            MT_1210110019
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
