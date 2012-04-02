From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/core: add missing string for the display of SDR
 rates in sysfs
Date: Mon, 2 Apr 2012 12:29:18 -0700
Message-ID: <CAL1RGDVH28u1tY3K8Mw29wfzXVeYR-mNDDvfpABsoSTmZA56Ww@mail.gmail.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
 <1333377921-8349-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUCO+ijdYyaPsx7X9eYssj-qDEqeYm-gSAY30NwYo1Qpg@mail.gmail.com>
 <CAJZOPZLWmBDBc7HpzWYa9etiiq4ZKeqP6XTYOat6mino8en3aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLWmBDBc7HpzWYa9etiiq4ZKeqP6XTYOat6mino8en3aA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 2, 2012 at 11:50 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Oh, I see what you mean - and I don't think we need to consider this
> as interface change - these is an interface - namely "nGbs (mX DDD)
> where n is number =A0m is number and DDD is string (SDR, DDR, QDR,
> FDR10, etc) and this interface was buggy to wrong print certain cases=
,
> which we fixed in the two commits I mentioned. Now we found another
> bug ("SDR" not printed) and we fix it (hopefully the last one in this
> function) - that's all. I don't think we should assume there are
> apps/libs up their who set their code to match the exact bugs we had
> in sysfs, it was just not important enough the report on, or they
> didn't hit it (e.g SDR is pretty not common now), thoughts?

I really don't think there's a good reason to change this output (which
we had for many years).  Maybe nothing cares either way but the
benefit is so minimal that I don't think the risk is worth it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
