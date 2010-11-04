From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Thu, 4 Nov 2010 09:51:40 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B857@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>
	<4CD26E04.3060408@voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F@orsmsx501.amr.corp.intel.com>
 <4CD2DFD3.7040900@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD2DFD3.7040900-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> still, I am not sure to be with you, the mads used by the CM aren't
> reliable, correct?
> so I don't see why/how a mad containing e.g junk DLID completes with
> error...

CM mads aren't reliable, however they are retried.  If a CM REQ does not receive a response after so many retries (usually 15), the REQ fails (status is timeout).  The mad layer reports the timeout to the cm module.  With snooping in place, a user will be notified that a mad send has failed and be given a copy of the mad.

At a higher level, this would be one usage model:

1. App calls rdma_getaddrinfo()
2. The librdmacm contacts the ibacm for path record data.
3. ibacm returns a path record.  The path record _may_ have come from cached data.
4. The librdmacm tries to establish a connection.
5. The kernel ib_cm module issues REQ.
6. The ib_mad module retries the REQ until it times out.
7. The mad timeout is reported to any users wishing to capture errors.

In this example, the ibacm service would be registered and receive a copy of the failed REQ.  The ibacm can look at the data in the REQ, see if it if has cached path record data which matches, and remove the cached data if so.  If the REQ data cannot be found (for example, someone sent a REQ with a junk DLID), it simply discards the captured mad.

8. The librdmacm will see a connection failure.
9. The librdmacm can request a new path from the ibacm and retry.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
