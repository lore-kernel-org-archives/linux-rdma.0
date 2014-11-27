From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Tutorials/howto to modify exiting tcp/ip app for rdma
Date: Thu, 27 Nov 2014 15:39:22 +0200
Message-ID: <5477298A.6060605@dev.mellanox.co.il>
References: <CACaajQv2-TFkmANMNBikryG8CE_xhnOx05Qt9aQC8MXfyeRLSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQv2-TFkmANMNBikryG8CE_xhnOx05Qt9aQC8MXfyeRLSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/23/2014 10:41 PM, Vasiliy Tolstov wrote:
> Hello.
> I want to study ibverbs,rdma. I have application that use tcp/ip for
> transfer data.
> I want to add rdma support,avoiding usage IPoIB. So I want to write
> app that can find and connect to other nodes via guides.
> Does somebody share for me some links or how can I find it?
> Thanks
>
>

You can keep doing IP address resolution using rdma_cm.

You can see perftest examples in 
git://flatbed.openfabrics.org/~grockah/perftest.git
Or,
librdmacm's rping in git://flatbed.openfabrics.org/~shefty/librdmacm.git

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
