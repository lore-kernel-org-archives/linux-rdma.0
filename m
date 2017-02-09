From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Thu, 09 Feb 2017 10:53:26 +0100
Message-ID: <1486634006.3632.5.camel@profitbricks.com>
References: <20170207183538.GT6005@mtr-leonro.local>
         <20170207184206.GA14102@obsidianresearch.com>
         <20170207194759.GU6005@mtr-leonro.local>
         <20170207201428.GV6005@mtr-leonro.local>
         <20170207205930.GA28922@obsidianresearch.com>
         <20170208063758.GZ6005@mtr-leonro.local>
         <20170208173335.GB30720@obsidianresearch.com>
         <20170208180104.GG6005@mtr-leonro.local>
         <20170208181820.GA31664@obsidianresearch.com>
         <20170208185446.GH6005@mtr-leonro.local>
         <20170208205622.GA32427@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208205622.GA32427-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Mittwoch, den 08.02.2017, 13:56 -0700 schrieb Jason Gunthorpe:
> On Wed, Feb 08, 2017 at 08:54:46PM +0200, Leon Romanovsky wrote:
> 
> > > Hmm. Can you update your github? I'll look for you.
> > 
> > I pushed latest code to m/dv-1 branch, it is not for inclusion yet.
> > https://github.com/rleon/rdma-core/commits/m/dv-v1
> > Updated cover letter with changelog:
> > https://github.com/rleon/rdma-core/commit/a332669511d5bbbd3dcdd977f
> > bf95aa7ee47a69e
> > And all cmake/packages stuff in the patch:
> > https://github.com/rleon/rdma-core/commit/fcc4996c7fa5169fe599c2d56
> > 8476314c1f65ddc
> 
> This should take care of most things
> 
> https://github.com/jgunthorpe/rdma-plumbing/commit/490b7fb184c414ab16
> b7056f1effa9136e8afe46
> 
> The debian packaging still needs some adjusting.
> 
> I suspect it is against Debian policy to include libmlx.so in the
> providers package, it probably needs to have its own package and its
> own -dev package.

When other packages should be able to link against libmlx.so and need
header files for that, it is better to have separate binary packages
(libmlx and libmlx-dev) for it.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:  http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
