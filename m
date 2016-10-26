From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Wed, 26 Oct 2016 10:20:53 -0600
Message-ID: <20161026162053.GE24898@obsidianresearch.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477487048-62256-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 09:04:02PM +0800, Lijun Ou wrote:
> +static struct ibv_device *hns_roce_driver_init(const char *uverbs_sys_path,
> +					       int abi_version)
> +{
> +	struct hns_roce_device  *dev;
> +	char			 value[128];
> +	int			 i;
> +
> +	if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
> +				value, sizeof(value)) > 0)
> +		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
> +			if (!strcmp(value, acpi_table[i].hid))
> +				goto found;

You shouldn't need to do both modalias and compatible, there should be
an acceptable modalias for the DT version too.

But I wonder if this isn't generically better to be

 last_dir(readlink("device/driver")) == "hns"

instead?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
