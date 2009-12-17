From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 15:04:50 -0700
Message-ID: <20091217220450.GA8383@obsidianresearch.com>
References: <4B294BDD.3010405@systemfabricworks.com> <20091216213816.GV6188@obsidianresearch.com> <031b01ca7e99$38abf510$aa03df30$@com> <adazl5h47ix.fsf@roland-alpha.cisco.com> <03d101ca7f62$0dea4560$29bed020$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03d101ca7f62$0dea4560$29bed020$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2009 at 03:43:56PM -0600, Robert Pearson wrote:
> I agree about the polynomial. That would have been nice. As currently
> proposed the embedding of the IB transport in Ethernet frames preserves the
> IB ICRC as part of the transport and trades the VCRC for Ethernet's CRC32
> over the whole frame. This means that the packet is effectively covered by
> CRC32 twice except for the 802 headers and the fields that are excluded from
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
