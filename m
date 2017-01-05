From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Thu, 5 Jan 2017 16:09:29 -0700
Message-ID: <20170105230928.GA4262@obsidianresearch.com>
References: <1483642867.5227.18.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483642867.5227.18.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 05, 2017 at 08:01:07PM +0100, Benjamin Drung wrote:
> I looked at the Debian packaging of rdma-core and stumbled over the
> versioning. You change the version of the binary library packages
> (libibcm1, libibumad3, etc.) from the Debian package version (currently
> 12-1) to their shared library versions. This change is uncommon and
> confusing besides other issues. [1] It is common that the package
> version differ from the library (soname) version. As potential Debian
> sponsor I would reject this package version change.

Just to be clear, the packaging as it is today was only a suggested
starting point for discussion. I have no objection at all to changing
this or other things.

This was only done for two reasons:

 1) A clear migration from the pre-existing binary packages,
    using similar versioning (eg upgrading from librdmacm1 1.2 to 12
    seems pretty wonky)
 2) A possibility in future to make use of the library minor version.
    Eg librdmacm1 1.2 might introduce new APIs and build-depends
    could sanely use librdmacm1-dev (>= 1.2). RH has said they
    don't want to do this, and if Debian goes the same way then
    we won't bother manipulating the shlib minor version.
    Build depends will have to be based on the overall release
    number instead.

> The second problematic thing is that each library has its own major and
> minor number, but use the package version as patch level. This
> restricts the package version to one number which will increase fast.

We are not using libtool so there is no concept of a 'patch
level'. The file name of the shared library is not a semantic version
string either. The main package version can be any string and
everything will work out correctly.

If Debian does not use the library version as part of the binary
package then there is no reason at all to be concerned about its
construction as nothing will really see it.

Each of the libraries uses strong ABI compatability with symbol
versioning.

> The package version could follow the semantic versioning [2], the
> version schema from the kernel [3],

We discussed these options on the mailing list and they were not popular.

To be clear the full form of the package version is 
<release>.<patchlevel> similar to other projects. Eg a backport or
bugfix could be called '12.1', a vendor fork could be called '12.vnd1'
and so on.

We don't have any of the legacy compat reasons to have a two level
release number scheme like the kernel.

> or by date [4].

I don't recall if date was discussed. It doesn't seem significantly
better than a release serial number.. I think that makes more sense
for a project that is doing timed releases, which we are not planning
to do.

> PS: I am thinking about offering becoming a co-maintainer for the rdma-
> core Debian package.

This is very exciting news! Please feel free to send any patches or
pull requests to improve the packaging, or otherwise! I hope that
significant parts of the the debian/ dir can be maintained upstream
like Redhat is going to do for their packaging.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
