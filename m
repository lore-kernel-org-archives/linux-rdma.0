From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Tue, 26 Feb 2019 21:09:36 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A4FBAC@fmsmsx124.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <01b0d571-81d8-ed6c-77b7-e83ee0ab9caa@amazon.com>
 <20190225185015.GD21863@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190225185015.GD21863@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: 'Jason Gunthorpe' <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, Yossi Leybovich <sleybo@amazon.com>
List-Id: linux-rdma@vger.kernel.org

>Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
>

[..]

>> > +	ret = irdma_alloc_rsrc(iwdev->rf,
>> > +			       iwdev->rf->allocated_mrs, iwdev->rf->max_mr,
>> > +			       &stag_index, &next_stag_index);
>> > +	if (!ret) {
>> > +		stag = stag_index << IRDMA_CQPSQ_STAG_IDX_S;
>> > +		stag |= driver_key;
>> > +		stag += (u32)consumer_key;
>> > +		irdma_add_devusecount(iwdev);
>> > +	}
>>
>> This is confusing IMHO, better to test for 'if (ret)' and keep the
>> main flow unindented.
>
>Yes please follow the standard 'success oriented flow'
>
OK.
