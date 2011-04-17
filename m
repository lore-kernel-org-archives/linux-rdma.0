From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] routing segfault + LMC > 0 routing bug?
Date: Sun, 17 Apr 2011 17:34:02 +0300
Message-ID: <20110417143402.GA12476@calypso.voltaire.com>
References: <1300843412.3128.135.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1300843412.3128.135.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18:23 Tue 22 Mar     , Albert Chu wrote:
> Hey Jim, Alex,
> 
> Just hit a segfault on the main tree.  It appears patch 
> 
> commit 9ddcf3419eade13bdc0a54f93930c49fe67efd63
> Author: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
> Date:   Fri Sep 3 10:43:12 2010 -0600
> 
> opensm: Avoid havoc in minhop caused by torus-2QoS persistent use of
> osm_port_t:priv.
> 
> segfaults opensm on one of our systems w/ updn routing and lmc > 0
> (would likely segfault dor, minhop, and maybe others too).  Our system
> has older switches that do not support enhanced port zero, thus do not
> support LMC > 0.  (I imagine setting lmc_esp0 to FALSE, results in the
> same behavior.)  Subsequently even if you set LMC > 0 in your opensm
> config file, there can be ports with LMC = 0 and LMC != 0 (e.g. from
> HCAs). Subsequently in alloc_ports_priv(), some ports will have priv set
> to NULL and some will not.  Because of assumptions in osm_switch.c about
> priv != NULL when lmc > 0, we hit a segfault.  The issue didn't exist
> before b/c we allocated p_port->priv non-NULL no matter what.
> 
> The attached patch fixes the problem w/ updn.  I haven't looked through
> all of the 2Qos code thoroughly to figure out the consequences of this
> change, so I'm just considering this a starting point for discussion.
> 

Applied, thanks.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
