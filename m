From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH net-next 1/8] net: hns3: Add HNS3 VF IMP(Integrated
 Management Proc) cmd interface
Date: Tue, 5 Dec 2017 17:11:39 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BB636A3@FRAEML521-MBX.china.huawei.com>
References: <20171203123307.19820-1-salil.mehta@huawei.com>
        <20171203123307.19820-2-salil.mehta@huawei.com>
 <20171205.113744.2040678170803031734.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205.113744.2040678170803031734.davem@davemloft.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Hi Dave,

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, December 05, 2017 4:38 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; lipeng (Y)
> <lipeng321@huawei.com>; mehta.salil.lnk@gmail.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH net-next 1/8] net: hns3: Add HNS3 VF IMP(Integrated
> Management Proc) cmd interface
> 
> From: Salil Mehta <salil.mehta@huawei.com>
> Date: Sun, 3 Dec 2017 12:33:00 +0000
> 
> > +static int hclgevf_ring_space(struct hclgevf_cmq_ring *ring)
> > +{
> > +	int ntu = ring->next_to_use;
> > +	int ntc = ring->next_to_clean;
> > +	int used = (ntu - ntc + ring->desc_num) % ring->desc_num;
> 
> Order local variables from longest to shortest line, please.
This one skipped my eyes. Will fix. Thanks.

> 
> Audit your entire submission for this issue.
Sure, will do. 


> 
> > +static int hclgevf_cmd_csq_done(struct hclgevf_hw *hw)
> > +{
> > +	u32 head = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG);
> > +	return head == hw->cmq.csq.next_to_use;
> > +}
> 
> Please return bool from this function.
Agreed. Should have been bool here. Will fix.


> 
> > +void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
> > +				  enum hclgevf_opcode_type opcode, bool
> is_read)
> > +{
> > +	memset((void *)desc, 0, sizeof(struct hclgevf_desc));
> 
> You never need casts like this, when the functions argument is void any
> pointer can be passed in as-is.
Agreed. Will remove this.


> 
> > +
> > +	/* If the command is sync, wait for the firmware to write back,
> > +	 * if multi descriptors to be sent, use the first one to check
> > +	 */
> > +	if (HCLGEVF_SEND_SYNC(le16_to_cpu(desc->flag))) {
> > +		do {
> > +			if (hclgevf_cmd_csq_done(hw))
> > +				break;
> > +			udelay(1);
> > +			timeout++;
> > +		} while (timeout < hw->cmq.tx_timeout);
> > +	}
> 
> This is potentially a long timeout with a spinlock held.  Consider
> using
> sleeping and completions.
I guess you meant 1 usec X (hw->cmq.tx_timeout = 200) times the delay
is large - right?

Will review it again. 

Thanks.
Salil

 
