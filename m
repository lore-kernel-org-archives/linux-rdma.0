From: Ross Smith <myxiplx-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: End user documentation for Infiniband?
Date: Wed, 9 Dec 2009 14:14:02 +0000
Message-ID: <7b160d240912090614j7ac3c126r5fec5a1516d6f91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi guys,

Sorry if this is a bit of a newbie question, or posted to the wrong
place, but I've been struggling to find any documentation for
configuring infiniband, and the openfabrics mailing lists appear well
and truly dead.

I have a very basic network running now, with three hosts, ipoib and
opensm.  It's running at 2.5Gbps which I understand is the default,
but I cannot for the life of me find any documentation on how to
configure it to run at higher speeds.

Any network benchmarks are peaking at around 290MB/s, so just under 2.5Gbps.
ibstat tells me that the link is running at 20.
ibdiagnet tells me that the ipoib subnet is configured for 10Gbps, but
that it has no members.

I'm guessing that I need to configure the ipoib subnet for 20Gbps, and
join the machines to it.  However I can't find documentation on how to
do either of these.

Can anybody help, or point me in the direction of some documentation?

thanks,

Ross
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
