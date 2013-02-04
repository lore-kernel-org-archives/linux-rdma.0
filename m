From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/configure.in: Remove Default-Start from opensmd
 init script
Date: Mon, 4 Feb 2013 17:36:31 +0200
Message-ID: <20130204153631.GC13151@calypso.mtl.com>
References: <20130129171850.GB2961@calypso.mtl.com>
 <5108E0F6.3060602@acm.org>
 <51093F8E.10905@redhat.com>
 <51094393.1060102@acm.org>
 <51095CD5.80503@redhat.com>
 <51097080.9000402@acm.org>
 <5109737F.70101@redhat.com>
 <20130131072100.GU2961@calypso.mtl.com>
 <510A7DAF.60802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510A7DAF.60802-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:20 Thu 31 Jan     , Doug Ledford wrote:
> On 01/31/13 02:21, Alex Netes wrote:
> > On 14:24 Wed 30 Jan     , Doug Ledford wrote:
> >> On 1/30/2013 2:12 PM, Bart Van Assche wrote:
> >>> On 01/30/13 18:48, Doug Ledford wrote:
> >>>> On 1/30/2013 11:00 AM, Bart Van Assche wrote:
> >>>>> Which convention is followed for other packages ? This is what I
> >>>>> found in
> >>>>> the Fedora 18 iscsi-initiator-utils package
> >>>>> (http://be.mirror.eurid.eu/fedora/linux/releases/18/Fedora/source/SRPMS/i/iscsi-initiator-utils-6.2.0.872-19.fc18.src.rpm):
> >>>>>
> >>>>>
> >>>>> * iscsid.init: Default-Start: 3 4 5
> >>>>> * iscsi-initiator-utils.spec:
> >>>>
> >>>> Okay, first off, any package that still uses the SysV initscripts as of
> >>>> Fedora 18 is not what I would call a package that is keeping up with the
> >>>> Fedora packaging guidelines or Fedora technologies.  As such, I'm not
> >>>> really sure you want to use it as an example of a good package.
> >>>> However, that being said, you will note in this spec file that the iSCSI
> >>>> initiator package does exactly what you removed, or suggested be
> >>>> removed, from the opensmd spec file.  It unilaterally adds the
> >>>> initscript to the system.  The default start/stop settings are
> >>>> different, but the add action is the same.
> >>>>
> >>>> All initscripts should be added to the system, regardless of their
> >>>> default start/stop settings, and the default-start and default-stop
> >>>> should be used to control *how* they are added by default, and chkconfig
> >>>> --level .* <scriptname> [on|off] should be used to control whether or
> >>>> not they are on or off differently than their default settings.
> >>>
> >>> Thanks for the detailed reply. Regarding the purpose of the patch at the
> >>> start of this thread: do you know whether it is LSB-compliant to use
> >>> "Default-Start: null" or should "Default-Start" be left out entirely in
> >>> order not to create the start links ? See e.g.
> >>> http://refspecs.linuxbase.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/initscrcomconv.html.
> >>>
> >>>
> >>> Bart.
> >>
> >> I've always used "Default-start:" without any listed levels, but I
> >> haven't really tested it either and the spec is not specific about this
> >> particular possible configuration.
> >>
> >>
> > 
> > It's how the script was defined before. The behavior on RHEL and SLES is
> > different when not specifying "Default-start:". On RHEL, `chkconfig opensmd on`
> > adds the service to the default runlevels: 2 3 4 5. While on SLES it doesn't.
> 
> That sounds like a bug in SLES to be honest.  chkconfig opensmd on
> without --levels should follow the Default-Start: item (just like
> chkconfig add opensmd).
> 

I think that RHEL and SLES implemented chkconfig differently. From man page of
chkconfig on RHEL: "By  default,  the  on  and off options affect only
runlevels 2, 3, 4, and 5". While in SLES nothing is mentioned regarding the
defaults. 
It's not acceptable to load opensm by default on boot, so I don't see other
choice right now except of reverting commit 01ab74450fd1227cf2dfb9219ffd697d3beb4a45
or doing something similar of what I suggested at the start of the thread.

--Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
