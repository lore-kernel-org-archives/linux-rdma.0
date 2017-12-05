From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net-next 1/8] net: hns3: Add HNS3 VF IMP(Integrated
 Management Proc) cmd interface
Date: Tue, 05 Dec 2017 11:37:44 -0500 (EST)
Message-ID: <20171205.113744.2040678170803031734.davem@davemloft.net>
References: <20171203123307.19820-1-salil.mehta@huawei.com>
        <20171203123307.19820-2-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171203123307.19820-2-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Sun, 3 Dec 2017 12:33:00 +0000

> +static int hclgevf_ring_space(struct hclgevf_cmq_ring *ring)
> +{
> +	int ntu = ring->next_to_use;
> +	int ntc = ring->next_to_clean;
> +	int used = (ntu - ntc + ring->desc_num) % ring->desc_num;

Order local variables from longest to shortest line, please.

Audit your entire submission for this issue.

> +static int hclgevf_cmd_csq_done(struct hclgevf_hw *hw)
> +{
> +	u32 head = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG);
> +	return head == hw->cmq.csq.next_to_use;
> +}

Please return bool from this function.

> +void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
> +				  enum hclgevf_opcode_type opcode, bool is_read)
> +{
> +	memset((void *)desc, 0, sizeof(struct hclgevf_desc));

You never need casts like this, when the functions argument is void any
pointer can be passed in as-is.

> +
> +	/* If the command is sync, wait for the firmware to write back,
> +	 * if multi descriptors to be sent, use the first one to check
> +	 */
> +	if (HCLGEVF_SEND_SYNC(le16_to_cpu(desc->flag))) {
> +		do {
> +			if (hclgevf_cmd_csq_done(hw))
> +				break;
> +			udelay(1);
> +			timeout++;
> +		} while (timeout < hw->cmq.tx_timeout);
> +	}

This is potentially a long timeout with a spinlock held.  Consider using
sleeping and completions.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
