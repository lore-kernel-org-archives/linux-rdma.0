From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 26 Mar 2012 14:13:49 -0700
Message-ID: <CAG4TOxPHziBpJ5hAoVCQTJWeR+-uC+2vM9S0aKE-6-B9JCEkWQ@mail.gmail.com>
References: <1332177079-14339-1-git-send-email-roland@kernel.org> <CD250C48050CFB4D95E78C95F2FDDD6E61A79B2E@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E61A79B2E-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2012 at 2:04 PM, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> What about the IPoIB patches (e.g. use Interrupt moderation)

I have no idea what patch that might be.  We've had the modify_cq call
in ipoib for years now,
with moderation parameters set through ethtool.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
