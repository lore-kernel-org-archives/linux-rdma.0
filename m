From: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Subject: strong ordering for data registered memory
Date: Tue, 10 Nov 2009 15:19:26 -0500
Message-ID: <4AF9CACE.8070700@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some time ago there was an email sent to this group with the subject 
"weak ordering for data registered memory".  I don't recall any action 
resulting from this thread.  So, I have a question.  If a bit were 
defined to specify "strong ordering", perhaps as a "access" flag (see 
ibv_access_flags) and used with ibv_reg_mr(), would that be sufficient 
for (1) client applications that need a HW "guarantee" of writing the 
last byte of an RDMA last and (2) platform implementations that need to 
deliver that feature?

-David

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
