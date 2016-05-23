From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting tomorrow
 - 5/24/2016
Date: Mon, 23 May 2016 19:30:02 +0000
Message-ID: <HE1PR05MB14189704DA1D862F5BF8B384B14E0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Agenda: IPoIB ops

IPoIB operations allow vendors to innovate and optimize the IPoIB data path (stateless offloads, interrupt moderation schemes, buffering schemes, etc.) without bloating the kAPI. This is done while sharing the IPoIB ULP code for protocol management and consistent interfaces. More specifically, when IPoIB creates an interface, it delegates data-path processing to the ib_dev if IPoIB ops are provided. Otherwise, IPoIB falls back to the common implementation.

This meeting is a follow-up to the fruitful discussions that were held during the last OFA workshop on this idea. Both the concept and an initial template for IPoIB ops will be discussed.

See below a short summary of the 5/17 OFVWG meeting + updated concall details.
Regards,
--Liran

--------

Concall details
===========
JOIN WEBEX MEETING
https://mellanox-tech.webex.com/join/Liran.Liss  |  702 830 424

JOIN BY PHONE
1-80-9453550 Israel toll free
1-855-299-5224 USA/Canada toll free
Access code: 702 830 424

Global call-in numbers:
https://mellanox-tech.webex.com/mellanox-tech/globalcallin.php?serviceType=MC&ED=457637257&tollFree=1

Toll-free calling restrictions:
http://www.webex.com/pdf/tollfree_restrictions.pdf


ABI notes:
========
1. A single ioctl request code is OK for all generic calls
2. Get rid of the ver fields (both in header and in versioned pointer)
3. Put the core response descriptor into the header
4. Allocate tb using stack and reduce number of allocations (allocate only once).
5. Don't use NLA_NESTED in the command (we don't, so we're ok)
6. Write system call continues to live in kernel for a meanwhile
7. Ioctl or write interface per fd. If ioctl was used, switch off the write interface for this fd.
8. Don't use library for serializing netlink in libibverbs, use custom structures.
9. Serialize data from write call to ioctl
10. Split patches - patch per core object
11. When high performance vendor channel is needed, use a second ioctl. Standard vendor control could be implemented by using either a specific vendor object_type or vendor attributes.


RSS notes:
========
1. General concept looks OK. Could be useful not just for Eth, but also for IPoIB, MADs, etc.
2. New RSS objects such as indirection table and work queues should be added to the ABI as they extend the object model.
3. Specific hash configuration does not need to be exposed to the ABI, but rather passed as vendor parameters directly to the driver


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
