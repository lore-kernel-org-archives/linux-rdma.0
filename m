From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: DHCP over InfiniBand Update
Date: Tue, 31 Aug 2010 16:09:19 -0400
Message-ID: <AANLkTinc9dER+PkBO9Yv=oeGd8NcjFtvSRa7+tXkpb+B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dhcp-users-/1rEenAg/5e+51mZqJFLXQ@public.gmane.org
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

There appear to be two basic approaches to supporting DHCP (over
InfiniBand) in Linux. There's LPF support (4.1.1 based) and older
(3.0.4 based) socket support.

The 4.1.1 LPF patches are:
http://lists.openfabrics.org/pipermail/ewg/2010-May/015265.html
http://lists.openfabrics.org/pipermail/ewg/2010-May/015266.html
http://lists.openfabrics.org/pipermail/ewg/2010-May/015264.html
The last being Matthieu Hautreux's <matthieu.hautreux at cea.fr>
improved XID generation (same as
https://lists.isc.org/mailman/htdig/dhcp-hackers/2009-January/001773.html).

AFAIT an LPF based approach will only work on older kernels (due to
elimination of CONFIG_FILTER support). Is this accurate ?

OFED has two patches for 3.0.4 for a socket approach in
http://www.openfabrics.org/git/?p=~tziporet/docs.git;a=tree;f=dhcp;h=aec68a2905559c8ed91f1157fa11d78cccb266cd;hb=ofed_1_5
dhcp-3.0.4.patch
0001-Make-DHCP-server-print-HW-info.patch

I've been upporting those to a 4.x based DHCP and have a fundamental
question which occurs even with the 3.0.4 socket based version. On the
client machine, the DHCPOFFER in response to the DHCPDISCOVER is
received (seen with tcpdump) but never seems to make it to the
dhclient application. I can't see any kernel stack error counters
incremented so I'm mystified as to what could be going wrong. I've
also tried this on a number of different kernels. Any idea on why this
might be or how to figure out where that packet is going ? I do see
the dhcp client port with netstat -a --udp -n
udp        0      0 0.0.0.0:68                  0.0.0.0:*
udp        0      0 0.0.0.0:68                  0.0.0.0:*
Any idea on what I'm missing ?

Also, is any of this work making it's way into a released DHCP ?
What's the process for this ? Is there some branch in a source
repository where this work is available ?

Thanks in advance for any pointers on all this.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
