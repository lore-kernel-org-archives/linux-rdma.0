From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Tue, 26 Sep 2017 08:15:35 +0300
Message-ID: <20170926051535.GB1230@mtr-leonro.local>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
 <1506359213.120853.75.camel@redhat.com>
 <20170925171821.GQ25094@mtr-leonro.local>
 <1506361015.120853.81.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506361015.120853.81.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 01:36:55PM -0400, Doug Ledford wrote:
> On Mon, 2017-09-25 at 20:18 +0300, Leon Romanovsky wrote:
> > On Mon, Sep 25, 2017 at 01:06:53PM -0400, Doug Ledford wrote:
> > > On Wed, 2017-08-30 at 17:23 +0800, Wei Hu (Xavier) wrote:
> > >
> > > > +	/*
> > > > +	 * If the command is sync, wait for the firmware to
> > > > write
> > > > back,
> > > > +	 * if multi descriptors to be sent, use the first one to
> > > > check
> > > > +	 */
> > > > +	if ((desc->flag) & HNS_ROCE_CMD_FLAG_NO_INTR) {
> > > > +		do {
> > > > +			if (hns_roce_cmq_csq_done(hr_dev))
> > > > +				break;
> > > > +			usleep_range(1000, 2000);
> > > > +			timeout++;
> > > > +		} while (timeout < priv->cmq.tx_timeout);
> > > > +	}
> > >
> > > then we spin here for a maximum amount of time between 200 and
> > > 400ms,
> > > so 1/4 to 1/2 a second.  All the time we are holding the bh lock on
> > > this CPU.  That seems excessive to me.  If we are going to spin
> > > that
> > > long, can you find a way to allocate/reserve your resources, send
> > > the
> > > command, then drop the bh lock while you spin, and retake it before
> > > you
> > > complete once the spinning is done?
> >
> > They don't allocate anything in this loop, but checking the pointers
> > are
> > the same, see hns_roce_cmq_csq_done.
>
> I'm not sure I understand your intended implication of your comment.  I
> wasn't concerned about them allocating anything, only that if the
> hardware is hung, then this loop will hang out for 1/4 to 1/2 a second
> and hold up all bottom half processing on this CPU in the meantime.
> That's the sort of things that provides poor overall system behavior.
>
> Now, since they are really only checking to see if the hardware has
> gotten around to their particular command, and their command is part of
> a ring structure, it's possible to record the original head command,
> and our new head command, and then release the spin_lock_bh around the
> entire do{ }while construct, and in hns_roce_cmd_csq_done() you could
> check that head is not in the range old_head:new_head.  That would
> protect you in case something in the bottom half processing queued up
> some more commands and from one sleep to the next the head jumped from
> something other than the new_head to something past new_head, so that
> head == priv->cmq.csq.next_to_use ends up being perpetually false.
> But, that's just from a quick read of the code, I could easily be
> missing something here...

Thanks,
I got your point, the phrase "can you find a way to allocate/reserve
your resources," confused me back then.

>
> > >
> > > > +#define HNS_ROCE_CMQ_TX_TIMEOUT			200
> > >
> > > or you could reduce the size of this define...
> > >
> > > --
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >     GPG KeyID: B826A3330E572FDD
> > >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> > > 2FDD
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> > > rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJ4ncACgkQ5GN7iDZy
WKeCWRAAlHiRPAAKBzTFd62QB8M7bfJe1m/vZ+gzKDC6wc8y7gOq/qFF8GMVW4hN
vrVH7ccnfe+KTqHNsTT61YQUEb/hUSjhyEODduvcxofpEOJfPz3xuO44TbvfctFL
Xqfri2WoaEIPfCDvG2QLWCexwrm4BzTqQNSWTIPtksUMh03OzdslDuZek+P6wa4P
IDNqlfn/WAjsAQ3Q+lvhK3ji4AEgEWcjWeuotV0Z7vETvkWWL+0X2QjVyZbQojHS
ZG3xjXLam+cYZEP3X6jLdlbrXsxO7OR4XS4YYpck5cltyRKrxoA/8RNDf6gXwM3N
CH1U2nECKWAQgw2JPH9kJcS5BfecMBmhlmupe5yv1ZWF0Cy6eHQfT79CmVndXDcM
UUi3dGc2dy12jy6OiNHxNKlvsDP7nya+YkkkDDbbh3cEniQDEP4jJEHv3Aahw/8x
lupY5S3VXyLLxF2HsR8za6NS1btmDVilLJhox0ThrLy/ayuMUOfmh5tHPMKTyU0j
2THTKBRkFUzmeiHa6bixwUDvXgztIJLiIUuk41pBoPUYgHJM464UVCQCvMBBsvSH
vnFFHvayqDMWYQJMHCD0pYJs7EnD2EEc+8fDlSosxi5MSoDuDTdT0tSg2MSz7dJl
xYvkrBzpVctWQQVNsjMKOyY/1yRUWiMoFKpzgTa9JRxtiLHfqzc=
=fBgA
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
