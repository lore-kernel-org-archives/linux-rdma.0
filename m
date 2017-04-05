From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 1/5] IB/qib: Use kcalloc() in qib_init_iba7322_funcs()
Date: Wed, 5 Apr 2017 16:54:40 +0200
Message-ID: <fa90e815-daff-57b1-7930-447c6f5fa3ab@users.sourceforge.net>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
 <5e5e00d3-b6a4-7371-65be-c5fe387d26b3@users.sourceforge.net>
 <20170405143438.GC5006@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405143438.GC5006@yuval-lap>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

>> @@ -7324,8 +7324,9 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
>>  		actual_cnt -= dd->num_pports;
>>  
>>  	tabsize = actual_cnt;
>> -	dd->cspec->msix_entries = kzalloc(tabsize *
>> -			sizeof(struct qib_msix_entry), GFP_KERNEL);
>> +	dd->cspec->msix_entries = kcalloc(tabsize,
>> +					  sizeof(*dd->cspec->msix_entries),
>> +					  GFP_KERNEL);
> 
> Are we fine with loosing the zeroing of the entries?

How did you get this concern?

Do you really miss such functionality from the other interface?

Regards,
Markus
