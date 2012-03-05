From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics on one opensm server
Date: Mon, 05 Mar 2012 12:25:47 -0500 (EST)
Message-ID: <342bed2a-d5c1-476e-82c1-d5fd870ab262@zmail13.collab.prod.int.phx2.redhat.com>
References: <4F54E177.9030302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F54E177.9030302-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> On 3/5/2012 10:28 AM, Doug Ledford wrote:
> > ----- Original Message -----
> >> On 3/1/2012 8:31 AM, Doug Ledford wrote:
> >>> I would say we are simply getting to the point where we *know* we
> >>> need
> >>> opensm to handle more than one fabric from a single instance ;-)
> >>
> >> Why does a single OpenSM need to handle multiple subnets/fabrics ?
> >> What's the issue with running multiple OpenSMs with each handling
> >> it's
> >> own subnet/fabric ?
> > 
> > Because it wasn't built with the idea in mind of sharing logs or
> > cache
> > directories, etc.
> 
> Yes, each instance has it's own configuration and output files.
> 
> > Not to mention that the proliferation of files when
> > you start multiple instances of opensm is pretty insane (have you
> > counted how many different files opensm can be configured to
> > require
> > now a days...).
> 
> I'm not disagreeing with the fact that there are numerous config
> files
> (the main config file is already large enough without the myriad of
> features with their own separate config files) but different subnets
> have totally different configuration requirements. It's not just the
> subnet prefix, SM priority, and the few other config items that you
> identified.

In some cases, and in other cases the different subnets are perfect mirrors
of each other (redundant, identical fabrics).

> So what would make this better in your mind ?

If I got to wave a magic wand, I would say it's time that opensm
management started getting simpler, not more complex.  With all of
the various options for routing engines and QoS and partitions, it's
gotten to where you need the equivalent of the old Cisco CNA in order
to configure opensm ;-)


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
