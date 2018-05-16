From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Wed, 16 May 2018 12:01:15 -0600
Message-ID: <20180516180115.GF25661@ziepe.ca>
References: <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
 <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
 <20180514210200.GN21531@ziepe.ca>
 <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
 <E41BCEAA-0204-448D-8188-ACA03932B3AC@oracle.com>
 <20180515190424.GL5615@ziepe.ca>
 <3E15B62F-E705-43BD-8A72-9E74F784D40E@oracle.com>
 <20180516151201.GA25661@ziepe.ca>
 <695ae613-931a-50ba-2b83-9d172e0ac2bc@dev.mellanox.co.il>
 <151B2A36-28F0-4A88-8633-31AE7E55F848@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151B2A36-28F0-4A88-8633-31AE7E55F848@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Hal Rosenstock <hal@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 16, 2018 at 07:46:10PM +0200, Håkon Bugge wrote:

>    OK. Lets take one example. The pkey table contains 0xFFFF, 0x8001,
>    0x0001.
> 
>    The wce.pkey_index is 1 (i.e., pointing to 0x8001). Now, tell me, was
>    BTH.PKey 0x8001 (matches 0x8001) or was it 0x0001 (also matching
>    0x8001) ?

As far as the Linux core is concerned, it must have been 0x8001,
because the only way the pkey_index feature works properly is if
exact-match takes precedence over in-exact match.

Jason
