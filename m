From: "Todd Strader" <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Subject: ConnectX WQE invalidation
Date: Tue, 23 Feb 2010 17:11:36 -0600
Message-ID: <4B8460A8.3000203@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I've posted this question to the Mellanox support site, but I've found 
that it's not terribly responsive.  I was hoping someone here would know 
the answer to my question, or be able to direct me to someone who does.

I'm reading section 9.2.1 of the ConnectX Family PRM (Posting a Work 
Request to a Send Work Queue) and I'm a little confused.

Previous sections mention that the Send Queue is sampled at the WQEBB 
boundaries. And ownership is passed from SW to HW via the owner bit in 
the Ctrl segment. If that is the case, why does each 64 byte block of 
the SQ need to be invalidated initially and as the SQ progresses?

Let's say my WQEBB is 256 bytes. I would think that the HCA would only 
sample every 256 bytes for a valid control structure. Why do I need to 
maintain 64 byte chunks?

Thanks for the help.

Todd Strader
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
