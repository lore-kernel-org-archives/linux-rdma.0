From: Peter Chinetti <peter.chinetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: When does IB Multicast drop?
Date: Tue, 24 Nov 2015 16:10:30 -0600
Message-ID: <5654E056.5050608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've been reading* through the IBA spec (Release 1.3 2015-03-03), trying 
to understand IB multicast and its pitfalls.

I understand that IB multicast only supports Unreliable Datagram sends 
(10.5.2.1), and that there are neither delivery guarantees nor 
acknowledgments for UD sends. Furthermore, flow control is only 
available for Reliable Connections. I thought I saw that there was an 
ordering guarantee within a multicast group for a specific sender, but 
now I can't find that section again.

How far is the send guaranteed to propagate? What would cause the data 
to be dropped? Is it possible for an oversubscribed (e.g. a 80 Gb/s 
burst of multicast bandwidth trying to fit through a link with only 40 
Gb/s of bandwidth) link to slow down multicast data on a different 
network path, or will burst be "clipped" by dropping packets?

In testing some co-workers of mine have done we have found that when 
multicast is run in parallel over IB and Ether, the IB is occasionally 
slower, but does not seem to drop packets. This seems to suggest that 
flow control /is/ working for multicast (which would be great, as long 
as we know where the pathological cases are and avoid them).

Thank you,
Peter Chinetti

*Honestly, more like Control-F'ing for "multicast". Not super effective.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
