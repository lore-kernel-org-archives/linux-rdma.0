From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 00:26:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE7BE2@ORSMSX109.amr.corp.intel.com>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208212133.GC14378-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +	 * Determine the default pkey for parsing address file as well.
> > +	 *   order of preference: first full-member non-management pkey,
> > +	 *   0xffff, first pkey.
> > +	 */
> 
> This really should just be the 0 index pkey, which exactly matches how
> IPoIB determines the default pkey, which is what matters when talking
> rdmacm..

Ibacm currently hard-codes the 'default' pkey to 0xffff for ibacm <-> ibacm communication.  If there's no disagreement to switching to pkey[0], I'm fine with that.  I did not realize that ipoib uses this same default.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
