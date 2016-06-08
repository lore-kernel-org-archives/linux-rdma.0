From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Wed, 8 Jun 2016 13:53:53 -0400
Message-ID: <240BF8C6-AB80-4A27-8C38-1FE9BB02AD66@oracle.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net> <20160607194732.18401.71941.stgit@manet.1015granger.net> <20160607204941.GA7991@obsidianresearch.com> <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com> <20160607212831.GA9192@obsidianresearch.com> <D90190F5-ACCB-45D8-B08D-B75023ED6240@oracle.com> <20160607220107.GA9982@obsidianresearch.com> <c43e37cd-71ea-8629-20f2-bcd674d50b83@talpey.com> <8FF9BF11-C5BF-4418-9A84-AAD7A6D6321D@primarydata.com> <20160608174014.GB30822@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608174014.GB30822-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 8, 2016, at 1:40 PM, Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com> wrote:
>=20
> On Wed, Jun 08, 2016 at 03:06:56PM +0000, Trond Myklebust wrote:
>=20
>>   That would be a mount parameter which would only apply to RDMA sin=
ce
>>   everything else uses dynamic slot allocation these days. I=C4=81d =
prefer to
>>   avoid that.
>=20
> The only reason RDMA cannot allocate MRs on the fly is
> performance.. Maybe a dynamic scheme is the right answer..

Dynamically managing the MR free list should be straightforward:

1. Allocate a minimum number of MRs at transport creation time

2. If workload causes the transport to exhaust its supply of
    MRs, kick a worker thread to create some more

3. Maybe add a shrinker that can trim the MR list when the
    system is under memory pressure


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
