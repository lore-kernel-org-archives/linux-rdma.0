From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Simplified iWARP Consumer Library
Date: Fri, 5 Mar 2010 15:06:06 -0800
Message-ID: <02600C74DFEE41EFAD9D387CF5A837CC@amr.corp.intel.com>
References: <4B796BBD.5050007@inf.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B796BBD.5050007-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: philip.frey-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>as announced last week (on general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org), I have developed a
>shared library to simplify iWARP/RDMA application development on Linux in the
>course of my PhD. The library, called libiwarp, is based on libibverbs and
>librdmacm - it is essentially a set of wrappers to hide some of the complexity.

I briefly toured through the code, and it seems to offer these main features:

1. Joins the rdma_cm_id and qp together into a single construct.
2. Supports synchronous rdma_cm operation.
3. Abstracts some initialization, like opening the device, creating PDs, etc.
4. Simplifies some verbs operations.

Would it be possible to submit patches against the librdmacm to integrate some
of these features?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
