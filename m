From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Sat, 2 Dec 2017 09:28:56 -0700
Message-ID: <20171202162856.GA28143@ziepe.ca>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
 <20171201182806.GL7754@ziepe.ca>
 <20171202084019.GG8126@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171202084019.GG8126-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 02, 2017 at 10:40:19AM +0200, Leon Romanovsky wrote:
> On Fri, Dec 01, 2017 at 11:28:06AM -0700, Jason Gunthorpe wrote:
> > On Fri, Dec 01, 2017 at 07:13:05PM +0100, Benjamin Drung wrote:
> > > GitHub does not allow to rebase & merge the pull request. Is there any
> > > reason to not allow the rebase & merge workflow? My commits are atomic
> > > and the git history is cleaner without the merge commits.
> >
> > We have been using the merge workflow. I'm not sure this was every
> > really discussed which is best or not.
> >
> > The git history is simpler with rebase, but merge preserves the 'what
> > did I test' and preserves the series boundaries, which are also useful things.
> 
> We are also putting cover letters into the merge commit for documentation
> purposes.

Are we? I wish github did that :( On the plus side it does sign all
merge commits made through the web interface

commit 4925a85fc53f8f037a6792df450891340ee5a76b
gpg: Signature made Mon 20 Nov 2017 01:34:16 AM MST using RSA key ID 3AFDEB23
gpg: Good signature from "GitHub (web-flow commit signing) <noreply-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 5DE3 E050 9C47 EA3C F04A  42D3 4AEE 18F8 3AFD EB23
Merge: 3d9b214443effe 9db80df802bf91
Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Mon Nov 20 10:34:16 2017 +0200

    Merge pull request #254 from jgunthorpe/rdma_cm_mc
    
    Support for the MC join flag in RDMA CM


Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
