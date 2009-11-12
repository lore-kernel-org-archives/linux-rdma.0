From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mckey: add notifications on events
Date: Thu, 12 Nov 2009 08:24:55 -0800
Message-ID: <E4833D5890924476894DCF13A7CE82A9@amr.corp.intel.com>
References: <Pine.LNX.4.64.0911111814350.6979@zuben.voltaire.com> <C2A8DE4897EE4AA19F125A933FF8B08E@amr.corp.intel.com> <4AFBCCE3.9090106@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFBCCE3.9090106-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>The librdmacm examples serve for multiple purposes, among them user education
>on how to write rdmacm based apps and as a vehicle to test/validate/reproduce
>features/bugs/issues, for example a follow program claimed that she isn't sure
>to get a multicast error event on her application when a port goes down, so
>with my patch to mckey we were able to see that this event is generated and we
>can now do better testing. In the future mckey can be further enhanced to
>rejoin,etc on either of the events, makes sense?

ok - thanks - I'll merge it in

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
