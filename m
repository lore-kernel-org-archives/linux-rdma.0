From: Mahesh <mandyamahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: qperf
Date: Fri, 15 Mar 2013 08:52:47 +0000 (UTC)
Message-ID: <loom.20130315T094826-951@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,


While trying to understand the qperf code i found that the NCQE is 
hardcoded to the value of 1024 in rdma.c and there are no command line options
to modify it. Any specific reason why its done this way rather than
honouring the values returned from query.

Is it necessary to have atleast depth of 1024 to get reasonable
performance numbers.

Thanks in advance,
Mahesh
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
