From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] osm_subnet.c
Date: Thu, 12 Nov 2009 21:35:34 +0200
Message-ID: <20091112193534.GP7192@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
 <20091004001316.GK17846@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C8783C0D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C8783C0D-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:09 Mon 05 Oct     , Smith, Stan wrote:
> >>
> >> --- a/opensm/opensm/osm_subnet.c        2009-10-01
> >> 12:45:52.000000000 -0700 +++ b/opensm/opensm/osm_subnet.c
> >> 2009-10-01 14:24:18.000000000 -0700 @@ -397,7 +397,7 @@
> >>
> >>  /**********************************************************************
> >>
> >> **********************************************************************/
> >> -static long compar_mgids(const void *m1, const void *m2) +static
> >> intn_t compar_mgids(const void *m1, const void *m2)
> >
> > Any disagreement about changing a prototype of this method
> > (cl_pfn_fmap_cmp_t) in complib to use standard type (long) instead of
> > "homemade" and less clear one ('intn_t')?
> >
> > Sasha
> >
> >>  {
> >>         return memcmp(m1, m2, sizeof(ib_gid_t));
> >>  }
> 
> How is the processor architecture 'natural' size intn_t less clear than 'long'?

'intn_t' is not a standard type, but a hack defined in complib, unlike
this 'long' is a very basic C language type (btw I'm fine with 'int' for
this particular case).

> In some worlds sizeof(long) != sizeof(void*).

This is bad. Fortunately for this case we don't need a "natural" int. And
for case where it is really needed a standard types would be more
appropriate in general than complib's defined intn_t.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
