From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 5/3/2016
Date: Mon, 9 May 2016 20:13:25 +0000
Message-ID: <HE1PR05MB14187F16759AC81DE1887E73B1700@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <HE1PR05MB1418D253A2B5F7DEAD633C73B1790@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418D253A2B5F7DEAD633C73B1790-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Let's continue the discussion when some more concrete proposals are posted; so no OFVWG meeting tomorrow.
Please find the summary of the last meeting below.

Next meeting planned for 5.17.2016.
Tentative agenda:
- Follow-up on ABI developments
- Generic RSS interface for Raw Ethernet QPs

Thanks,
--Liran

========

ABI notes from 5.3.2016:

The option of encoding an object ID and a method in the ioctl() request code was discussed.
This allows strace to report specific calls as long as the code comprises globally unique tuples. However, the downside is that the object space needs to be partitioned for different uses and would be limited.

There is a general agreement that netlink-style nesting is a good thing, but the flexibility it offers should not be overused for the sake of simplicity. The goal is to have 1-2 attributes per operation, depending on logical grouping of fields. Vendor-specific attributes are nested, and may be as simple as comprising a single binary-packed attribute. Providing globally unique vendor attributes might make the task of attribute validation easier and generic. Need to check if this would continue to hold with optional attributes as well.

The uAPI should map the existing kAPI completely. Partitioning of attributes into groups and introducing typed attributes for addressing should allow the kernel implementation to be optimized. In addition, generic terms that are bound to specific enumerations, such as MTU, could be generalized while still providing backward compatibility.

The option of allowing a vendor to bypass the generic kAPI parsing for specific object/methods was raised as a method to still support generic objects while further optimizing the representation. However, it's not clear if the savings would be substantial, and this prevents objects created this way from interacting with other generic objects and being manipulated in common code paths.

ucma could employ a similar scheme. The possibility of uniting the ucma fd with uverbs was raised as way to simply the code. However, ucma and uverbs stand for different things and have different security contexts. Also, ucma objects are not always associated with a device instance. A new event queue object, which can aggregate events from multiple devices and/or multiple event sources such as device and CM events, could be introduced to simplify application event processing.

First objective is resolve the security issues and to allow the existing user-space code to work. Immediate follow-up extensions should include a granular capability query subsystem and the aforementioned an event queue object.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
