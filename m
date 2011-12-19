From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: "illegal seek" with ibv_post_recv
Date: Mon, 19 Dec 2011 10:11:43 -0700
Message-ID: <20111219101143.725484ctnfedibm7@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When I make a call to ibv_post_recv I sometimes get an error...  
calling perror prints out "illegal seek" as the reason for the  
error... What does this mean?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
