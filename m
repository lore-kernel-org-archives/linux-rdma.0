From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iser-target: fix error return code in
 isert_create_device_ib_res()
Date: Wed, 11 Dec 2013 11:57:48 -0800
Message-ID: <1386791868.20247.104.camel@haakon3.risingtidesystems.com>
References: <CAPgLHd8eEFhMyfieCULgj+OzCRrTMN9G60pAvTP0+zOhBeK=qw@mail.gmail.com>
	 <alpine.LNX.2.00.1312021459400.24931@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1312021459400.24931@pobox.suse.cz>
Sender: target-devel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, vu@mellanox.com, sagig@mellanox.com, ogerlitz@mellanox.com, yongjun_wei@trendmicro.com.cn, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2013-12-02 at 15:00 +0100, Jiri Kosina wrote:
> On Tue, 29 Oct 2013, Wei Yongjun wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This one has been sitting in my queue for quite some time, but I'd like 
> the actual infiniband maintainers to be acted upon by.
> 
> Roland, please?

Hi Jiri, Wei & Co,

Apologies for missing this one earlier..

This patch has been queued with a CC' for v3.10+ stable to
target-pending/master, and will be included in the next for-v3.13 fixes
PULL request.

Thank you,

--nab

> 
> > ---
> >  drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> > index 6df2350..2ba71c0 100644
> > --- a/drivers/infiniband/ulp/isert/ib_isert.c
> > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> > @@ -263,21 +263,29 @@ isert_create_device_ib_res(struct isert_device *device)
> >  						isert_cq_event_callback,
> >  						(void *)&cq_desc[i],
> >  						ISER_MAX_RX_CQ_LEN, i);
> > -		if (IS_ERR(device->dev_rx_cq[i]))
> > +		if (IS_ERR(device->dev_rx_cq[i])) {
> > +			ret = PTR_ERR(device->dev_rx_cq[i]);
> > +			device->dev_rx_cq[i] = NULL;
> >  			goto out_cq;
> > +		}
> >  
> >  		device->dev_tx_cq[i] = ib_create_cq(device->ib_device,
> >  						isert_cq_tx_callback,
> >  						isert_cq_event_callback,
> >  						(void *)&cq_desc[i],
> >  						ISER_MAX_TX_CQ_LEN, i);
> > -		if (IS_ERR(device->dev_tx_cq[i]))
> > +		if (IS_ERR(device->dev_tx_cq[i])) {
> > +			ret = PTR_ERR(device->dev_tx_cq[i]);
> > +			device->dev_tx_cq[i] = NULL;
> >  			goto out_cq;
> > +		}
> >  
> > -		if (ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP))
> > +		ret = ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP);
> > +		if (ret)
> >  			goto out_cq;
> >  
> > -		if (ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP))
> > +		ret = ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP);
> > +		if (ret)
> >  			goto out_cq;
> >  	}
> >  
> > 
> 
