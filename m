From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Wed, 16 May 2018 15:30:42 -0400
Message-ID: <476dbacf-d02e-1bfa-35c7-aa5c743901ad@dev.mellanox.co.il>
References: <20180514210200.GN21531@ziepe.ca>
 <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
 <E41BCEAA-0204-448D-8188-ACA03932B3AC@oracle.com>
 <20180515190424.GL5615@ziepe.ca>
 <3E15B62F-E705-43BD-8A72-9E74F784D40E@oracle.com>
 <20180516151201.GA25661@ziepe.ca>
 <695ae613-931a-50ba-2b83-9d172e0ac2bc@dev.mellanox.co.il>
 <151B2A36-28F0-4A88-8633-31AE7E55F848@oracle.com>
 <20180516180115.GF25661@ziepe.ca>
 <FDEBA43A-C98F-4E2B-A8F3-CA809FBAD479@oracle.com>
 <20180516181655.GH25661@ziepe.ca>
 <A087A721-E596-428E-8554-FAEB4BE9B306@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A087A721-E596-428E-8554-FAEB4BE9B306@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/16/2018 3:22 PM, Håkon Bugge wrote:
> But, do we need an update to IBTA (that the BTH.PKey shall be that of the VM's Port)?

Nothing in spec mentions shared (port) virtualization so that is an
exercise completely left to the reader...

Annex A19 is silent on this specific point but the virtual port model
has virtual port partition table so there's no ambiguity there.
