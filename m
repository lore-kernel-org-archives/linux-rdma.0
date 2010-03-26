From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 09:47:34 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE84CFD841@azsmsx501.amr.corp.intel.com>
References: <4BACD985.1070906@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BACD985.1070906-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[...]

>  They also want
>to be able to "reset" a failed device (EEH events

[...]

>1) device A event happens causing the device to unregister itself with
>the RDMA core.  This could be an EEH event requiring full device reset,
>or a OS hot-plug removal event.

Just to nit-pick on terminology.  When you say reset a device do you mean
adapter(or silicon) reset?  In the case of multiport adapter, does that
mean all devices for that adapter will post RDMA_CM_EVENT_DEVICE_REMOVAL
event?

Chien

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
