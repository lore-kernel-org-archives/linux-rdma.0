From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Mon, 3 Mar 2014 12:33:39 -0800
Message-ID: <CABgxfbFrgKvRkELvna6DQgE+zqy1GPrM_x1GVv7tW+UbcDuYUA@mail.gmail.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
	<E755E683-C064-4ED3-8448-C61F4E5AF16E@oracle.com>
	<20140303190733.GA4556@infradead.org>
	<79E85B7D-5ECC-4A63-BB07-C45A570DA53D@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <79E85B7D-5ECC-4A63-BB07-C45A570DA53D-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "faibish, sorin" <faibish_sorin-mb1K0bWo544@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 3, 2014 at 11:54 AM, faibish, sorin <faibish_sorin-mb1K0bWo544@public.gmane.org> wrote:
>
> > On Mar 3, 2014, at 7:09 PM, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> >> On Mon, Mar 03, 2014 at 12:02:33PM -0500, Chuck Lever wrote:
> >> All HCAs in 3.13 (and rxe) can support either MTHCA_FMR or FRMR or both. Wendy?s HCA supports only ALLPHYSICAL.
> >
> > Is Wendy planning to submit her HCA driver ASAP?  If not there's not
> > reason to keep ALLPHYSICAL either.
> I second Christoph. Legacy is good as long as there are users of Linux with the legacy server. I would say that the only reason to keep it is if Linux server will support it. Same we apply to Lustre client in kernel.
>
> ./Sorin
>
> >
> >> Does it make sense to deprecate then remove the registration modes in the first list?
> >
> > Yes.
> >
>

After discussing this with my manager, we'll let it go for now ...
will re-submit the full patch set in the future when we finalize the
plan.

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
