From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] infiniband/uverbs: Fix integer overflows
Date: Fri, 24 Mar 2017 20:02:03 +0000
Message-ID: <1490385702.3312.18.camel@sandisk.com>
References: <1490385317-35641-1-git-send-email-vlad@tsyrklevich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490385317-35641-1-git-send-email-vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Content-Language: en-US
Content-ID: <A57A8B598AF6DB4B823CBB0F056E3337-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org" <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-03-24 at 15:55 -0400, Vlad Tsyrklevich wrote:
> The 'num_sge' variable is verfied to be smaller than the 'sge_count'
> variable; however, since both are user-controlled it's possible to cause
> an integer overflow for the kmalloc multiply on 32-bit platforms
> (num_sge and sge_count are both defined u32). By crafting an input that
> causes a smaller-than-expected allocation it's possible to write
> controlled data out-of-bounds.

Hello Vlad,

Do you think that an RDMA driver exists that supports a max_sge value that
is large enough to cause this multiplication to overflow?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
