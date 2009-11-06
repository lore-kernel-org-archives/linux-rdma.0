From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] contain pthreads defs with ifdef  HAVE_LIBPTHREAD
Date: Fri, 6 Nov 2009 18:56:23 +0200
Message-ID: <20091106165623.GD7192@me>
References: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
 <3F6F638B8D880340AB536D29CD4C1E1912C8E0D221@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C8E0D221-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:07 Thu 05 Nov     , Smith, Stan wrote:
> 
> The use of ifdef HAVE_LIBPTHREAD was based on existing HAVE_LIBPTHREAD usage in opensm/include/opensm/osm_stats.h @ line 97.

Right, but it was used due to differences in the functionality between
cl_event_t and pthread stuff. I would be happy to remove those #ifdef's
upon such differences elimination.

> If the community prefers the use of macros then these two patches can be skipped.

I think that macros are nicer.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
