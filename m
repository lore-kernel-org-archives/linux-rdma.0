From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [PATCH 08/21] IB/hfi1: Adjust default MTU to be 10KB
Date: Mon, 18 Apr 2016 23:31:25 -0400
Message-ID: <20160419033124.GF27515@rhel.amr.corp.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
 <20160412181708.21853.23423.stgit@scvm10.sc.intel.com>
 <20160418070708.GJ6349@leon.nu>
 <20160418120335.GB17987@phlsvsds.ph.intel.com>
 <20160418123032.GM6349@leon.nu>
 <1461004942.3765.78.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461004942.3765.78.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: leon-2ukJVAZIZ/Y@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 02:42:22PM -0400, David Woodhouse wrote:
> On Mon, 2016-04-18 at 15:30 +0300, Leon Romanovsky wrote:
> > From the name of that function looks that the parameter supplied
> > should be ENUM, but it is not=A0the case.
>=20
> The implicit question might, perhaps, be "why?" :)

OPA defines MTU values which are not "ib_mtu" enumerations.  This code =
is
processing 2 different "types" of enumerations.  The IB compatible ones=
 as well
as new ones which are specific to OPA.

The OPA enums are not defined as a type but perhaps they should be?

=46rom include/rdma/opa_port_info.h:

enum { =20
        OPA_MTU_8192  =3D 6,
        OPA_MTU_10240 =3D 7,
};


Also I just noticed this comment for the function which is no longer
appropriate:

=2E..
 * The actual flag used to determine "8k MTU" will change and is curren=
tly
 * unknown.
=2E..

We should remove the comment.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
