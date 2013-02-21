From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibumad/umad.c: In resolve_ca_port, skip ethernet link
 layer ports
Date: Thu, 21 Feb 2013 15:38:10 -0500
Message-ID: <512685B2.4080803@dev.mellanox.co.il>
References: <51266F1F.608@dev.mellanox.co.il> <20130221114427.0b82d4054d46a0920dda104e@llnl.gov> <51267C8D.7030002@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823736F35242C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F35242C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/21/2013 3:08 PM, Hefty, Sean wrote:
>> On 2/21/2013 2:44 PM, Ira Weiny wrote:
>>> What about QP1?  It was my understanding that CM was still required for RoCE.
>>
>> Yes, RoCE requires CM support but AFAIK CM doesn't use/require these
>> interfaces to get send or receive it's MADs.
>>
>> RoCE is a weird animal in terms of IB management as SM/QP0 is not
>> used/deprecated and QP1 is only required for CM with most other QP1
>> things beyond the spec with the exception of SA which is also not
>> used/deprecated.
> 
> Does the kernel expose QP1 for RoCE to user space?

kernel MAD does not create QP0 for ethernet link layer ports but it does
create QP1. There's no link layer specific code in kernel user MAD so I
presume that QP1 is exposed to user space.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
