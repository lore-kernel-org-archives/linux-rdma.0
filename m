From: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Sending and Receiving QPs with IPoIB
Date: Fri, 19 Jan 2018 18:28:15 +0000
Message-ID: <5CDA63463B33C94CA80846587415F0773A70EE41@ORSMSX111.amr.corp.intel.com>
References: <5CDA63463B33C94CA80846587415F07728293A70@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5CDA63463B33C94CA80846587415F07728293A70-8oqHQFITsIGkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wright, James C" <james.c.wright-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Having a sending QP and a receiving QP per node in IPoIB connected mode is affecting HFI1 performance because of the resulting lopsidedness of QPn to hardware resource mappings. Therefore, we are investigating changing this behavior to be compliant to the RFC (https://tools.ietf.org/html/rfc4755#section-3.3).

On a separate email, Roland Dreier mentioned that IPoIB connected mode has 2 QPs for historical reasons. We *really* need to know if there is some technical reason the implementation is this way before cracking open IPoIB to change this.

Roland Dreier email:

I assume you're talking about IPoIB connected mode?

I think the reason is just historical - the code to use one QP in each direction was never written, and no one has cared enough to do it.

- R.


Thank you,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
