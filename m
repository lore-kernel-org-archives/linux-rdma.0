From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Mon, 3 Mar 2014 11:07:33 -0800
Message-ID: <20140303190733.GA4556@infradead.org>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
 <E755E683-C064-4ED3-8448-C61F4E5AF16E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E755E683-C064-4ED3-8448-C61F4E5AF16E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 03, 2014 at 12:02:33PM -0500, Chuck Lever wrote:
> All HCAs in 3.13 (and rxe) can support either MTHCA_FMR or FRMR or both. Wendy?s HCA supports only ALLPHYSICAL.

Is Wendy planning to submit her HCA driver ASAP?  If not there's not
reason to keep ALLPHYSICAL either.

> Does it make sense to deprecate then remove the registration modes in the first list?

Yes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
