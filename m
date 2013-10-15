From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 14 Oct 2013 17:52:06 -0700
Message-ID: <CA+55aFw151GyGbAEStnvj41pokNfUegQW2uGWFw59FCvT--jRA@mail.gmail.com>
References: <1381774575-8817-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381774575-8817-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 14, 2013 at 11:16 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Last batch of IB changes for 3.12: many mlx5 hardware driver fixes plus
> one trivial semicolon cleanup.

Quite frankly, these mlx5 updates don't look like regression fixes.
They look like "continued development" to me, and seem to be things
that never worked. At least some of them look like performance
enhancements, in fact, not even resembling bugfixes. Others look like
"not a bug, but let's improve random behavior".

I pulled this once, because hardly anybody really cares. But the other
side of that "nobody cares" is that I might as well not have pulled.
If this kind of "continued development" patches keep happening, I'll
just start ignoring pull requests after the merge window.

So get your act together, and push back on the people you are supposed
to manage. Because this is *not* acceptable for post-rc5, and I'm
giving this single warning. Next time, I'll just ignore the sh*t you
send me.

Comprende?

             Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
