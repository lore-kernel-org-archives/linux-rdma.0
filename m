From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: Re: [PATCH] osm_subnet.c
Date: Thu, 12 Nov 2009 21:18:11 +0200
Message-ID: <20091112191811.GO7192@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
	<20091004001316.GK17846@me>
	<A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <A6E929B3F38F455EB28EB478FBAF290E@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Sean Hefty <sean.hefty@intel.com>
Cc: ofw@lists.openfabrics.org, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 09:20 Mon 05 Oct     , Sean Hefty wrote:
> >>  /**********************************************************************
> >>   **********************************************************************/
> >> -static long compar_mgids(const void *m1, const void *m2)
> >> +static intn_t compar_mgids(const void *m1, const void *m2)
> >
> >Any disagreement about changing a prototype of this method
> >(cl_pfn_fmap_cmp_t) in complib to use standard type (long) instead of
> >"homemade" and less clear one ('intn_t')?
> >
> >Sasha
> >
> >>  {
> >>         return memcmp(m1, m2, sizeof(ib_gid_t));
> >>  }
> 
> If the function is simply a wrapper around a single call to memcmp, why keep it
> at all?

The function is used as comparator callback in complib's fleximap
implementation (just similar to qsort()'s compar parameter and others)
and signed integer (= , >  or < 0) should be returned. Using pointer
sized int as return value is not needed here. We can do it to match
others comparators (qsort, scandir, etc.) prototype exactly:

	int compar(const void *, const void *);

, or to not bother at all and leave it as 'long'.

Hmm, I would prefer to change to 'int' to prevent future confusing.
Thoughts?

Sasha
