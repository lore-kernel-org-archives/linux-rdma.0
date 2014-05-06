From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] add new verb command support
Date: Tue, 6 May 2014 09:55:32 -0700
Message-ID: <CAG4TOxOxczxgL4YiBC79KcpS1zbYXNoAz98HjEwYz1p30eoX7w@mail.gmail.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com> <OFF7DE6FCF.79F7A49C-ON44257CCF.0047233F-44257CCF.0048BCE1@ru.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFF7DE6FCF.79F7A49C-ON44257CCF.0047233F-44257CCF.0048BCE1-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 5, 2014 at 6:14 AM, Alexey Ishchuk
<alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org> wrote:
> Dear community,
>
> I posted the patches to provide the DAPL API support on the s390x platform
> to the linux-rdma mailing list several weeks ago and still don't have any
> feedback to them. I would like to kindly ask the component maintainers to
> take care of the patches and integrate them to the appropriate source code
> trees. Could you tell me, are you planning to integrate the kernel patch
> into the Linux kernel? Could you tell me, are the userspace component
> maintainers planning to integrate the changes into the OFED components?
> Could you, please, give the feedback?

In my opinion, the same feedback I gave for the first posting still
applies.  This approach is too invasive and hacky looking.  To be
blunt, s390 is not a mainstream platform, and adding #ifdefs all over
just to support fake kernel bypass on s390 doesn't seem like a good
tradeoff.

So I think this needs to be rearchitected before it goes upstream.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
