From: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: WRITE/SEND to multiple destinations
Date: Mon, 3 Nov 2014 02:32:27 +0000 (UTC)
Message-ID: <loom.20141103T000730-108@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello everyone,

As a newbie to the world of InfiniBand programming,
I would appreciate your helps on my somewhat general and basic question.

Assume that I have a server, and N clients (N > 1).
I would like my server to set all clients' memory buffers to some value V.
How would I go about this problem?
So far, I've managed to establish 1-1  connections using READ/WRITE/SEND/RECEIVE.
So I guess the core of my question is:
how 1-to-N  connections are established in InfiniBand, and
if, in this regard, there is any difference between
RDMA verbs (READ/WRITE) vs. SEND/RECEIVE? 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
