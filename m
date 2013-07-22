From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Mon, 22 Jul 2013 13:46:22 +0200
Message-ID: <51ED1B8E.7070703@acm.org>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374153931-7313-8-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/18/13 15:25, Or Gerlitz wrote:
> +static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
> +			    struct iser_conn *ib_conn,
> +			    struct iser_regd_buf *regd_buf,
> +			    u32 offset, unsigned int data_size,
> +			    unsigned int page_list_len)
> +{
> +	struct ib_send_wr fastreg_wr, inv_wr;
> +	struct ib_send_wr *bad_wr, *wr = NULL;
> +	u8 key;
> +	int ret;
> +
> +	if (!desc->valid) {
> +		memset(&inv_wr, 0, sizeof(inv_wr));
> +		inv_wr.opcode = IB_WR_LOCAL_INV;
> +		inv_wr.send_flags = IB_SEND_SIGNALED;
> +		inv_wr.ex.invalidate_rkey = desc->data_mr->rkey;
> +		wr = &inv_wr;
> +		/* Bump the key */
> +		key = (u8)(desc->data_mr->rkey & 0x000000FF);
> +		ib_update_fast_reg_key(desc->data_mr, ++key);
> +	}
> +
> +	/* Prepare FASTREG WR */
> +	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
> +	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
> +	fastreg_wr.send_flags = IB_SEND_SIGNALED;
> +	fastreg_wr.wr.fast_reg.iova_start = desc->data_frpl->page_list[0] + offset;
> +	fastreg_wr.wr.fast_reg.page_list = desc->data_frpl;
> +	fastreg_wr.wr.fast_reg.page_list_len = page_list_len;
> +	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
> +	fastreg_wr.wr.fast_reg.length = data_size;
> +	fastreg_wr.wr.fast_reg.rkey = desc->data_mr->rkey;
> +	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
> +					       IB_ACCESS_REMOTE_WRITE |
> +					       IB_ACCESS_REMOTE_READ);

Hello Sagi,

If I interpret the above code correctly the rkey used in the previous 
FRWR is invalidated as soon as a new FRWR is queued. Does this mean that 
the iSER initiator limits queue depth to one ?

Another question: is it on purpose that iscsi_iser_cleanup_task() does 
not invalidate an rkey if a command has been aborted successfully ? A 
conforming iSER target does not send a response for aborted commands. 
Will successful command abortion result in the rkey not being 
invalidated ? What will happen if a new FRWR is submitted with an rkey 
that is still valid ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
