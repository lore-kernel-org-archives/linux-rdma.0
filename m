From: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 04/12] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Sat, 11 Jul 2015 14:50:58 -0400
Message-ID: <682604AF-955A-44F8-86F9-EB7D403CABFF@gmail.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204218.26247.67243.stgit@manet.1015granger.net> <20150711103428.GD14741@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150711103428.GD14741-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jul 11, 2015, at 6:34 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wr=
ote:
>=20
> On Thu, Jul 09, 2015 at 04:42:18PM -0400, Chuck Lever wrote:
>> All HCA providers have an ib_get_dma_mr() verb. Thus
>> rpcrdma_ia_open() will either grab the device's local_dma_key if one
>> is available, or it will call ib_get_dma_mr() which is a 100%
>> guaranteed fallback. There is never any need to use the
>> ib_reg_phys_mr() code path in rpcrdma_register_internal(), so it can
>> be removed.
>=20
> Can you also send a follow-on to remove ib_reg_phys_mr entirely from
> all core (=3D non-staging) code?

I would prefer to run this by Doug Oucharek first, as a courtesy.
Unless I=E2=80=99m mistaken, the Lustre client is supposed to be on its
way into the kernel, not on its way out.

Anyone have Doug=E2=80=99s e-mail address?


--
Chuck Lever
chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
