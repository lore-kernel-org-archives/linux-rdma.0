From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: dapltest question
Date: Fri, 08 Jul 2011 10:23:29 -0500
Message-ID: <4E1720F1.5080201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Arlin,

I have a dumb question:  Is dapltest designed to support multiple dapltest client processes running on multiple physical 
systems to connect to a single dapltest server process/system?

I'm running tests where we have 4 client nodes running dapltest transaction clients connecting to the same dapltest 
server on a 5th node and I'm debugging a dapltest server hang.  I have more details if you're interested, but I just 
wanna make sure dapltest is designed to support this mode.

Thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
