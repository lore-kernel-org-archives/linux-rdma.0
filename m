From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Mon, 29 Jan 2018 21:20:47 +0200
Message-ID: <c04d3c09-7154-fcda-49d3-1e165b96d1ea@grimberg.me>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
 <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
 <1515992195.24576.156.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012C8513D9048FC1CC7011088EF0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1516780534.24576.335.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012090CB423505B207D2C3888E20@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CY1PR0701MB2012090CB423505B207D2C3888E20@CY1PR0701MB2012.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Elior, Ariel" <Ariel.Elior@cavium.com>, target-devel <target-devel@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>, "Radzi, Amit" <Amit.Radzi@cavium.com>, "Galon, Yoav" <Yoav.Galon@cavium.com>
List-Id: linux-rdma@vger.kernel.org


>> Sagi, what are your thoughts wrt changing attr.cap.max_send_wr at runtime
>> vs. exposing a smaller max_data_sg_nents=32 for ib_devices with limited
>> attr.cap.max_send_sge..?
> For our device defining max_data_sg_nents didn't help on some scenarios,
> It seems that Frequency of the issue occurring increases with number of luns we
> Try to run over.

Maybe this is related to the queue-full strategy the target core takes
by simply scheduling another attempt unconditionally without any
hard guarantees that the next attempt will succeed?

This flow is per se_device which might be a hint why its happening more
with a larger number of luns? maybe the isert completion handler
context (which is also workqueue) struggles with finding cpu quota?
