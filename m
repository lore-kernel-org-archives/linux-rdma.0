From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Thu, 1 Jun 2017 12:59:39 +0100
Message-ID: <7a4e8dce-f1af-d664-bb0b-062f84b45b60@synopsys.com>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
 <20170531194426.GA23120@infradead.org>
 <20170601043013.GN5406@mtr-leonro.local>
 <09d8f6bc-5994-82d1-9a0f-59540b6c525f@synopsys.com>
 <fbb4b7cb-e3e4-b540-22e4-5d920857e8fe@synopsys.com>
 <52727D4A-F647-4924-8DF0-4D7F248626AA@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52727D4A-F647-4924-8DF0-4D7F248626AA-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> 
>> After search in /sys I found the mellanox device mlx5_0
> 
>> (/sys/class/infiniband/mlx5_0/) and was able to execute ibstat on it:
> 
>>
> 
>> #  ibstat mlx5_0
> 
>> CA 'mlx5_0'
> 
>>        CA type: MT4121
> 
>>        Number of ports: 1
> 
>>        Firmware version: 16.19.21102
> 
>>        Hardware version: 0
> 
>>        Node GUID: 0x248a070300aa8466
> 
>>        System image GUID: 0x248a070300aa8466
> 
>>        Port 1:
> 
>>                State: Down
> 
>>                Physical state: Disabled
> 
>>                Rate: 10
> 
>>                Base lid: 65535
> 
>>                LMC: 0
> 
>>                SM lid: 0
> 
>>                Capability mask: 0x2651e848
> 
>>                Port GUID: 0x248a070300aa8466
> 
>>                Link layer: InfiniBand
> 
>> #
> 
>> #
> 
>> # pwd
> 
>>
> 
>> Shouldn't the device be visible in /dev?
> 
> Hi Joao,
> 
> 
> 
> I'm glad this solved your issue.
> 
> Under dev you will not see Mellanox devices. They are visible only under the sysfs path you found.
> 
> In /dev you might see the mst devices if you have mst running..

Thanks for the help Majd! I suggest the driver uses the 0 profile by default to
avoid this kind of meomory problems. What do you think? I can make a patch for
it if you agree.

Thanks.

> 
>>
> 
>> Thanks.
> 
>>
> 
>> --
> 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> 
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIGaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=s2fO0hii0OGNOv9qQy_HRXy-xAJUD1NNoEcc3io_kx0&m=MZ71e2hCV-Ipb5oWcgk4I1Z6_Wd8shDLv1AtVKJPigw&s=EvobH0aYP1erS-5GZpBL5Zpabx5LMnEJWTRExwPWSdY&e= 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
