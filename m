From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: AW: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 15:58:15 +0200
Message-ID: <526FBEF7.2030807@mellanox.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de> <526F9F5A.7010903@mellanox.com> <526FB051.5020709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526FB051.5020709-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/10/2013 14:55, Erez Shitrit wrote:
> In addition to what Or just wrote,
> GRO currently doesn't work on ipoib interfaces, that according to bad 
> handling mac address that are not 6 bytes (we have plans to fix that 
> in the near future), that is the reason you don't see 64k packets on 
> tcpdump (like you see in LRO). 

I just checked with net-next which is 3.12-rc6+ and there IS 
aggregationfor datagram mode

> 15:56:40.983883 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801688305:1801692289, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 3984
> 15:56:40.983942 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801692289:1801756033, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 63744
> 15:56:40.984027 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801756033:1801819777, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 63744
> 15:56:40.984079 IP 192.168.20.17.40861 > 192.168.20.18.55714: Flags 
> [.], ack 1801688305, win 1544, options [nop,nop,TS val 305403520 ecr 
> 44014459], length 0
> 15:56:40.984104 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801819777:1801823649, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 3872
> 15:56:40.984159 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801823649:1801883521, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 59872
> 15:56:40.984214 IP 192.168.20.17.40861 > 192.168.20.18.55714: Flags 
> [.], ack 1801819777, win 1009, options [nop,nop,TS val 305403520 ecr 
> 44014459], length 0
> 15:56:40.984241 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags 
> [.], seq 1801883521:1801887393, ack 1, win 220, options [nop,nop,TS 
> val 44014459 ecr 305403520], length 3872


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
