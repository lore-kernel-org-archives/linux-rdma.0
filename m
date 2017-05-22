From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v7 0/9] SELinux support for Infiniband RDMA
Date: Mon, 22 May 2017 10:50:31 +0000
Message-ID: <VI1PR05MB167866E1D919FC98BC9DC285C4F80@VI1PR05MB1678.eurprd05.prod.outlook.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1705221033550.3502@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/21/2017 7:35 PM, James Morris wrote:=0A=
> On Fri, 19 May 2017, Dan Jurgens wrote:=0A=
>=0A=
>> From: Daniel Jurgens <danielj@mellanox.com>=0A=
> What kind of testing has this code had?  It's relatively complex and as a=
 =0A=
> security feature, it especially needs to be well-tested.=0A=
>=0A=
>=0A=
I tested it on my own systems, checking that it correctly allows and restri=
cts access, and revokes access to when the partition table or security poli=
cy change.  I'm also working with a group of defense contractors to deploy =
this in a cluster for testing in a more production like environment.  Once =
it's available in Linus' kernel releases I will also deploy automated testi=
ng in our regression system.=0A=
=0A=
