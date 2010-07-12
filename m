From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: basic questions about partitions
Date: Mon, 12 Jul 2010 13:53:09 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D0B58321@MNEXMB1.qlogic.org>
References: <4C3B5FEA.1020904@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3B5FEA.1020904-wbocuHtxKic@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom,

For your first question: yes, an HCA port can belong to multiple partitions. Trivial example: All HCAs must always be able to communicate with the SM, so they must be members of the SM's partition even if they are also members of (for example) the "MPI Traffic" partition.

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tom Ammon
Sent: Monday, July 12, 2010 2:33 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: basic questions about partitions

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
