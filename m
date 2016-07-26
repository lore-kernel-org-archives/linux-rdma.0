From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx5 driver load error
Date: Tue, 26 Jul 2016 10:29:42 -0700
Message-ID: <CAF1ivSbYMxe8CE87KrzM9SRV7UD030chhfNPzMxd=ODq48zgvw@mail.gmail.com>
References: <CAF1ivSa1vtCzGX7tkyTwxQr7zbSZ-e=p8vJPFT=DANS7ZaE_eA@mail.gmail.com>
 <20160725070059.GA20674@leon.nu> <CAF1ivSZarECVv9J2epbtmhgD9txfhZXGRiAnCpVPh+rP4ib3PQ@mail.gmail.com>
 <c8b50608-12cd-25ac-2dac-fadf06d5a2e1@mellanox.com> <CAF1ivSZ=a46t7HFxBDKv5FdW+NPeXqJqi3bCunrVDh+_BwkYog@mail.gmail.com>
 <232a2b7a-8832-4baf-f595-73c39cc5d3df@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <232a2b7a-8832-4baf-f595-73c39cc5d3df-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 25, 2016 at 11:49 PM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> On 7/25/2016 11:40 PM, Ming Lin wrote:
>>
>> On Mon, Jul 25, 2016 at 2:01 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> On 7/25/2016 10:28 AM, Ming Lin wrote:
>>>>
>>>>
>>>> On Mon, Jul 25, 2016 at 12:00 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> wrote:
>>>>>
>>>>>
>>>>> On Thu, Jul 21, 2016 at 03:54:31PM -0700, Ming Lin wrote:
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I build k.o/for-4.8 branch(commit fb92d8fb1b9). But mlx5 driver
>>>>>> doesn't
>>>>>> work.
>>>>>>
>>>>>> root@host:~# lspci |grep -i mellanox
>>>>>> 03:00.0 Ethernet controller: Mellanox Technologies MT27700 Family
>>>>>> [ConnectX-4]
>>>>>> 03:00.1 Ethernet controller: Mellanox Technologies MT27700 Family
>>>>>> [ConnectX-4]
>>>>>>
>>>>>> root@host:~# dmesg |grep -i mlx5
>>>>>> [    3.833348] mlx5_core 0000:03:00.0: firmware version: 12.12.1100
>>>>>> [    4.024478] mlx5_core 0000:03:00.0: enable hca failed
>>>>>> [    4.260086] mlx5_core 0000:03:00.0: mlx5_load_one failed with error
>>>>>> code -5
>>>>>> [    4.333568] mlx5_core: probe of 0000:03:00.0 failed with error -5
>>>>>> [    4.339977] mlx5_core 0000:03:00.1: firmware version: 12.12.1100
>>>>>> [    4.410366] mlx5_core 0000:03:00.1: enable hca failed
>>>>>> [    4.562862] mlx5_core 0000:03:00.1: mlx5_load_one failed with error
>>>>>> code -5
>>>
>>>
>>> Hi Ming,
>>>
>>> Did you upgrade the Firmware as well?
>>
>>
>> It works after upgrading firmware.
>
> Hi Ming,
>
> I didn't mean that you need to upgrade the firmware to make this work.
> I wanted to understand if alongside with driver upgrade you did a firmware
> upgrade.

The original firmware is 12.12.1100.

12.12.1100 + v4.4 kernel: not work
12.12.1100 + v4.7-rc2 kernel: not work

12.16.1020 + v4.4 kernel: works
12.16.1020 + v4.7-rc2: works

>
>>
>> Thanks.
>>
>>> Did it work before the kernel upgrade?
>>> Do you work in pass-through mode?
>>> Does cold reboot resolve the issue?
>>>
>>> Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
