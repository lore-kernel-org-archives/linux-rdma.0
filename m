From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: better understanding rdma-cm UNREACHABLE/ETIMEDOUT scheme
Date: Tue, 21 May 2013 21:21:55 +0300
Message-ID: <CAJZOPZJ44fgPtBHpu5eXSVUQb0zP7rJH1UvL2RneDCrhGVLSwQ@mail.gmail.com>
References: <519B8DB3.3010500@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD29AE3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD29AE3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dina Leventol <dinal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 21, 2013 at 6:24 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> One thing seen in the nodes dmesg is a message from an old patch of
>> yours which exists in ofed1.5.3 but didn't hit (or wasn't accepted?)
>> upstream saying "ib_cm: calculated mra timeout 67584 > 8192, decreasing
>> used timeout_ms" does this provides any insight into the problem?

> I don't remember this patch at all.

Alex sent it to you, is that something which is missing upstream or
alternatively could create troubles on that ofed stack where its
applied?


> My first guess is that the server isn't responding to new requests.

yep, smells like this could be the root cause here, Dina and Alex will
do some tweaking of the server code to make sure there's no starvation
is servicing new connection requests.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
