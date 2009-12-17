From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 17:17:43 -0600
Message-ID: <040d01ca7f6f$237de0f0$6a79a2d0$@com>
References: <4B294BDD.3010405@systemfabricworks.com> <20091216213816.GV6188@obsidianresearch.com> <031b01ca7e99$38abf510$aa03df30$@com> <adazl5h47ix.fsf@roland-alpha.cisco.com> <03d101ca7f62$0dea4560$29bed020$@com> <20091217220450.GA8383@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Oops. I should have said ICRC not VCRC. There is no VCRC for rdmaoe.
The ICRC is, however, computed exactly the same as for an IB packet. It is
bit for bit identical.

-----Original Message-----
From: Robert Pearson [mailto:rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org] 
Sent: Thursday, December 17, 2009 5:00 PM
To: 'Jason Gunthorpe'
Cc: 'Roland Dreier'; 'frank zago'; 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'John
Groves'
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)

Of course we need to interoperate with ConnectX-en and it, as far as I know,
only knows how to compute the VCRC as though the packet was going to get
sent to IB including a phantom 12 byte LRH that is filled with 1's without
any way to turn it off. It is also a requirement that UD work well too.
Instead of connection setup if we could get a capability bit in a port info
record we could handle the general case.

Bob

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Thursday, December 17, 2009 4:05 PM
To: Robert Pearson
Cc: 'Roland Dreier'; 'frank zago'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; 'John Groves'
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)

On Thu, Dec 17, 2009 at 03:43:56PM -0600, Robert Pearson wrote:
> I agree about the polynomial. That would have been nice. As currently
> proposed the embedding of the IB transport in Ethernet frames preserves
the
> IB ICRC as part of the transport and trades the VCRC for Ethernet's CRC32
> over the whole frame. This means that the packet is effectively covered by
> CRC32 twice except for the 802 headers and the fields that are excluded
from
> the ICRC. CRC32C should give better protection.

The ICRC isn't even necessary from a technical sense for DCE. The
underlying reasons for the ICRC/VCRC split are not really present for
ethernet. Considering RDMAoE isn't interoperable with existing IB anyhow
and DCE can't do routing, the best course would be to just get rid of
it entirely.

IMHO, a smart thing would be to figure out how to exchange ICRC
capability during the connection setup and turn it off if both sides
support it. With the ICRC removed the rxe send side should be able to
be completely 0 copy...

Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
