From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Thu, 27 Oct 2016 11:41:35 +0800
Message-ID: <5811776F.20908@huawei.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161026162053.GE24898-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/27 0:20, Jason Gunthorpe 写道:
> On Wed, Oct 26, 2016 at 09:04:02PM +0800, Lijun Ou wrote:
>> +static struct ibv_device *hns_roce_driver_init(const char *uverbs_sys_path,
>> +					       int abi_version)
>> +{
>> +	struct hns_roce_device  *dev;
>> +	char			 value[128];
>> +	int			 i;
>> +
>> +	if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
>> +				value, sizeof(value)) > 0)
>> +		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
>> +			if (!strcmp(value, acpi_table[i].hid))
>> +				goto found;
> 
> You shouldn't need to do both modalias and compatible, there should be
> an acceptable modalias for the DT version too.
> 
when startup by DT, the content of device/modalias is of:NinfinibandT<NULL>Chisilicon,hns-roce-v1.
it is long and complex. the content of device/of_node/compatible is hisilicon,hns-roce-v1
when startup by APCI, the content of device/modalias is acpi:HISI00D1:
Hence, we decide to adopt the above approach to  distinguish the device. when adding a device of pcie
in v2, we will add a condition branch to distinguish it, as follows:
   if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
			value, sizeof(value)) > 0)
		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
		if (!strcmp(value, acpi_table[i].hid))
			goto found;

....
  if (ibv_read_sysfs-file(uverbs_sys_path, "device/vendor", value, sizeof(value)) > 0)
	...
  if (ibv_read_sysfs-file(uverbs_sys_path, "device/vendor", value, sizeof(value)) > 0)
 	...

> But I wonder if this isn't generically better to be
> 
>  last_dir(readlink("device/driver")) == "hns"
> 
> instead?
> Jason
> 
I think it is not insteaded. because it will be find the hns in the path(device/driver)
As follows:
when startup by DT, the content of device/driver is:
root@(none)$ cat /sys/class/infiniband/hns_0/device/driver/
bind module/ unbind
c4000000.infiniband/ uevent
root@(none)$ cat /sys/class/infiniband/hns_0/device/driver/
>

when startup by ACPI, the content of device/driver is:
root@(none)$ cat /sys/class/infiniband/hns_0/device/driver/
HISI00D1:00/ bind module/ uevent unbind
root@(none)$ cat /sys/class/infiniband/hns_0/device/driver/
cat: read error: Is a directory

thanks
Lijun Ou
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
