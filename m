From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 12/26] xprtrdma: Port to new memory registration API
Date: Thu, 8 Oct 2015 23:26:39 +0300
Message-ID: <CAJ3xEMjiNA6+yzggVBKC5ff0huri0KJOYoLx=FfAfs3HDO=VpA@mail.gmail.com>
References: <1444290669-5252-1-git-send-email-sagig@mellanox.com>
	<1444290669-5252-13-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444290669-5252-13-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 8, 2015 at 10:50 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Instead of maintaining a fastreg page list, keep an sg table
> and convert an array of pages to a sg list. Then call ib_map_mr_sg
> and construct ib_reg_wr.
>
> Note that the next step would be to have NFS work with sg lists
> as it maps well to sk_frags (see comment from hch
> http://marc.info/?l=linux-rdma&m=143677002622296&w=2).


I don't see the point to keep the 2nd paragraph in the upstream git log
forever, it deserves to be after the --- line such that when the maintainer
uses git am this stays out, so apply this in the respin you'd be doing
to address Chuck's comments.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
