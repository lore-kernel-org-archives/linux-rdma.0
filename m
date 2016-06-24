From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Interrupted IO causing async errors
Date: Fri, 24 Jun 2016 18:16:37 -0400
Message-ID: <34BD06A5-6BF1-4FA8-94F2-DF20DD8C6156@oracle.com>
References: <00e101d1cd65$e19bf360$a4d3da20$@opengridcomputing.com> <BDD2D64C-7A05-42EB-83C2-F95825C7579D@oracle.com> <20160624192637.GE14506@obsidianresearch.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160624192637.GE14506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Jun 24, 2016, at 3:26 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
>> On Thu, Jun 23, 2016 at 08:15:29PM -0400, Chuck Lever wrote:
>> When an application is signaled, outstanding RPCs are terminated.
>> When an RPC completes, whether because a reply was received,
>> or because the local application has died, any memory that was
>> registered on behalf of that RPC is invalidated before it can be
>> used for something else. The data in that memory remains at rest
>> until invalidation and DMA unmapping is complete.
> 
>> It appears that your server is attempting to read an argument or
>> write a result for an RPC that is no longer pending. I think both
>> sides should report a transport error, and the connection should
>> terminate. No other problems, though: other operation should
>> continue normally after the client re-establishes a fresh connection.
> 
> Yuk! A transport tare down and restart on user space CTRL-C/etc ?
> Isn't that a little too common and a little too expensive to be a
> permanent solution?

I agree, it's not an optimal solution, but:

- The server must not be allowed to update memory
that may have already been re-used after an RPC has
terminated.

- Typically reconnecting is quite fast.

- Not every ^C or signal will trigger connection loss: only
if there happens to be an outstanding RPC involving the
signaled application.

- Often a ^C or signal is the result of impatience while
waiting for storage target restart. In that case, a reconnect
is required anyway and the client has to redrive RPCs it is
still interested in.

- The problem seems most acute for Long Replies, where a
large buffer has been registered for the server to write
the reply into (as opposed to using a simple RDMA Send).
As we work to increase the inline thresholds, there will be
many fewer Long Replies and that narrows the exposure
significantly.

- Signals during workloads where NFS/RDMA is beneficial
seem to be fairly infrequent. That of course is likely to change
over time.

So this is a compromise solution that is safe and should
not be too onerous to performance. However, I'm open to
better (less noisy) approaches.

A protocol mechanism could be added so that a client can
notify a server of a canceled RPC. This helps some, but is
racy (impossible to be 100% effective), and protocol
changes take time.

Wait a moment after a signal occurs during a synchronous
RPC, to provide an opportunity for server replies to drain
and handle invalidation for us. Again, helps some, but not
100% guaranteed to prevent a Remote Protection Error.
Care must be taken to wait without deadlocking the RPC
client.

Memory resources for a terminated RPC could be parked
until the server replies and the regions can be invalidated
normally in the reply handler.

If the advertised buffer is part of a direct I/O, and the
application has terminated, that memory would have to
be put aside somehow until it was safe to re-use.

A page in the page cache would have to be removed or
locked during the waiting period, and that has some
undesirable consequences.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
