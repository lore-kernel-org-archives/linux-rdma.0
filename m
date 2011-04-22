From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: opensm: file routing engine
Date: Fri, 22 Apr 2011 12:39:54 -0700
Message-ID: <CA846D94-378A-4CCE-BFCD-10EF4B4B4FAE@llnl.gov>
References: <4DB19397.7090005@parsci.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB19397.7090005-HFKXkVZtcVHQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul Monday (Parallel Scientific)" <paul.monday-HFKXkVZtcVHQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 22, 2011, at 7:41 AM, Paul Monday (Parallel Scientific) wrote:

> I've been toying with the file routing engine implementation for some 
> work I'm doing, but I'm finding very little documentation on it.  I only 
> have one switch to experiment with at the moment as well so some of the 
> information in the lid / lfts files that are generated are not obvious 
> for how they expand to a multiple switch environment.  Perhaps there is 
> a document around since I'm a RTFM type of person?
> 
> At any rate, here's what I've gathered with 4. being the big question.
> 
> 1. The easiest way to get started with the file routing engine is to 
> generate the lid / lfts using a different routing engine.  I went ahead 
> and did the following:  opensm -D 0x40 -R ftree
> 2. Once run, copy the /var/log/opensm-lfts.dump and 
> /var/log/opensm-lid-matrix.dump files elsewhere for use
> 3. I've tried to generalize the file contents below
> 4. Modify the opensm-lid-matrix.dump file to "implement" or "tweak" the 
> routing algorithm over the physical network?
> 5. Run opensm -R file -M new-lid-matrix.dump -U new-lfts.dump

I think this is the general method yes.

> 
> I have one other strange question ... is it possible to carve a single 
> physical switch into two logical switches (put a cable between ports 
> 16/17 and modify the routing tables ... this seems like it wouldn't work 
> as the Unicast LID / Switch: guid rows in the respective files below 
> serve as keys so the single switch would be identified twice).

Not that I am aware of.  When you say you have a single switch I assume you mean a switch based on a single switch ASIC?  Like a 24 or 36 port "pizza box" switch.

> 
> The file formats seem to be:
> 
> opensm-lfts.dump (later becomes -U [file])
> - Contains all discovered ports (powered on), their function (Switch vs. 
> Channel Adapter), their LID and some extra information.  This is 
> essentially the physical network (if all machines are powered on) ... 
> the format is:
> Unicast lids [0-x] of switch Lid LID# guid <GUID> ('switch description'):
> <LID 0xZZZZ> <SwitchPort ZZZ> # <Channel Adapter | Switch> portguid 
> <GUID>: 'Descirption'
> 
> I assume this file grows with all of the Channel Adapters and switches.  
> Given a switch-switch connection a row would look like
> 0x0019 005 # Switch portguid 0x000000000000003 'MF3:switch-my:MTS3600/U1'

Yes this file grows with more nodes in the system.  But the line above is not a connection but rather a linear forwarding table entry.  In general, this is saying that for the given lid "0x0019" route out port 5 of that switch (the switch given by the "Unicast lids [..." line.  The information after '#' is more information about the node with lid=0x0019. This is _not_ the other end of the link on port 5.

The topology of the physical connections are shown in opensm-subnet.lst.

> 
> You could essentially use this file to map the entire physical network, 
> you would end up with a graph ... but no information for how to traverse 
> it efficiently, does that sound right?

No this is not mapping the physical network.  It is a dump of the port forwarding which was programed into each switch by opensm.

Changing this file is what allows you to change the routing and then feed it back into opensm.

> 
> opensm-lid-matrix.dump
> - Looks like it contains the hop information ... but it's a bit more 
> cryptic since I have only one switch :(  It should contain a list of all 
> switches, the LID for the switch and then hop information.  The hop 
> information is what I'm a bit puzzled about here, as well as what port 
> guid information is tacked on.  The format of the file is:
> Switch: guid 0x000000000000x
> <LID 0xZZZZ> 00 ff ff <hops for all ports> # portguid 0x0000000

That is the switch to switch hop count information. Probably not of much use with only 1 switch.

Ira

> 
> I know ... it's a detailed question but I figured I would write enough 
> so someone else wouldn't have to reverse engineer using the file routing 
> engine if this is basically right.
> 
> Paul Monday
> Parallel Scientific, LLC
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
