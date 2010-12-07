From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Can't capture RDS packets
Date: Mon, 06 Dec 2010 17:32:39 -0800
Message-ID: <4CFD8EB7.1040207@oracle.com>
References: <602499.57236.qm@web77009.mail.sg1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <602499.57236.qm-j5MJQUehm+eV+NGWguM0hVZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lam.peter84-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Cc: rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/02/2010 08:11 AM, Peter Lam wrote:
> I try to use Wireshark to capture the packets using rds-example but
> it can't capture any packets. Is it because Wireshark does not
> support RDS?
>
> $ ./rds-sample -s 127.0.0.1 -c 127.0.0.1 -v --rdma-read Client
> Sending RDMA message 0 from 127.0.0.1 to 127.0.0.1
>
> $ ./rds-sample -s 127.0.0.1 --rdma-write -v server listening on
> 127.0.0.1 Received RDS packet 0 of len 104, cmsg len 0, on port
> 20942 payload contains: -1
> J!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}

Hi Peter,

(Sorry for the delay, was out last week.)
(CCing linux-rdma in case anyone there has advice.)

Wireshark doesn't know about RDS wire protocol yet, that's true.

A larger issue is that the kernel's packet-capturing hooks are only for
netdevs. RDS over Infiniband (and RDS loopback) do not use netdevs
internally. RDS/TCP goes over a netdev so those will show up,
encapsulated inside eth/IP/TCP headers.

I understand Mellanox has a program called ibdump that outputs raw IB
packets in pcap-compatible format for their cards. Google ibdump. If 
that works, then you should be able to load it in Wireshark, and the 
last remaining obstacle would be the RDS protocol dissector module.

Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
