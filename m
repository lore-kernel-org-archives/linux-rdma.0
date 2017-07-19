From: "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v2 2/2] RDMA/core: Initialize port_num in qp_attr
Date: Wed, 19 Jul 2017 14:38:18 +0000
Message-ID: <5C5647B5F4794941BAAC07CF28785CBC33E5F3B1@fmsmsx101.amr.corp.intel.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
 <1500043291-19768-3-git-send-email-mustafa.ismail@intel.com>
 <32E1700B9017364D9B60AED9960492BC34341CD3@fmsmsx120.amr.corp.intel.com>
 <DM2PR0701MB13920AC9BBE7471A921FBF0A88A60@DM2PR0701MB1392.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM2PR0701MB13920AC9BBE7471A921FBF0A88A60@DM2PR0701MB1392.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "e1000-rdma@lists.sourceforge.net" <e1000-rdma@lists.sourceforge.net>, "Saleem, Shiraz" <shiraz.saleem@intel.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Kalderon, Michal [mailto:Michal.Kalderon@cavium.com]
> Sent: Wednesday, July 19, 2017 3:10 AM
> To: Marciniszyn, Mike <mike.marciniszyn@intel.com>; Ismail, Mustafa
> <mustafa.ismail@intel.com>; linux-rdma@vger.kernel.org;
> dledford@redhat.com
> Cc: swise@opengridcomputing.com; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; e1000-rdma@lists.sourceforge.net; Saleem, Shiraz
> <shiraz.saleem@intel.com>; Amrani, Ram <Ram.Amrani@cavium.com>
> Subject: RE: [PATCH v2 2/2] RDMA/core: Initialize port_num in qp_attr
> 
> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> > owner@vger.kernel.org] On Behalf Of Marciniszyn, Mike
> > > Initialize the port_num for iWARP in rdma_init_qp_attr.
> > >
> > > Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> > > Cc: <stable@vger.kernel.org> # v2.6.14+
> > > Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> Why is the second patch required if you only validate the port_num if the
> IB_QP_PORT mask is on?
> Given the first patch [PATCH v2 1/2] RDMA/uverbs: Fix the check for port
> number, this one seems redundant.
Strictly speaking it is not required, but we felt it safer to always return a valid port number
as is done in the IB case.

Regards,

Mustafa
