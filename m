From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Fri, 28 Oct 2016 15:28:06 +0800
Message-ID: <5812FE06.7030406@huawei.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com> <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161027145139.GD6818-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/27 22:51, Jason Gunthorpe 写道:
> On Thu, Oct 27, 2016 at 11:41:35AM +0800, oulijun wrote:
> 
>> when startup by DT, the content of device/modalias is
>> of:NinfinibandT<NULL>Chisilicon,hns-roce-v1.  it is long and
>> complex.
> 
> If you want to match the hardware then properly parsing the mod alias
> is the right way to do it.
> 
>> the content of device/of_node/compatible is hisilicon,hns-roce-v1
> 
> No, it is more complex than that, future DTs may have a list for
> instance, just a string match is not good enough
> 
>> when startup by APCI, the content of device/modalias is
>> acpi:HISI00D1:
> 
> Also may be more complex..
> 
>>   if (ibv_read_sysfs-file(uverbs_sys_path, "device/vendor", value, sizeof(value)) > 0)
>> 	...
>>   if (ibv_read_sysfs-file(uverbs_sys_path, "device/vendor", value, sizeof(value)) > 0)
>>  	...
> 
> You can also match PCI with modalias.
> 
>>> But I wonder if this isn't generically better to be
>>>
>>>  last_dir(readlink("device/driver")) == "hns"
>>>
> 
>> I think it is not insteaded. because it will be find the hns in the
>> path(device/driver)
> 
> I said readlink, which will return something like '../../../../bus/platform/drivers/hhns'
> 
> So just detect the driver is calld hhns and let the kernel deal with
> figuring it out.
> 
> Jason
> 
> .
> 
Hi, Jason
  I have verified it according to your advice and learned the readlink. i think that it need to
exist the file, as follows:
   xx -> /xxxx/../../

but not have it.
rs/t@(none)$ cd /sys/class/infiniband/hns_0/device/driver/module/driver
root@(none)$ ls
platform:hns_roce

I try to read the result of readlink(), but it is fail:
readlink("/sys/class/infiniband/hns_0/device/driver/module/driver", buf, sizeof *buf)

in addition that, the last() is not exit in C library.

Lijun Ou


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
