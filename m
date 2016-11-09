From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Wed, 9 Nov 2016 21:10:31 +0800
Message-ID: <58232047.4060709@huawei.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com> <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com> <58130573.4010902@huawei.com>
 <20161028164030.GA17289@obsidianresearch.com> <5813F869.7010606@huawei.com>
 <20161107231532.GB7002@obsidianresearch.com> <20161108125441.GB27883@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161108125441.GB27883-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/11/8 20:54, Leon Romanovsky 写道:
> On Mon, Nov 07, 2016 at 04:15:32PM -0700, Jason Gunthorpe wrote:
>> On Sat, Oct 29, 2016 at 09:16:25AM +0800, oulijun wrote:
>>
>>> We hope that the only one userspace library file named
>>> libhns-rdmav2.so will be used for the different hardware
>>> version(hip06, hip07, ...), because there are only little change
>>> between their userspace drivers. So we need to distinguish hardware
>>> version.
>>
>> I guess that makes sense, but you still need to be able to parse dt
>> compatible strings that are lists.
> 
> IMHO, it can be easily done as follow up patches.
> 
Hi, Leon & Jason
   We hope that the only one userspace library file named libhns-rdmav2.so will be used for the different hardware version(hip06, hip07, ...),
because there are only little change between their userspace drivers. So we need to distinguish hardware version.
We can't distinguish them if only matching driver name "hns_roce".

It will be matched it when appeared the second hard version, the code will be fixed as follows:
 firstly, we will add a hca_table structure:
 static struct {
	unsigned int		vendor;
	unsigned int		device;
	void			*data;
	int			version;
} hca_table[] = {
	{PCI_VENDOR_ID_HISILICON, 0xA223, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
	{PCI_VENDOR_ID_HISILICON, 0xA224, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
	{PCI_VENDOR_ID_HISILICON, 0xA225, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
	{PCI_VENDOR_ID_HISILICON, 0xA226, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
	{PCI_VENDOR_ID_HISILICON, 0xA227, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
	{PCI_VENDOR_ID_HISILICON, 0xA22F, &hns_roce_u_hw_v2, HNS_ROCE_HW_VER2},
};

second, we will distinguish with it by hca_table[]:
   if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
				value, sizeof(value)) > 0)
		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
			if (!strcmp(value, acpi_table[i].hid)) {
				u_hw = acpi_table[i].data;
				hw_version = acpi_table[i].version;
				goto found;
			}

	if (ibv_read_sysfs_file(uverbs_sys_path, "device/of_node/compatible",
				value, sizeof(value)) > 0)
		for (i = 0; i < sizeof(dt_table) / sizeof(dt_table[0]); ++i)
			if (!strcmp(value, dt_table[i].compatible)) {
				u_hw = dt_table[i].data;
				hw_version = dt_table[i].version;
				goto found;
			}

	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device", value,
				sizeof(value)) < 0)
		return NULL;

	sscanf(value, "%i", &vendor);

	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor", value,
				sizeof(value)) < 0)
		return NULL;

	sscanf(value, "%i", &vendor);

	for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i)
		if (vendor == hca_table[i].vendor &&
		    device == hca_table[i].device)
			goto found;

for using the path "device/of_node/compatible" when startup by DT method with hip06,
the content of compatible can only match with the device id and name in the hns-roce.ko:
static const struct of_device_id hns_roce_of_match[] = {
	{ .compatible = "hisilicon,hns-roce-v1", .data = &hns_roce_hw_v1, },
	{},
};
hence, we think that it will be distinguished by found the string("hisilicon, hns-roce-v1") in
/../../../device/of_node/compatible

When the userspace library of hns support hip07 or hip 08, the so file is still libhns-rdmav2.so and
will be used simultaneously for hip06 and hip07 or hip08 etc.

Lijun Ou
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
