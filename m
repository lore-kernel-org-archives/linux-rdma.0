From: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Subject: Re: [PATCH v2 2/2] RDMA/core: Initialize port_num in qp_attr
Date: Wed, 19 Jul 2017 15:09:03 +0000
Message-ID: <DM2PR0701MB1392FAF086CEA7AA8F204A5688A60@DM2PR0701MB1392.namprd07.prod.outlook.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
 <1500043291-19768-3-git-send-email-mustafa.ismail@intel.com>
 <32E1700B9017364D9B60AED9960492BC34341CD3@fmsmsx120.amr.corp.intel.com>
 <DM2PR0701MB13920AC9BBE7471A921FBF0A88A60@DM2PR0701MB1392.namprd07.prod.outlook.com>,<5C5647B5F4794941BAAC07CF28785CBC33E5F3B1@fmsmsx101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5C5647B5F4794941BAAC07CF28785CBC33E5F3B1@fmsmsx101.amr.corp.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Saleem, Shiraz" <shiraz.saleem@intel.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>
List-Id: linux-rdma@vger.kernel.org

From: Ismail, Mustafa <mustafa.ismail@intel.com>
Sent: Wednesday, July 19, 2017 5:38 PM

> > > > Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds"=
)
> > > > Cc: <stable@vger.kernel.org> # v2.6.14+
> > > > Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > Why is the second patch required if you only validate the port_num if t=
he
> > IB_QP_PORT mask is on?
> > Given the first patch [PATCH v2 1/2] RDMA/uverbs: Fix the check for por=
t
> > number, this one seems redundant.
> Strictly speaking it is not required, but we felt it safer to always retu=
rn a valid port number
> as is done in the IB case.

It's not always initialized in the IB case either. More than that if at thi=
s point you'll
initialize it for ib as well you'll get a failure on ib_modify_qp_is_ok, si=
nce when
transitioning to RTR  / RTS providing IB_QP_PORT is not a valid option.
We actually hit this issue when running rping over RoCE. (prior to your fix=
 i mean )=20
I agree that in general there's no real harm, but it seems a bit out of con=
text, and if we
make the change common for ib/iwarp we'll have to modify ib_modify_qp_is_ok=
 which=20
is written close to the spec.=20

thanks,
Michal
