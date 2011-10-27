From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 5/9] ib_srpt: Fix sport->port_guid formatting code
Date: Wed, 26 Oct 2011 17:37:10 -0700
Message-ID: <1319675830.21607.99.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-6-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-pcNWgt1uxT2gH6KvDhdkkP1hbBbYnt81f-gHVr_UhdBg@mail.gmail.com>
	 <1319487952.17450.72.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qjOT2rqeLn=DJi5ogk+KTV8_Fi0tYwj4gECtcSNNhHRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qjOT2rqeLn=DJi5ogk+KTV8_Fi0tYwj4gECtcSNNhHRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-10-26 at 20:23 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 10:25 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > On Mon, 2011-10-24 at 21:57 +0200, Bart Van Assche wrote:
> >> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> >> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> >> > +               snprintf(sport->port_guid, sizeof(sport->port_guid),
> >> > +                               "0x0000000000000000%016llx",
> >> > +                               be64_to_cpu(sport->gid.global.interface_id));
> >>
> >> If I interpret Roland's e-mail correctly Roland asked to use GID table
> >> entry 0 (http://www.spinics.net/lists/linux-rdma/msg09751.html) ?
> >>
> >
> > I'll defer to Roland on this, as the port->gid.global.interface_id you
> > recommended does exactly what we need.  I'm happy to test another code
> > snippet if you have one handy.
> 
> Something like this should generate GID 0 in ASCII format (not tested
> in any way, and using separators will help to make the output easier
> to read):
> 
> snprintf(sport->port_gid, sizeof(sport->port_gid),
>             "0x%016llx%016llx",
>              be64_to_cpu(sport->gid.global.subnet_prefix),
>              be64_to_cpu(sport->gid.global.interface_id));
> 

So adding the subnet_prefix here works as expected, and as previously
mentioned I'm OK to change the /var/target/fabric/ib_srpt.spec
formatting in rtslib for SRP target ports to accommodate this..

But the bit that now looks kinda odd with this change is that NodeACLs
would still not be using the subnet_prefix.  Here's a bit of targetcli
output to demonstrate:

/ib_srpt> info
Fabric module name: ib_srpt
ConfigFS path: /sys/kernel/config/target/srpt
Allowed WWNs list (free type): 0xfe800000000000000002c903000e8ace, 0xfe800000000000000002c903000e8acd
Fabric module specfile: /var/target/fabric/ib_srpt.spec
Fabric module features: acls
Corresponding kernel module: ib_srpt
/ib_srpt> ls
o- ib_srpt ......................................................... [2 Targets]
  o- 0xfe800000000000000002c903000e8acd .............................. [enabled]
  | o- acls ............................................................ [1 ACL]
  | | o- 0x00000000000000000002c903000e8be9 .................... [1 Mapped LUNs]
  | |   o- mapped_lun0 ............................................. [lun0 (rw)]
  | o- luns ........................................................... [1 LUNs]
  |   o- lun0 ................................... [iblock/scsi_debug (/dev/sdb)]
  o- 0xfe800000000000000002c903000e8ace .............................. [enabled]
    o- acls ............................................................ [1 ACL]
    | o- 0x00000000000000000002c903000e8bea .................... [1 Mapped LUNs]
    |   o- mapped_lun0 ............................................. [lun0 (rw)]
    o- luns ........................................................... [1 LUNs]
      o- lun0 .................................. [iblock/scsi_debug2 (/dev/sdc)]
/ib_srpt> 

So I don't see an easy way to get subnet_prefix for the incoming
initiator port in srpt_cm_req_recv(), as what's being passed in from
srp_login_req->initiator_port_id seems to have subnet_prefix already
stripped off..?

So the two question here for Roland and yourself are:  Is using a real
subnet prefix for target ports, but not the explict NodeACLs for
initiator ports acceptable for an initial merge..?  If not, how is it
possible to obtain the remote initiator port's subnet_prefix during
login in srpt_cm_req_recv() so we can keep subnet_prefix usage
consistent between target ports and explict NodeACL initiator ports
in /sys/kernel/config/target/srpt/

Thank you,
.
--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
