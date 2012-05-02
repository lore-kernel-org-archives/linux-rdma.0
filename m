From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Don't sleep in atomic notifier handler
Date: Wed, 2 May 2012 15:46:12 -0700
Message-ID: <CAL1RGDUVmK4T=-SJOQz6KFQhbjkMnbXUaxU0-eyWDH-bXMNtQA@mail.gmail.com>
References: <1335591601-26473-1-git-send-email-levinsasha928@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335591601-26473-1-git-send-email-levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 27, 2012 at 10:40 PM, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> + =A0 =A0 =A0 spin_lock(&ocrdma_devlist_lock);
> + =A0 =A0 =A0 list_add_tail_rcu(&dev->entry, &ocrdma_dev_list);
> + =A0 =A0 =A0 spin_lock(&ocrdma_devlist_lock);

Er, applied with this fixed to be spin_unlock at the end...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
