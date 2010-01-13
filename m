From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv7 0/9] RoCEE support to Infiniband
Date: Wed, 13 Jan 2010 13:18:37 -0800
Message-ID: <adaockxn1oy.fsf@roland-alpha.cisco.com>
References: <20100105103213.GB31480@mtls03>
	<ada7hrnp7rr.fsf@roland-alpha.cisco.com>
	<2ED289D4E09FBD4D92D911E869B97FDD026854EA@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD026854EA-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
	(Liran Liss's message of "Wed, 13 Jan 2010 23:08:30 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > RoCEE was chosen for these patches in accordance with the terminology
 > used in the proposal discussed by the OFA.  We have no problem
 > resubmitting these patches using "iboe" so that you can push them into
 > 2.6.34.  We will need to stay aware of any future name recommendations
 > by relevant industry bodies.

Well, don't just take my opinion as the final answer.  It would be good
if someone could "officially" pick a name.  However I really do feel
that RoCEE is a pretty bad choice, since it is both technically
inaccurate and also hard for users to understand.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
