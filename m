From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting tomorrow
 - 5/31/2016 at 11:00PDT
Date: Mon, 30 May 2016 18:53:55 +0000
Message-ID: <DB5PR05MB1415D13134A3D394191994F3B1450@DB5PR05MB1415.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Agenda: continue ABI discussion

The agenda of this meeting is to continue the discussion on the ABI desirables and means to implement them, based on the insights of the initial implementation proposals.
See below a short summary of the 5/24 OFVWG meeting on ipoib-ops + concall details.

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


IPoIB-ops notes:
============
- The general concept makes sense
- The provider should be allowed to inspect ipoib priv fields to simplify the interface:
-- Allocate the netdev on behalf of ipoib with proper queue counts and netdev features
-- Upon open()/stop(), discover changes in pkey and qkey

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
