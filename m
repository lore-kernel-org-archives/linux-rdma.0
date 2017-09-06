From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Wed, 6 Sep 2017 11:11:44 -0400
Message-ID: <4E2E5580-69A5-4C3B-9FCA-E61AE2042E6B@oracle.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net> <1230f9d9-07c1-6d00-b197-f408712fb5c1@grimberg.me> <890CC58C-7F8F-4B7E-8620-21F07007D3AA@oracle.com> <6dcdcc25-2613-cdb5-1db2-6c944f05242b@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6dcdcc25-2613-cdb5-1db2-6c944f05242b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Sep 6, 2017, at 10:29 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>>> Question, what happens in direct-io for example? Can a mapped buffer be
>>> reclaimed/free'd before the send completion arrives?
>> Good Q! RPC completion allows memory containing the arguments and
>> results to be re-used. IIRC our conclusion was that a retransmitted
>> Send could expose the wrong argument data on the wire in this case.
>> Buffer re-use implies that the RPC has completed. Either a matching
>> RPC Reply was received, or the RPC was terminated via a POSIX signal.
>> If the client has already received an RPC Reply for this transaction,
>> a previous transmission of the RPC Call has already executed on the
>> server, and this retransmission will be ignored. It's only purpose is
>> to generate an appropriate RDMA ACK.
>> A re-used buffer might be subsequently used for data that is sensitive,
>> and the retransmission will expose that data on the wire.
> 
> That was where I was going with this...
> 
>> To protect
>> against that, RPC can use a GSS flavor that protects confidentiality
>> of RPC arguments and results. This would also require RPC-over-RDMA
>> to use only RDMA Read to convey RPC Call messages. Send would be used
>> only to convey the chunk lists, never data.
>> Note that the buffers used to construct RPC Calls are always mapped
>> and Send uses the local DMA key to post them. These can also be
>> re-used immediately after RPC completion. The exposure risk there is
>> of RPC headers and non-data arguments.
> 
> I see, but how can the user know that that it needs to use RPCSEC_GSS
> otherwise nfs/rdma might compromise sensitive data? And is this
> a valid constraint? (just asking, you're the expert)

sec=krb5p is used in cases where data on the wire must remain
confidential. Otherwise, sensitive or no, data on the wire goes
in the clear.

But an administrator might not expect that other sensitive data
on the client (not involved with NFS) can be placed on the wire
by the vagaries of memory allocation and hardware retransmission,
as exceptionally rare as that might be.

Memory in which Send data resides is donated to the device until
the Send completion fires: the ULP has no way to get it back in
the meantime. ULPs can invalidate memory used for RDMA Read at
any time, but Send memory is registered with the local DMA key
(as anything else is just as expensive as an RDMA data transfer).

The immediate solution is to never use Send to move file data
directly. It will always have to be copied into a buffer or
we use RDMA Read. These buffers contain only data that is
destined for the wire. Does that close the unwanted exposure
completely?

If the HCA can guarantee that all Sends complete quickly (either
successful, flush, or time out after a few seconds) then it could
be fair to make RPC completion also wait for Send completion.
Otherwise, a ^C on a file operation targeting an unreachable
server will hang indefinitely.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
