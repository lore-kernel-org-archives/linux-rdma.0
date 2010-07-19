From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question Regarding rdma/ucm
Date: Mon, 19 Jul 2010 10:32:43 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A6E49D90@orsmsx501.amr.corp.intel.com>
References: <4C41EAF8.1050901@tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C41EAF8.1050901-/Zw1syy4LHg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark O'C <mjocalla-/Zw1syy4LHg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Copying linux-rdma mail list on the response.  It helps to show interest in specific features and patches for merging things.

> I have seen recently that you submitted a number of patches which allow
> users to join multicast groups using MGIDs directly. I see that the APIs
> for these come under /include/rdma/rdma_user_cm.h
> 
> Can you tell me will these APIs be available in OFED 1.5.2? I am looking
> through rc2 but this file is not present.

I'm assuming that you're referring to the patches that deal with AF_IB.  Those will NOT be available in OFED until they have been queued for inclusion upstream.   I don't know of any issues with those patches; I just don't think others have had time to review them in detail.

That said, the current code does support MGIDs directly to a limited degree.  The MGID must be specified as an IPv6 address that meets the following check (done in the kernel):

       } else if ((addr->sa_family == AF_INET6) &&
                  ((be32_to_cpu(sin6->sin6_addr.s6_addr32[0]) & 0xFFF0FFFF) ==
                                                                0xFF10A01B)) {
                 /* IPv6 address is an SA assigned MGID. */
                 memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);

MGIDs obtained by joining a multicast group and letting the IB SA select the MGID should have this format.  The AF_IB patches remove this special handling and allow specifying the full range of MGIDs.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
