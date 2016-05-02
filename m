From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Status of RXE/Soft-RoCE driver?
Date: Mon, 2 May 2016 18:29:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0481A1@ORSMSX109.amr.corp.intel.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com> <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160429205434.GA11286-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> During the Collab summit I thought we reached a rough consensus that
> these sorts of uAPI changes to the common multi-vendor API would go
> through a more rigorous process and those who are proposing them would
> actively seek a multi-vendor sign off instead of simply dumping them
> on the list.

I agree that this is the right approach to follow.  A Linux maintainer should not be in the position of having to decide on which features merit a uAPI change.

> Further, I also thought we reached a rough consensus that we'd shunt
> some of this stuff to the driver specific uAPI channel to reduce this
> continual churn on the common multi-vendor API for currently
> driver-specific features. Drivers can implement their unique features
> and sanely export them through the kernel without so much pain. The
> uAPI 2.0 concepts from all parties have been heavily influenced by
> this idea.
> 
> Certainly, if patches cannot attract any review or interest from the
> community as part of the core API then I'd say that is an excellent
> sign they should be shunted to a driver specific channel.

This is an excellent point.  The lack of interest is likely a very good sign that this is a driver specific feature.

I'm not sure why there seems to be objection to calling out driver specific features as driver specific and exposing them as such.  It seems like the quickest way to get features into the hands of prospective users.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
