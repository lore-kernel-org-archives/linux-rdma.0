From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Wed, 7 Oct 2009 17:38:27 -0700
Message-ID: <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>	 <4ACAF913.3050909@voltaire.com>	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9F4DE6A2B4F644698E94F00C4FEEF30A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>When used over IB, the IP address is little more than a qualifier contained
>within the IB CM REQ private data.

If we added support for AF_GID/AF_IB to the kernel, the rdma_cm could leave all
of the private data carried in the IB CM REQ entirely up to the user.  If the
user happens to format that data to look like the CMA header, so be it.  I
believe this would allow for a 'clean' implementation of rdma_resolve_addr,
preserve the ABI, and still allow a library to provide backwards compatibility.

The following information should be known after calling rdma_resolve_addr: sgid,
dgid, pkey, source port/sid, destination port/sid.  The address structure for
AF_IB should be defined to capture this information.  (The port / service ID
needs to be worked out.)

Would this approach combined with the ability to set the route work for
everyone?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
