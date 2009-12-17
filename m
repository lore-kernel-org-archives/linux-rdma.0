From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 17:10:32 -0600
Message-ID: <040601ca7f6e$22450840$66cf18c0$@com>
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

Forgot to reply to one other point. For the most part we have been
developing in vanilla recent kernel.org trees when we are testing rxe<->rxe.
To talk to ConnectX we need to use the OFED-rdmaoe environment and then we
have to play with symvers. If support for ConnectX-en with rdmaoe were
upstream then we would only use those kernels.

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
