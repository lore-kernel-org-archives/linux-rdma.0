From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: race in ULPs when processing RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Mon, 6 May 2013 23:25:40 +0300
Message-ID: <CAJZOPZKm2ZXKVgTKAYXj6uHzji_p00UQQbKHzmqiPaTSLctEKg@mail.gmail.com>
References: <5186671F.3020408@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD21043@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD21043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 6, 2013 at 6:46 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The user should free any objects that are associated with the device associated with
> the rdma_cm id.  If the user only accesses the device using the rdma_cm id, then all
> objects should be freed.

So think on the case, e.g for iser where a ULP maintains a per-device
context where they stroe IB objects used for all connections of that
device (e.g PD, CQs, DMA-MR, etc) and per connection object where the
QP and RDMA-CM ID are storage.

The per-device context is created on demand throughout establishing
the 1st connection (e.g after address resolution where the IB device
to be used for that connection is "resolved") over a device and
destroyed after the last connection is disconnected.

Could we come up with an elegant (or the most not elegant..) way for a
secure teardown of the IB elements of that global context in the
context of the device removal event?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
