From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 00/13] NFS/RDMA patches for 3.17
Date: Tue, 24 Jun 2014 17:35:19 +0300
Message-ID: <CAJZOPZ+ix6tPDHXbVrSnVzofHSbzqOoyTBvzkEo-GJpOYOaPFA@mail.gmail.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623223201.1634.83888.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 24, 2014 at 1:39 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> The main purpose of this series is to address more connection drop
> recovery issues by fixing FRMR re-use to make it less likely the
> client will drop the connection due to a memory operation error.
>
> Some other clean-ups and fixes are present as well.


>From quick looking, patches 1,2 and 5 of series and maybe more have
very good match for 3.16-rc (fix kernel crashes etc), I don't think
they need to wait for 3.17
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
