From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 14:54:34 -0600
Message-ID: <20160429205434.GA11286@obsidianresearch.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
 <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
 <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a1d504ff-716c-210a-7114-517577d2e0fa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 29, 2016 at 11:06:46AM -0400, Doug Ledford wrote:

> > These patches are long time here in mailing list and they were reviewed as
> > all other patches in this mailing list.
> 
> That's not true.  The RSS patches in particular tend to get no review.
> No one appears to care about them.  V1 was posted way back last year and
> no one had anything to say about them.  I don't know when V2 was, it's
> no longer in my mailbox.  Then v3 has been on the list for 12 days and
> again, no one has responded.  No review at all does not mean
> automatically accepted.

During the Collab summit I thought we reached a rough consensus that
these sorts of uAPI changes to the common multi-vendor API would go
through a more rigorous process and those who are proposing them would
actively seek a multi-vendor sign off instead of simply dumping them
on the list. Liran nominated himself and the OFVWG to act as a
forum. I recommend we let that process get going and do it's work.

Further, I also thought we reached a rough consensus that we'd shunt
some of this stuff to the driver specific uAPI channel to reduce this
continual churn on the common multi-vendor API for currently
driver-specific features. Drivers can implement their unique features
and sanely export them through the kernel without so much pain. The
uAPI 2.0 concepts from all parties have been heavily influenced by
this idea.

Certainly, if patches cannot attract any review or interest from the
community as part of the core API then I'd say that is an excellent
sign they should be shunted to a driver specific channel.

There is more flexability in user space to make mistakes with the
libibverbs/etc API, and more options to provide access to these kind
of services. For instance I really wonder if integrating into
libibverbs is really the right home to trial a broad range of brand
new UD offload focused features.

> >> verbs 2.0 API is settled so we only have one API to apply it too,
> > 
> > SELinux code adds hooks which are deep in IB/core code and doesn't
> > play with ABI at all.
> 
> They snoop ABI.  If they ABI changes, they would possibly need to be
> changed in order to continue to be able to read the elements.

Agree, if we go to a object based uAPI then there may be better ways
to make use of selinux right at the uapi layer.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
