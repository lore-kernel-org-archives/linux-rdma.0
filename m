From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
Date: Mon, 17 Jul 2017 19:10:15 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC34341CBF@fmsmsx120.amr.corp.intel.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
 <1500043291-19768-2-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1500043291-19768-2-git-send-email-mustafa.ismail@intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Ismail, Mustafa" <mustafa.ismail@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "e1000-rdma@lists.sourceforge.net" <e1000-rdma@lists.sourceforge.net>, "Saleem, Shiraz" <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
> 
> The port number is only valid if IB_QP_PORT is set in the mask.
> So only check port number if it is valid to prevent modify_qp from
> failing due to an invalid port number.
> 
> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> Cc: <stable@vger.kernel.org> # v2.6.14+
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>

Tested-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
