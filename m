From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 18 Nov 2014 16:40:42 +0200
Message-ID: <546B5A6A.2050806@mellanox.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com> <1416312682-7899-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416312682-7899-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 2:11 PM, Yishai Hadas wrote:
> @@ -599,6 +638,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   	struct ib_uverbs_file *file = filp->private_data;
>   	struct ib_uverbs_cmd_hdr hdr;
>   	__u32 flags;
> +	int srcu_key;
> +	ssize_t ret;
>   
>   	if (count < sizeof hdr)
>   		return -EINVAL;
> @@ -606,6 +647,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   	if (copy_from_user(&hdr, buf, sizeof hdr))
>   		return -EFAULT;
>   
> +	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
> +	if (file->device->disassociated) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
>   	flags = (hdr.command &
>   		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
>   
> @@ -613,26 +660,36 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   		__u32 command;
>   
>   		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> -					   IB_USER_VERBS_CMD_COMMAND_MASK))
> -			return -EINVAL;
> +					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}

put this change and it's such in a pre-patch that does refactoring of 
the ib_uverbs_write() code, to make the volume and amount of changes 
introduced by this patch smaller

>   
>   		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
>   
>   		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
> -		    !uverbs_cmd_table[command])
> -			return -EINVAL;
> +		    !uverbs_cmd_table[command]) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
>   		if (!file->ucontext &&
> -		    command != IB_USER_VERBS_CMD_GET_CONTEXT)
> -			return -EINVAL;
> +		    command != IB_USER_VERBS_CMD_GET_CONTEXT) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
> -		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command)))
> -			return -ENOSYS;
> +		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command))) {
> +			ret = -ENOSYS;
> +			goto out;
> +		}
>   
> -		if (hdr.in_words * 4 != count)
> -			return -EINVAL;
> +		if (hdr.in_words * 4 != count) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
> -		return uverbs_cmd_table[command](file,
> +		ret = uverbs_cmd_table[command](file,
>   						 buf + sizeof(hdr),
>   						 hdr.in_words * 4,
>   						 hdr.out_words * 4);
> @@ -647,47 +704,69 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   		size_t written_count = count;
>   
>   		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> -					   IB_USER_VERBS_CMD_COMMAND_MASK))
> -			return -EINVAL;
> +					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
>   		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
>   
>   		if (command >= ARRAY_SIZE(uverbs_ex_cmd_table) ||
> -		    !uverbs_ex_cmd_table[command])
> -			return -ENOSYS;
> +		    !uverbs_ex_cmd_table[command]) {
> +			ret = -ENOSYS;
> +			goto out;
> +		}
>   
> -		if (!file->ucontext)
> -			return -EINVAL;
> +		if (!file->ucontext) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
> -		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
> -			return -ENOSYS;
> +		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
> +			ret = -ENOSYS;
> +			goto out;
> +		}
>   
> -		if (count < (sizeof(hdr) + sizeof(ex_hdr)))
> -			return -EINVAL;
> +		if (count < (sizeof(hdr) + sizeof(ex_hdr))) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
> -		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr)))
> -			return -EFAULT;
> +		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr))) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
>   
>   		count -= sizeof(hdr) + sizeof(ex_hdr);
>   		buf += sizeof(hdr) + sizeof(ex_hdr);
>   
> -		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count)
> -			return -EINVAL;
> +		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
> -		if (ex_hdr.cmd_hdr_reserved)
> -			return -EINVAL;
> +		if (ex_hdr.cmd_hdr_reserved) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
>   		if (ex_hdr.response) {
> -			if (!hdr.out_words && !ex_hdr.provider_out_words)
> -				return -EINVAL;
> +			if (!hdr.out_words && !ex_hdr.provider_out_words) {
> +				ret = -EINVAL;
> +				goto out;
> +			}
>   
>   			if (!access_ok(VERIFY_WRITE,
>   				       (void __user *) (unsigned long) ex_hdr.response,
> -				       (hdr.out_words + ex_hdr.provider_out_words) * 8))
> -				return -EFAULT;
> +				       (hdr.out_words + ex_hdr.provider_out_words) * 8)) {
> +				ret = -EFAULT;
> +				goto out;
> +			}
>   		} else {
> -			if (hdr.out_words || ex_hdr.provider_out_words)
> -				return -EINVAL;
> +			if (hdr.out_words || ex_hdr.provider_out_words) {
> +				ret = -EINVAL;
> +				goto out;
> +			}
>   		}
>   
>   		INIT_UDATA_BUF_OR_NULL(&ucore, buf, (unsigned long) ex_hdr.response,
> @@ -704,22 +783,37 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>   						   &uhw);
>   
>   		if (err)
> -			return err;
> -
> -		return written_count;
> +			ret = err;
> +		else
> +			ret = written_count;
> +	} else {
> +		ret = -ENOSYS;
>   	}
>   
> -	return -ENOSYS;
> +out:
> +	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
> +	return ret;
>   }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
