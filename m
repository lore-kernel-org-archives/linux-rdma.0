From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v5 8/9] selinux: Add IB Port SMP access vector
Date: Tue, 22 Nov 2016 23:00:17 +0000
Message-ID: <VI1PR0501MB242975002A23E40F567336E9C4B40@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com>
 <1479843638-67136-9-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1611230945140.3895@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/22/2016 4:47 PM, James Morris wrote:=0A=
> On Tue, 22 Nov 2016, Dan Jurgens wrote:=0A=
>=0A=
>> +		*out_sid =3D c->sid[0];=0A=
>> +	} else {=0A=
>> +		*out_sid =3D SECINITSID_UNLABELED;=0A=
>> +	}=0A=
> Per previous comment about the braces.=0A=
The coding style says if one branch requires brackets they should be used o=
n all branches:=0A=
=0A=
"This does not apply if only one branch of a conditional statement is a sin=
gle statement; in the latter case use braces in both branches: "=0A=
=0A=
