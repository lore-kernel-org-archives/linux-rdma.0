From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 15:49:04 -0700
Message-ID: <20170309224904.GA5867@obsidianresearch.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
 <20170309171014.GC12694@obsidianresearch.com>
 <1489098918.2597.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489098918.2597.12.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 10:35:30PM +0000, Bart Van Assche wrote:
> On Thu, 2017-03-09 at 10:10 -0700, Jason Gunthorpe wrote:
> > On Thu, Mar 09, 2017 at 11:25:27AM +0100, Philipp Thomas wrote:
> > 
> > > I'm trying to build latest rdma-core but it fails in ibacm because a
> > > library is missing:
> > 
> > The suse cmake rpm macros are broken, this is worked around in the
> > shipped rdma-core.spec:
> > 
> > # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
> > # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
> > # module libraries (eg ibacmp).
> > %define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=""
> > 
> > Ideally you would consult internally to globally fix the rpm cmake
> > macro, otherwise you have to use the above hack..
> 
> Something else is also broken, namely the SuSE section in rdma-core.spec. I
> just figured out that the following is needed to build an RPM on SuSE systems:
> 
> diff --git a/rdma-core.spec b/rdma-core.spec
> index f7a440d7..aa486371 100644
> +++ b/rdma-core.spec
> @@ -28,7 +28,7 @@ BuildRequires: ninja,make
>  %define __builder ninja
>  # cmake_install,make_jobs is specified by opensuse
>  %define cmake cmake
> -%define cmake_install DESTDIR=%{buildroot} ninja install
> +%define cmake_install DESTDIR=%{buildroot} make install

I'm not sure what tree you are looking at? The above '-' line never
appeared in mainline?

The opensuse rpm macros themselves are supposed to provide
cmake_install, so the spec file should not define it. Did they change
their macros again or something?

We provide it for the RH cases because they use a different cmake rpm
macro set. :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
