From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Simplified iWARP Consumer Library
Date: Thu, 11 Mar 2010 14:49:32 -0800
Message-ID: <D02FA836874E4D0BB034477ED376C46C@amr.corp.intel.com>
References: <4B796BBD.5050007@inf.ethz.ch> <02600C74DFEE41EFAD9D387CF5A837CC@amr.corp.intel.com> <4B91913C.8000705@inf.ethz.ch> <34C415061F244870BB8A526637CD04B0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <34C415061F244870BB8A526637CD04B0-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, phil-dElbnslWKco@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>Which of the features would you want to see in librdmacm? I guess the
>>integration of the cm_id and qp as well as the simpler (synchronous)
>connection
>>establishment and teardown functionality would fit. However, all cm events
>>will thereafter be handled within the library rather than being presented to
>>the user. Does that make sense?

I have some ideas for simplifying connection establishment as part of my changes
to support native IB addresses through the rdma_cm interface.  This includes
adding new calls to the librdmacm: rdma_getaddrinfo and
rdma_create_id_and_optional_qp_and_bind_addr_and_set_route.
I'll pick a different name for the latter. :)  Combined, I think these calls
could allow a user to more easily connect, while still providing low level
control for anyone who wants it.

I haven't looked at the details for this, but we may be able to support
synchronous operation by allowing the user to provide a NULL rdma_event_channel
when creating the rdma_cm_id.  We can take advantage of rdma_migrate_id to
implement this, or even toggle between synchronous and asynchronous mode.  The
hope is that the librdmacm can remain threadless.

If you can give me a month or so to finish my current patches, I'll take a look
at this as part of my work.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
