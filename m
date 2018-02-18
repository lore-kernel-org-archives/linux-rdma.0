From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC 1/2] Protect larger order pages from breaking up
Date: Sun, 18 Feb 2018 09:00:00 +0000
Message-ID: <DB6PR05MB335259492C780BA8B5BF8959BDC90@DB6PR05MB3352.eurprd05.prod.outlook.com>
References: <20180216160110.641666320@linux.com>
 <20180216160121.519788537@linux.com>
 <5108eb20-2b20-bd48-903e-bce312e96974@oracle.com>
 <alpine.DEB.2.20.1802161411440.11934@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1802161411440.11934@nuc-kabylake>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, "andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org" <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>=20
> Yup it has a pool for everyone. Question is how to divide the loot ;-)
>=20
> > IIRC, Guy Shattah's use case was for allocations greater than MAX_ORDER=
.
> > This would not directly address that.  A huge contiguous area (2GB) is
> > the sweet spot' for best performance in his case.  However, I think he
> > could still benefit from using a set of larger (such as 2MB) size
> > allocations which this scheme could help with.
>=20
> MAX_ORDER can be increased to allow for larger allocations. IA64 has f.e.
> a much larger MAX_ORDER size. So does powerpc. And then the reservation
> scheme will work.
>=20

MAX_ORDER can be increased only if kernel is recompiled.=20
It won't work for code running for the general case / typical user.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
