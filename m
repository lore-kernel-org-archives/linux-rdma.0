From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 15:35:58 -0800
Message-ID: <adad42d41i9.fsf@roland-alpha.cisco.com>
References: <4B294BDD.3010405@systemfabricworks.com>
	<20091216213816.GV6188@obsidianresearch.com>
	<031b01ca7e99$38abf510$aa03df30$@com>
	<adazl5h47ix.fsf@roland-alpha.cisco.com>
	<03d101ca7f62$0dea4560$29bed020$@com>
	<20091217220450.GA8383@obsidianresearch.com>
	<040501ca7f6c$b9099950$2b1ccbf0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <040501ca7f6c$b9099950$2b1ccbf0$@com> (Robert Pearson's message
	of "Thu, 17 Dec 2009 17:00:26 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Of course we need to interoperate with ConnectX-en and it, as far as I know,
 > only knows how to compute the VCRC as though the packet was going to get
 > sent to IB including a phantom 12 byte LRH that is filled with 1's without
 > any way to turn it off. It is also a requirement that UD work well too.
 > Instead of connection setup if we could get a capability bit in a port info
 > record we could handle the general case.

How do you get port info records in an IBoE fabric?  There's no SA to
query, right?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
