From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Wed, 23 Sep 2015 20:41:06 +0200
Message-ID: <20150923184106.GA7759@lst.de>
References: <1443023567-13259-1-git-send-email-hch@lst.de> <1443023567-13259-2-git-send-email-hch@lst.de> <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8BE4B1B3-54CD-46D1-9BBD-9149F6219468-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 23, 2015 at 10:23:15AM -0700, Chuck Lever wrote:
> Getting rid of ib_query_device() makes sense. Moving the device
> attributes into ib_device is nice. Getting rid of ib_device_attr
> is of questionable value. Why do we need to go there?
>=20
> IB core API changes generate merge conflicts with feature work
> in the ULPs. It=E2=80=99s a pain for maintainers. In this particular
> case, keeping ib_device_attr would greatly reduce ULP churn.

But it will keep a totally nonsenical structure around in the future.

Note that the whole in-kernel Verbs API is a bit of a nightmare, so
there will be all kinds of larger changes.  Better get it right as long
as we have as few ULPs as we have now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
