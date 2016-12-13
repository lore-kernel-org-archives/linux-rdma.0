From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: SR-IOV with mlx4 on ConnectX-2 fails with DMAR errors
Date: Tue, 13 Dec 2016 12:01:02 -0700
Message-ID: <20161213190102.GA15119@obsidianresearch.com>
References: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA@mail.gmail.com>
 <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw@mail.gmail.com>
 <20161213165441.GB11099@obsidianresearch.com>
 <CAN27Ff7hEr4u5nyELjwRXb3W_t0TNefuuT4AzdjAoWWGRHqTFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAN27Ff7hEr4u5nyELjwRXb3W_t0TNefuuT4AzdjAoWWGRHqTFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 13, 2016 at 01:36:42PM -0500, Joshua McBeth wrote:
> I bisected the kernel between v4.1 and v4.3.1 by booting each build on
> the SR-IOV host and attempting to "ping x.x.x.x" with x.x.x.x being
> the IP address assigned to the Infiniband interface of a remote host
> 
> At 4be90bc's parent the SR-IOV host is able to ping the remote host,
> but at 4be90bc the SR-IOV host is not able to ping the remote host
> (destination host unreachable)

Okay, that makes sense

> The DMAR errors occur in both the kernel built at 4be90bc (not passing
> ping test) and its parent (passing ping test)

Continuing to bisect until you find the commit that introduces the
DMAR errors would also be helpful, I think.

> Reverting only the commit 4be90bc from a later kernel (4.8.x) does not
> enable the SR-IOV host to ping the remote host, which to me suggests
> that another commit after 4be90bc is also causing my test to fail.

Okay, that does not seem too surprising.

Does this make your 4.8 kernel work? If yes, then I suspect mlx4 has
broken IB_DEVICE_LOCAL_DMA_LKEY with SRIOV.. Leon? mlx5 has this
broken, doesn't it?

It would also be very helpful to try and determine what memory the NIC is
trying to read.. If it is the ipoib packet or some mlx4 internal
thing.

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2be4ea0cda9c19..1346924d27691f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -243,6 +243,8 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	atomic_set(&pd->usecnt, 0);
 	pd->flags = flags;
 
+	device->attrs.device_cap_flags = 0;
+
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
 	else

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
