From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 11:43:45 -0700
Message-ID: <B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>
References: <4BB0E670.3010507@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB0E670.3010507-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Does the rdma-cm allow concurrent binds to PF_INET, INADDR_ANY, port=X
>and PF_INET6, IN6ADDR_ANY_INIT, port=X ?

No, since this shows up in the rdma_cm as using the same port space.

The rdma_cm might be able to support this if the port space were separated based
on the address family, depending on how PS IB ends up.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
