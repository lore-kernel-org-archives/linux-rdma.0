From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibumad/umad.c: In resolve_ca_port, skip ethernet link
 layer ports
Date: Thu, 21 Feb 2013 14:59:09 -0500
Message-ID: <51267C8D.7030002@dev.mellanox.co.il>
References: <51266F1F.608@dev.mellanox.co.il> <20130221114427.0b82d4054d46a0920dda104e@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130221114427.0b82d4054d46a0920dda104e-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/21/2013 2:44 PM, Ira Weiny wrote:
> What about QP1?  It was my understanding that CM was still required for RoCE.

Yes, RoCE requires CM support but AFAIK CM doesn't use/require these
interfaces to get send or receive it's MADs.

RoCE is a weird animal in terms of IB management as SM/QP0 is not
used/deprecated and QP1 is only required for CM with most other QP1
things beyond the spec with the exception of SA which is also not
used/deprecated.

-- Hal

> 
> Ira
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
