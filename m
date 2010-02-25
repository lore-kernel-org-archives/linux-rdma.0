From: Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org>
Subject: link width question / opensm
Date: Thu, 25 Feb 2010 00:39:05 -0600
Message-ID: <20100225063905.GA4690@X300.wifi.conference.usenix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


  Hi,

for various reasons I'm trying to force a specific setting for 
the link speed and link width of an IB link.

I know opensm has an option to force link speed to a certain value.  I
modified OpenSM (3.3.5) and added a similar option for link width
(link_width_enabled field of port info struct).

Reading the IB spec, link_width_enabled is marked as read-write, just as
the link speed field.

However, it doesn't seem to work. I verified that link_width_enabled is
correctly set.

My questions:

- Is support for changing link width dependent on driver version 
or specific IB hardware?

- Is there another way to get what I want (control over link width+speed)?

  Thanks,
  Dries

PS. Please cc me. I'm not on the list.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
