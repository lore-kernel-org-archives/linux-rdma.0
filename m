From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 15:02:17 -0700
Message-ID: <660D538F30E647F3AE1E5E6C1ACBE882@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>	 <20091019234329.GC9643@obsidianresearch.com>	 <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>	 <20091020003344.GA14520@obsidianresearch.com>	 <1256164230.12075.31.camel@wilder.ibm.com>	 <20091021230845.GR14520@obsidianresearch.com> <1256245942.12075.46.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1256245942.12075.46.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>For ipv6 I ran what I described previously.  What I do need to do is add
>the option to rping to specify a source address and run it with various
>address.  Any help you can give defining what exactly needs to be tested
>would be appreciated.

You can also test with ucmatose to verify ipv4 still works.  Use the -b option
to bind to a specific address.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
