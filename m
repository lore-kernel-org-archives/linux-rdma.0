From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: mlx4/xrc problem
Date: Wed, 22 May 2013 12:38:37 -0500
Message-ID: <519D029D.8020102@opengridcomputing.com>
References: <519CEC83.9010501@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823736FD29FE1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD29FE1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/22/2013 11:39 AM, Hefty, Sean wrote:
>> [root@hpc-hn1 libibverbs-1.1.4]# ibv_xsrq_pingpong -d mlx4_0 192.168.174.52
>>      local: LID 0001, QPN RECV 98004b SEND 18004c, PSN 5b6d99, SRQN 0042
>>     remote: LID 0002, QPN RECV d4004a SEND 54004b, PSN d7ba7a, SRQN 0042
> The same SRQN on both sides looks suspicious.
I confirmed via gdb that 0x42 is in ctx.srq->xrc_srq_num on both sides.

>> [root@hpc-cn2 libibverbs-1.1.4]# ibv_xsrq_pingpong  -d mlx4_0
>>     remote: LID 0001, QPN RECV 98004b SEND 18004c, PSN 5b6d99, SRQN 0042
>>      local: LID 0002, QPN RECV d4004a SEND 54004b, PSN d7ba7a, SRQN 0042

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
