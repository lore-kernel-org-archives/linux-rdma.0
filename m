From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: size of queue pair number
Date: Thu, 24 May 2012 10:07:25 +0200
Message-ID: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

we want to make use of Infiniband communication and I am working on the
Linux part. The peer can be a non-Linux system. Now we see a mismatch in
the size of the queue pair number in Linux (32 bits) and the Infiniband
Architecture Specification (24 bits). Will the additional 8 highest
order bits ever be used in Linux? And if yes, for which purpose? Is the
maximum queue pair number 0xFFFFFF? 

Kind regards, Ursula Braun, IBM Germany


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
