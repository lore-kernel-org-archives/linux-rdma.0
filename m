From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Wed, 9 Aug 2017 14:19:32 -0600
Message-ID: <20170809201932.GA7363@obsidianresearch.com>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
 <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
 <20170809155532.GC15586@obsidianresearch.com>
 <f42a6eaa-79f9-1063-b58a-08da363d09e7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f42a6eaa-79f9-1063-b58a-08da363d09e7-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 09, 2017 at 06:39:23PM +0200, Nicolas Morey-Chaisemartin wrote:
> >>>          subprocess.check_call(["git","archive",
> >>> -                               "--prefix","%s/"%(os.path.splitext(tarfn)[0]),
> >>> +                               # This must match the prefix generated buildlib/github-release
> >>> +                               "--prefix","%s-%s/"%(project,get_version()),
> >>>                                 "--output",os.path.join(tmpdir,"SOURCES",tarfn),
> >> You have an issue here because tarfn is not set yet.
> > No, it was still set above, see the first hunk.
> 
> Yes. But the value it has is "wrong"
> If I take the current spec file used in OBS:
> Source0:        %{name}-%{version}%{git_ver}.tar.xz
> 
> Omitting the Source0 that should be changed to Source, this wille set tarfn to rdma-core-15%{git_ver}.tar.xz

Okay..

Why not use

%setup -n %{name}-%{version}

In the spec file? Eg do not include the git version in the prefix so
it matches the format produced by the github scripts.

Then, the above will make a archive with 'rdma-core-15/' as the prefix.

The archive will be called

'SOURCE/%{name}-%{version}%{git_ver}.tar.xz'

Then the go.py will parse and determine that the archive should be
called

'SOURCE/rdma-core-15-git124556.tar.xz'

And drop a symlink to fix it up.

> This means that we would need to detar/rename/retar the package in
> the go.py.  It feels overly complicated :/ What we use this for is
> mainly for RC and non-release packages. We set the git_ver to -rc1,
> -<NN>-g<SHA1>  so we know at a glance that this is not an official
> release.  I can either try to get this working in the go.py, or I'll
> simply drop this from our spec and bring it back when needed for non
> release packages.

I think if this is your usage then you would be fine to use '%setup
-n'..

We can already recover the git HEAD from a git archive output by using
'git get-tar-commit-id' so it isn't really necessary to include the
git commit id in the prefix.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
