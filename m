From: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: Pro/Cons of send/receive/read/write operations?
Date: Wed, 10 Nov 2010 10:14:16 -0700
Message-ID: <20101110101416.p006bad7hyc88wog@celticblues.com>
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

It seems there are several ways to transfer data via RDMA: Send/Send  
w/immediate, Receive, RDMA Write/RDMA Write w/immediate, the Atomic  
extensions, and then the various transport modes variations with some  
of these operations.  As an RDMA/IB newbie, it is somewhat confusing  
when determining the best operations for my application.  What are the  
various pros/cons of each?

For my application I will have multiple apps (probably around 4 for  
now) sending data to a single app.  I have 3 sets of data, packets if  
you like, that need to be sent, or written to, the target app.  Packet  
1, is small, only 16 bytes. Packet 2, will be a minimum of 4 MB and  
will likely be as large 16 MB, perhaps more.  Packet 3, will be a max,  
probably, of 4 MB.

Thanks,
CB

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
