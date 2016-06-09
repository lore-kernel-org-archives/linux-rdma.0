From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 12/13] IB/core: Export a common fw_ver sysfs entry
Date: Thu, 9 Jun 2016 16:40:38 -0600
Message-ID: <20160609224038.GB13366@obsidianresearch.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
 <1465509248-11324-13-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465509248-11324-13-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 05:54:07PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>  
> +static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	char tmp[ETHTOOL_FWVERS_LEN];
> +	struct ib_device *dev = container_of(device, struct ib_device, dev);
> +
> +	ib_get_device_fw_str(dev, tmp, sizeof(tmp));
> +
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", tmp);

No need to use the stack:

ib_get_device_fw_str(dev, buf, PAGE_SIZE);
strlcat(buf, "", PAGE_SIZE);
return strlen(buf);

>  	&dev_attr_node_guid,
> -	&dev_attr_node_desc
> +	&dev_attr_node_desc,
> +	&dev_attr_fw_ver

Should be 
 +	&dev_attr_fw_ver,

Note trailing comma. Avoids git churn like the above on append.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
