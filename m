From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question regarding max_rd_atomic
Date: Tue, 17 Dec 2013 16:42:26 -0500
Message-ID: <CADPSxAix0B=VEzg9Zx_nuiK1aXwGvGoMi7FhSb-Y7M6NaAYRSw@mail.gmail.com>
References: <CADPSxAgR8PRXPfMgTEKp0=f8uGNLs4nSDLpKubPMH8RRV9VzxA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388D0DD5C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D0DD5C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

That was really helpful. Thanks a lot.

--Anuj

On Tue, Dec 17, 2013 at 4:37 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> 1. Why doesn't this exist for other operations like RDMA write or SEND?
>
> RDMA reads require that the remote HW maintain some state information about the operation as it is progressing.  The remote QP receives the read request, pulls the requested data from memory, and transfers the data back to the initiator.  RDMA writes and send operations do not require this sort of context on the remote side.
>
>> 2. Why is the maximum value so small i.e 16?
>
> Basically, it's a HW constraint.  RDMA reads are still queued at the requestor side.  Some number of read requests are transferred to the remote side, so that the remote HW can process them.  All that's needed is a large enough queue to keep the pipeline going, where 'large enough' is relative to the round trip latency between the nodes, the size of the read operations, how often read requests appear back to back, and so forth.  In practice, I'm guessing that a small number is usually sufficient.
>
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
