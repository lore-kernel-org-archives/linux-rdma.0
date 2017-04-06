From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Thu, 6 Apr 2017 10:57:22 -0600
Message-ID: <20170406165722.GE7657@obsidianresearch.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-5-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB10FAD8@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCy_JD1cu=3ZHSbrXBHmeTj-M7pJ6nM=rRXFVMi6Szvwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BCy_JD1cu=3ZHSbrXBHmeTj-M7pJ6nM=rRXFVMi6Szvwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 06, 2017 at 05:13:52PM +0300, Matan Barak wrote:
> On Thu, Apr 6, 2017 at 12:05 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > Mostly questions.
> >
> >> @@ -1628,7 +1148,7 @@ ssize_t ib_uverbs_resize_cq(struct
> >> ib_uverbs_file *file,
> >>                  (unsigned long) cmd.response + sizeof resp,
> >>                  in_len - sizeof cmd, out_len - sizeof resp);
> >>
> >> -     cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
> >> +     cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
> >
> > (I noticed rereg_mr used a write lock.)
> > Is a read lock sufficient here?
> >
> 
> I guess we don't want to allow two concurrent resize_cq, so write
> lock should be better here. However, I don't want to change logic in
> these patches. I think such a patch is better of being separate with
> a proper commit message.  We don't step on these bugs, as there's no
> lock at the verbs layer. So usually, device drivers provide the
> locking their themselves.

It makes sense to split the patch, but the 'write lock' nee
'exclusive' seems like the wrong approach, we need an actual mutex
just like for multicast.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
