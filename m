From: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 07/11] IB/hfi1: Fix infinite loop in 8051
 command error path
Date: Wed, 20 Dec 2017 22:24:57 +0000
Message-ID: <5CDA63463B33C94CA80846587415F077282939F3@ORSMSX111.amr.corp.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035657.2126.88651.stgit@scvm10.sc.intel.com>
 <20171220080854.GL2942@mtr-leonro.local>
 <5CDA63463B33C94CA80846587415F0772829387D@ORSMSX111.amr.corp.intel.com>
 <20171220181244.GD22908@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220181244.GD22908-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I guess he means why did you randomly reformat the whitespace around _do_8051_command just for >removing a '_', and why did you reformat it to a non-kernel-standard formatting?

An updated patch will be resubmitted.

Thank you,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
