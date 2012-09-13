From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups to support full and partial membership for the same pkey
Date: Thu, 13 Sep 2012 10:35:15 +0300
Message-ID: <201209131035.15318.jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <201209121056.00309.jackm@dev.mellanox.co.il> <5050BCDD.50106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5050BCDD.50106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 12 September 2012 19:48, Doug Ledford wrote:
> > On the Hypervisor, however, we assume that if both versions of the =
pkey are in its pkey table,
> > then for its own infiniband operation (as opposed to performing its=
 pkey virtualizing function),
> > it should operate with the highest membership type in its table for=
 a given 15-bit pkey.
>=20
> That's what I was looking for. =A0So, how can you know this assumptio=
n is
> correct? =A0It seems to me that if someone wanted to restrict members=
hip
> of the hypervisor as part of a security lockdown, then give full
> membership to a guest because that guest is some high security, singl=
e
> task guest, then this assumption would break things (the user would b=
e
> able to assign the full membership key to the guest OK, but regardles=
s
> of how they wanted the hypervisor to be subscribed to that particular
> pkey, it would always get the full membership from the guest).
>=20
This issue, unfortunately, opens up a real "can of worms".
ib_find_cached_pkey() is used by the CM in determining the (15-bit) p_k=
ey
to be used for the connection (although 16-bit pkeys are placed in the
CM_REQ message (see IB Spec 1.2.1, table 99, page 667). The REQ handler=
 on
the remote side finds the index in its pkey table which contains the
(15-bit) pkey enclosed in the REQ message.  This index is then used
when creating the local RC qp as its pkey_index.
AFAIK, no check is performed regarding compatible membership forms (i.e=
=2E,
that at least one of the two sides has the full membership form of the
15-bit pkey) -- it is the network administrator's responsibility to see
that the pkey configurations are correct.

Up to now, the ib_core driver has assumed that only 1 membership form p=
er
15-bit pkey is contained in the local pkey table.

Now that both forms may exist in the Hypervisor's table, we do have a p=
roblem.
1. We cannot depend on ib_find_cached_pkey simply finding the first 15-=
bit pkey
   which matches its search, since we cannot depend on the order of ful=
l vs limited
   membership forms appearing in the pkey table (the order is not contr=
ollable -- see
   the example at the end of this post).
2. We therefore need a consistent policy for preferentially retrieving =
either the full
   or the partial member for a given 15-bit pkey.
3. This policy must be configurable by the administrator per host, per =
HCA.

The problems that I see:
1. What if the Hypervisor needs to have limited membership for some con=
nections, but
   full membership for others?  Such a split policy is complex to imple=
ment -- it would
   require specifying PER PKEY whether the preferential return should b=
e full, or should
   be limited.
2. What if the Hypervisor has several HCAs, and wishes a different poli=
cy for each HCA?

There may be more problems as well.  Liran?

In any event, the issue of multiple pkey forms in a given pkey table is=
 actually separate
from SRIOV (it's just that SRIOV needs multiple forms, so the issue cam=
e up).
Solving it will require changes in the ib core driver.

I don't yet have a concrete proposal to fix this at present.  Any ideas=
 would be appreciated.

-Jack

P.S. We have the same issue in procedure ib_find_pkey(), also in this p=
atch, in core/device.c .
This procedure is used in lots of places: ipoib, core/multicast, sa_que=
ry.

I seem to recall that there were problems with IPoIB when partial membe=
rship pkeys are used.
Liran, do you recall something?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
It is also impossible to demand that the pkey table be ordered so that =
if both limited
and full pkeys are present, then the full membership value always appea=
rs first.

A simple example:
  1. Fill the entire pkey table with full-membership pkeys. Say pkey A =
and pkey B are both
     in the table, and that pkey A appears first.

  2. Delete full-membership pkey A, and add the limited-membership valu=
e of Pkey B. This
     new limited-pkey-B will be entered into the pkey table by OpenSM i=
n the position just
     vacated by the deleted pkey A -- it is the only available slot!.

  3. The Limited-membership pkey-B value will therefore unavoidably app=
ear in the table
     before the full-membership pkey-B value.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
