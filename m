From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Thu, 26 May 2011 08:24:17 -0600
Message-ID: <4DDE6291.1090809@sandia.gov>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
 <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
 <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
 <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
 <055701cc1b29$c8fcc6c0$5af65440$@systemfabricworks.com>
 <BANLkTikLeWHYLKrX8O=syt-Q+b6LP2PCtw@mail.gmail.com>
 <4DDDF0B1.6090305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDDF0B1.6090305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Roland Dreier wrote:
>> Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>>> With lash+mesh redsky required 6-7 VLs to wire up without deadlocks. 
>>> I think
>>> that Jim's version uses 8 SLs but only 2VLs to work.
>>> If someone was using a torus and also wanted to support QOS and also 
>>> wanted
>>> to separate multicast and management on a separate VL to be 
>>> absolutely sure
>>> that there is no possibility of a deadlock you might end up with #QOS 
>>> * 2 +
>>> 1 which would be 5 using the current algorithm.
> 
>> But again you don't need all those VLs on the HCAs' links, do you?
> 
> Jason Gunthorpe wrote:
>> Routing algorithms only need VLs on interswitch links, not on HCA to
>> switch links. The only use of the HCA to switch VLs is for QoS. Mesh
>> topologies can usually be routed with only two VLs, but you need alot
>> of SLs to make that work.
> 
> Bob, Jim, Alex
> 
> I wasn't sure if the SL-to-VL mapping done by open SM is dictated by the 
> directives @ the user config file or if the routing algorithm is "VL 
> aware" but the routing engine? if the latter, do interswitch links use 
> different mapping vs. HCA - switch links?

FWIW, the torus-2QoS routing engine uses VL bit 0 for torus deadlock
avoidance, VL bit 1 to route around a missing switch without deadlocks,
and VL bit 2 to provide two QoS levels.  It needs the port dependence
of the SL2VL maps to do this in switches.

The interswitch and HCAs use the same mapping, but only VL bit 2
is needed on HCAs, to provide the QoS levels.

I chose that bit usage because it seemed the proper ordering of
capabilities if there are fewer than 8 data VLs available - basic
deadlock avoidance is most important; some QoS is nice to have but
not that useful if the fabric can deadlock.

Is that what you were asking, at least WRT. torus-2QoS?

-- Jim

> 
> Or.
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
