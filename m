From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 23 Feb 2017 08:33:56 -0800
Message-ID: <CA+55aFz6mZUHonfz3qtq17MJNcO+m4m4qspuZzhBG8wPi8Azjg@mail.gmail.com>
References: <1487796701.86943.126.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487796701.86943.126.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2017 at 12:51 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> the third is a tree-wide change and per typical policy I was going to
> wait until the end of the merge window and submit it them...

Well, "typical policy" for tree-wide ones is definitely not that some
random crazy driver subsystem does them.

What are these tree-wide ones?

> it's the patch series posted by Bart Van Assche to remove the IB DMA
> ops structs and use the core DMA ops instead

Do you have pointers to the actual diff? That doesn't sound very
tree-wide, it sounds limited to just rdma, and as such shouldn't
impact anybody else.

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
