From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: dumping queue state
Date: Wed, 20 Dec 2017 13:01:18 -0600
Message-ID: <020801d379c4$eaaa0c00$bffe2400$@opengridcomputing.com>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com> <20171220163655.GW2942@mtr-leonro.local> <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com> <20171220171146.GX2942@mtr-leonro.local> <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com> <20171220180549.GY2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220180549.GY2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Check filters options too, to filters by numbers and display columns.

[root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link cxgb4_0/-
display lqpn,type,state,pid lqpn 1000-1030
DEV/PORT  LQPN       TYPE  STATE  PID
cxgb4_0/- 1027       RC    RTS    0
[root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link cxgb4_0/-
display lqpn,type,state,pid lqpn 1000-1033
DEV/PORT  LQPN       TYPE  STATE  PID
cxgb4_0/- 1027       RC    RTS    0
cxgb4_0/- 1033       RC    RTS    0
[root@stevo1 ~]#

Working!



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
