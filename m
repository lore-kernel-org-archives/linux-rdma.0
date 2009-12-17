From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 15:43:56 -0600
Message-ID: <03d101ca7f62$0dea4560$29bed020$@com>
References: <4B294BDD.3010405@systemfabricworks.com>	<20091216213816.GV6188@obsidianresearch.com>	<031b01ca7e99$38abf510$aa03df30$@com> <adazl5h47ix.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl5h47ix.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I agree about the polynomial. That would have been nice. As currently
proposed the embedding of the IB transport in Ethernet frames preserves the
IB ICRC as part of the transport and trades the VCRC for Ethernet's CRC32
over the whole frame. This means that the packet is effectively covered by
CRC32 twice except for the 802 headers and the fields that are excluded from
the ICRC. CRC32C should give better protection.

We have thought that we could try CRC32C first and if that works then use
that, otherwise fall back to CRC32 which would allow rxe to use CRC32C when
talking to itself and get a speedup on new Intel CPUs.

The crc32 code we have is based on some suggestions from Intel and seems to
be much faster than the 'standard' code in the kernel and we are/were
planning to merge the crc computation with the data copy. It is actually
less explicitly optimized than the code in the kernel but when we use the
loop unrolling directive in the compiler we get better overall results. That
core loop gives us about 5-6GB/sec for the copy/crc vs about 500MB/sec for
the 'standard' crc + copy.

Our plan is to strip out all the trace and dump code when the driver is
stable. We will keep the warn and error messages.

Bob

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, December 17, 2009 3:26 PM
To: Robert Pearson
Cc: 'Jason Gunthorpe'; 'frank zago'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; 'John
Groves'
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)


 > Yes, but later. For now it is still being actively developed and is
changing
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
