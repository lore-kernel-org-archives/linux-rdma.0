From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] zero-copy extensions for rsockets
Date: Wed, 1 Aug 2012 00:15:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6EA44@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A6E8D5@ORSMSX101.amr.corp.intel.com>
 <20120731183243.GA4755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E926@ORSMSX101.amr.corp.intel.com>
 <20120731213450.GA5787@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A6E9E6@ORSMSX101.amr.corp.intel.com>
 <20120731231557.GA6956@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731231557.GA6956-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christoph Lameter (christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org)" <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, "Greg KH (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm not sure that is so great, one of the benefits of the aio
> interface is you have just one queue and one eventfd to manage, no
> matter how many fd's you are AIOing against. Completions can happen
> out of order. Requiring an app to juggle multiple ioq thingies split
> on some arbitrary axis (ie by HCA, in particular) is very ugly from a
> user perspective.

I'm only referring to the interface.  aio allows a user to create any number of aio context's, with the ability to direct every read/write to a different context.  Sure a user can use just a single queue and eventfd, but that's not required.

I was suggesting a more restrictive interface.  One where a socket is bound to exactly one aio context, or at most two with sends and receives defined separately.  So, it's known which CQ to poll.
 
> What I would see as much more difficult is how to match your streaming
> RDMA WRITE ring algorithm used for synchronous read/write with
> asynchronous read/write and direct placement. That seems pretty
> complicated.

I would expect sent data to appear in the stream in the same order that the calls are made.  Likewise, reads would complete in order.
 
> I'm not sure what semantics you are going for here? Is get/put the
> same as a AIO read/write, or are they RDMA? How does it work if one
> side is using read/write and the other does get/put? Are there two
> things here? async read/write and the get/put RDMAish stuff?

Mapping to RDMA:
iomap - register memory and publish address/key to remote side
iounmap - unregister memory
get - RDMA read
put - RDMA write

There are different things here.  The primary goal is to add usable zero-copy support to rsockets.  iomap/put/get are intended to address that on the receive side.  (In the case of get, the initiator is also the receiver.)  Asynchronous completions are intended to address this on the send side.

A call like put can behave similar to write wrt a blocking or nonblocking socket.  However, get doesn't make any sense as a nonblocking call without asynchronous completions.  If asynchronous support is added for get/put, then it makes sense to extend that functionality to any data transfer call.  But there's no requirement on the application to use it for other calls.  It's probably works out better if they don't.
 
> At a minimum I think you'd want to prefix these names with rsockets_,
> since they are very likely to collide with something else.

Yes - there would be a prefix.

> But, is this valuable? If people are going to have to do lots of
> rework to support these calls would they just be better off using
> something like CCI?

Personally, I've heard a lot of different developers ask specifically for simple socket extensions to support RDMA.

The entire goal of rsockets is to minimize the changes needed for an application to use RDMA devices.  So, I agree, if the solution requires a large amount of rework, it's not worth it.

But if we can provide a small number of calls that a user can *selectively* use throughout their application that do avoid memory copies, then I believe there's significant value in doing so.  The application does not need to change how they setup connections.  Most of their communication can remain as-is.  E.g. using read/write for small messages.  But they now have the ability to integrate zero-copy calls into their app by one side calling iomap and the other side put.

Such an option sounds substantially better than having to write to an entirely new API, such as verbs.  Plus it enables an iterative approach to migrating to zero-copy calls. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
