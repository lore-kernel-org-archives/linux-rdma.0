From: Giuseppe Aprea <giuseppe.aprea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: multiple infiniband interfaces on single node
Date: Mon, 14 Jun 2010 09:48:49 +0200
Message-ID: <AANLkTikvB4pAHy3H3FZBcZWFU7rqSzIMeo6lb0QGpFaa@mail.gmail.com>
References: <AANLkTimxrq4qhyatMWtm3z6rMDJxYYBU4bNunv5ex4l3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimxrq4qhyatMWtm3z6rMDJxYYBU4bNunv5ex4l3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,
I am dealing with a set of 4 nodes (ibm x3850 ) binded together using
ScaleXpander chip. Each node is equipped with a 20 Gb DDR infiniband
network card so the new single image multi-node has 4 cards. We are
using mellanox ofed to handle infiniband connectivity. Our problem now
is how to exploit all 4 cards together. It seems that ofed
"ib-bonding" can only be used for a kind of fail-over configuration of
the cards and we wonder if it is possible to set up automatic
bandwidths sum, i.e. if this node is included in a hostfile for an
mpi-job together with other nodes it should be able to use the whole
of its potential 20*4 Mb bandwidth, (possibly) without changing job
submission parameters. I googled around unsuccessfully quite a lot but
I may have missed the right keywords to find what I need. Any help
will be much appreciated.

Thanks in advance.

Dr G. Aprea
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
