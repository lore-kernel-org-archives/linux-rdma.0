From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core rpm for SuSE
Date: Fri, 4 Aug 2017 07:55:51 +0200
Message-ID: <0db11dd4-56c5-4ac9-e7f4-b9a328ca94e3@suse.de>
References: <CO2PR07MB25846E91BD9DA1744AEB20BBF8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
 <20170803113505.GF4333@linux-x5ow.site> <1501775351.2922.5.camel@wdc.com>
 <66a7dd28-f752-b8d9-e8c2-00128245ce2c@suse.de>
 <1501780444.2922.10.camel@wdc.com>
 <20170803172957.GA30952@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803172957.GA30952-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 03/08/2017 à 19:29, Jason Gunthorpe a écrit :
> On Thu, Aug 03, 2017 at 05:14:11PM +0000, Bart Van Assche wrote:
>> On Thu, 2017-08-03 at 17:59 +0200, Nicolas Morey-Chaisemartin wrote:
>>> We have a different spec file due to SUSE packaging policies, and some
>>> path differences but the default one works. As this is new, I wanted to
>>> make sure it works well before submitting it. With v15 coming out and the
>>> associated systemd/udev changes, I'll have to update the spec and validate
>>> it but once this is done I'll send a patch to this ML and get it upstreamed.
>> Hello Nicolas,
>>
>> Do you plan to submit an entirely new RPM or changes to the rdma-core.spec
>> file in the top-level directory? Personally I strongly prefer the latter. We
>> have already three groups of distro packaging files and that is really annoying
>> to rdma-core contributors because every packaging change has to be tested three
>> times (rdma-core.spec, redhat/rdma-core.spec and debian/*.install). Adding a
>> fourth packaging file would increase the maintenance burden even further.
> If suse contributes their spec file I think we could delete the top
> level rdma-core.spec
>
> There are enough differences in the suse spec file I suspect it would
> be more maintainable to have it separate.
>
> We still have to test the builds against that configuration anyhow, I
> dont see a big burden there - so long as cbuild can run an appropriate
> suse build (opensuse is OK for testing?)..
>
> Jason
Yes a separate spec makes more sense.
With the amount differences we have, it would be hellish to maintain a common spec file with redhat and most of the stuff would have to be done twice anyway.

And yes, the RPM works with both SLE (12SP3), OpenSUSE Leap (>=42.2) and TumbleWeed without any issue.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
