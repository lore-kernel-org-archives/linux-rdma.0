From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Wed, 16 May 2018 20:14:50 +0200
Message-ID: <FDEBA43A-C98F-4E2B-A8F3-CA809FBAD479@oracle.com>
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
 <20180516180115.GF25661@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516180115.GF25661@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Hal Rosenstock <hal@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org



> On 16 May 2018, at 20:01, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Wed, May 16, 2018 at 07:46:10PM +0200, H=C3=A5kon Bugge wrote:
>=20
>>   OK. Lets take one example. The pkey table contains 0xFFFF, 0x8001,
>>   0x0001.
>>=20
>>   The wce.pkey_index is 1 (i.e., pointing to 0x8001). Now, tell me, =
was
>>   BTH.PKey 0x8001 (matches 0x8001) or was it 0x0001 (also matching
>>   0x8001) ?
>=20
> As far as the Linux core is concerned, it must have been 0x8001,
> because the only way the pkey_index feature works properly is if
> exact-match takes precedence over in-exact match.

And now if the table only contains 0xFFFF, 0x8001, how do you tell?


H=C3=A5kon
