From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Simplified iWARP Consumer Library
Date: Fri, 5 Mar 2010 16:07:03 -0800
Message-ID: <34C415061F244870BB8A526637CD04B0@amr.corp.intel.com>
References: <4B796BBD.5050007@inf.ethz.ch> <02600C74DFEE41EFAD9D387CF5A837CC@amr.corp.intel.com> <4B91913C.8000705@inf.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B91913C.8000705-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: phil-dElbnslWKco@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>I'll have to look into that. So far, the library was intended as an add-on
>to the existing code with the option to fall back to the original API if
>need be.

I think we keep this concept.

>Which of the features would you want to see in librdmacm? I guess the
>integration of the cm_id and qp as well as the simpler (synchronous) connection
>establishment and teardown functionality would fit. However, all cm events
>will thereafter be handled within the library rather than being presented to
>the user. Does that make sense?

I wasn't thinking about replacing existing calls, but rather adding new
functions.  I would start with just trying to integrate one feature, probably
the simpler connection model for the active side, then look to expand from
there.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
