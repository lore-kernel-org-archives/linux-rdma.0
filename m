From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/28] ibtrs: add header shared between ibtrs_client and
 ibtrs_server
Date: Fri, 24 Mar 2017 13:35:46 +0100
Message-ID: <20170324123546.GG3571@linux-x5ow.site>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
 <1490352343-20075-2-git-send-email-jinpu.wangl@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490352343-20075-2-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com, Kleber Souza <kleber.souza@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Roman Pen <roman.penyaev@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 11:45:16AM +0100, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@profitbricks.com>
> 
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> Signed-off-by: Kleber Souza <kleber.souza@profitbricks.com>
> Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
> ---

[...]

> +
> +#define XX(a) case (a): return #a

please no macros with retun in them and XX isn't quite too descriptive as
well.

[...]

> +static inline const char *ib_wc_opcode_str(enum ib_wc_opcode opcode)
> +{
> +	switch (opcode) {
> +	XX(IB_WC_SEND);
> +	XX(IB_WC_RDMA_WRITE);
> +	XX(IB_WC_RDMA_READ);
> +	XX(IB_WC_COMP_SWAP);
> +	XX(IB_WC_FETCH_ADD);
> +	/* recv-side); inbound completion */
> +	XX(IB_WC_RECV);
> +	XX(IB_WC_RECV_RDMA_WITH_IMM);
> +	default: return "IB_WC_OPCODE_UNKNOWN";
> +	}
> +}

How about:

struct {
	char *name;
	enum ib_wc_opcode opcode;
} ib_wc_opcode_table[] = {
	{ stringyfy(IB_WC_SEND), IB_WC_SEND },
	{ stringyfy(IB_WC_RDMA_WRITE), IB_WC_RDMA_WRITE },
	{ stringyfy(IB_WC_RDMA_READ ), IB_WC_RDMA_READ }
	{ stringyfy(IB_WC_COMP_SWAP), IB_WC_COMP_SWAP },
	{ stringyfy(IB_WC_FETCH_ADD), IB_WC_FETCH_ADD },
	{ stringyfy(IB_WC_RECV), IB_WC_RECV },
	{ stringyfy(IB_WC_RECV_RDMA_WITH_IMM), IB_WC_RECV_RDMA_WITH_IMM },
	{ NULL, 0 },
};

static inline const char *ib_wc_opcode_str(enum ib_wc_opcode opcode)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(ib_wc_opcode_table); i++)
		if (ib_wc_opcode_table[i].opcode == opcode)
			return ib_wc_opcode_table[i].name;

	return "IB_WC_OPCODE_UNKNOWN";
}


[...]

> +/**
> + * struct ibtrs_msg_hdr - Common header of all IBTRS messages
> + * @type:	Message type, valid values see: enum ibtrs_msg_types
> + * @tsize:	Total size of transferred data
> + *
> + * Don't move the first 8 padding bytes! It's a workaround for a kernel bug.
> + * See IBNBD-610 for details

What about resolving the kernel bug instead of making workarounds?

> + *
> + * DO NOT CHANGE!
> + */
> +struct ibtrs_msg_hdr {
> +	u8			__padding1;
> +	u8			type;
> +	u16			__padding2;
> +	u32			tsize;
> +};

[...]

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
