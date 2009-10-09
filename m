From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] rping is not resolving ipv6 addresses
Date: Fri, 9 Oct 2009 16:02:47 -0700
Message-ID: <0AA9B9870A0545E6BCCF3A5EF4BAB34E@amr.corp.intel.com>
References: <1254957121.23471.17.camel@wilder.ibm.com> <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com> <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com> <1255122901.3533.20.camel@wilder.ibm.com> <20091009224604.GG5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091009224604.GG5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>rdma_resolve_addr (and likely the underlying kernel component) must
>respect this when dealing with link local scope addresses.
>
>rmda_resolve_addr should fail if a link local IPv6 address is provided
>without scope, like the normal IP stack:

The rdma cm was never fully coded or tested for ipv6 support.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
