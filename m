From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: separate router guid
 resolution code
Date: Mon, 12 Oct 2009 18:49:54 +0200
Message-ID: <20091012164954.GB31774@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
 <20091004001942.GM17846@me>
 <4ACA3D10.5010909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ACA3D10.5010909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:38 Mon 05 Oct     , Rolf Manderscheid wrote:
> Sasha Khapyorsky wrote:
> > Move off subnet destination (router address) resolution code to separate
> > function to improve readability.
> >  ...
> > +static ib_net64_t find_router(osm_sa_t *sa, ib_net64_t prefix)
> 
> Much better.  The *sa argument to find_router() can even be const.

Ok. This cannot hurt.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
