From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Wed, 9 Aug 2017 09:55:32 -0600
Message-ID: <20170809155532.GC15586@obsidianresearch.com>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
 <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 09, 2017 at 11:56:47AM +0200, Nicolas Morey-Chaisemartin wrote:

> >>  def run_rpm_build(args,spec_file,env):
> >>      version = get_version();
> >> -    with open(spec_file,"r") as F:
> >> +
> >> +    # Pre-process file with rpm spec to avoid manually replacing macros
> >> +    f = open(spec_file + ".processed", "w");
> >> +    subprocess.check_call(["rpmspec", "-P", spec_file], stdout=f);

> > This isn't going to work on any host system that does not have
> > rpmspec, including my Debian systems..

> Are you building RPM outside of docker on your Debian ?

No..

The issue is the above subprocess.check_call is run on the host, while
the call I added below inside go.py is run inside the container.

The host may not have rpmspec, while we guarentee that the container
does.

> I ran the pkg suite for all targets and they all work.

Your host has rpmspec :)

> >  def run_rpm_build(args,spec_file,env):
> > -    version = get_version();
> >      with open(spec_file,"r") as F:
> >          for ln in F:
> > -            if ln.startswith("Version:"):
> > -                ver = ln.strip().partition(' ')[2];
> > -                assert(ver == get_version());
> > -
> You are losing this last check which seems important. It make sure the ti tag is in sync with the RPM

If you think it is important it can be left in..

> >              if ln.startswith("Source:"):
> >                  tarfn = ln.strip().partition(' ')[2];
> > -    tarfn = tarfn.replace("%{version}",version);
> >  
> >      image_id = get_image_id(args,env.image_name());
> >      with private_tmp(args) as tmpdir:
> > @@ -426,7 +420,8 @@ def run_rpm_build(args,spec_file,env):
> >          os.mkdir(os.path.join(tmpdir,"tmp"));
> >  
> >          subprocess.check_call(["git","archive",
> > -                               "--prefix","%s/"%(os.path.splitext(tarfn)[0]),
> > +                               # This must match the prefix generated buildlib/github-release
> > +                               "--prefix","%s-%s/"%(project,get_version()),
> >                                 "--output",os.path.join(tmpdir,"SOURCES",tarfn),
> You have an issue here because tarfn is not set yet.

No, it was still set above, see the first hunk.

> I'm confused on why moving the call to rpmspec further down would solve your Debian issue ?

Further down the code is run in the container where rpmspec is
guarenteed to exist. Everything in cbuild is run on the host except
for the snippet in go.py

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
