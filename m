From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Status of ECMP patch
Date: Fri, 20 Jul 2012 10:58:02 -0700
Message-ID: <20120720105802.949f950b6df6954be45be5ce@llnl.gov>
References: <6A4B9687-301F-492A-88E8-5AC5CBDA784E@lanl.gov>
	<16FC53E6-F78C-4193-B6A3-D194FA1EFF32@lanl.gov>
	<50099A5B.7020208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50099A5B.7020208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Susan Coulter <markus-YOWKrPYUwWM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 20 Jul 2012 13:50:19 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Hi Susan,
> 
> On 7/20/2012 1:30 PM, Susan Coulter wrote:
> > Question:
> > About 2 years ago I reported at the OFA Developers Workshop that the ecmp routing within MinHop does not equally distribute routes among the multiple paths.  That is, if 4 different ports at one hop all result in an equal number of hops thru the rest of the fabric, the routes are not distributed equally among those 4 ports/paths.
> > 
> > I was told there were 2 different approaches to solve this and patches had been discussed/submitted and the community was deciding on a path forward.
> > 
> > Does anyone know the status of this?
> 
> The two approaches are:
> 1. Scatter ports (from Jared Carr)
> 2. Port shifting (from Al Chu)

To turn these options on:

In opensm.conf:

# Assign ports in a random order instead of round-robin.
# If zero disable, otherwise use the value as a random seed
scatter_ports 0

# Port Shifting (use FALSE if unsure)
port_shifting FALSE


On the command line:

       --scatter-ports
              This option will randomize port selecting in routing.

       --port-shifting
              This option enables a feature called port shifting.  In some fabrics, particularly cluster environments, routes commonly align and congest with other routes due to algorithmically unchanging traf-
              fic patterns.  This routing option will "shift" routing around in an attempt to alleviate this problem.


Ira

> 
> and both have been upstream since April 2011.
> 
> -- Hal
> 
> > My apologies if the data is out there somewhere and I simply cannot find it.
> > 
> > Thanx in advance.
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
