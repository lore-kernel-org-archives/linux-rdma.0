From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: dumping queue state
Date: Wed, 20 Dec 2017 11:42:22 -0600
Message-ID: <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com> <20171220163655.GW2942@mtr-leonro.local> <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com> <20171220171146.GX2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220171146.GX2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> WIP: no manuals, no review yet and not massively tested - but works for me
:
> 
> 
> >
> > Is there a way to extend commands with provider-specific data?
> >
> 
> In future yes, rdmatool provides "-d" option (detailed output) and IMHO
> all vendor specific will got there.

Cool.

Looksie:

[root@stevo1 iproute2]# ./rdma/rdma res
1: mlx4_0: curr/max: pd 4/32764 cq 17/65408 qp 3/163768
2: cxgb4_0: curr/max: pd 2/65536 cq 16/24576 qp 2/12288
2: cxgb4_0: curr/max: pd 2/65536 cq 16/24576 qp 2/12288

[root@stevo1 iproute2]# ./rdma/rdma res show qp link cxgb4_0
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
cxgb4_0/- 1028       RC    RTS    0          [rdma-cm]
cxgb4_0/- 1026       RC    RTS    0          [rdma-cm]

I'm not sure why the port is not specified on the above cxgb4 QPs which are
connected.  They should have a port number.  But perhaps it isn't filled in
correctly in the cm_id or something?  

[root@stevo1 iproute2]# ./rdma/rdma res show qp link mlx4_0
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx4_0/1  537        RC    RTS    0          [rdma-cm]
mlx4_0/1  536        RC    RTS    0          [rdma-cm]
mlx4_0/1  1          GSI   RTS    0          [rdma-mad]
[root@stevo1 iproute2]#

rdma should probably understand enough transport-specific details to not
display ib-specific stuff on an iwarp qp.  Here PSNs and PATH-MIG are all
IB-specific:

[root@stevo1 iproute2]# ./rdma/rdma res show qp link cxgb4_0 -d
DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM
SQ-PSN     RQ-PSN     PATH-MIG
cxgb4_0/- 1028       0          RC    RTS    0          [rdma-cm]       0
0          MIGRATED
cxgb4_0/- 1026       0          RC    RTS    0          [rdma-cm]       0
0          MIGRATED

[root@stevo1 iproute2]# ./rdma/rdma res show qp link mlx4_0 -d
DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM
SQ-PSN     RQ-PSN     PATH-MIG
mlx4_0/1  537        537        RC    RTS    0          [rdma-cm]
13145128   12441844   MIGRATED
mlx4_0/1  536        536        RC    RTS    0          [rdma-cm]
14218681   1982803    MIGRATED
mlx4_0/1  1          ---        GSI   RTS    0          [rdma-mad]      0
---        ---

Looking good though!

Why did you prefer netlink vs debugfs for this stuff?  (I'm sure it was
discussed on the list but I missed it).

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
