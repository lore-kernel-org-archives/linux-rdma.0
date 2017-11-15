From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/6] debian: Let libibverbs1 16 break
 ibverbs-providers 15
Date: Wed, 15 Nov 2017 10:20:17 +0100
Message-ID: <1510737617.4026.56.camel@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
         <20171114200247.25890-2-benjamin.drung@profitbricks.com>
         <20171114203939.GT4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114203939.GT4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 14.11.2017, 13:39 -0700 schrieb Jason Gunthorpe:
> On Tue, Nov 14, 2017 at 09:02:42PM +0100, Benjamin Drung wrote:
> > ibverbs-providers uses the private symbols of libibverbs1. Thus
> > libibverbs1 will not work with an old version version of
> > ibverbs-providers if the private symbol version is bumped.
> > 
> > Bump the ibverbs-providers version that libibverbs1 breaks which
> > was
> > forgotten on the symbol version bump. See also commit
> > 611b7cc3b8e0d79aa986f042f486fccc95d73679. Append a tilde to support
> > the lower version numbers (e.g. 16~201711132208) in the PPA builds.
> 
> This seems strange to me, we don't really need Breaks semantics here.
> 
> Shouldn't we do something like:
> 
> Package: ibverbs-providers
> Depends: [..], libibverbs1 (= ${binary:Version}),
> 
> ?

We had exactly that previously and commit
611b7cc3b8e0d79aa986f042f486fccc95d73679 changed that behavior. See
there for a reasoning. When building, ibverbs-provides will get an
dependency on libibverbs1 (>= X) where X matches the major number from
the private symbols (currently X = 16)

> We really do not want to encourage mixing and matching versions.

The current way with Breaks allows one to mix and match only within one
 major release. So you could use ibverbs-provides 15.1 with libibverbs1
15 (but not with 14 or 16).

> IIRC the existing breaks is only because of how the new packages
> interact with the legacy ones??

The Provides & Replaces & Breaks in ibverbs-providers are there for
upgrading from the old package names to ibverbs-providers.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
