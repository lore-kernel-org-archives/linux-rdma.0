From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [OPENSM] match functions to prototypes in header file
Date: Thu, 1 Oct 2009 12:51:48 -0600
Message-ID: <20091001185148.GJ19540@obsidianresearch.com>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com> <20091001183127.GX17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091001183127.GX17846@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 08:31:27PM +0200, Sasha Khapyorsky wrote:
> > @@ -1106,9 +1109,9 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
> >  			"\t\t\t\tresv2...................0x%X\n"
> >  			"\t\t\t\tresv3...................0x%X\n",
> >  			cl_ntoh64(p_pr->service_id),
> > -			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
> > +			inet_ntop(AF_INET6, (void*)p_pr->dgid.raw, gid_str,
> 
> And why is such casting(s) needed?

Casting away const like that is incorrect, fix your inet_ntop to have
a POSIX signature or ignore the warning.

> Also wouldn't it be simpler to remove 'const' in "type * const var"
> function parameter definitions? This restricts only value of a pointer
> (not structure content), and since function parameters are passed by
> values such restriction is only related to a function implementation
> and actually meanless in sense of API. Thoughts?

Yah, type * const var is quite strange. Why propose this?

Then again, this existing is quite strange too:

> >  			  IN const osm_log_level_t log_level)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
