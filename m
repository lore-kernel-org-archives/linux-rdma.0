From: Todd Strader <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Subject: Multicast Scaling
Date: Thu, 05 Aug 2010 14:34:34 -0500
Message-ID: <4C5B124A.7030409@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm running ib_send_bw (version 1.20) over ConnectX HCAs on an 
Infiniscale III switch.  If I run:
ib_send_bw -s 256 -c RC
I get 790 MB/s
ib_send_bw -s 256 -c UD
still gets me 790 MB/s
ib_send_bw -s 256 -c UD -g 1
which runs over a multicast GID/LID gets 790 MB/s when there are two 
HCAs on the switch.  However:
3 HCAs - 726 MB/s
4 HCAs - 701 MB/s
. . .
12 HCAs - 205 MB/s

I'm trying to understand why this drops off for each new HCA I add to 
the switch.  All the HCAs and the switch are running the latest firmware 
(2.7.0 and 1.0.5 respectively).  Only one HCA is transmitting and only 
one is receiving.  All the other HCAs are quiet.

I'm wondering if anyone has any suggestions on what causes this effect 
and how I might deal with it.

Thanks.

Todd
**********************************************************************************************
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information 
belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is 
intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any 
disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please 
immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not 
use or disclose the content to others.
**********************************************************************************************

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
