From: Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Subject: Problems with link, opensm complains IB_SA_MAD_STATUS_REQ_INVALID
Date: Fri, 16 Dec 2011 00:17:24 +0100
Message-ID: <4EEA8004.4060103@grepit.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Starting opensm from OFED 1.5.1, 1.5.3.2, 1.5.4 on a Scientific Linux 5
machine, directly linked to its neighbour (a twin 1U setup) gives me no
connection but lots of errors in /var/log/opensm.log, like these:

Dec 15 22:38:35 685651 [45AFD940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
from port 0x001e8c0000b90641 (vespasianus HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID
Dec 15 22:38:35 686174 [464FE940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
from port 0x001e8c0000c84b62 (titus HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID

Does anyone know what happens here? Another twin node has no problems,
that one uses OFED-1.5.1.

I can send a "-V" log of opensm or any config files if you like,

thanks,

Gerben
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
