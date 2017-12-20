From: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Sending and Receiving QPs with IPoIB
Date: Wed, 20 Dec 2017 22:36:59 +0000
Message-ID: <5CDA63463B33C94CA80846587415F07728293A70@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I noticed that when a client talks to a server over IPoIB with a TCP application, 2 QPs get created, one for sending and one for receiving instead of using 1 QP for sending and receiving.

	Why do we have one QP for sending and one for receiving?
	Is this intended behavior?

Thank you,

Sebastian Sanchez
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
