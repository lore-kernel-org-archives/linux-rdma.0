From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/9] Peer-Direct support
Date: Thu, 23 Oct 2014 10:29:02 -0700
Message-ID: <CAG4TOxNDNNKYF0VLf45XvaNPqOr=V=iq5qFCeUG87eDDa7Kbeg@mail.gmail.com>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414065777-21173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 23, 2014 at 5:02 AM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The API defined for Peer-Direct is described in this cover letter.
> The required implementation for a hardware device to expose memory
> buffers over Peer-Direct is also detailed in this letter.

I don't see how I can justify merging this (for now at least), given
that there are no actual users of all this (fairly complex) new code,
besides a sample that doesn't actually do anything useful.  Is there
any actual consumer that might go upstream someday that we can at
least review now?

> This makes the usage of peer-direct almost completely transparent to
> the individual hardware drivers. The only changes required in the low
> level IB hardware drivers is supporting an interface for immediate
> invalidation of registered memory regions.

Why do we need immediate invalidation of memory regions?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
