From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 4 Jun 2015 20:31:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE50C7@ORSMSX109.amr.corp.intel.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604201953.GA7227-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I am very surprised to see this layered under send_mad, all the
> context is lost at that point, and it makes it impossible to provide
> all the non-IB context (IP addrs, netdevs, QOS, etc)

It's layered under query path record.  This should provide the most benefit to the most applications, including the existing kernel clients.  You could extend this by hooking into the rdma cm directly, but IMO, that can be viewed as another optimization.  Basically, if one were to hook in only one place, this seems the most reasonable.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
