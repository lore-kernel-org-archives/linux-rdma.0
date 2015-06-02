From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 2 Jun 2015 13:04:10 -0600
Message-ID: <20150602190410.GA23362@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <1433271083.40123.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433271083.40123.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 02, 2015 at 02:51:23PM -0400, Doug Ledford wrote:
> On Tue, 2015-06-02 at 12:08 -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 02, 2015 at 10:35:24AM -0400, Doug Ledford wrote:
> > 
> > > So, just so everyone is clear on this point: the current user space
> > > implementation of this feature creates an unversioned, newly named
> > > ibv_wc_ex struct that is ibv_wc with a 64bit timestamp tacked on at the
> > > end (not 64bit aligned either).  If we ever wanted to have a different
> > > extension to our ibv_wc struct, there is no good way to do that.
> > 
> > No, if they followed (I didn't check yes) the extension scheme then the
> > poll call is
> > 
> >  struct ibv_wc_ex wcs[num_wcs]
> >  ibv_poll_wc_ex(&wcs,num_wcs,sizeof(wcs[0]));
> > 
> > And the drivers decide what to do based on the 3rd argument, which is
> > essentially the ABI version.
> 
> Ick.  OK.  I would *much* prefer something done akin to the routines in
> packer.c of the kernel, but that's not my call to make, the decision on
> the ABI/API extension mechanism was made long ago.  It does, however,
> mean that extensions are serial and not modular, and that's a shame.

All verbs extensions are essentially serial, each extension requires a
fixed allocation of structure bytes, made by upstream.

This is also why no vendor may ship an extension that is not upstream
and continue to use the same soname as upstream. Similarly for the
kernel.

This is fairly performance neutral, while a packer.c scheme would be
unacceptably expensive, IMHO. poll_wc is one of the most performance
sensitive routines in the library.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
