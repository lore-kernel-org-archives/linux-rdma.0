From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 03/13] infiniband: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Mon, 8 Jul 2013 11:23:26 -0700
Message-ID: <CAL1RGDXV1_BjSLrQDFdVQ1_D75+bMtOtikHOUp8VBiy_OJUf=w@mail.gmail.com>
References: <cover.1372777600.git.ydroneaud@opteya.com> <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, I just applied a patch to convert to
get_unused_fd_flags(O_CLOEXEC) in uverbs, since there isn't anything
useful that can be done with uverbs fds across an exec.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
