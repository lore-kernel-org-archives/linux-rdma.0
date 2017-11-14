From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/6] debian: Let libibverbs1 16 break
 ibverbs-providers 15
Date: Tue, 14 Nov 2017 13:39:39 -0700
Message-ID: <20171114203939.GT4263@ziepe.ca>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
 <20171114200247.25890-2-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114200247.25890-2-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 09:02:42PM +0100, Benjamin Drung wrote:
> ibverbs-providers uses the private symbols of libibverbs1. Thus
> libibverbs1 will not work with an old version version of
> ibverbs-providers if the private symbol version is bumped.
> 
> Bump the ibverbs-providers version that libibverbs1 breaks which was
> forgotten on the symbol version bump. See also commit
> 611b7cc3b8e0d79aa986f042f486fccc95d73679. Append a tilde to support
> the lower version numbers (e.g. 16~201711132208) in the PPA builds.

This seems strange to me, we don't really need Breaks semantics here.

Shouldn't we do something like:

Package: ibverbs-providers
Depends: [..], libibverbs1 (= ${binary:Version}),

?

We really do not want to encourage mixing and matching versions.

IIRC the existing breaks is only because of how the new packages
interact with the legacy ones??
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
