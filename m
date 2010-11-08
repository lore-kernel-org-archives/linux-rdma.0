From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Mon, 08 Nov 2010 12:14:19 +0200
Message-ID: <4CD7CD7B.2020003@voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>	<4CD26E04.3060408@voltaire.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F@orsmsx501.amr.corp.intel.com>	<4CD2DFD3.7040900@Voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B857@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B857-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> CM mads aren't reliable, however they are retried.  If a CM REQ does not receive a response after so many retries (usually 15), the REQ fails (status is timeout).  The mad layer reports the timeout to the cm module.  With snooping in place, a user will be notified that a mad send has failed and be given a copy of the mad.
mmm, got that - I also see that ib_mad_send_wc has both the status and 
the content of the mad, upon which you base the design
> 3. ibacm returns a path record.  The path record _may_ have come from cached data.
> 4. The librdmacm tries to establish a connection.
> 5. The kernel ib_cm module issues REQ.
> 6. The ib_mad module retries the REQ until it times out.
> 7. The mad timeout is reported to any users wishing to capture errors.
> In this example, the ibacm service would be registered and receive a copy of the failed REQ.  The ibacm can look at the data in the REQ, see if it if has cached path record data which matches, and remove the cached data if so.
> 8. The librdmacm will see a connection failure.
so the usage of mad snooping would be for cache invalidations, I wonder 
if registering on GID/MGID IN/OUT traps be sufficient for the same purpose?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
