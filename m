From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 07/10] iser-target: Declare correct flags when
 accepting a connection
Date: Tue, 17 Nov 2015 11:38:23 +0200
Message-ID: <564AF58F.8010209@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-8-git-send-email-sagig@mellanox.com>
 <20151117090325.GE19578@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151117090325.GE19578@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


>> +	struct iser_cm_hdr rsp_hdr;
>>
>>   	memset(&cp, 0, sizeof(struct rdma_conn_param));
>>   	cp.initiator_depth = isert_conn->initiator_depth;
>>   	cp.retry_count = 7;
>>   	cp.rnr_retry_count = 7;
>>
>> +	memset(&rsp_hdr, 0, sizeof(rsp_hdr));
>> +	rsp_hdr.flags = (ISERT_ZBVA_NOT_USED | ISERT_SEND_W_INV_NOT_USED);
>> +	cp.private_data = (void *)&rsp_hdr;
>> +	cp.private_data_len = sizeof(rsp_hdr);
>
> Btw, where does iser_cm_hdr and these flags come from?  I can't find
> anything like this in RFC7145.

It's mentioned in the cover-letter:
"The support negotiation for this feature is based on IBTA
annex 12 "Support for iSCSI Extensions for RDMA" carried in rdma_cm
private data."

You can find it at:
https://cw.infinibandta.org/document/dl/7145
