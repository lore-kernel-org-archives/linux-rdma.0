From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Thu, 3 Nov 2016 18:42:13 -0600
Message-ID: <20161104004213.GA28485@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
 <20161027211059.GA7224@obsidianresearch.com>
 <20161028171147.GJ42084@redhat.com>
 <581B9F91.4050407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <581B9F91.4050407-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 03, 2016 at 02:35:29PM -0600, Doug Ledford wrote:
> >>> +%package -n librdmacm-utils
> >>> +Summary: Examples for the librdmacm library
> >>> +Requires: librdmacm%{?_isa} = %{version}-%{release}
> >>
> >> Why the requires? Shouldn't auto shlib dependencies take care of that?
> > 
> > Probably. I think this was another legacy bit copied over from a
> > stand-alone spec file.
> 
> Actually, no.  When you have a -utils package that goes with a library
> package, standard procedure is to tie them directly like this.  The auto
> dependency stuff will allow, say, librdmacm-1.1.17-1 and
> librdmacm-utils-1.1.16-1 to happily satisfy each other since the later
> librdmacm provides all of the sonames and apis that the -utils package
> needs.  This is as designed as you want a librdamcm update to not
> trigger a required update of, say, openmpi, unless there is truly a
> change that requires it.  But, for the utils that go with the library,
> even though we don't *have* to update them with the library, we want
> that to happen automatically, so the explicit requires makes that happen
> even if librdmacm-utils was excluded from the update command.

Okay, Jarod you will need to send a patch to put this back, because I
applied all the changes discussed in this email when I made the pull
request.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
