From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v7 2/9] IB/core: Enforce PKey security on QPs
Date: Mon, 22 May 2017 10:42:22 +0000
Message-ID: <VI1PR05MB167814F66EEF8A1BD77C793AC4F80@VI1PR05MB1678.eurprd05.prod.outlook.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
 <1495198139-69993-3-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1705220959450.3502@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/21/2017 7:13 PM, James Morris wrote:=0A=
> On Fri, 19 May 2017, Dan Jurgens wrote:=0A=
>=0A=
>> security/security.c                  | 385 ++++++++++++++++++++++=0A=
> This looks wrong -- merge problem?=0A=
=0A=
Yes, it was a merge problem.  I added back the per field initialization of =
the security head hooks.  Paul stripped this (and the same problem in patch=
 0004) himself before merging.=0A=
=0A=
>=0A=
>=0A=
>> +	if (pps->alt.state !=3D IB_PORT_PKEY_NOT_VALID) {=0A=
>> +		get_pkey_and_subnet_prefix(&pps->alt,=0A=
>> +					   &pkey,=0A=
>> +					   &subnet_prefix);=0A=
>> +=0A=
>> +		ret =3D enforce_qp_pkey_security(pkey,=0A=
>> +					       subnet_prefix,=0A=
>> +					       sec);=0A=
>> +	}=0A=
>> +=0A=
>> +	if (ret)=0A=
>> +		goto out;=0A=
> The above if/goto is unnecessary.=0A=
=0A=
Right.=0A=
=0A=
Paul, do you want me to fix this with a new patch?=0A=
=0A=
>=0A=
>> +=0A=
>> +out:=0A=
>> +	return ret;=0A=
>> +}=0A=
>=0A=
>=0A=
=0A=
