From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux DMA address
Date: Tue, 3 Jul 2012 17:03:00 +0300
Message-ID: <CAJZOPZLbMv9WoTfHALTx6Ff8S24iHER-=a+nG3tFYGOwHr7yFw@mail.gmail.com>
References: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62@de.ibm.com>
	<4FF1A7F0.10208@mellanox.com>
	<OF2C9BED9D.50BF4649-ONC1257A30.004A568D-C1257A30.004ADEF1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF2C9BED9D.50BF4649-ONC1257A30.004A568D-C1257A30.004ADEF1-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Let me stress this once again...
> 1.) Is it possible/allowed to call ib_dma_map_single() on Linux, same
> buffer address, size and dma_data direction, for two different ib devices?
> For the data transmission we will have controls in place that not both
> devices write at the same time into that buffer.
> 2.) If this is possible, will the returned dma_addresses be the same? Any
> dependencies on the adapter model?
> Any thoughts on this? Thanks.

Here's the question for you - can you strip the ib_ part from the
mentioned APIs and answer the question? e.g w.r.t your non IB HW of
choice (still under Linux)? if yes, the same answer applies with the
ib_ part, if not, I can try to help, but please  take a look 1st on
the DMA mapping documents under the kernel doc dir.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
