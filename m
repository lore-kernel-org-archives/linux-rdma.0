From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Prevent driver hang with unprogrammed boards
Date: Mon, 11 Apr 2011 13:24:50 -0700
Message-ID: <BANLkTikuO=uKCxkvuSfx1UBQuDxLtWCacg@mail.gmail.com>
References: <20110411134517.3720.3633.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110411134517.3720.3633.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2011 at 6:45 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0!time_after64(tstart, tstart + msecs_to_=
jiffies(500))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0!time_after64(get_jiffies_64(),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstart + msecs_to_jiffi=
es(500))) {

By the way, is there any need to use 64-bit jiffies stuff here?

Couldn't this be more cleanly written with just time_is_before_jiffies(=
)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
