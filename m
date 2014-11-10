From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH v2 09/10] NFS: SETCLIENTID XDR buffer sizes are incorrect
Date: Mon, 10 Nov 2014 11:21:34 -0500
Message-ID: <CAHQdGtTOzEtFe6QkjdR80D+hnP1YoR42BdUEz_2Z_hqHJxf+jA@mail.gmail.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
	<20141109011518.8806.36904.stgit@manet.1015granger.net>
	<5460D84A.3050704@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5460D84A.3050704-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 10, 2014 at 10:22 AM, Anna Schumaker
<Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Chuck,
>
> It looks like this patch and the next one are general client changes, so they might have to be submitted to Trond directly rather than going through my tree.  Trond, what do you think?

Ditto for the iostat locking change (PATCH 08/10). None of those are
RDMA related.

Should I just cherrypick them from this series?

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
