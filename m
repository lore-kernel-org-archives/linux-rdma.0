From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: basic questions about partitions
Date: Mon, 12 Jul 2010 12:33:14 -0600
Message-ID: <4C3B5FEA.1020904@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  Hi,

I have some basic questions about IB partitions.

Can an HCA port belong to more than 1 partition at a time?

How do you configure partitions with opensm? From reading the opensmd 
man page, it looks like you just create a file called 
/etc/osm-partitions.conf, with port GUIDs and such, but is this current? 
I ask because according to the man page the opensm configuration file is 
in /etc/opensm/ . Can you tell opensm where to look for the partitions file?

Thanks,

Tom

-- 
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
