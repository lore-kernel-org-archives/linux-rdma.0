From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [RFC v1 10/19] RDMA/irdma: Add connection manager
Date: Tue, 26 Feb 2019 21:07:51 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A4FAF6@fmsmsx124.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-11-shiraz.saleem@intel.com>
 <0eafe40b-4c54-dc12-6a85-3a821d99d2cd@amazon.com>
 <20190225184629.GC21863@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190225184629.GC21863@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: 'Jason Gunthorpe' <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

>Subject: Re: [RFC v1 10/19] RDMA/irdma: Add connection manager
>
>On Sun, Feb 24, 2019 at 01:21:16PM +0200, Gal Pressman wrote:
>> On 15-Feb-19 19:10, Shiraz Saleem wrote:
>> > +/**
>> > + * irdma_cm_teardown_connections - teardown QPs
>> > + * @iwdev: device pointer
>> > + * @ipaddr: Pointer to IPv4 or IPv6 address
>> > + * @ipv4: flag indicating IPv4 when true
>>
>> There is no ipv4 parameter.
>
>Be sure to run code through make W=1 - it runs stuff that checks the kdocs.

OK. Will do. Thanks! We have a few hits here.

>
>> > +	INIT_LIST_HEAD(&teardown_list);
>> > +	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
>> > +		spin_lock_irqsave(&vsi->qos[i].lock, flags);
>> > +		list_for_each_safe(list_node, list_core_temp, &vsi->qos[i].qplist) {
>> > +			u32 qp_ip[4];
>> > +
>> > +			sc_qp = container_of(list_node, struct irdma_sc_qp, list);
>> > +			if (sc_qp->qp_type != IRDMA_QP_TYPE_ROCE_RC)
>> > +				continue;
>> > +
>> > +			qp = sc_qp->back_qp;
>> > +			if (!disconnect_all) {
>> > +				if (nfo->ipv4)
>> > +					qp_ip[0] = qp->udp_info.local_ipaddr3;
>> > +				else
>> > +					memcpy(qp_ip,
>> > +					       &qp->udp_info.local_ipaddr0,
>> > +					       sizeof(qp_ip));
>> > +			}
>> > +
>> > +			if (disconnect_all ||
>> > +			    (nfo->vlan_id == qp->udp_info.vlan_tag &&
>> > +			    !memcmp(qp_ip, ipaddr, nfo->ipv4 ? 4 : 16))) {
>> > +				spin_lock_irqsave(&iwdev->rf->qptable_lock,
>flags);
>>
>> You should use different 'flags' here.
>
>If irqs are already proven disabled it is just spin_lock, right?
>
Correct.
