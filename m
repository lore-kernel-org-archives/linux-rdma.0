From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: race in ULPs  when processing RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Mon, 6 May 2013 15:46:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD21043@ORSMSX109.amr.corp.intel.com>
References: <5186671F.3020408@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5186671F.3020408-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What would be the correct way to go for consumers, is that making sure
> they destroy 1st all their IB
> objects (PDs, MRs, CQs, QPs, etc) prior to destroying the last rdma_cm
> id on a device removal event?
> any other idea?

The user should free any objects that are associated with the device associated with the rdma_cm id.  If the user only accesses the device using the rdma_cm id, then all objects should be freed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
