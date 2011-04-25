From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: opensm: file routing engine
Date: Mon, 25 Apr 2011 09:28:53 -0700
Message-ID: <74014BB3-E8E3-4295-8F05-7B5DDE0A3587@llnl.gov>
References: <4DB19397.7090005@parsci.com> <CA846D94-378A-4CCE-BFCD-10EF4B4B4FAE@llnl.gov> <4DB1E6F7.2030702@parsci.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB1E6F7.2030702-HFKXkVZtcVHQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul Monday (Parallel Scientific)" <paul.monday-HFKXkVZtcVHQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 22, 2011, at 1:37 PM, Paul Monday (Parallel Scientific) wrote:

> Thank you, your detail is greatly appreciated :)
> 
>>> I have one other strange question ... is it possible to carve a single
>>> physical switch into two logical switches (put a cable between ports
>>> 16/17 and modify the routing tables ... this seems like it wouldn't work
>>> as the Unicast LID / Switch: guid rows in the respective files below
>>> serve as keys so the single switch would be identified twice).
>> Not that I am aware of.  When you say you have a single switch I assume you mean a switch based on a single switch ASIC?  Like a 24 or 36 port "pizza box" switch.
> Yes, a 36 port Mellanox pizza box with a single crossbar ... based on 
> how I read these files, it looks like they key off a single GUID that 
> identifies the switch ... which would probably make the subnet manager 
> unhappy if I arbitrarily tried to mock it up being two switches somehow
>> The file formats seem to be:
>> 
>> opensm-lfts.dump (later becomes -U [file])
>> - Contains all discovered ports (powered on), their function (Switch vs.
>> Channel Adapter), their LID and some extra information.  This is
>> essentially the physical network (if all machines are powered on) ...
>> the format is:
>> Unicast lids [0-x] of switch Lid LID# guid<GUID>  ('switch description'):
>> <LID 0xZZZZ>  <SwitchPort ZZZ>  #<Channel Adapter | Switch>  portguid
>> <GUID>: 'Descirption'
>> 
>> I assume this file grows with all of the Channel Adapters and switches.
>> Given a switch-switch connection a row would look like
>> 0x0019 005 # Switch portguid 0x000000000000003 'MF3:switch-my:MTS3600/U1'
>> Yes this file grows with more nodes in the system.  But the line above is not a connection but rather a linear forwarding table entry.  In general, this is saying that for the given lid "0x0019" route out port 5 of that switch (the switch given by the "Unicast lids [..." line.  The information after '#' is more information about the node with lid=0x0019. This is _not_ the other end of the link on port 5.
> Ahhh, I see ... so this table could get quite large ... if I have 1,000 
> nodes in a subnet, each with a LID assigned, this table would become 
> quite large as each LID would be listed for each switch if I have my 
> forwarding thoughts in my head ... maybe I need to wander around and 
> steal another switch from someone ;-)

Another option would be to use ibsim:  git://git.openfabrics.org/~alexnetes/ibsim.git

You could simulate more switches in your network.

Ira


>> The topology of the physical connections are shown in opensm-subnet.lst.
> Ahhh, but the opensm-subnet.lst is not handed to the file routing 
> algorithm ... this must be "derived" at runtime each run I'm guessing 
> and then dumped to /var/log.  Very helpful!  Thank you for the pointer.
>>> You could essentially use this file to map the entire physical network,
>>> you would end up with a graph ... but no information for how to traverse
>>> it efficiently, does that sound right?
>> No this is not mapping the physical network.  It is a dump of the port forwarding which was programed into each switch by opensm.
>> 
>> Changing this file is what allows you to change the routing and then feed it back into opensm.
>> 
>>> opensm-lid-matrix.dump
>>> - Looks like it contains the hop information ... but it's a bit more
>>> cryptic since I have only one switch :(  It should contain a list of all
>>> switches, the LID for the switch and then hop information.  The hop
>>> information is what I'm a bit puzzled about here, as well as what port
>>> guid information is tacked on.  The format of the file is:
>>> Switch: guid 0x000000000000x
>>> <LID 0xZZZZ>  00 ff ff<hops for all ports>  # portguid 0x0000000
>> That is the switch to switch hop count information. Probably not of much use with only 1 switch.
> Ugh ... I need another switch or .dump files from someone ... I haven't 
> found any stray .dump files out on the network, but then, Google knows 
> all and someone must have posted a couple somewhere to play with.
> 
> Thank you so much again Ira, I wasn't too far off and mostly it seems 
> I'm off in places that having only a single switch wouldn't let me see.  
> The semantic correction of opensm-lfts.dump was critical.
> 
> Cheers, have a wonderful weekend.
> 
> Paul Monday
> Parallel Scientific, LLC
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
