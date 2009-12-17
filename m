From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 13:56:53 -0800
Message-ID: <adavdg5463e.fsf@roland-alpha.cisco.com>
References: <4B294BDD.3010405@systemfabricworks.com>
	<20091216213816.GV6188@obsidianresearch.com>
	<031b01ca7e99$38abf510$aa03df30$@com>
	<adazl5h47ix.fsf@roland-alpha.cisco.com>
	<03d101ca7f62$0dea4560$29bed020$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03d101ca7f62$0dea4560$29bed020$@com> (Robert Pearson's message
	of "Thu, 17 Dec 2009 15:43:56 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > We have thought that we could try CRC32C first and if that works then use
 > that, otherwise fall back to CRC32 which would allow rxe to use CRC32C when
 > talking to itself and get a speedup on new Intel CPUs.

How would you negotiate that?  Is this being worked in the definition of
the IBoE spec?  It seems in a final standard, having something stronger
than two CRC32s and something that can handle jumbo frames would be
worth it.

 > The crc32 code we have is based on some suggestions from Intel and seems to
 > be much faster than the 'standard' code in the kernel and we are/were
 > planning to merge the crc computation with the data copy. It is actually
 > less explicitly optimized than the code in the kernel but when we use the
 > loop unrolling directive in the compiler we get better overall results. That
 > core loop gives us about 5-6GB/sec for the copy/crc vs about 500MB/sec for
 > the 'standard' crc + copy.

Interesting ... can the upstream kernel code be improved similarly?

 > Our plan is to strip out all the trace and dump code when the driver is
 > stable. We will keep the warn and error messages.

If you develop upstream and use the ftrace tracepoints stuff then the
overhead of (runtime) disabled trace points is nearly zero (one 5-byte
NOP, so a cycle or two).  So you can keep them forever (which is
realistically how long you're going to be debugging this :)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
