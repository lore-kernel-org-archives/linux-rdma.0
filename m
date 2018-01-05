From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Fri, 5 Jan 2018 11:05:48 -0700
Message-ID: <20180105180548.GD11972@mellanox.com>
References: <1510948060.3973.29.camel@redhat.com>
 <20171119145633.07a3a715@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171119145633.07a3a715-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 02:56:33PM +1100, Stephen Rothwell wrote:
> Hi Doug,
> 
> On Fri, 17 Nov 2017 14:47:40 -0500 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Jason Gunthorpe is now co-maintaining the RDMA subsystem with me.  We
> > have a shared repo that we can both write into.  I would like you to re-
> > aim the RDMA linux-next pull point to:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-
> > next
> 
> I have updated to use this and added Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> as a contact.

Thanks Stephen, has been working well!

Is it necessary/desirable for the linux-next GPG keyring to get
updated with my key? See below

commit 6c76eedf431ccc0388d906d43aec3f4c6c24e69e
Merge: 2b5c0f8f7394c2 e4b1851973245d
Author: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Date:   Fri Jan 5 11:34:45 2018 +1100

    Merge remote-tracking branch 'rdma/for-next'
    
    Automatic RDMA for-next tag
    
    For Stephen Rothwell's for-next
    
    # gpg: Signature made Thu 04 Jan 2018 14:12:32 AEDT
    # gpg:                using RSA key 386DF7157E209B1A
    # gpg: Can't check signature: No public key
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
