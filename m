From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: race in ULPs when processing RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Mon, 6 May 2013 20:33:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD2121B@ORSMSX109.amr.corp.intel.com>
References: <5186671F.3020408@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD21043@ORSMSX109.amr.corp.intel.com>
 <CAJZOPZKm2ZXKVgTKAYXj6uHzji_p00UQQbKHzmqiPaTSLctEKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKm2ZXKVgTKAYXj6uHzji_p00UQQbKHzmqiPaTSLctEKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So think on the case, e.g for iser where a ULP maintains a per-device
> context where they stroe IB objects used for all connections of that
> device (e.g PD, CQs, DMA-MR, etc) and per connection object where the
> QP and RDMA-CM ID are storage.
> 
> The per-device context is created on demand throughout establishing
> the 1st connection (e.g after address resolution where the IB device
> to be used for that connection is "resolved") over a device and
> destroyed after the last connection is disconnected.
> 
> Could we come up with an elegant (or the most not elegant..) way for a
> secure teardown of the IB elements of that global context in the
> context of the device removal event?

I would think that this would do it:

- call rdma_destroy_qp() from the callback
- decrement the global reference count
- destroy the global context from the callback when count = 0
- return non-zero from the callback to destroy the rdma cm id

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
