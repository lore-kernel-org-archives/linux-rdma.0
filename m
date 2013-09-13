From: xrg.dev-8HG2SOrYmURWk0Htik3J/w@public.gmane.org
Subject: ibv_poll_cq misbehaving with RoCE 40Gbps
Date: Fri, 13 Sep 2013 09:23:30 -0400
Message-ID: <20130913132330.9AA5BC02C9@smtp.hushmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello list,

I am experiencing a strange behavior with ibv_poll_cq on RoCE 40 
Gb. When calling the following:

int N = ibv_poll_cq (CQ, DEPTH, WC);

N sometimes becomes equal to DEPTH, although the number of 
outstanding WR is well below DEPTH. In our current example, DEPTH = 
128 and the # of outstanding requests is 4. With N >> # of valid 
WC, scanning the WC array produces, of course, errors.

I am using RHEL 6.4 with the OFED distribution provided by RH. Any 
clue were this error may be coming from ?

Thanks,
Xavier

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
