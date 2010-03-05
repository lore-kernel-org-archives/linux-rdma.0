From: Philip Frey <philip.frey-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Subject: Re: Simplified iWARP Consumer Library
Date: Sat, 6 Mar 2010 00:18:20 +0100
Message-ID: <4B91913C.8000705@inf.ethz.ch>
References: <4B796BBD.5050007@inf.ethz.ch> <02600C74DFEE41EFAD9D387CF5A837CC@amr.corp.intel.com>
Reply-To: phil-dElbnslWKco@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02600C74DFEE41EFAD9D387CF5A837CC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'll have to look into that. So far, the library was intended as an add-on
to the existing code with the option to fall back to the original API if
need be.

Which of the features would you want to see in librdmacm? I guess the
integration of the cm_id and qp as well as the simpler (synchronous) connection
establishment and teardown functionality would fit. However, all cm events
will thereafter be handled within the library rather than being presented to the
user. Does that make sense?

Sean Hefty wrote:
>> as announced last week (on general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org), I have developed a
>> shared library to simplify iWARP/RDMA application development on Linux in the
>> course of my PhD. The library, called libiwarp, is based on libibverbs and
>> librdmacm - it is essentially a set of wrappers to hide some of the complexity.
> 
> I briefly toured through the code, and it seems to offer these main features:
> 
> 1. Joins the rdma_cm_id and qp together into a single construct.
> 2. Supports synchronous rdma_cm operation.
> 3. Abstracts some initialization, like opening the device, creating PDs, etc.
> 4. Simplifies some verbs operations.
> 
> Would it be possible to submit patches against the librdmacm to integrate some
> of these features?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
