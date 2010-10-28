From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: opensm: Add new torus routing engine: torus-2QoS
Date: Thu, 28 Oct 2010 09:05:13 -0600
Message-ID: <1288278313.10847.121.camel@sale659.sandia.gov>
References: <1979183626.4701.1288273369806.JavaMail.root@mailhost.nacad.ufrj.br>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1979183626.4701.1288273369806.JavaMail.root-PYEadblV/Clu9b0RgFGBsz+BjnF0zU1Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Albino A. Aveleda" <bino-xFQApgkTvcmHezZ8Xjuinw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 2010-10-28 at 07:42 -0600, Albino A. Aveleda wrote:
> Dear Jim,
> 
> I have compiled and installed the opensm with torus-2qos.
> There is comment below in config file.
> ---
> # We need to tell the routing engine what directions we
> # want the torus coordinate directions to be, by specifing
> # the endpoints (switch GUID + port) of a link in each
> # direction. These links need to share a common switch,
> # which we call the torus seed.
> # Here we specify positive coordinate directions:
> xp_link 0x200000  0x200019   # S_0_0_0 -> S_1_0_0
> yp_link 0x200000  0x200005   # S_0_0_0 -> S_0_1_0
> zp_link 0x200000  0x200001   # S_0_0_0 -> S_0_0_1
> ---
> 
> How do I get xp, yp and zp_link address?

You can bring up your fabric once with some other routing
engine, say minhop, and run ibnetdiscover.

This will tell you the node GUIDs for all your switches.

Then you need to pick a switch to be the seed.  If you
know that, e.g. your fabric is wired such that port 1,
say, connects to the switch in the direction you want to
be +x, look in your ibnetdiscover output to find the 
node GUID for the switch connected to that port of your
seed switch.

For maximum resiliency, pick the switch that your
opensm host connects to as the seed.

-- Jim

> 
> Best regards,
> Albino
> 
> ----- "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org> escreveu:
> 
> > 
> > This posting http://www.spinics.net/lists/linux-rdma/msg02967.html
> > has some example input for a 5x5x5 torus.
> > 
> > You'll want to configure your torus (via opensm --torus_config
> > <file>)
> > so that the intra-NEM links are z-direction links.  This will allow
> > you to swap a QNEM and keep the fabric routable during the process.
> > 
> > Please look over the torus-2QoS section in
> > opensm/doc/current-routing.txt
> > to see why this is so, and to help understand why the info
> > in torus-2QoS.conf is required.
> > 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
