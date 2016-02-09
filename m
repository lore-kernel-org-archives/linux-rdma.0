From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 03/21] IB/srpt: Remove struct srpt_node_acl
Date: Tue, 9 Feb 2016 07:03:52 -0800
Message-ID: <56B9FFD8.2040809@sandisk.com>
References: <56B3D453.7030409@sandisk.com> <56B3D4D7.8060800@sandisk.com>
 <20160209131507.GA25849@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209131507.GA25849-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/09/16 05:15, Christoph Hellwig wrote:
>> -	.node_acl_size			= sizeof(struct srpt_node_acl),
>> +	.node_acl_size			= sizeof(struct se_node_acl),
>
> just drop this line entirely, the core code will do the right thing.

Hello Christoph,

Can you show me the code in the LIO core that handles not specifying 
.node_acl_size ? I have tried to find it but haven't found it yet.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
