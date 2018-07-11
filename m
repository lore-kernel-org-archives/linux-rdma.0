From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Wed, 11 Jul 2018 13:13:18 +0200
Message-ID: <20180711111318.GL20050@dhcp22.suse.cz>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <20180709122908.GJ22049@dhcp22.suse.cz>
 <20180710134040.GG3014@mtr-leonro.mtl.com>
 <20180710141410.GP14284@dhcp22.suse.cz>
 <20180710162020.GJ3014@mtr-leonro.mtl.com>
 <20180711090353.GD20050@dhcp22.suse.cz>
 <20180711101447.GU3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180711101447.GU3014@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Alex Deucher <alexander.deucher@amd.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Dimitri Sivanich <sivanich@sgi.com>, Boris Ostrovsky <boris.ostrovsky>
List-Id: linux-rdma@vger.kernel.org

On Wed 11-07-18 13:14:47, Leon Romanovsky wrote:
> On Wed, Jul 11, 2018 at 11:03:53AM +0200, Michal Hocko wrote:
> > On Tue 10-07-18 19:20:20, Leon Romanovsky wrote:
> > > On Tue, Jul 10, 2018 at 04:14:10PM +0200, Michal Hocko wrote:
> > > > On Tue 10-07-18 16:40:40, Leon Romanovsky wrote:
> > > > > On Mon, Jul 09, 2018 at 02:29:08PM +0200, Michal Hocko wrote:
> > > > > > On Wed 27-06-18 09:44:21, Michal Hocko wrote:
> > > > > > > This is the v2 of RFC based on the feedback I've received so far. The
> > > > > > > code even compiles as a bonus ;) I haven't runtime tested it yet, mostly
> > > > > > > because I have no idea how.
> > > > > > >
> > > > > > > Any further feedback is highly appreciated of course.
> > > > > >
> > > > > > Any other feedback before I post this as non-RFC?
> > > > >
> > > > > From mlx5 perspective, who is primary user of umem_odp.c your change looks ok.
> > > >
> > > > Can I assume your Acked-by?
> > >
> > > I didn't have a chance to test it because it applies on our rdma-next, but
> > > fails to compile.
> >
> > What is the compilation problem? Is it caused by the patch or some other
> > unrelated changed?
> 
> Thanks for pushing me to take a look on it.
> Your patch needs the following hunk to properly compile at least on my system.

I suspect you were trying the original version. I've posted an updated
patch here http://lkml.kernel.org/r/20180627074421.GF32348@dhcp22.suse.cz
and all these issues should be fixed there. Including many other fixes.

Could you have a look at that one please?
-- 
Michal Hocko
SUSE Labs
