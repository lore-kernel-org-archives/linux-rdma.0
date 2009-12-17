From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 15:46:46 -0800
Message-ID: <ada4onp4109.fsf@roland-alpha.cisco.com>
References: <4B294BDD.3010405@systemfabricworks.com>
	<20091216213816.GV6188@obsidianresearch.com>
	<031b01ca7e99$38abf510$aa03df30$@com>
	<adazl5h47ix.fsf@roland-alpha.cisco.com>
	<03d101ca7f62$0dea4560$29bed020$@com>
	<20091217220450.GA8383@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091217220450.GA8383-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Thu, 17 Dec 2009 15:04:50 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > The ICRC isn't even necessary from a technical sense for DCE. The
 > underlying reasons for the ICRC/VCRC split are not really present for
 > ethernet. Considering RDMAoE isn't interoperable with existing IB anyhow
 > and DCE can't do routing, the best course would be to just get rid of
 > it entirely.

Not sure I agree... it would be entirely possible and sensible to create
an IBoE router (and if the IBoE GRH used global scope addresses, pretty
much the same as routing IPv6), and I think you would want end-to-end
ICRC protection in that case (since the router would be regenerating the
ethernet CRC).  Even in the ethernet case there are probably realistic
cases of adding a VLAN tag or something that require the CRC to be
recalculated by a switch -- and some switches probably cut corners and
just recalculate the CRC of all packets on egress, just to avoid
conditional cases.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
