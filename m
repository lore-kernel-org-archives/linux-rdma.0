From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options (repost)
Date: Mon, 4 Jul 2011 13:52:59 +0300
Message-ID: <20110704105259.GA6084@calypso.voltaire.com>
References: <1297388014.18394.302.camel@auk59.llnl.gov>
 <1300915898.3128.168.camel@auk59.llnl.gov>
 <20110406140929.GA21920@calypso.voltaire.com>
 <1302113667.4906.336.camel@auk59.llnl.gov>
 <1302137816.4906.403.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1302137816.4906.403.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al, Hared,

Applied:
  [PATCH 1/4] Support port shifting.
  [PATCH 3/4] Support scatter ports.
  [PATCH 4/4] Cleanup scatter ports patch. 

Thanks.

On 17:56 Wed 06 Apr     , Albert Chu wrote:
> Hey Alex, Jared,
> 
> On Wed, 2011-04-06 at 11:14 -0700, Albert Chu wrote:
> > Hey Alex,
> > 
> > On Wed, 2011-04-06 at 07:09 -0700, Alex Netes wrote:
> > > Hi Al, Jared,
> > > 
> > > On 14:31 Wed 23 Mar     , Albert Chu wrote:
> > > > > 
> > > > > 1) Port Shifting
> > > > > 
> > > > > This is similar to what was done with some of the LMC > 0 code.
> > > > > Congestion would occur due to "alignment" of routes w/ common traffic
> > > > > patterns.  However, we found that it was also necessary for LMC=0 and
> > > > > only for used-ports.  For example, lets say there are 4 ports (called A,
> > > > > B, C, D) and we are routing lids 1-9 through them.  Suppose only routing
> > > > > through A, B, and C will reach lids 1-9.
> > > > > 
> > > > > The LFT would normally be:
> > > > > 
> > > > > A: 1 4 7
> > > > > B: 2 5 8
> > > > > C: 3 6 9
> > > > > D:
> > > > > 
> > > > > The Port Shifting option would make this:
> > > > > 
> > > > > A: 1 6 8
> > > > > B: 2 4 9
> > > > > C: 3 5 7
> > > > > D:
> > > > > 
> > > > > This option by itself improved the mpiGraph average send/recv bandwidth
> > > > > from 420 MB/s and 508 MB/s to to 991 MB/s and 1172 MB/s.
> > > > > 
> > > 
> > > After thinking about this a little more and reviewing Jared Carr's - Scatter ports
> > > patch, I think we should combine these efforts into one framework as Al
> > > suggested.
> 
> As I was beginning to integrate Jared's patch with mine, it ends up that
> algorithmically/architecturally, it isn't as easy (or similar) as I had
> originally thought.  In particular, it has issues with LMC > 0.
> Normally you want to route through a port that is least forwarded
> through or goes through systems it hasn't seen yet.  This sort of
> conflicts with the idea of selecting a port randomly.
> 
> I'm going to throw out the following patch series as a starting point
> for discussion on scatter ports.  My original two patches have been
> updated with new log messages and some minor tweaks.
> 
> My attempt of integration of Jared's scatter patch is included.  It has
> a variety of cleanup (b/c of conflicts w/ my patches), 1 or 2 gotchas I
> caught, and various tweaks for code consistency with my patches/other
> OpenSM code.  Jared's original code algorithm is largely unchanged, but
> I did modify it to deal with LMC > 0 better (by basically ignoring LMC).
> 
> Jared, LMK what you think and if it'll work for you.
> 
> Al
> 
> P.S.  Jared, I made you author on the 3rd patch naturally.
> 
> > Moreover, isn't "port_shifting" too much fabric oriented? Do
> > > general OpenSM users will find this useful for them?
> > > Moreover, how can user identify that port_shifting may improve performance for
> > > him.
> > 
> > I will admit, I'm unsure of how much non-HPC users would benefit from
> > this option, be hurt by it, or if they would even care.  I can't speak
> > for all users, but here at LLNL and at most of the lab HPC sites, people
> > play with the options and experiment to find the best routing algorithm
> > + settings that support their environment.  I would imagine the
> > port_shifting option would just be another option for people to
> > experiment with.
> > 
> > I think adding Jared's Scatter Ports would be easy to merge into my line
> > of patches.  Let me see if I can integrate his patch into my line
> > easily.
> > 
> > > Is providing shift factor (more than the suggested 1) will help to make it
> > > suitable foo a general case?
> > 
> > That seems like a good idea, we certainly could support an arbitrary
> > shift, allowing users to experiment if there is a better one for their
> > particular environment.
> > 
> > > > > 2) Remote Guid Sorting
> > > > > 
> > > > > Most core/spine switches we've seen thus far have had line boards
> > > > > connected to spine boards in a consistent pattern.  However, we recently
> > > > > got some Qlogic switches that connect from line/leaf boards to spine
> > > > > boards in a (to the casual observer) random pattern.  I'm sure there was
> > > > > a good electrical/board reason for this design, but it does hurt routing
> > > > > b/c updn doesn't account for this.  Here's an output from iblinkinfo as
> > > > > an example.
> > > > > 
> > > 
> > > Why this problem can't be addressed by guid_routing_order_file option?
> > 
> > The problem we encountered in our fabric is predominantly a
> > switch-to-switch routing issue with a spine switch.  The
> > guid_routing_order_file wouldn't be able to solve this, since its input
> > is just end ports.
> > 
> > Or another way to say it, this option directly affects the routing
> > decisions made.  The guid_routing_order_file does not, it only affects
> > the order in which routes are chosen (which can have consequences, but
> > the routing algorithm itself is unchanged).
> > 
> > Al
> > 
> > > 
> > > --Alex
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
