From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Fix kernel panic on QME7342 boards
Date: Mon, 31 Oct 2011 10:59:28 -0700
Message-ID: <CAL1RGDWohYC2BpiKYwAfB+p3BhmkUTMPdiQo9qLVt7vgv3Z71Q@mail.gmail.com>
References: <20111025164207.31124.13380.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111025164207.31124.13380.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2011 at 9:42 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> introduced by 62066fc8df4632c772d723813ce7af456d62ddf7.

Thanks, rolled this into that commit since it wasn't upstream yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
