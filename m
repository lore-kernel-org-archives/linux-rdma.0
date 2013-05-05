From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: race in ULPs  when processing RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Sun, 5 May 2013 17:05:19 +0300
Message-ID: <5186671F.3020408@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

When the low level driver exercises the hot unplug code (e.g if the user 
does modprobe -r, pci hot unplug, etc)
they would call the rdma-cm remove_one callback, which would go and 
generate RDMA_CM_EVENT_DEVICE_REMOVAL
event for the cma consumers. Now, if the consumer doesn't make sure they 
destroy all the IB objects
created on that ll device instance (e.g mlx4_0) prior to finalizing all 
processing of the DEVICE_REMOVAL
callback, the rdma-cm will let the low level driver green light to 
finalize its de-registation (destruction
of the IB device instance etc) with the IB core, and a call from the 
consumer to (say) ib_destroy_cq(dev, cq)
will crash since that dev object is practically null or the call points 
to  a function/module which
doesn't exist any more in the kernel address space - agree?

What would be the correct way to go for consumers, is that making sure 
they destroy 1st all their IB
objects (PDs, MRs, CQs, QPs, etc) prior to destroying the last rdma_cm 
id on a device removal event?
any other idea?

In iSER we don't make sure to destroy all the IB objects prior to acking 
this event to the rdma-cm
and we see crashes under RoCE link layer, where under IB link layer not 
crashing, most likely some
timing which is different between the link layers, but the arch question 
is still valid.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
