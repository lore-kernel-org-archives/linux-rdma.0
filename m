From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/5] IB/core: Add support for extended query
 device caps
Date: Tue, 4 Nov 2014 14:35:09 +0200
Message-ID: <5458C7FD.7070400@mellanox.com>
References: <1415001766-8366-1-git-send-email-eli@mellanox.com> <1415001766-8366-3-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415001766-8366-3-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/11/2014 10:02, Eli Cohen wrote:
> +int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
> +			      struct ib_udata *ucore,
> +			      struct ib_udata *uhw)
> +{
> +	struct ib_uverbs_ex_query_device_resp resp;
> +	struct ib_uverbs_ex_query_device  cmd;
> +	struct ib_device_attr attr;
> +	struct ib_device *device;
> +	int err;
> +
> +	device = file->device->ib_dev;
> +	if (ucore->inlen < sizeof(cmd))
> +		return -EINVAL;
> +
> +	if (ucore->outlen < sizeof(resp))
> +		return -ENOSPC;

This check may cause compatibility problems when running a newer kernel
with old userspace. The userspace code will have a smaller
ib_uverbs_ex_query_device_resp struct, so the verb will always fail. A
possible solution is to drop this check, and modify ib_copy_to_udata so
that it only copies up to ucore->outlen bytes.

> +
> +	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
> +	if (err)
> +		return err;
> +
> +	if (cmd.comp_mask)
> +		return -EINVAL;

This check may make it difficult for userspace to use this verb. If
running an older kernel with a newer userspace, the userspace will need
to run the verb multiple times to find out which combination of
comp_mask bits is actually supported. I think a better way would be to
drop this check, and let userspace rely on the returned comp_mask in the
ib_uverbs_ex_query_device_resp struct to determine which features are
supported by the current kernel.

> +
> +	err = device->query_device(device, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	copy_query_dev_fields(file, &resp.base, &attr);
> +	resp.comp_mask = 0;
> +
> +	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
