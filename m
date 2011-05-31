From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/5] read_config: don't try to open file beginning with '.'
Date: Tue, 31 May 2011 11:42:16 -0700
Message-ID: <BANLkTimPvmNzOHn8JRkmu=iBU88nNEq9_A@mail.gmail.com>
References: <cover.1301562707.git.ydroneaud@opteya.com> <aa79e6cff5121994d60fb10315ce54e5a2dc63af.1301562707.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aa79e6cff5121994d60fb10315ce54e5a2dc63af.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2011 at 2:29 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> Files beginning with a dot are mostly current and parent directories or,
> by convention, hidden files.
>
> Those path are skipped in find_sysfs_dev().

Not sure we want to do this. We already skip non-regular files, and
I'm not sure we want to exclude certain file names.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
