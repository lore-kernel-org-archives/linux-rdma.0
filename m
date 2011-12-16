From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Problems with link, opensm complains
 IB_SA_MAD_STATUS_REQ_INVALID
Date: Thu, 15 Dec 2011 16:06:00 -0800
Message-ID: <20111215160600.ebccb033.weiny2@llnl.gov>
References: <4EEA8004.4060103@grepit.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EEA8004.4060103-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 15 Dec 2011 15:17:24 -0800
Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org> wrote:

> Hi,
> 
> Starting opensm from OFED 1.5.1, 1.5.3.2, 1.5.4 on a Scientific Linux 5
> machine, directly linked to its neighbour (a twin 1U setup) gives me no
> connection but lots of errors in /var/log/opensm.log, like these:
> 
> Dec 15 22:38:35 685651 [45AFD940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
> from port 0x001e8c0000b90641 (vespasianus HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Dec 15 22:38:35 686174 [464FE940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
> from port 0x001e8c0000c84b62 (titus HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> 
> Does anyone know what happens here? Another twin node has no problems,
> that one uses OFED-1.5.1.
> 
> I can send a "-V" log of opensm or any config files if you like,

Just set -D 0x7 which adds VERBOSE and send the snippet around the above errors.

Ira

> 
> thanks,
> 
> Gerben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
