From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_lat whos
Date: Wed, 24 Nov 2010 17:00:51 +0200
Message-ID: <4CED28A3.9070907@Voltaire.com>
References: <4CE3B455.4080003@Voltaire.com> <4CE3BCE3.7090107@Voltaire.com> <4CE50190.3080707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE50190.3080707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ido Shamai wrote:
> I will check the issue now.

Thinking a little further on this and talking with some colleagues, a question was made, 
whether the issue can be related to IB credits/starvation and/or protocol/interoperability 
with switches. 

In an attempt to eliminate that, I repeated the test, this time in a loopback manner, e.g used ib_send_lat once with mtu=256 and once with mtu=2048 with both client/server running on the same node/hca - same result, the mtu=256 produces much better latency for large messages, e.g 1k and onward, for example for msg size=8k the latency is ~7us with mtu=256 and ~9us with mtu=2k

I recalled that on the 2nd generation HCA (tavor), if mtu=2048 is used, the bandwidth is severely damaged (hence the ofed tavor quirk and friends) can this problem which I see on the 4th generation HCA, be somehow related?

Or. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
