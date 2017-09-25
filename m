From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Mon, 25 Sep 2017 20:18:21 +0300
Message-ID: <20170925171821.GQ25094@mtr-leonro.local>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
 <1506359213.120853.75.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O7Os1+MGCLLi8F5z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506359213.120853.75.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--O7Os1+MGCLLi8F5z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 01:06:53PM -0400, Doug Ledford wrote:
> On Wed, 2017-08-30 at 17:23 +0800, Wei Hu (Xavier) wrote:
>
> So, we set the send timeout limit here:
>
> > +	/* Setup Tx write back timeout */
> > +	priv->cmq.tx_timeout = HNS_ROCE_CMQ_TX_TIMEOUT;
> > +
>
> [ snip ]
>
> > +int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
> > +		      struct hns_roce_cmq_desc *desc, int num)
> > +{
> > +	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv
> > *)hr_dev->priv;
> > +	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
> > +	struct hns_roce_cmq_desc *desc_to_use;
> > +	bool complete = false;
> > +	u32 timeout = 0;
> > +	int handle = 0;
> > +	u16 desc_ret;
> > +	int ret = 0;
> > +	int ntc;
> > +
> > +	spin_lock_bh(&csq->lock);
>
> and we take a bh lock here...
>
> > +	if (num > hns_roce_cmq_space(csq)) {
> > +		spin_unlock_bh(&csq->lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	/*
> > +	 * Record the location of desc in the cmq for this time
> > +	 * which will be use for hardware to write back
> > +	 */
> > +	ntc = csq->next_to_use;
> > +
> > +	while (handle < num) {
> > +		desc_to_use = &csq->desc[csq->next_to_use];
> > +		*desc_to_use = desc[handle];
> > +		dev_dbg(hr_dev->dev, "set cmq desc:\n");
> > +		csq->next_to_use++;
> > +		if (csq->next_to_use == csq->desc_num)
> > +			csq->next_to_use = 0;
> > +		handle++;
> > +	}
> > +
> > +	/* Write to hardware */
> > +	roce_write(hr_dev, ROCEE_TX_CMQ_TAIL_REG, csq->next_to_use);
> > +
> > +	/*
> > +	 * If the command is sync, wait for the firmware to write
> > back,
> > +	 * if multi descriptors to be sent, use the first one to
> > check
> > +	 */
> > +	if ((desc->flag) & HNS_ROCE_CMD_FLAG_NO_INTR) {
> > +		do {
> > +			if (hns_roce_cmq_csq_done(hr_dev))
> > +				break;
> > +			usleep_range(1000, 2000);
> > +			timeout++;
> > +		} while (timeout < priv->cmq.tx_timeout);
> > +	}
>
> then we spin here for a maximum amount of time between 200 and 400ms,
> so 1/4 to 1/2 a second.  All the time we are holding the bh lock on
> this CPU.  That seems excessive to me.  If we are going to spin that
> long, can you find a way to allocate/reserve your resources, send the
> command, then drop the bh lock while you spin, and retake it before you
> complete once the spinning is done?

They don't allocate anything in this loop, but checking the pointers are
the same, see hns_roce_cmq_csq_done.

>
> > +#define HNS_ROCE_CMQ_TX_TIMEOUT			200
>
> or you could reduce the size of this define...
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--O7Os1+MGCLLi8F5z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJOl0ACgkQ5GN7iDZy
WKcaMQ/7B7RIFDzf+rEEn6ZKn3EX2+/QEeIioBgP6MHkVdZxVVZ+6EJTX0ZrtAVH
S/wk7M4DCuLmKFY431u4lKnYYP+VivVcNj+Lcyq3GekA2eX3VXDERsdKNsKIdl19
rjTmqhQ1vGAxmsjpQ3ssxKkTmXkE+tuJ8287irJajf0/z760rvsCcw81ch8IPp9B
1Xi1xv589hHOeQ+e3ZZEPWWEm8pVwWl0s95y8NjH38YRViOHTHYeTfOavBhTamjN
Yq+ZftkL9HnKSx1ksN3SEi2/HvtTQfib6UyICZBrmqs23x+hxepAFgEOHxYSG+9y
p4ZvpDitZ4UutNSkkqv/6sI9PeLA0zaqbARE75aMBAY4vBg8am9WEcoY2vtLNZrc
lkRUh3D8ec+G9UGKR6nEzUHQiQLHVumZAZmsmKFrdSBYDBbSWVA3ckVVvqyV31P1
s42TGskk7JSe1GOOPN1XyiW+4qD6NnvW07ufhjnB3G9p16kHJLt9AVwxH4DLWxDw
Ur4YUk5c04TK7F99cM+CxuAmEMO710+7br1ZOtn5aL23PkOLwUjwkTT5WzzStuZc
KENNYR6wYe4/AZ+nQ0Lw4ytrsh1CjaDx9IbeoId5sAkIZmlrOGMy9pkCHzO/cEyE
BFnc/YRZ72mqFO+je92id7Ixvy8iGsLm2nmK4FnwSiRtJrWw52M=
=1FE4
-----END PGP SIGNATURE-----

--O7Os1+MGCLLi8F5z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
