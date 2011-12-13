From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: Multiple multicast groups
Date: Tue, 13 Dec 2011 13:53:46 -0700
Message-ID: <20111213135346.132670b3va8kdk62@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I am trying to modify one of the multicast examples (mckey.c) so that  
I have multiple multicast groups each one handling a different type of  
data.  I am somewhat confused as to how I would do this.  can I keep 1  
RDMA CM channel between each server/client pair?  Would I need to keep  
a qp, send/recv queue and completion queue for each multicast group?

Thx

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
