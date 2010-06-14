From: Jie Cai <Jie.Cai-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Subject: Re: multiple infiniband interfaces on single node
Date: Mon, 14 Jun 2010 18:02:01 +1000
Message-ID: <4C15E1F9.4000404@anu.edu.au>
References: <AANLkTimxrq4qhyatMWtm3z6rMDJxYYBU4bNunv5ex4l3@mail.gmail.com> <AANLkTikvB4pAHy3H3FZBcZWFU7rqSzIMeo6lb0QGpFaa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikvB4pAHy3H3FZBcZWFU7rqSzIMeo6lb0QGpFaa-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Giuseppe Aprea <giuseppe.aprea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Aprea,

MVAPICH2 should support multiple IB interfaces as default.
As I don't have experience on single image systems (ScaleMP?),
I am not really sure will MVAPHICH2 works as normal.

Otherwise, you might need to explicitly change your code to take
advantage of multiple physical IB connections.

BTW: as 8b-10b encoding method is used for PCI-e 2.0, you would only
be able to see 16Gb per IB connection, and if you use 4 connections
at same time, you would not be able to see 4*16Gb bandwidth due to
hardware and software contentions.

You might be interested in this:
http://ieeexplore.ieee.org/search/srchabstract.jsp?tp=&arnumber=5328503&queryText%3D.QT.Non-threaded+and+Threaded+Approaches+to+Multirail+Communication+with+uDAPL.QT.%26openedRefinements%3D*%26searchField%3DSearch+All

Hope this helps.

Kind Regards,
Jie
--
http://cs.anu.edu.au/~Jie.Cai


Giuseppe Aprea wrote:
> Hi list,
> I am dealing with a set of 4 nodes (ibm x3850 ) binded together using
> ScaleXpander chip. Each node is equipped with a 20 Gb DDR infiniband
> network card so the new single image multi-node has 4 cards. We are
> using mellanox ofed to handle infiniband connectivity. Our problem now
> is how to exploit all 4 cards together. It seems that ofed
> "ib-bonding" can only be used for a kind of fail-over configuration of
> the cards and we wonder if it is possible to set up automatic
> bandwidths sum, i.e. if this node is included in a hostfile for an
> mpi-job together with other nodes it should be able to use the whole
> of its potential 20*4 Mb bandwidth, (possibly) without changing job
> submission parameters. I googled around unsuccessfully quite a lot but
> I may have missed the right keywords to find what I need. Any help
> will be much appreciated.
>
> Thanks in advance.
>
> Dr G. Aprea
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
