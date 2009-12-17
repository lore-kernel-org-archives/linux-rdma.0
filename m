From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Thu, 17 Dec 2009 11:36:08 -0600
Message-ID: <039501ca7f3f$6b9f4e30$42ddea90$@com>
References: <4B294BDD.3010405@systemfabricworks.com>	<20091216213816.GV6188@obsidianresearch.com>	<031b01ca7e99$38abf510$aa03df30$@com>	<7FFE592E129646A2B0DB5AC99D0261C7@amr.corp.intel.com> <adafx7a79xh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx7a79xh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ipath driver, which I am more familiar with, replicated the transport
for RC, UC and UD which also caused some code duplication. We tried to
combine them all together in rxe.

Bob Pearson

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, December 16, 2009 5:53 PM
To: Sean Hefty
Cc: 'Robert Pearson'; 'Jason Gunthorpe'; 'frank zago';
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; 'John Groves'
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)


 > Is there any commonality that can be shared between rxe and the qlogic
driver?

Interesting to note that according to ohcount, rxe is 9591 non-blank
non-comment lines of kernel code, while qib is 36957 lines.  So the
complexity of IB transport is a small part of the complexity of qib.

 - R.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
