From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 13:25:58 -0800
Message-ID: <adazl5h47ix.fsf@roland-alpha.cisco.com>
References: <4B294BDD.3010405@systemfabricworks.com>
	<20091216213816.GV6188@obsidianresearch.com>
	<031b01ca7e99$38abf510$aa03df30$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <031b01ca7e99$38abf510$aa03df30$@com> (Robert Pearson's message
	of "Wed, 16 Dec 2009 15:46:26 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Yes, but later. For now it is still being actively developed and is changing
 > a lot. Once it settles down we plan to convert to patches and push up
 > stream.

I think you would probably be better off developing the kernel driver as
a branch in an up-to-date kernel tree, and then worrying about backports
later.  You could get rid of some of the redundant infrastructure like
dump_hex() and crc32 (too bad IB didn't choose the CRC32C polynomial, so
you can't use the crypto API and get Intel CRC32 instruction
acceleration for free).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
