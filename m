From: Bob-zOt1CrANNomHCRyBVyKX4rVCufUGDwFn@public.gmane.org
Subject: Infiniband, ISCSI and Xen
Date: Thu, 03 Jun 2010 09:01:27 +0100
Message-ID: <E1OK5Ml-000HW4-Qv@pr-webmail-1.mail.demon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry to post this here but I dont know of a Infiniband/OFED user mailling list.

I'm looking at what software I need to present two replicated storage devices to open source Xen servers. OS is Centos.

On the target side I think I can use the ISCSI target included with OFED to present the storage and DRBD in SDP mode to replicate the storage between the two boxes (Unless someone know of a better way).

It is the Xen side I'm unsure of. Does the Xen PVSCSI interface offer the fastest interface for VMs to ISCSI-SRP targets? PVSCSI is not supported by default in Centos which means a custom Xen compile so I was wondering if there are any other suggestions.


Thanks,

Bob

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
