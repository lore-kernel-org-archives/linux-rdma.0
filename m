From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: rdma-core rpm for SuSE
Date: Thu, 3 Aug 2017 17:14:11 +0000
Message-ID: <1501780444.2922.10.camel@wdc.com>
References: <CO2PR07MB25846E91BD9DA1744AEB20BBF8B10@CO2PR07MB2584.namprd07.prod.outlook.com>
         <20170803113505.GF4333@linux-x5ow.site> <1501775351.2922.5.camel@wdc.com>
         <66a7dd28-f752-b8d9-e8c2-00128245ce2c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <66a7dd28-f752-b8d9-e8c2-00128245ce2c-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Content-ID: <10B1A56F26C8F44EAC989A9ED8978DE2-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org" <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 17:59 +0200, Nicolas Morey-Chaisemartin wrote:
> We have a different spec file due to SUSE packaging policies, and some
> path differences but the default one works. As this is new, I wanted to
> make sure it works well before submitting it. With v15 coming out and the
> associated systemd/udev changes, I'll have to update the spec and validat=
e
> it but once this is done I'll send a patch to this ML and get it upstream=
ed.

Hello Nicolas,

Do you plan to submit an entirely new RPM or changes to the rdma-core.spec
file in the top-level directory? Personally I strongly prefer the latter. W=
e
have already three groups of distro packaging files and that is really anno=
ying
to rdma-core contributors because every packaging change has to be tested t=
hree
times (rdma-core.spec, redhat/rdma-core.spec and debian/*.install). Adding =
a
fourth packaging file would increase the maintenance burden even further.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
