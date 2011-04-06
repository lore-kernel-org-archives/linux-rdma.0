From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options (repost)
Date: Wed, 6 Apr 2011 17:09:29 +0300
Message-ID: <20110406140929.GA21920@calypso.voltaire.com>
References: <1297388014.18394.302.camel@auk59.llnl.gov>
 <1300915898.3128.168.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1300915898.3128.168.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>, Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al, Jared,

On 14:31 Wed 23 Mar     , Albert Chu wrote:
> > 
> > 1) Port Shifting
> > 
> > This is similar to what was done with some of the LMC > 0 code.
> > Congestion would occur due to "alignment" of routes w/ common traffic
> > patterns.  However, we found that it was also necessary for LMC=0 and
> > only for used-ports.  For example, lets say there are 4 ports (called A,
> > B, C, D) and we are routing lids 1-9 through them.  Suppose only routing
> > through A, B, and C will reach lids 1-9.
> > 
> > The LFT would normally be:
> > 
> > A: 1 4 7
> > B: 2 5 8
> > C: 3 6 9
> > D:
> > 
> > The Port Shifting option would make this:
> > 
> > A: 1 6 8
> > B: 2 4 9
> > C: 3 5 7
> > D:
> > 
> > This option by itself improved the mpiGraph average send/recv bandwidth
> > from 420 MB/s and 508 MB/s to to 991 MB/s and 1172 MB/s.
> > 

After thinking about this a little more and reviewing Jared Carr's - Scatter ports
patch, I think we should combine these efforts into one framework as Al
suggested. Moreover, isn't "port_shifting" too much fabric oriented? Do
general OpenSM users will find this useful for them?
Moreover, how can user identify that port_shifting may improve performance for
him.
Is providing shift factor (more than the suggested 1) will help to make it
suitable foo a general case?

> > 2) Remote Guid Sorting
> > 
> > Most core/spine switches we've seen thus far have had line boards
> > connected to spine boards in a consistent pattern.  However, we recently
> > got some Qlogic switches that connect from line/leaf boards to spine
> > boards in a (to the casual observer) random pattern.  I'm sure there was
> > a good electrical/board reason for this design, but it does hurt routing
> > b/c updn doesn't account for this.  Here's an output from iblinkinfo as
> > an example.
> > 

Why this problem can't be addressed by guid_routing_order_file option?


--Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
