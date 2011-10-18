From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Tue, 18 Oct 2011 15:52:38 -0700
Message-ID: <CAL1RGDWhg6mjn2qa6Dgm2Hc2NugMM=RuG_6HrpxEvrooAZOX3w@mail.gmail.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
 <CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA@mail.gmail.com>
 <alpine.DEB.2.00.1110181013090.687@router.home> <CAJZOPZJvF1F1J_DYJf-v6JZx5pGv_sxTb8GgsF09HFj81jQ+sw@mail.gmail.com>
 <CAJZOPZJCzMemMboH0V83w87uHqggQ5zqtMR3eKocvWKdaypmZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJCzMemMboH0V83w87uHqggQ5zqtMR3eKocvWKdaypmZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2011 at 3:13 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> -s 100 fixes the issue.
>
> Good to know! I'll take a look into whether/how we could improve this
> little but annoying incompatibility...

Do you understand why -s 100 fixes things?  If so can you explain it to me? ;)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
