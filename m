From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: IB equivalent of virtual IP address ?
Date: Sun, 20 Feb 2011 14:33:01 +0100
Message-ID: <AANLkTinTwygiSzBC3-AJjt070RTz_B=qYqcm9AayPwPn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

A convenient way to provide high availability when using fail-over
between two IPv4 iSCSI servers is to configure the HA software such
that a secondary IPv4 address is only assigned to the active server.
I'd like to build a HA SRP setup using a similar approach. This leads
me to the following question: does there exist an equivalent of
virtual IP addresses for IB ? As far as I can see in the IBTA specs a
subnet manager can assign a secondary GID to an IB HCA port
dynamically.

Does any of the existing IB switches support this ? If so, how does
communication between HA software and IB switch happen ?

Does OpenSM support assigning secondary GIDs to a HCA port ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
