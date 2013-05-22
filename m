From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure permissions
Date: Wed, 22 May 2013 14:32:19 -0700
Message-ID: <CAL1RGDX+XTMmwDQicztdJoq0oE0VfXvg5dhW8k-YEk38-vg6fw@mail.gmail.com>
References: <cover.1369085762.git.ydroneaud@opteya.com> <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 20, 2013 at 2:43 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> libibverbs must refuse to load arbitrary shared objects.
>
> This patch check the configuration directory and files for
> - being owned by root;
> - not being writable by others.

uverbs is an unprivileged interface.  Right now I can develop and test
libibverbs and driver code as an unprivileged user.  If I'm
understanding correctly, this patch would break that -- I'd have to
install to a root-owned directory to test.

What's the exploit this protects against?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
