From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 19:30:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732DC04EFB@ORSMSX101.amr.corp.intel.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
 <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A823732DC03E16@ORSMSX101.amr.corp.intel.com>
 <20120118190214.GK2892@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118190214.GK2892-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The method cannot be parsed outside the context of the
> (baseVersion,manamgentClass,classVersion) tuple. A agent that does not
> understand the managementClass must return GetResp.
>
> I feel if the base version is not supported then a GetResp should be
> returned without a memcpy. The base version set to the highest
> supported value and the TID copied over from the reply but everything
> else 0'd. This allows base version discovery which might be important
> some day.

If the BaseVersion isn't supported, then I don't know that the code should assume anything about the rest of the MAD format, including the location or size of any other fields.  If we at least know that BaseVersion = 1, then we should be safe checking for common methods.  If BaseVersion > 1, then maybe we're better off just dropping the MAD still.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
