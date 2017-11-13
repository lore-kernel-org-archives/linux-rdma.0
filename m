From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] buildlib: use cmake to find python
Date: Mon, 13 Nov 2017 12:31:39 -0700
Message-ID: <20171113193139.GN6918@ziepe.ca>
References: <1923c475-0597-a597-36a5-8a33cccae6ef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1923c475-0597-a597-36a5-8a33cccae6ef-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 13, 2017 at 02:00:15PM +0100, Nicolas Morey-Chaisemartin wrote:
> Depending on the system, python might not be available as pythomn (but python2, python3, etc.)
> Use FIND_PACKAGE to get the right executable.

Looks fine to me.

>    # Compute a relative symlink from VERBS_PROVIDER_DIR to LIBDIR
> -  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
> +  execute_process(COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/buildlib/relpath

I'm assuming this little script works with python3 ?

cbuild won't though..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
