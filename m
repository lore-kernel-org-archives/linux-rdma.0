From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core packaging and multilib
Date: Wed, 15 Mar 2017 10:45:09 -0600
Message-ID: <20170315164509.GE29562@obsidianresearch.com>
References: <bb6b2274-a120-6a16-0025-4c0b1b090029@redhat.com>
 <20170314181708.GA25495@obsidianresearch.com>
 <79c87a2b-6b8e-d2f3-0246-bb549c52f8f3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <79c87a2b-6b8e-d2f3-0246-bb549c52f8f3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2017 at 12:34:37PM -0400, Doug Ledford wrote:
 
> That's not entirely true.  The man page specifically says the path in
> the man page is an example, so it need not match the arch in use, it can
> simply be one or the other with no substitution.  For the provider lib
> path, it's in a comment, so again it would be possible to use proper
> verbage to express that it is a sample and not use substitution.  We
> might even be able to do something like:
> 
> # Modern distros commonly use either /usr/lib or /usr/lib64 for the
> # default _libpath.  Substitute the correct value below before
> # uncommenting
> # provider_lib_path _libpath/ibacm

Debian derived uses /usr/lib/x86_64-linux-gnu

I think change the man page like:

       To add a provider to the ibacm core service, the provider must

       1. be implemented as a shared library;

       2. be installed under the configured directory, (see the output
       of ib_acme -D . -O)

       3  export a function provider_query() that returns a pointer to its provider info
          and version info.

And something similar for the etc file? The RH spec file produces the
etc file by running the ib_acme command, so it should sedscript in the
right text..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
