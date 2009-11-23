From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: patch for non-ib network
Date: Mon, 23 Nov 2009 11:11:32 -0800
Message-ID: <adafx853vkr.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.62.0911201915430.25859@mailhub.cdac.in>
	<Pine.LNX.4.62.0911231138530.24997@mailhub.cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.62.0911231138530.24997-NG0XCrj25/kh/ldBx82aDQ@public.gmane.org>
	(javed-If5XQcfNmg0@public.gmane.org's message of "Mon, 23 Nov 2009 18:57:30 +0530 (IST)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: javed-If5XQcfNmg0@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > paramnet-3 supports RDMA. there's separate uDAPL interface for fast
 > path specifically for MPI apps. tested with MVAPICH2 and intel mpi.
 > 
 > we've started with ofed/IPoIB for TCP/IP support. network is capable
 > of exploiting the stack further.
 > 
 > mismatch between ofed requirements and paramnet-3 specs, are covered
 > in the patch.

Then I would suggest sending the patch for review and inclusion in the
kernel.  Documentation/SubmittingPatches and Documentation/SubmittingDrivers
in the kernel source tree may be helpful.

However I would still probably think that IPoIB for non-IB networks is
unnecessary complexity -- the mismatch of IB and traditional ethernet/IP
semantics makes even IPoIB a bit of a problem for some apps, and then
layering a not-IB network on top of that is probably not a good idea.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
