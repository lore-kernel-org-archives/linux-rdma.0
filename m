From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofw] [PATCH] opensm - standardize on a single Windows #define
Date: Mon, 12 Oct 2009 22:15:32 -0600
Message-ID: <20091013041532.GK18578@obsidianresearch.com>
References: <C014357BC392401989734C286EDC5AE1@amr.corp.intel.com> <21B1AC3C6F82416A8764CF0B6FD9C27B@amr.corp.intel.com> <3F6F638B8D880340AB536D29CD4C1E1912C8846161@orsmsx501.amr.corp.intel.com> <20091012220041.GL13830@me> <3F6F638B8D880340AB536D29CD4C1E1912C896BBEA@orsmsx501.amr.corp.intel.com> <3F6F638B8D880340AB536D29CD4C1E1912C896BBFC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C896BBFC-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 03:29:38PM -0700, Smith, Stan wrote:

> If __linux__ doesn't work for you, then please create a Linux Platform define I can use.

Pretty much all the patches I've seen you make should be guarded by
__WIN__, you shouldn't be using __linux__.

opensm and the other OFA stuff is POSIX. If you need to deviate from
POSIX because Windows isn't, then you should use __WIN__ as the guard.

It is inappropriate to guard POSIX code with __linux__

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
