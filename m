From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] ibacm/ibacmp: fix a crash when SM restarts
Date: Thu, 4 Dec 2014 12:22:29 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0868D135@CRSMSX101.amr.corp.intel.com>
References: <1416408407-6774-1-git-send-email-kaike.wan@intel.com>
 <1416408407-6774-4-git-send-email-kaike.wan@intel.com>
 <1828884A29C6694DAF28B7E6B8A8237399E21295@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E21295-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Ibacm may cause segfault when the SM restarts: when the SM restarts,
> > ibacm will receive P_Key change event and instruct ibacmp to close all
> > endpoints.
> > However,
> > ibacmp only resets the core endpoint pointer in its ep structure and
> > keeps the ep in the port's ep_list. Afterwards, the ibacm core will
> > ask ibacmp to create an ep for each pkey enumerated from the local
> > port. The ep will be found from the port's ep_list if it exists.
> > However, if an old pkey is not present in the new SM configuration,
> > the old ep will still be linked in the port's ep_list with the
> > ep->endpoint being set to NULL. When the ibacm core forwards the
> > client reregistration event to ibacmp, ibacmp will enumerate the
> > ep_list and try to join multicast group for each ep, including any one
> > with ep-
> > >endpoint
> > set to NULL. In this case, it will cause segfault in acm_send_sa_mad().
> > Additional check should be able to avoid the crash.
> 
> I'm having trouble following this.  Is the problem that the provider is not
> cleaning up properly/completely when being told to close its endpoint?
> 
[Wan, Kaike] Yes, it's a problem for the current implementation of the default provider ibacmp. If the provider can clean up properly, it will not have such a problem. Nevertheless, the ibacm core should validate incoming parameters for a SA request from any provider.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
